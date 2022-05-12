// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:car_play_app/presentation/state_management/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isToggled1 = false;
  bool isToggled2 = false;

  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Interface",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      height: 150,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                  value: 1,
                                  groupValue: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value as int;
                                    });
                                    Navigator.pop(context);
                                  }),
                              SizedBox(width: 5),
                              Text("Landscape mode"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: 2,
                                  groupValue: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value as int;
                                    });
                                    Navigator.pop(context);
                                  }),
                              SizedBox(width: 5),
                              Text("Portrait mode"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("CANCLE"),
                      ),
                    ],
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: "Select a skin\n",
                  style: TextStyle(
                    color: Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'CarPlay',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dark mode"),
                FlutterSwitch(
                  height: 15.0,
                  width: 30.0,
                  toggleSize: 10.0,
                  borderRadius: 10.0,
                  activeColor: Colors.red,
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onToggle: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(value);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Switch to Android"),
                FlutterSwitch(
                  height: 15.0,
                  width: 30.0,
                  toggleSize: 10.0,
                  borderRadius: 10.0,
                  activeColor: Colors.red,
                  value: isToggled2,
                  onToggle: (value) {
                    setState(() {
                      isToggled2 = value;
                    });
                  },
                ),
              ],
            ),
            GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Remove Advertising"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value as int;
                                      });
                                      Navigator.pop(context);
                                    }),
                                SizedBox(width: 5),
                                Text("Donate \$1.00 USD"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value as int;
                                      });
                                      Navigator.pop(context);
                                    }),
                                SizedBox(width: 5),
                                Text("Donate \$2.00 USD"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 3,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value as int;
                                      });
                                      Navigator.pop(context);
                                    }),
                                SizedBox(width: 5),
                                Text("Donate \$3.00 USD"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 4,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value as int;
                                      });
                                      Navigator.pop(context);
                                    }),
                                SizedBox(width: 5),
                                Text("Donate \$4.00 USD"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 5,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value as int;
                                      });
                                      Navigator.pop(context);
                                    }),
                                SizedBox(width: 5),
                                Text("Donate \$5.00 USD"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 6,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value as int;
                                      });
                                      Navigator.pop(context);
                                    }),
                                SizedBox(width: 5),
                                Text("I did it before"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("CANCLE"),
                        ),
                      ],
                    ),
                  );
                },
                child: Text("Remove advertising")),
            Divider(),
            Text(
              "About Car Player",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            Text("Send feedback"),
            Text("Privacy Policy"),
            RichText(
              text: TextSpan(
                text: "Build\n",
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Version 2.2.11',
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
