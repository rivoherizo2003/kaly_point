import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/dto/person_session_dto.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/widgets/checkpoint/list_tile_person.dart';
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
  double _scrollOffset = 0;
  @override
  void initState() {
    super.initState();
    _scrollControllerToPersonServes = ScrollController();
    _scrollControllerToPersonServes.addListener(_onScrollToServePersons);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerformCheckPointViewModel>().initialize(
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
      setState(() {
        _scrollOffset = _scrollControllerToPersonServes.offset;
      });

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

  @override
  Widget build(BuildContext context) {
    return Consumer<PerformCheckPointViewModel>(
      builder: (BuildContext context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          separatorBuilder: (context, index){
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
            if(viewModel.personsToServe.isEmpty){
              return const Center(
                child: Padding(padding: EdgeInsets.all(16.0),
                child: Text("Liste des personnes à servir vide."),),
              );
            }

            final PersonSessionDto personSessionDto = viewModel.personsToServe[index];

            return ListTilePerson(lastname: personSessionDto.lastname, firstname: personSessionDto.firstname, callBackTilePerson: () => {},personId: personSessionDto.personId, icon: const Icon(Icons.check), colorBtn: Colors.green, foregroundColorBtn: Colors.green,);
          },
        );
      },
    );
  }
}
