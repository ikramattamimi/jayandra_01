import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jayandra_01/utils/app_styles.dart';
import 'package:jayandra_01/widget/white_container.dart';

class AddingDevicePage extends StatefulWidget {
  const AddingDevicePage({super.key});

  @override
  State<AddingDevicePage> createState() => _AddingDevicePageState();
}

class _AddingDevicePageState extends State<AddingDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Styles.primaryColor,
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
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Styles.textColor,
              size: 20,
            ),
          ),
          // title: Text(
          //   "Tambah Terminal",
          //   style: Styles.bodyTextBlack,
          // ),
        ),
        backgroundColor: Styles.primaryColor,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            // padding: EdgeInsets.all(16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Menambahkan Terminal",
                    style: Styles.headingStyle4,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),
                  GestureDetector(
                    onTap: () => context.pushNamed("done_add_device"),
                    child: SizedBox(
                      height: 380,
                      width: MediaQuery.of(context).size.width,
                      child: WhiteContainer(
                        padding: 16,
                        margin: 0,
                        child: Column(
                          children: [
                            const Gap(16),
                            Text(
                              "Sedang menghubungkan dengan perangkat, mohon tunggu sebentar",
                              style: Styles.bodyTextGrey3,
                              textAlign: TextAlign.center,
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/searching.png"),
                                ],
                              ),
                            ),
                            const Gap(20),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
