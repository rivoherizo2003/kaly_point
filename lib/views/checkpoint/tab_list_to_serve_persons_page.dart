import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_to_serve_dto.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/widgets/checkpoint/list_tile_person.dart';
import 'package:kaly_point/widgets/confirm_dialog.dart';
import 'package:provider/provider.dart';

class TabListToServePersonsPage extends StatefulWidget {
  final String sessionTitle;
  final CheckPoint checkPoint;

  const TabListToServePersonsPage({
    super.key,
    required this.checkPoint,
    required this.sessionTitle,
  });

  @override
  State<TabListToServePersonsPage> createState() =>
      _TabListToServePersonsPageState();
}

class _TabListToServePersonsPageState extends State<TabListToServePersonsPage> {
  late ScrollController _scrollControllerToPersonServes;
  @override
  void initState() {
    super.initState();
    _scrollControllerToPersonServes = ScrollController();
    _scrollControllerToPersonServes.addListener(_onScrollToServePersons);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerformCheckPointViewModel>().initializeTabToServePersons(
        sessionId: widget.checkPoint.sessionId,
        checkPointId: widget.checkPoint.id,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollControllerToPersonServes.removeListener(_onScrollToServePersons);
    _scrollControllerToPersonServes.dispose();
  }

  void _onScrollToServePersons() {
    if (_scrollControllerToPersonServes.hasClients) {
      final maxScroll =
          _scrollControllerToPersonServes.position.maxScrollExtent;
      final currentScroll = _scrollControllerToPersonServes.offset;
      if (currentScroll > 0 && currentScroll >= (maxScroll - 100)) {
        context.read<PerformCheckPointViewModel>().loadMoreToServePersons(
          checkPointId: widget.checkPoint.id,
          sessionId: widget.checkPoint.sessionId,
        );
      }
    }
  }

  void _onClickAssignPerson({
    required int personId,
    required int sessionId,
    required String personFullname,
  }) async {
    final bool? confirmedDelete = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: "Valider pointage",
        content: "Etes vous sur de valider le pointage de [$personFullname] ?",
        confirmText: 'Pointer',
      ),
    );

    if (confirmedDelete == true) {
      if (!mounted) return;

      context.read<PerformCheckPointViewModel>().assignPersonToCheckPoint(
        personId,
        widget.checkPoint.id,
        widget.checkPoint.sessionId,
      );

      if (context.read<PerformCheckPointViewModel>().errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${context.read<PerformCheckPointViewModel>().errorMessage}")),
      );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$personFullname ajouté(e) au pointage!")),
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
          controller: _scrollControllerToPersonServes,
          itemCount:
              viewModel.personsToServe.length +
              (viewModel.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (viewModel.personsToServe.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Liste des personnes à servir vide."),
                ),
              );
            }

            final PersonToServeDto personToServeDto =
                viewModel.personsToServe[index];

            return ListTilePerson(
              iconColor: Colors.deepOrange.shade300,
              lastname: personToServeDto.lastname,
              firstname: personToServeDto.firstname,
              callBackTilePerson: () => _onClickAssignPerson(
                personId: personToServeDto.personId,
                sessionId: widget.checkPoint.sessionId,
                personFullname:
                    "${personToServeDto.firstname} ${personToServeDto.lastname}",
              ),
              personId: personToServeDto.personId,
              icon: const Icon(Icons.check),
              colorBtn: Colors.deepOrange.shade300,
              foregroundColorBtn: Colors.deepOrange.shade300,
            );
          },
        );
      },
    );
  }
}
