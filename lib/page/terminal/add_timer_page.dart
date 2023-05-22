import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/page/terminal/time_picker.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/list_tile_view.dart';
import 'package:jayandra_01/widget/white_container.dart';

class AddTimerPage extends StatefulWidget {
  const AddTimerPage({super.key});

  @override
  State<AddTimerPage> createState() => _AddTimerPageState();
}

class _AddTimerPageState extends State<AddTimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Tambah Timer",
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check_rounded),
          ),
        ],
      ),
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          SizedBox(
            height: 256,
            width: MediaQuery.of(context).size.width,
            child: WhiteContainer(
              padding: 16,
              margin: 16,
              child: Column(
                children: [
                  TimerPickerExample(),
                ],
              ),
            ),
          ),
          WhiteContainer(
            margin: 16,
            padding: 0,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Ulangi",
                    style: Styles.bodyTextBlack2,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Styles.textColor3,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Catatan",
                    style: Styles.bodyTextBlack2,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Styles.textColor3,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Socket",
                    style: Styles.bodyTextBlack2,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Styles.textColor3,
                  ),
                  subtitle: Text(
                    "Socket 1",
                    style: Styles.bodyTextGrey3,
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Socket",
                //       style: Styles.bodyTextBlack2,
                //     ),
                //   ],
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
