import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cards_record/view/widgets/public_widget.dart';

// دالة مسؤولة عن عرض اداة تحديد التاريخ للمستخدم وثم اداة تحديد الوقت وترجع
// الناتج كمتغير يحتوي على التاريخ والوقت
Future<String> getDateAndTimeFromUser(String? initDateTime) async {
  try {
    String pickedDateTime = DateTime.now().toString();
    DateTime initDate = DateTime.now();
    TimeOfDay initTime = TimeOfDay.now();

    // عمل اعادة تعيين وتحويل للتاريخ الابتدائي وتقسيمه الى تاريخ ووقت
    if (initDateTime != null) {
      pickedDateTime = initDateTime;
      List<String> parts = initDateTime.split(' ');
      initDate = DateFormat('yyyy/MM/dd').parse(parts[0]);
      parts = parts[1].split(':');
      initTime =
          TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    // تمكين المستخدم من تحديد التاريخ
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
    );

    // تمكين المستخدم من تحديد الوقت
    if (pickedDate != null) {
      final TimeOfDay? pickedTime =
          await showTimePicker(context: Get.context!, initialTime: initTime);

      if (pickedTime != null) {
        pickedDateTime = DateFormat('yyyy/MM/dd H:m:s').format(DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
            DateTime.now().second));
      }
    }
    return pickedDateTime;
  } catch (e) {
    print("::::Error in getDateAndTimeFromUser: $e");
    return "_";
  }
}

// دالة لارجاع تاريخ الان كقيمة ابتدائية بتنسيق محدد حتى التزم بهذا التنسيق في كامل التطبيق
String initializeDate() {
  return DateFormat('yyyy/MM/dd H:mm:s').format(DateTime.now());
}

// دالة تستقبل التاريخ وتقوم بارجاعه بشكل منسق جاهز للعرض للمستخدم
String formatDateToShow(String date, {bool showTime = false}) {
  try {
    print(date);
    List<String> partsDate = date.split(' ');
    String formattedDate = partsDate[0];
    if (showTime && partsDate.length > 1) {
      final time = DateFormat('H:mm:s').parse(partsDate[1]);
      formattedDate += "  " + DateFormat('h:mm:s a').format(time);
    }
    return formattedDate;
  } catch (e) {
    print("::::Error in formatDateToShow: $e");
    return "_";
  }
}

List<Widget> sortWidgetsByDate(List<Widget> widgets) {
  try {
    print("Length: ${widgets.length}");
    print(widgets[0].runtimeType);
    widgets.sort((a, b) {
      print("Key Widget::: ${a.key}");
      String keyString1 = a.key.toString();
      String date1 = keyString1.substring(3, keyString1.length - 3);
      String keyString2 = b.key.toString();
      String date2 = keyString2.substring(3, keyString2.length - 3);
      return DateFormat('yyyy/MM/dd H:mm:s')
          .parse(date2)
          .compareTo(DateFormat('yyyy/MM/dd H:mm:s').parse(date1));
    });
    // return widgets;
  } catch (e) {
    print("Error in sortWidgetsByDate::: $e");
    buildSnackbar("There is error. try again");
  }
  return widgets;
  // List<String> date= widgets.map((e) => e.key.toString()).toList();
  // print("date: $date");
}

buildButtonsRowAsDialog(List<Widget> buttonsList) {
  return buildDialog(
    title: "",
    content: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttonsList,
      ),
    ),
    actionToolsList: [],
  );
}
