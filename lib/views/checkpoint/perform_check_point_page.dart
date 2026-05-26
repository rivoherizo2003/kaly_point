import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/utils/date_helper.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/views/checkpoint/create_new_person_page.dart';
import 'package:kaly_point/views/checkpoint/edit_person_page.dart';
import 'package:kaly_point/widgets/checkpoint/state_section.dart';
import 'package:kaly_point/views/checkpoint/tab_list_served_persons_page.dart';
import 'package:kaly_point/views/checkpoint/tab_list_to_serve_persons_page.dart';
import 'package:kaly_point/widgets/confirm_dialog.dart';
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

class _PerformCheckPointPageState extends State<PerformCheckPointPage>
    with SingleTickerProviderStateMixin {
  Timer? _debounce;
  final TextEditingController _controllerSearch = TextEditingController();
  late TabController _tabController;
  int _indexTabActive = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _indexTabActive = _tabController.index;
      if (_controllerSearch.value.text.isNotEmpty) {
        context.read<PerformCheckPointViewModel>().searchPerson(
          _controllerSearch.value.text,
          widget.checkPoint.sessionId,
          widget.checkPoint.id,
          _indexTabActive,
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabController.dispose();
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

  Future<void> _showEditFormPerson(
    PersonCheckPointDto personCheckPointDto,
  ) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => EditPersonPage(
        personCheckPointDto: personCheckPointDto,
        indexActiveTab: _indexTabActive,
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<PerformCheckPointViewModel>().searchPerson(
        query,
        widget.checkPoint.sessionId,
        widget.checkPoint.id,
        _indexTabActive,
      );
    });
  }

  Future<void> _onDeletePerson(PersonCheckPointDto personCheckPointDto) async {
    String message =
        "Êtes vous sur de supprimer cette personne [${personCheckPointDto.firstname} ${personCheckPointDto.lastname}] ?";

    final bool? confirmDeletePerson = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: "Valider suppression",
        content: message,
        confirmText: 'Supprimer',
        warningText: "⚠️ Attention : Cette action est définitive.",
      ),
    );

    if (confirmDeletePerson == true) {
      if (!mounted) return;

      await context.read<PerformCheckPointViewModel>().deletePerson(
        personId: personCheckPointDto.personId,
        indexTabActive: _indexTabActive,
        currentSessionId: personCheckPointDto.currentSessionId,
        currentCheckPointId: personCheckPointDto.checkPointPersonId,
      );
      
      if (!mounted) return;

      final viewModel = context.read<PerformCheckPointViewModel>();
      if (viewModel.errorMessage != null) {
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
        SnackBar(
          content: Text(
            "${personCheckPointDto.firstname} ${personCheckPointDto.lastname} supprimé(e) avec succés!",
          ),
        ),
      );
    }
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
                      TabBar(
                        controller: _tabController,
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
                                  textStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  textStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          controller: _controllerSearch,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade600,
                            ),
                            hintText: "Ex: 12 nom prenom",
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
                            suffixIcon:
                                ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _controllerSearch,
                                  builder: (context, value, child) {
                                    return value.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              _onSearchChanged('');
                                              _controllerSearch.clear();
                                            },
                                            icon: const Icon(Icons.clear),
                                          )
                                        : const SizedBox.shrink();
                                  },
                                ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            TabListToServePersonsPage(
                              checkPoint: widget.checkPoint,
                              sessionTitle: widget.checkPoint.title,
                              callBackDeletePerson: _onDeletePerson,
                              callBackEditPerson: _showEditFormPerson,
                            ),
                            TabListServedPersonsPage(
                              checkPoint: widget.checkPoint,
                              sessionTitle: widget.checkPoint.title,
                              callBackDeletePerson: _onDeletePerson,
                              callBackEditPerson: _showEditFormPerson,
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
        floatingActionButton: FloatingActionButton.small(
          onPressed: _addNewPerson,
          tooltip: 'Ajouter une personne',
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey.withAlpha(450),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
