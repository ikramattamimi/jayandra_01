import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:provider/provider.dart';

class PowerstripView extends StatefulWidget {
  const PowerstripView({
    super.key,
    required this.powerstripId,
    // required this.powerstrip,
    // required this.powerstripIcon,
  });
  // final PowerstripModel powerstrip;
  // final IconData powerstripIcon;
  final int powerstripId;

  @override
  State<PowerstripView> createState() => _PowerstripViewState();
}

class _PowerstripViewState extends State<PowerstripView> {
  late bool _toggleStatus;
  late IconData _toggleIcon;
  late Color _toggleColor;
  late String _activeSocket;
  late PowerstripModel powerstrip;

  @override
  void initState() {
    super.initState();
    // _toggleStatus = widget.powerstrip.isPowerstripActive;
    // _totalActiveSocket = widget.powerstrip.totalActiveSocket;
    // getTogglesStatus();
  }

  void getTogglesStatus(bool isPowerstripOn, int totalActiveSocket) {
    if (isPowerstripOn == true) {
      _activeSocket = "$totalActiveSocket Socket Aktif";
      _toggleIcon = Icons.toggle_on;
      _toggleColor = Styles.accentColor;
    } else {
      _activeSocket = "Nonaktif";
      _toggleIcon = Icons.toggle_off;
      _toggleColor = Styles.textColor3;
    }
  }

  void setToggle() async {
    _toggleStatus = !_toggleStatus;
    // _totalActiveSocket = 4;
    // _powerstripObjectResponse = await _powerstripController.changeAllSocketStatus(widget.powerstrip.id, _toggleStatus);
    setState(() {
      // getTogglesStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final powerstripProvider = Provider.of<PowerstripProvider>(context);
    final myPowerstrip = powerstripProvider.powerstrips.firstWhere((element) => element.id == widget.powerstripId);

    getTogglesStatus(myPowerstrip.isPowerstripActive, myPowerstrip.totalActiveSocket);

    return GestureDetector(
      onTap: () {
        context.pushNamed('powerstrip', extra: myPowerstrip.id);
      },
      child: SizedBox(
        width: 170,
        height: 140,
        child: Container(
          margin: const EdgeInsets.only(
            left: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: Styles.secondaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================================
              // Icon dan Toggle
              // ===================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.electrical_services_rounded,
                    size: 30,
                  ),
                  // IconButton(
                  //   onPressed: setToggle,
                  //   icon:
                  Icon(
                    _toggleIcon,
                    color: _toggleColor,
                    size: 40,
                  ),
                  // )
                ],
              ),
              // ===================================
              // Nama powerstrip dan status socket
              // ===================================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    myPowerstrip.name,
                    style: Styles.title,
                  ),
                  Text(
                    _activeSocket,
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
}
