import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/utils/date_helper.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/widgets/card_widget.dart';
import 'package:kaly_point/widgets/checkpoint/state_section.dart';
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
  final double _scrollOffset = 0;
  @override
  Widget build(BuildContext context) {
    final appBarOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);
    return Scaffold(
      appBar: MyAppBar(
        title:
            "${widget.checkPoint.title} [${DateHelper.formatDate(widget.checkPoint.createdAt)}]",
        appBarOpacity: appBarOpacity,
      ),
      body: Consumer<PerformCheckPointPageViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              Text(widget.sessionTitle),
              const StateSection(),
              Expanded(child: DefaultTabController(length: 2, child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(labelColor: AppColors.primaryBlue,unselectedLabelColor: Colors.grey, indicatorColor: AppColors.primaryBlue, indicatorWeight: 3, tabs: [
                      Tab(text: "A servir (100)"),
                      Tab(text: "Servi (45)",)
                    ],),
                  )
                ],
              ))),
            ],
          );
        },
      ),
    );
  }
}
