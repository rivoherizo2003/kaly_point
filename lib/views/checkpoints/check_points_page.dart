import 'package:flutter/material.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/models/session.dart';
import 'package:kaly_point/utils/date_helper.dart';
import 'package:kaly_point/viewmodels/checkpoint_viewmodel.dart';
import 'package:kaly_point/views/checkpoint/perform_check_point_page.dart';
import 'package:kaly_point/views/checkpoints/create_check_point_page.dart';
import 'package:kaly_point/views/checkpoints/edit_check_point_page.dart';
import 'package:kaly_point/widgets/card_widget.dart';
import 'package:kaly_point/widgets/confirm_dialog.dart';
import 'package:kaly_point/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class CheckPointsPage extends StatefulWidget {
  final int sessionId;
  final String titleSession;

  const CheckPointsPage({
    super.key,
    required this.sessionId,
    required this.titleSession,
  });

  @override
  State<CheckPointsPage> createState() => _CheckPointsPageState();
}

class _CheckPointsPageState extends State<CheckPointsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  late Session session;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckpointViewmodel>().initialize(
        sessionId: widget.sessionId,
      );
      // session = await SessionService().findOneById(widget.sessionId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
        context.read<CheckpointViewmodel>().loadMore(
          sessionId: widget.sessionId,
        );
      }
    }
  }

  void _createNewCheckPoint() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => CreateCheckPointPage(
        sessionId: widget.sessionId,
        title: widget.titleSession,
      ),
    );
  }

  void _confirmDeleteCheckPoint(
    String title,
    String createdAt,
    int checkpointId,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Suppression pointage?',
        content: 'Êtes vous sur de supprimer ce pointage $title - $createdAt?',
        confirmText: 'Delete',
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;

      context.read<CheckpointViewmodel>().deleteCheckpoint(
        checkpointId,
        widget.sessionId,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pointage supprimée")));
    }
  }

  void _editCheckPoint(int id) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>
          EditCheckPointPage(checkPointId: id, sessionId: widget.sessionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBarOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);

    return Scaffold(
      appBar: MyAppBar(
        title: "Pointages [${widget.titleSession}]",
        appBarOpacity: appBarOpacity,
      ),
      body: Consumer<CheckpointViewmodel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount:
                viewModel.checkpoints.length +
                (viewModel.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (viewModel.checkpoints.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Pas de pointages. Créer en un avec le bouton +",
                    ),
                  ),
                );
              }

              final CheckPoint checkPoint = viewModel.checkpoints[index];

              return Padding(
                padding: const EdgeInsets.all(5),
                child: Card.outlined(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.green.withAlpha(30),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PerformCheckPointPage(
                            checkPointId: checkPoint.id,
                            sessionId: widget.sessionId,
                            sessionTitle: widget.titleSession,
                            checkPointTitle: checkPoint.title,
                          ),
                        ),
                      );
                    },
                    child: CardWidget(
                      cardTitle: DateHelper.formatDate(checkPoint.createdAt),
                      cardText1: checkPoint.title,
                      cardText2: checkPoint.description,
                      enabledEdit: false,
                      enabledDelete: true,
                      callBackButton1: () => _editCheckPoint(checkPoint.id),
                      callBackButton2: () => _confirmDeleteCheckPoint(
                        checkPoint.title,
                        DateHelper.formatDate(checkPoint.createdAt),
                        checkPoint.id,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewCheckPoint,
        tooltip: 'Création pointage',
        foregroundColor: Colors.white,
        backgroundColor: Colors.brown.withAlpha(450),
        child: const Icon(Icons.add),
      ),
    );
  }
}
