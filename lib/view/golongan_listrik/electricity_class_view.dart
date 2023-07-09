import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/module/home/home_controller.dart';
import 'package:jayandra_01/module/home/home_provider.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/circle_icon_container.dart';
import 'package:provider/provider.dart';

class ElectricityClassView extends StatefulWidget {
  const ElectricityClassView({super.key, required this.homeId});

  final int homeId;

  @override
  State<ElectricityClassView> createState() => _ElectricityClassViewState();
}

class _ElectricityClassViewState extends State<ElectricityClassView> {
  var description =
      "Golongan Listrik merupakan tarif tenaga listrik yang disediakan oleh PT Perusahaan Listrik Negara (Persero) kepada konsumen. Anda dapat mengetahui golongan listrik yang terpasang di rumah Anda melalui struk tagihan listrik.";
  var electricityClassData = [
    {
      'nama': 'R1 / 900 VA',
      'biaya': 1352.00,
    },
    {
      'nama': 'R1 / 1300 VA',
      'biaya': 1444.70,
    },
    {
      'nama': 'R1 / 2200 VA',
      'biaya': 1444.70,
    },
    {
      'nama': 'R2 / 3500 VA',
      'biaya': 1699.53,
    },
    {
      'nama': 'R2 / 5500 VA',
      'biaya': 1699.53,
    },
    {
      'nama': 'R3 / 6600',
      'biaya': 1699.53,
    },
  ];

  String? selectedElClass;

  final homeController = HomeController();

  @override
  void initState() {
    super.initState();
    // electricityClass = ;
  }

  void selectRadio(value) {
    setState(() {
      selectedElClass = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context);
    var selectedHome = homeProvider.findHome(widget.homeId);
    selectedElClass = selectedHome.className;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Golongan Listrik",
          style: Styles.pageTitle,
        ),
        backgroundColor: Styles.secondaryColor,
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
      body: ListView(
        children: [
          Card(
            elevation: 0,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(32),
                  Align(
                    alignment: Alignment.center,
                    child: CircleIconContainer(
                      width: 80,
                      height: 80,
                      color: Styles.accentColor,
                      icon: Icons.money,
                      iconSize: 40,
                      iconColor: Styles.secondaryColor,
                    ),
                  ),
                  const Gap(32),
                  Text(
                    description,
                    style: Styles.bodyTextBlack2,
                    textAlign: TextAlign.justify,
                  ),
                  const Gap(16),
                  Text(
                    "Silahkan pilih golongan listrik anda:",
                    style: Styles.bodyTextBlack2,
                  ),
                  const Gap(8),
                  Column(
                    children: electricityClassData.map((items) {
                      return RadioListTile(
                        title: Text(
                          items['nama'].toString(),
                          style: Styles.bodyTextBlack2,
                        ),
                        selected: selectedElClass == items['nama'].toString(),
                        value: items['nama'].toString(),
                        groupValue: selectedElClass,
                        onChanged: (value) {
                          selectRadio(value);
                          selectedHome.className = selectedElClass ?? selectedHome.className;
                          homeController.updateHome(selectedHome);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
