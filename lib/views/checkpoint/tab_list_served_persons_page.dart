import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/dto/person_session_dto.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/widgets/checkpoint/list_tile_person.dart';
import 'package:provider/provider.dart';

class TabListServedPersonsPage extends StatefulWidget {
  final String sessionTitle;
  final CheckPoint checkPoint;

  const TabListServedPersonsPage({
    super.key,
    required this.checkPoint,
    required this.sessionTitle,
  });

  @override
  State<TabListServedPersonsPage> createState() => _TabListServedPersons();
}

class _TabListServedPersons extends State<TabListServedPersonsPage> {
  late ScrollController _scrollControllerToServedPersons;
  double _scrollOffset = 0;
  @override
  void initState() {
    super.initState();
    _scrollControllerToServedPersons = ScrollController();
    _scrollControllerToServedPersons.addListener(_onScroll);
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

    _scrollControllerToServedPersons.removeListener(_onScroll);
    _scrollControllerToServedPersons.dispose();
  }

  void _onScroll() {
    if (_scrollControllerToServedPersons.hasClients) {
      setState(() {
        _scrollOffset = _scrollControllerToServedPersons.offset;
      });

      final maxScroll =
          _scrollControllerToServedPersons.position.maxScrollExtent;
      final currentScroll = _scrollControllerToServedPersons.offset;
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
          controller: _scrollControllerToServedPersons,
          itemCount:
              viewModel.personsServed.length +
              (viewModel.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if(viewModel.personsServed.isEmpty){
              return const Center(
                child: Padding(padding: EdgeInsets.all(16.0),
                child: Text("Liste des personnes à servir vide."),),
              );
            }

            final PersonCheckPointDto personCheckPointDto = viewModel.personsServed[index];

            return ListTilePerson(lastname: personCheckPointDto.lastname, firstname: personCheckPointDto.firstname, callBackTilePerson: () => {},personId: personCheckPointDto.personId,icon: const Icon(Icons.undo), colorBtn: Colors.red, foregroundColorBtn: Colors.red);
          },
        );
      },
    );
  }
}
