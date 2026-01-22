import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/models/state_check_point.dart';
import 'package:kaly_point/utils/date_helper.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/views/checkpoint/create_new_person_page.dart';
import 'package:kaly_point/widgets/checkpoint/state_section.dart';
import 'package:kaly_point/widgets/checkpoint/tab_list_served_persons.dart';
import 'package:kaly_point/widgets/checkpoint/tab_list_to_serve_persons.dart';
import 'package:kaly_point/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class PerformCheckPointPage extends StatefulWidget {
  final String sessionTitle;
  final CheckPoint checkPoint;

  const PerformCheckPointPage({
    super.key,
    required this.checkPoint,
    required this.sessionTitle,
  });

  @override
  State<PerformCheckPointPage> createState() => _PerformCheckPointPageState();
}

class _PerformCheckPointPageState extends State<PerformCheckPointPage> {
  late ScrollController _scrollControllerPersonServed;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollControllerPersonServed = ScrollController();
    _scrollControllerPersonServed.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerformCheckPointViewModel>().initialize(sessionId: widget.checkPoint.sessionId, checkPointId: widget.checkPoint.id);
    });
  }

  @override
  void dispose() {
    _scrollControllerPersonServed.removeListener(_onScroll);
    _scrollControllerPersonServed.dispose();
    super.dispose();
  }

  void _onScroll(){
    if(_scrollControllerPersonServed.hasClients){
      setState(() {
        _scrollOffset = _scrollControllerPersonServed.offset;
      });

      final maxScroll = _scrollControllerPersonServed.position.maxScrollExtent;
      final currentScroll = _scrollControllerPersonServed.offset;
      if(currentScroll > 0 && currentScroll >= (maxScroll - 100)){
        context.read<PerformCheckPointViewModel>().loadMore(checkPointId: widget.checkPoint.id, sessionId: widget.checkPoint.sessionId);
      }
    }
  }

  void _addNewPerson() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => CreateNewPersonPage(checkPointId: widget.checkPoint.id, sessionId: widget.checkPoint.sessionId,),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBarOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(
          title:
              "${widget.checkPoint.title} [${DateHelper.formatDate(widget.checkPoint.createdAt)}]",
          appBarOpacity: appBarOpacity,
        ),
        body: Consumer<PerformCheckPointViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                Text(widget.sessionTitle),
                StateSection(stateCheckPoint: viewModel.stateCheckPoint),
                Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: AppColors.primaryBlue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.primaryBlue,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(text: "A servir (100)"),
                          Tab(text: "Servi (45)"),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 10.0,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade600,
                            ),
                            hintText: "Rechercher nom/numéro...",
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      const TabListToServePersons(),
                      const TabListServedPersons(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewPerson,
          tooltip: 'Ajouter une personne',
          foregroundColor: Colors.white,
          backgroundColor: Colors.primaries.first.shade200,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
