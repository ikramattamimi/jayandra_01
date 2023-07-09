import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jayandra_01/models/home_model.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/view/powerstrip/powerstrip_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.homeModel});
  final HomeModel homeModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provider
    final powerstripProvider = Provider.of<PowerstripProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    // Provider var
    var myHome = homeProvider.findHome(widget.homeModel.homeId);
    var powerstrips = powerstripProvider.powerstrips.where((element) => element.homeId == myHome.homeId).toList();

    _tabController = TabController(length: powerstrips.length, vsync: this);

    // final myPowerstrip = powerstrips.isEmpty ? null : powerstrips.firstWhere((element) => element.id == 1);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          myHome.homeName,
          style: Styles.pageTitle,
        ),
        backgroundColor: Styles.primaryColor,
        centerTitle: true,
        foregroundColor: Styles.textColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Kelas Listrik',
                onTap: () {
                  context.pushNamed(
                    "electricity_class_page",
                    extra: widget.homeModel.homeId,
                  );
                },
                child: Text(
                  'Kelas Listrik : ${widget.homeModel.className}',
                  style: Styles.bodyTextBlack,
                ),
              ),
              PopupMenuItem<String>(
                value: 'Budgeting',
                onTap: () {
                  context.pushNamed(
                    "budgeting_page",
                    extra: widget.homeModel,
                    queryParams: {
                      'budgetText': widget.homeModel.budget.toInt().toString(),
                    },
                  );
                },
                child: Text(
                  NumberFormat.currency(
                    symbol: "Budget : Rp ",
                    decimalDigits: 2,
                  ).format(widget.homeModel.budget),
                  style: Styles.bodyTextBlack,
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Styles.primaryColor,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Styles.accentColor,
            dividerColor: Styles.accentColor,
            indicatorColor: Styles.accentColor,
            unselectedLabelColor: Styles.accentColor2,
            tabs: getTabs(powerstrips),
            // final myPowerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == 1);
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: getPowerstripWidget(powerstrips),
            ),
          ),
          // Row(
          //   children: getPowerstripWidget(powerstrips),
          // )
        ],
      ),
    );
  }

  List<Widget> getPowerstripWidget(List<PowerstripModel> powerstrips) {
    List<Widget> powerstripWidgets = [];
    if (powerstrips != []) {
      for (var powerstrip in powerstrips) {
        powerstripWidgets.add(
          PowerstripView(
            pwsKey: powerstrip.pwsKey,
            homeName: widget.homeModel.homeName,
            homeId: widget.homeModel.homeId,
          ),
        );
      }
    }
    return powerstripWidgets;
  }

  List<Widget> getTabs(List<PowerstripModel> powerstrips) {
    List<Widget> tabs = [];
    for (var powerstrip in powerstrips) {
      tabs.add(Tab(text: powerstrip.pwsName.isEmpty ? "Powerstrip" : powerstrip.pwsName));
    }
    return tabs;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
