import 'package:flutter/material.dart';
import 'package:kaly_point/models/session.dart';
import 'package:kaly_point/services/database_service.dart';
import 'package:kaly_point/utils/date_helper.dart';
import 'package:kaly_point/viewmodels/session_viewmodel.dart';
import 'package:kaly_point/views/checkpoints/check_points_page.dart';
import 'package:kaly_point/views/sessions/create_session_page.dart';
import 'package:kaly_point/views/sessions/edit_session_page.dart';
import 'package:kaly_point/widgets/confirm_dialog.dart';
import 'package:kaly_point/widgets/my_app_bar.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    if (_scrollController.hasClients) {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      if (currentScroll > 0 && currentScroll >= (maxScroll - 200)) {
        context.read<SessionViewModel>().loadMore();
      }
    }
  }

  void _createNewSession() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => CreateSessionPage(),
    );
  }

  void _editSession(int? sessionId) {
    if (sessionId == null) {
      return;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => EditSessionPage(sessionId: sessionId),
    );
  }

  void _confirmDeleteSession(String title, int? sessionId) async {
    if (sessionId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("An error occured")));
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Suppression session?',
        content: 'Êtes vous sur de supprimer cette session $title?',
        confirmText: 'Delete',
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;

      context.read<SessionViewModel>().deleteSession(sessionId);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Session supprimée")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);

    return Scaffold(
      appBar: MyAppBar(title: widget.title, appBarOpacity: appBarOpacity),
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
            itemCount:
                viewModel.sessions.length + (viewModel.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (viewModel.sessions.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Pas de session. Créer une session"),
                  ),
                );
              }

              if (index == viewModel.sessions.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
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
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckPointsPage(sessionId: session.id, titleSession: session.title,),
                          ),
                        );
                    },
                    child: CardWidget(
                      cardTitle: session.title,
                      cardText1:
                          'Crée le ${DateHelper.formatDate(session.createdAt)}',
                      cardText2: session.description,
                      enabledDelete: true,
                      enabledEdit: true,
                      callBackButton1: () => _editSession(session.id),
                      callBackButton2: () =>
                          _confirmDeleteSession(session.title, session.id),
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
        tooltip: 'Création Session',
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber.withAlpha(450),
        child: const Icon(Icons.add),
      ),
    );
  }
}
