import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powerstrip_model.dart';
import 'package:jayandra_01/module/powerstrip/powerstirp_provider.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:provider/provider.dart';

class PowerstripWidget extends StatefulWidget {
  const PowerstripWidget({
    super.key,
    required this.powerstripId,
  });
  final int powerstripId;

  @override
  State<PowerstripWidget> createState() => _PowerstripWidgetState();
}

class _PowerstripWidgetState extends State<PowerstripWidget> {
  late bool _toggleStatus;
  late IconData _toggleIcon;
  late Color _toggleColor;
  late String _activeSocket;
  late PowerstripModel powerstrip;

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
    final screenSize = AppLayout.getSize(context);

    return GestureDetector(
      onTap: () {
        context.pushNamed('powerstrip', extra: myPowerstrip.id);
      },
      child: SizedBox(
        width: screenSize.width / 2.2,
        height: screenSize.height / 5,
        child: Card(
          elevation: 0,
          // margin: const EdgeInsets.only(
          //   left: 16,
          //   bottom: 16,
          // ),
          child: Padding(
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
      ),
    );
  }
}
