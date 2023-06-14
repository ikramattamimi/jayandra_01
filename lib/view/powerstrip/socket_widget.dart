import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_controller.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SocketWidget extends StatefulWidget {
  const SocketWidget({
    super.key,
    required this.socketId,
    required this.powerstripId,
    // required this.socket,
    required this.changeParentState,
  });
  // final SocketModel socket;
  final Function changeParentState;
  final int socketId;
  final int powerstripId;

  @override
  State<SocketWidget> createState() => _SocketState();
}

class _SocketState extends State<SocketWidget> {
  // late SocketModel socket;
  final PowerstripController _powerstripController = PowerstripController();
  final TextEditingController _updateNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // socket = widget.socket;
  }

  @override
  Widget build(BuildContext context) {
    final powerstripProvider = Provider.of<PowerstripProvider>(context);
    var powerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == widget.powerstripId);
    var mySocket = powerstrip.sockets!.firstWhere((element) => element.socketId == widget.socketId);
    final screenSize = AppLayout.getSize(context);
    return SizedBox(
      // height: 120,
      width: screenSize.width / 2.5,
      height: screenSize.height / 5,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    MdiIcons.powerSocketDe,
                    size: 30,
                  ),
                  SizedBox(
                    width: 40,
                    height: 25,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: mySocket.status!,
                      onChanged: (value) {
                        setState(() {
                          mySocket.status = !mySocket.status!;
                          powerstrip.updateOneSocketStatus(mySocket.socketId!, mySocket.status!);
                          widget.changeParentState(powerstrip);
                        });
                      },
                      activeColor: Styles.accentColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenSize.width / 5,
                        child: Wrap(
                          children: [
                            Text(
                              mySocket.name!,
                              style: Styles.title,
                            ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   padding: EdgeInsets.zero,

                      //   onPressed: showEditNameDialog(mySocket, powerstripProvider),
                      //   icon: const Icon(
                      //     Icons.edit,
                      //     size: 16,
                      //   ),
                      // ),
                      InkWell(
                        onTap: () => showEditNameDialog(mySocket, powerstripProvider),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                  Text(
                    (mySocket.status != false) ? "Nyala" : "Mati",
                    style: Styles.bodyTextGrey3,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showEditNameDialog(SocketModel mySocket, PowerstripProvider powerstripProvider) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Ganti nama socket',
          style: Styles.headingStyle1,
        ),
        content: Text(
          'Masukkan nama socket yang baru',
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
                    prefixIcon: MdiIcons.powerSocketDe,
                    hintText: mySocket.name!,
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
                      powerstripProvider.updateSocketName(
                        _updateNameController.text,
                        mySocket.socketId!,
                        mySocket.powerstripId!,
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
