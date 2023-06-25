
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/socket_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstrip_controller.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/module/powerstrip/socket_controller.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/custom_widget/custom_text_form_field.dart';
import 'package:logger/logger.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SocketWidget extends StatefulWidget {
  const SocketWidget({
    super.key,
    required this.socketId,
    required this.pwsKey,
    // required this.socket,
    required this.changeParentState,
  });
  // final SocketModel socket;
  final Function changeParentState;
  final int socketId;
  final String pwsKey;

  @override
  State<SocketWidget> createState() => _SocketState();
}

class _SocketState extends State<SocketWidget> {
  @override
  void initState() {
    super.initState();
    // socket = widget.socket;
  }

  @override
  void dispose() {
    socketController.socketNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final powerstripProvider = Provider.of<PowerstripProvider>(context);
    var powerstrip = powerstripProvider.findPowerstrip(widget.pwsKey);
    var mySocket = powerstrip.sockets.firstWhere((element) => element.socketNr == widget.socketId);
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
                      value: mySocket.status,
                      onChanged: (value) {
                        setState(() {
                          mySocket.status = !mySocket.status;
                          powerstrip.updateOneSocketStatus(mySocket.socketNr, mySocket.status);
                          widget.changeParentState(powerstrip);
                          socketController.setSocketStatus(mySocket);
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
                  Text(
                    "(Socket ${mySocket.socketNr})",
                    style: Styles.bodyTextGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenSize.width / 5,
                        child: Wrap(
                          children: [
                            Text(
                              mySocket.name.isNotEmpty ? mySocket.name : "Socket ${widget.socketId}",
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

// =============================================================================
// Local Var
// =============================================================================

  // late SocketModel socket;
  final PowerstripController powerstripController = PowerstripController();
  final SocketController socketController = SocketController();

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
                    controller: socketController.socketNameController,
                    prefixIcon: MdiIcons.powerSocketDe,
                    hintText: mySocket.name.isNotEmpty ? mySocket.name : "Socket ${widget.socketId}",
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    // onSaved:
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () {
                      setSocketName(powerstripProvider, mySocket);
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

  // void setSocketStatus(HomeProvider homeProvider) async {

  //     // Menampilkan animasi loading
  //     setState(() {
  //       powerstripController.isLoading = true;
  //     });

  //     try {
  //       // Memproses API
  //       final setSocketStatusResponse = await Future.any([
  //         powerstripController.setSocketStatus(socket),
  //         Future.delayed(
  //           const Duration(seconds: 10),
  //           () => throw TimeoutException('API call took too long'),
  //         ),
  //       ]);

  //       // Menyembunyikan animasi loading
  //       setState(() {
  //         powerstripController.isLoading = false;
  //       });

  //       var userId = UserModel().userId;

  //       // Jika status autentikasi sukses dengan kode 0
  //       if (setSocketStatusResponse!.code == 0) {
  //         var budget = powerstripController.budgetingController.text;
  //         var className = powerstripController.elClassController.text;
  //         var homeName = powerstripController.homeNameController.text;
  //         var home = HomeModel(
  //           budget: budget.isNotEmpty ? double.parse(budget) : 0,
  //           className: className,
  //           homeName: homeName,
  //           userId: userId,
  //         );
  //         homeProvider.addHome(home);

  //         // Menampilkan pesan status
  //         // ignore: use_build_context_synchronously
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(addHomeResponse.message)),
  //         );

  //         // Menunggu 1 detik untuk memberikan kesempatan kepada pengguna
  //         // membaca pesan status autentikasi
  //         Future.delayed(const Duration(seconds: 1), () {
  //           context.pop();
  //         });
  //       }
  //     } catch (err) {
  //       // Menyembunyikan animasi loading
  //       setState(() {
  //         homeController.isLoading = false;
  //       });

  //       // Menampilkan pesan dari controller
  //       // ignore: use_build_context_synchronously
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(err.toString())),
  //       );

  //       Logger(printer: PrettyPrinter()).e(err);
  //     }
  // }

  setSocketName(PowerstripProvider powerstripProvider, SocketModel mySocket) async {
    try {
      mySocket.name = socketController.socketNameController.text;
      // Memproses API
      final response = await socketController.updateSocketName(mySocket);

      // Menyembunyikan animasi loading
      setState(() {
        socketController.isLoading = false;
      });

      // Jika status autentikasi sukses dengan kode 0
      if (response.code == 0) {
        // Set Provider
        powerstripProvider.setSocketName(
          mySocket.name,
          mySocket.socketNr,
          mySocket.pwsKey,
        );

        // Menampilkan pesan status
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );

        // ignore: use_build_context_synchronously
        context.pop();
      }
    } catch (err) {
      // Menyembunyikan animasi loading
      setState(() {
        socketController.isLoading = false;
      });

      // Menampilkan pesan dari controller
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );

      Logger(printer: PrettyPrinter()).e(err);
    }
  }
}
