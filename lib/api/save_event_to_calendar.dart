// aliases are used because both packages contain a class named "Event"
import 'package:add_2_calendar/add_2_calendar.dart' as a2c;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/event_models.dart' as gs;
import 'package:permission_handler/permission_handler.dart';




Future<void> saveEventToCalendar(context, gs.Event gsEvent) async {

  final a2c.Event event = a2c.Event(
    title: gsEvent.title,
    description: gsEvent.description,
    location: gsEvent.location,
    startDate: DateTime.parse(gsEvent.start.toString()),
    endDate: DateTime.parse(gsEvent.end.toString()),
    // iosParams: a2c.IOSParams(), // iosParams allows urls so perhaps after we implement deep linking we can add the event url here
    // androidParams: a2c.AndroidParams(),
    // recurrence: a2c.Recurrence( // implement in the future, add a boolean argument 'asRecur' when we implement this
    //     frequency: a2c.Frequency.monthly,
    //     interval: 2,
    //     ocurrences: 6,
    //   ),
  );

  try {
    await a2c.Add2Calendar.addEvent2Cal(event);
  } catch (e) {
    var status = await Permission.calendarWriteOnly.status;
    if (status.isDenied) {
      print('Calendar access denied');
      showAlertDialog(context, 'Calendar');
    } else {
      print('Error adding event to calendar: $e');
    }
  }
}

showAlertDialog (context, String permissionItem) {
  return showCupertinoDialog<void>(
  context: context, 
  barrierDismissible: false,
  builder: (BuildContext context) => CupertinoAlertDialog(
    title: const Text("Permission Denied"),
    content: Text("Allow access to $permissionItem in settings"),
    actions: <CupertinoDialogAction>[
    CupertinoDialogAction(
      child: const Text('Cancele'),
      onPressed: () => Navigator.of(context).pop(),
    ),
    // CupertinoDialogAction
    CupertinoDialogAction(
      isDefaultAction: true,
      child: const Text ('Settings'),
      onPressed: () => openAppSettings(),
    ),
    ],
  ),
);
}