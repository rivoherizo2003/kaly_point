import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/utils/date_helper.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/views/checkpoint/create_new_person_page.dart';
import 'package:kaly_point/widgets/checkpoint/state_section.dart';
import 'package:kaly_point/views/checkpoint/tab_list_served_persons_page.dart';
import 'package:kaly_point/views/checkpoint/tab_list_to_serve_persons_page.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addNewPerson() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => CreateNewPersonPage(
        checkPointId: widget.checkPoint.id,
        sessionId: widget.checkPoint.sessionId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(
          title:
              "${widget.checkPoint.title} [${DateHelper.formatDate(widget.checkPoint.createdAt)}]",
          appBarOpacity: 0.5,
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
                      const Text("Liste des personnes"),
                      TabBar(
                        labelColor: AppColors.primaryBlue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.primaryBlue,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(
                            child: Row(  
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8),
                                const Text("A servir"),
                                Badge(
                                  label: Text(
                                    "${viewModel.stateCheckPoint.nbrPersonToServe}",
                                  ),
                                  textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  backgroundColor: Colors.deepOrange.shade300,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  child: Icon(Icons.person_2_outlined),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8),
                                const Text("Servi"),
                                Badge(
                                  label: Text(
                                    "${viewModel.stateCheckPoint.nbrPersonServed}",
                                  ),
                                  textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  child: Icon(Icons.person_2_outlined),
                                ),
                              ],
                            ),
                          ),
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
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            TabListToServePersonsPage(
                              checkPoint: widget.checkPoint,
                              sessionTitle: widget.checkPoint.title,
                            ),
                            TabListServedPersonsPage(
                              checkPoint: widget.checkPoint,
                              sessionTitle: widget.checkPoint.title,
                            ),
                          ],
                        ),
                      ),
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
