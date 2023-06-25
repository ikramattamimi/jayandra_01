import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider
    final powerstripProvider = Provider.of<PowerstripProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    // Provider var
    var powerstrips = powerstripProvider.powerstrips;
    var myHome = homeProvider.findHome(widget.homeModel.email, widget.homeModel.homeName);

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
      ),
      backgroundColor: Styles.primaryColor,
      body: Container(
        // padding: const EdgeInsets.only(left: 16),
        child: Column(
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
}
