import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_controller.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/view/powerstrip/socket_widget.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class PowerstripView extends StatefulWidget {
  const PowerstripView({
    super.key,
    required this.idPowerstrip,
    // required this.powerstrip,
  });
  // final PowerstripModel powerstrip;
  final int idPowerstrip;

  @override
  State<PowerstripView> createState() => _PowerstripViewState();
}

class _PowerstripViewState extends State<PowerstripView> {
  /// ==========================================================================
  /// Page's Widget
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    final powerstripProvider = Provider.of<PowerstripProvider>(context);

    // initWidgets(userModel, powerstripProvider);
    var myPowerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == widget.idPowerstrip);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              myPowerstrip.name,
              style: Styles.pageTitle,
            ),
            IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      'Ganti nama powerstrip',
                      style: Styles.headingStyle1,
                    ),
                    content: Text(
                      'Masukkan nama powerstrip yang baru',
                      style: Styles.bodyTextBlack,
                    ),
                    actions: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextFormField(
                                controller: _updateNameController,
                                prefixIcon: MdiIcons.powerSocketDe,
                                hintText: powerstrip!.name,
                                obscureText: false,
                                keyboardType: TextInputType.name,
                                // onSaved:
                              ),
                              const Gap(16),
                              ElevatedButton(
                                onPressed: () {
                                  // deleteTimer(timerProvider);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Nama socket diganti")),
                                  );
                                  powerstripProvider.updatePowerstripName(
                                    _updateNameController.text,
                                    powerstrip!.id,
                                  );
                                  context.pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Styles.accentColor,
                                    minimumSize: const Size(50, 50),
                                    padding: EdgeInsets.zero),
                                child: Text(
                                  "simpan".toUpperCase(),
                                  style: Styles.buttonTextWhite,
                                ),
                              ),
                              const Gap(8),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Batalkan'),
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(50, 50),
                                ),
                                child: Text(
                                  'Batal'.toUpperCase(),
                                  style: Styles.bodyTextGrey2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                size: 16,
              ),
            ),
          ],
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 5,
              child: Card(
                elevation: 0,
                child: Column(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setPowerstrip(myPowerstrip),
                      icon: Icon(
                        Icons.power_settings_new_rounded,
                        color: myPowerstrip.isPowerstripActive ? Styles.accentColor : Styles.accentColor2,
                        size: 32,
                      ),
                    ),
                    const Gap(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: getSockets(myPowerstrip.sockets!),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  const Gap(5),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      context.pushNamed('powerstrip_schedule', extra: powerstrip);
                    },
                    icon: Icon(
                      Icons.schedule_rounded,
                      color: Styles.accentColor,
                      size: 32,
                    ),
                  ),
                  Text(
                    "Jadwal",
                    style: Styles.bodyTextBlack3,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  const Gap(5),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => context.pushNamed("powerstrip_timer", extra: powerstrip),
                    icon: Icon(
                      Icons.timer,
                      color: Styles.accentColor,
                      size: 32,
                    ),
                  ),
                  Text(
                    "Timer",
                    style: Styles.bodyTextBlack3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ==========================================================================
  /// Data Dictionary
  /// ==========================================================================
  String pageTitle = "";
  List<String> sockets = ['Socket 1', 'Socket 2', 'Socket 3', 'Socket 4'];
  final _powerstripController = PowerstripController();
  final TextEditingController _updateNameController = TextEditingController();

  List<SocketModel>? socketss;
  PowerstripModel? powerstrip;

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  @override
  void initState() {
    super.initState();
    getPowerstripState();

    BuildContext myContext = context;
    final powerstripProvider = Provider.of<PowerstripProvider>(myContext, listen: false);
    powerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == widget.idPowerstrip);
    // pageTitle = widget.powerstrip.name;
  }

  void getPowerstripState() {
    // powerstrip = widget.powerstrip;
    // socketss = powerstrip?.sockets;
  }

  updatePowerstripStatusByOneSocketChange(PowerstripModel powerstrip) {
    for (var socket in powerstrip.sockets!) {
      if (socket.status == true) {
        setState(() {
          powerstrip.isPowerstripActive = true;
        });
        break;
      } else {
        setState(() {
          powerstrip.isPowerstripActive = false;
        });
      }
    }
  }

  void setPowerstrip(PowerstripModel myPowerstrip) async {
    setState(() {
      myPowerstrip.isPowerstripActive = !myPowerstrip.isPowerstripActive;
      for (var socket in myPowerstrip.sockets!) {
        socket.status = myPowerstrip.isPowerstripActive;
      }
    });
    myPowerstrip.updateAllSocketStatus(myPowerstrip.isPowerstripActive);
    await _powerstripController.changeAllSocketStatus(myPowerstrip.id, myPowerstrip.isPowerstripActive);
  }

  List<Widget> getSockets(List<SocketModel> mySockets) {
    List<Widget> socketWidgets = [];
    for (var element in mySockets) {
      socketWidgets.add(
        Container(
          constraints: BoxConstraints(minHeight: AppLayout.getSize(context).height / 5.5),
          child: SocketWidget(
            socketId: element.socketId!,
            powerstripId: element.powerstripId!,
            changeParentState: updatePowerstripStatusByOneSocketChange,
          ),
        ),
      );
    }
    return socketWidgets;
  }
}
