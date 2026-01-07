import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';
import 'package:kaly_point/models/session.dart';
import 'package:kaly_point/utils/date_helper.dart';
import 'package:kaly_point/viewmodels/sessions/session_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kaly_point/widgets/card_widget.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key, required this.title});

  final String title;

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Initialize ViewModel
    Future.microtask(() {
      context.read<SessionViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _createNewSession() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Create Session'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Session title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<SessionViewModel>().createSession(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBarOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: TextStyle(color: AppColors.primaryColor, fontSize: 20),
        backgroundColor: Colors.white.withValues(alpha: appBarOpacity),
        elevation: appBarOpacity > 0.5 ? 4.0 : 0.0,
      ),
      body: Consumer<SessionViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.clearError,
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: viewModel.sessions.isEmpty
                ? 1
                : viewModel.sessions.length,
            itemBuilder: (context, index) {
              if (viewModel.sessions.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No sessions yet. Create one to get started"),
                  ),
                );
              }

              final Session session = viewModel.sessions[index];

              return Padding(
                padding: const EdgeInsets.all(5),
                child: Card.outlined(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint("Card tapped");
                    },
                    child: CardWidget(
                      cardTitle: session.title,
                      cardText1: 'Created at ${DateHelper.formatDate(session.createdAt)}',
                      cardText2: session.description,
                      enabledDelete: true,
                      enabledEdit: true,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewSession,
        tooltip: 'Create Session',
        child: const Icon(Icons.add),
      ),
    );
  }
}
