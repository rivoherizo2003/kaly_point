import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/widgets/checkpoint/list_tile_person.dart';
import 'package:kaly_point/widgets/confirm_dialog.dart';
import 'package:kaly_point/widgets/error_message.dart';
import 'package:provider/provider.dart';
import 'package:kaly_point/utils/typedefs.dart';

class TabListServedPersonsPage extends StatefulWidget {
  final String sessionTitle;
  final CheckPoint checkPoint;
  final OnDeletePersonCallback callBackDeletePerson;
  final OnEditPersonCallback callBackEditPerson;

  const TabListServedPersonsPage({
    super.key,
    required this.checkPoint,
    required this.sessionTitle,
    required this.callBackDeletePerson,
    required this.callBackEditPerson,
  });

  @override
  State<TabListServedPersonsPage> createState() => _TabListServedPersons();
}

class _TabListServedPersons extends State<TabListServedPersonsPage> {
  late ScrollController _scrollControllerServedPersons;
  @override
  void initState() {
    super.initState();
    _scrollControllerServedPersons = ScrollController();
    _scrollControllerServedPersons.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerformCheckPointViewModel>().initializeTabServedPersons(
        sessionId: widget.checkPoint.sessionId,
        checkPointId: widget.checkPoint.id,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollControllerServedPersons.removeListener(_onScroll);
    _scrollControllerServedPersons.dispose();
  }

  void _onScroll() {
    if (_scrollControllerServedPersons.hasClients) {
      final maxScroll = _scrollControllerServedPersons.position.maxScrollExtent;
      final currentScroll = _scrollControllerServedPersons.offset;
      if (currentScroll > 0 && currentScroll >= (maxScroll - 100)) {
        context.read<PerformCheckPointViewModel>().loadMoreServedPersons(
          checkPointId: widget.checkPoint.id,
          sessionId: widget.checkPoint.sessionId,
        );
      }
    }
  }

  void _onClickUnassignPerson({
    required int checkPointPersonId,
    required String personFullname,
  }) async {
    final bool? confirmedUnassign = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: "Supprimer pointage",
        content:
            "Etes vous sur de supprimer le pointage de [$personFullname] ?",
        confirmText: 'Supprimer',
      ),
    );

    if (confirmedUnassign == true) {
      if (!mounted) return;

      context.read<PerformCheckPointViewModel>().deletePersonCheckPoint(
        checkPointPersonId,
        widget.checkPoint.sessionId,
        widget.checkPoint.id,
      );

      if (context.read<PerformCheckPointViewModel>().errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${context.read<PerformCheckPointViewModel>().errorMessage}",
            ),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$personFullname supprimé(e) du pointage!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PerformCheckPointViewModel>(
      builder: (BuildContext context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if(viewModel.errorMessage != null){
          return ErrorMessage(errorMessage: viewModel.errorMessage, callBackDismiss: ()=> {viewModel.clearError()});
        }

        return ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              thickness: 0.2,
              indent: 16,
              endIndent: 16,
              color: Colors.grey,
            );
          },
          controller: _scrollControllerServedPersons,
          itemCount:
              viewModel.personsServed.length +
              (viewModel.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (viewModel.personsServed.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Liste des personnes à servir vide."),
                ),
              );
            }

            final PersonCheckPointDto personCheckPointDto =
                viewModel.personsServed[index];

            return ListTilePerson(
              personCheckPointDto: personCheckPointDto,
              callBackTilePerson: () => {
                if (personCheckPointDto.checkPointPersonId != null)
                  _onClickUnassignPerson(
                    checkPointPersonId: personCheckPointDto.checkPointPersonId!,
                    personFullname:
                        "${personCheckPointDto.firstname} ${personCheckPointDto.lastname}",
                  ),
              },
              icon: const Icon(Icons.undo),
              colorBtnAndForegroundBtn: const Color.fromARGB(255, 201, 107, 7),
              iconColor: Colors.green,
              callBackEndToStart: () =>
                  widget.callBackDeletePerson(personCheckPointDto),
              callBackStartToEnd: () => widget.callBackEditPerson(personCheckPointDto),
            );
          },
        );
      },
    );
  }
}
