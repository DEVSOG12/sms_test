// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    title: "Rotation Demo",
    home: SendSms(),
  ));
}

class SendSms extends StatefulWidget {
  @override
  _SendSmsState createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  static const platform = MethodChannel('sendSms');

  Future<Null> sendSms({String? number, String? msg}) async {
    log("SendSMS");
    try {
      var mi = Permission.sms;
      if (await mi.isDenied) {
        log("Permission Denied");
        await Permission.sms.request();
        final String result = await platform.invokeMethod(
            'send', <String, dynamic>{
          "phone": number,
          "msg": "Hello! I'm sent programatically."
        }); //Replace a 'X' with 10 digit phone number
        log(result);
      } else {
        await Permission.sms.request();
        if (await mi.isGranted) {
          final String result = await platform.invokeMethod(
              'send', <String, dynamic>{
            "phone": number,
            "msg": msg
          }); //Replace a 'X' with 10 digit phone number
          log(result);
        }
      }
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        child: FlatButton(
            onPressed: () {
              List<String> numbers = [
                "+2348090650781",
                "+2348090650782",
                "+2348090650783"
              ];

              for (var number in numbers) {
                sendSms(
                    number: number, msg: "This is ${numbers.indexOf(number)}");
              }
            },
            child: const Text("Send SMS")),
      ),
    );
  }
}
