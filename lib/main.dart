import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(new MaterialApp(
    title: "Rotation Demo",
    home: new SendSms(),
  ));
}

class SendSms extends StatefulWidget {
  @override
  _SendSmsState createState() => new _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  static const platform = const MethodChannel('sendSms');

  Future<Null> sendSms() async {
    print("SendSMS");
    try {
      var mi = Permission.sms;
      if (await mi.isDenied) {
        log("Permission Denied");
        await Permission.sms.request();
        final String result = await platform.invokeMethod(
            'send', <String, dynamic>{
          "phone": "+2348090650781",
          "msg": "Hello! I'm sent programatically."
        }); //Replace a 'X' with 10 digit phone number
        print(result);
      } else {
        await Permission.sms.request();
        if (await mi.isGranted) {
          final String result = await platform.invokeMethod(
              'send', <String, dynamic>{
            "phone": "+2348090650781",
            "msg": "Hello! I'm sent programatically."
          }); //Replace a 'X' with 10 digit phone number
          print(result);
        }
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Container(
        alignment: Alignment.center,
        child: new FlatButton(
            onPressed: () => sendSms(), child: const Text("Send SMS")),
      ),
    );
  }
}
