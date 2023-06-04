import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/user_model.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/circle_icon_container.dart';
import 'package:jayandra_01/widget/white_container.dart';
import 'package:provider/provider.dart';

class ElectricityClassPage extends StatefulWidget {
  const ElectricityClassPage({super.key});

  @override
  State<ElectricityClassPage> createState() => _ElectricityClassPageState();
}

class _ElectricityClassPageState extends State<ElectricityClassPage> {
  var description =
      "Golongan Listrik merupakan tarif tenaga listrik yang disediakan oleh PT Perusahaan Listrik Negara (Persero) kepada konsumen. Anda dapat mengetahui golongan listrik yang terpasang di rumah Anda melalui struk tagihan listrik.";
  var electricityClassData = [
    {
      'nama': 'R1 / 900 VA',
      'biaya': 1352.00,
    },
    {
      'nama': 'R1 / 1.300 VA - 2.200 VA',
      'biaya': 1444.70,
    },
    {
      'nama': 'R2 / 3.500 VA - 5.500 VA',
      'biaya': 1699.53,
    },
    {
      'nama': 'R3 / 6.600 VA ke atas',
      'biaya': 1699.53,
    },
  ];

  String? electricityClass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // electricityClass = ;
  }

  void selectRadio(value) {
    setState(() {
      electricityClass = value.toString();
      print(electricityClass);
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context);
    electricityClass = user.electricityclass;
    print(user.electricityclass);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Styles.secondaryColor,
        // statusBarIconBrightness: Brightness.dark,
        // statusBarBrightness: Brightness.light,
      ),
    );
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
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Styles.primaryColor,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
            );
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
                        value: items['nama'].toString(),
                        groupValue: electricityClass,
                        onChanged: (value) {
                          selectRadio(value);
                          
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
