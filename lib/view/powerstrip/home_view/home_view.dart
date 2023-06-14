import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/circle_icon_container.dart';
import 'package:jayandra_01/view/powerstrip/powerstrip_view.dart';
import 'package:jayandra_01/view/powerstrip/powerstrip_widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final powerstripProvider = Provider.of<PowerstripProvider>(context);
    var powerstrips = powerstripProvider.powerstrips;

    final myPowerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == 1);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Rumah 1",
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
              tabs: [
                Tab(text: powerstrips[0].name),
                const Tab(text: 'Kamar'),
                const Tab(text: 'Ruang Keluarga'),
              ],
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
          PowerstripView(powerstripId: powerstrip.id),
        );
      }
    }
    return powerstripWidgets;
  }
}
