import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/page/terminal/time_picker.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/white_container.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Tambah Jadwal",
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
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      backgroundColor: Styles.primaryColor,
      body: ListView(
        children: [
          SizedBox(
            // height: 256,
            width: MediaQuery.of(context).size.width,
            child: WhiteContainer(
              padding: 16,
              margin: 16,
              child: Column(
                children: [
                  MyTimePicker(
                    title: "Jadwal Aktif",
                    ifPickedTime: true,
                    currentTime: startTime,
                    onTimePicked: (x) {
                      setState(() {
                        startTime = x;
                        print("The picked time is: $x");
                      });
                    },
                  ),
                  const Gap(10),
                  MyTimePicker(
                    title: "Jadwal Nonaktif",
                    ifPickedTime: true,
                    currentTime: endTime,
                    onTimePicked: (x) {
                      setState(() {
                        endTime = x;
                        print("The picked time is: $x");
                      });
                    },
                  ),
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

  Future selectedTime(BuildContext context, bool ifPickedTime, TimeOfDay initialTime, Function(TimeOfDay) onTimePicked) async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null) {
      onTimePicked(pickedTime);
    }
  }

  Widget _buildTimePick(String title, bool ifPickedTime, TimeOfDay currentTime, Function(TimeOfDay) onTimePicked) {
    return Row(
      children: [
        SizedBox(
          width: 170,
          child: Text(
            title,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: GestureDetector(
            child: Text(
              currentTime.format(context),
            ),
            onTap: () {
              selectedTime(context, ifPickedTime, currentTime, onTimePicked);
            },
          ),
        ),
      ],
    );
  }
}
