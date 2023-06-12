import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_controller.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
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
    // TODO: implement initState
    super.initState();
    // socket = widget.socket;
  }

  @override
  Widget build(BuildContext context) {
    final powerstripProvider = Provider.of<PowerstripProvider>(context);

    // initWidgets(userModel, powerstripProvider);
    var powerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == widget.powerstripId);
    var mySocket = powerstrip.sockets!.firstWhere((element) => element.socketId == widget.socketId);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 85,
          width: 85,
          child: IconButton(
            icon: Icon(
              MdiIcons.powerSocketDe,
              size: 85,
              color: (mySocket.status != false) ? Styles.accentColor : Styles.accentColor2,
            ),
            onPressed: () {
              setState(() {
                mySocket.status = !mySocket.status!;
                powerstrip.updateOneSocketStatus(mySocket.socketId!, mySocket.status!);
                widget.changeParentState(powerstrip);
              });
              _powerstripController.setSocketStatus(mySocket);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        const Gap(10),
        SizedBox(
          width: 67,
          child: Wrap(
            children: [
              Text(
                mySocket.name!,
                style: Styles.bodyTextBlack3,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
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
                      padding: EdgeInsets.symmetric(horizontal: 16),
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
          },
          icon: const Icon(
            Icons.edit,
            size: 16,
          ),
        )
      ],
    );
  }
}
