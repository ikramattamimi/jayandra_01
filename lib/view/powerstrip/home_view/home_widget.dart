import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/models/powestrip_model.dart';
import 'package:jayandra_01/utils/app_layout.dart';
import 'package:jayandra_01/utils/app_styles.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
  });

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String powerstripStatus = "1 Powerstrip Aktif";
  late PowerstripModel powerstrip;

  @override
  Widget build(BuildContext context) {
    final screenSize = AppLayout.getSize(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 16,
      ),
      child: InkWell(
        onTap: () {
          context.goNamed('home_view');
        },
        child: SizedBox(
          width: screenSize.width / 2.5,
          height: screenSize.height / 5.5,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.home_rounded,
                    size: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rumah 1",
                        style: Styles.title,
                      ),
                      Text(
                        powerstripStatus,
                        style: Styles.bodyTextGrey3,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
