import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

class PowerstripView extends StatefulWidget {
  const PowerstripView({
    super.key,
    required this.powerstripId,
    // required this.powerstrip,
  });
  // final PowerstripModel powerstrip;
  final int powerstripId;

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
    var myPowerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == widget.powerstripId);
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Gap(24),
            Text(
              "Informasi Powerstrip",
              style: Styles.headingStyle2,
            ),
            const Gap(5),
            getPowerstripInfoWidget(powerstripProvider, myPowerstrip),
            const Gap(16),
            Text(
              "Informasi Socket",
              style: Styles.headingStyle2,
            ),
            const Gap(5),
            SizedBox(
              height: AppLayout.getSize(context).height * 2 / 3,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                shrinkWrap: true,
                childAspectRatio: 1.3,
                physics: const NeverScrollableScrollPhysics(),
                children: getSockets(myPowerstrip.sockets!),
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
  late String _activeSocket;

  /// ==========================================================================
  /// Local Function
  /// ==========================================================================
  @override
  void initState() {
    super.initState();
    BuildContext myContext = context;
    final powerstripProvider = Provider.of<PowerstripProvider>(myContext, listen: false);
    powerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == widget.powerstripId);
    // pageTitle = widget.powerstrip.name;
    getPowerstripState(powerstrip!.isPowerstripActive, powerstrip!.totalActiveSocket);
  }

  void getPowerstripState(bool isPowerstripOn, int totalActiveSocket) {
    if (isPowerstripOn == true) {
      _activeSocket = "$totalActiveSocket Socket Nyala";
    } else {
      _activeSocket = "Mati";
    }
  }

  Widget getPowerstripInfoWidget(PowerstripProvider powerstripProvider, PowerstripModel myPowerstrip) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setPowerstrip(myPowerstrip);
                    getPowerstripState(
                      myPowerstrip.isPowerstripActive,
                      myPowerstrip.totalActiveSocket,
                    );
                  },
                  icon: Icon(
                    Icons.power_settings_new_rounded,
                    color: myPowerstrip.isPowerstripActive ? Styles.accentColor : Styles.accentColor2,
                    size: 32,
                  ),
                ),
                const VerticalDivider(
                  width: 20,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                  color: Colors.grey,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          myPowerstrip.name,
                          style: Styles.title,
                        ),
                        const Gap(20),
                        InkWell(
                          onTap: () => showUpdatePowerstripNameDialog(
                            powerstripProvider,
                            myPowerstrip,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _activeSocket,
                      style: Styles.bodyTextGrey3,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        context.pushNamed('powerstrip_schedule', extra: powerstrip);
                      },
                      child: Icon(
                        Icons.schedule_rounded,
                        color: Styles.accentColor,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Jadwal",
                      style: Styles.bodyTextBlack3,
                    ),
                  ],
                ),
                const Gap(10),
                Column(
                  children: [
                    InkWell(
                      onTap: () => context.pushNamed("powerstrip_timer", extra: powerstrip),
                      child: Icon(
                        Icons.timer,
                        color: Styles.accentColor,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Timer",
                      style: Styles.bodyTextBlack3,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
          constraints: BoxConstraints(minHeight: AppLayout.getSize(context).height / 6.5),
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

  showUpdatePowerstripNameDialog(PowerstripProvider powerstripProvider, PowerstripModel myPowerstrip) {
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    controller: _updateNameController,
                    prefixIcon: Icons.electrical_services_rounded,
                    hintText: myPowerstrip.name,
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
                        myPowerstrip.id,
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
  }
}
