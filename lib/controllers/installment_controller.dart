import 'package:flutter/material.dart' show BorderRadius, BorderSide, Color, Column, Container, EdgeInsets, ElevatedButton, Form, FormState, GlobalKey, Icon, IconButton, Icons, InputDecoration, MainAxisAlignment, OutlineInputBorder, Padding, Row, SizedBox, Text, TextAlign, TextEditingController, TextFormField, TextInputType, Widget;
import 'package:get/get.dart';
import 'package:cards_record/controllers/operations_controller.dart';
import 'package:cards_record/core/app_functions.dart';
import '../components/choice_chip_row.dart';
import '../view/widgets/public_widget.dart' show buildDialog, buildCancelElevatedButton, buildSnackbar;

import '../models/app_Db.dart' show appDb, Installment;
import '../models/operations_on_db.dart' show getTotallAllBatches, getTotallAllCreditInstallments, getTotallAllCreditorInstallments;

class InstallmentController extends GetxController{
  // متغير سيحتوي على تاريخ سداد القسط
  // Rx<DateTime> installmentDate= DateTime.now().obs;
  Rx<String> installmentDate= initializeDate().obs;// DateFormat('yyyy/MM/dd H:m:s').format(DateTime.now()).obs;
  int _amount= 0;   // قيمة القسط
  String _receiver= "";   // مستلم القسط
  String _note = "";  // ملاحظة حول القسط
  bool _is_creditor= true;
  RxInt restBefore= 0.obs;
  RxInt restAfter= 0.obs;
  @override
  void onInit() async{
    installmentDate.value= initializeDate(); //DateFormat('yyyy/MM/dd H:m:s').format(DateTime.now());
    _amount = 0;
    _receiver = "";
    _note = "";
    _is_creditor = true;
    restBefore = 0.obs;
    restAfter = 0.obs;
    super.onInit();
  }

  // دالة لتحديث القيمة المتبقية بناءا على نوع القسط اذا كان دائن ام مدين
  void setCreditorOrCredit(int selectedChoice) {
    _is_creditor = selectedChoice == 0;
    if (_is_creditor) {      
      restAfter.value = restBefore.value - _amount;
    } else {
      restAfter.value = restBefore.value + _amount;
    }

    // update();
  }

  void updateRestValues({required bool isEdit, int? rest, String? amount})async{
    try {
      print(restBefore.value);
      if (isEdit && rest != null && amount != null) {
        print("///////////////");
        restBefore.value =
            _is_creditor ? rest + int.parse(amount) : rest - int.parse(amount);
        print(restBefore.value);
        restAfter.value = rest;
      } else {
        restBefore.value = (await getTotallAllBatches() +
                await getTotallAllCreditInstallments()) -
            (await getTotallAllCreditorInstallments());
        int tempAmount = amount != null ? int.parse(amount) : 0;
        restAfter.value = _is_creditor
            ? restBefore.value - tempAmount
            : restBefore.value + tempAmount;
      }
      print(restBefore.value);
    } catch (e) {
      print("====Error in updateRestValues Fun: $e");
    }
  }

  // للقسط، سواء كان اضافة قسط جديد أو تعديل قسط موجود dialog دالة لبناء مربع
  void buildInstallmentDialog(
      {String initAmount = "", String initReceiver = "", String initNote = "",
      String date = "", int? rest, int? idToEdit, bool is_creditor = true}) async{
    this.onInit();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();  
    // عمل تهيئة للقيم بناء على القيم المستقبلة اذا كان نوع العملية هو تعديل  
    _is_creditor = is_creditor;
    if (initAmount.isNotEmpty) _amount = int.parse(initAmount);
    if (date.isNotEmpty){
      installmentDate.value = date;
      // installmentDate.value = DateFormat('yyyy/MM/dd').parse(date);
    }
    // if (rest == null) {
    //   restBefore.value =(await getTotallAllBatches()) - (await getTotallAllCreditorInstallments())+ await getTotallAllCreditInstallments();
    //   restAfter.value = restBefore.value;
    // } else{
    //   restBefore.value= _is_creditor? rest+int.parse(initAmount):rest-int.parse(initAmount);
    //   restAfter.value= rest;
    // }
    print(idToEdit != null);
    updateRestValues(isEdit: idToEdit != null, rest: rest, amount: _amount.toString());

    buildDialog(
      title: idToEdit == null? "Pay Installment": "Edit Installment",
      content: Column(
        children: [
          // خيارات لتحديد هل القسط دائن او مدين
          ChoiceChipRow(
            choices: ["Creditor".tr, "Credit".tr],
            changeSelected: (value) {
              setCreditorOrCredit(value);
              updateRestValues(isEdit: idToEdit!=null, rest: rest, amount: _amount.toString());
            },
            initialSelected: _is_creditor? 0: 1,
          ),

          // صناديق ادخال مبلغ القسط ومستلم القسط والملاحظة
          Form(
            key: formKey,
            child: Column(
              children: [
                buildTextFieldForm(
                    label: "Amount",
                    hint: "Enter the amount",
                    initialValue: initAmount),
                buildTextFieldForm(
                    label: "To (optional)",
                    hint: "Who received the installment?",
                    initialValue: initReceiver), 
                buildTextFieldForm(
                    label: "Note (optional)",
                    hint: "",
                    initialValue: initNote),
              ],
            ),
          ),            
          
          // عرض تاريخ تسليم القسط وزر لتعديل التاريخ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Obx(
                  () => Text(
                    "${'Installment date'.tr}: ${formatDateToShow(installmentDate.value)}",
                    // "${'Installment date'.tr}: ${DateFormat('yyyy/MM/dd').format(installmentDate.value)}",
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
              ),
              // زر لتعديل التاريخ
              IconButton(
                onPressed: () async{
                  installmentDate.value = await getDateAndTimeFromUser(installmentDate.value);
                  // await showDatePicker(
                  //   context: Get.context!,
                  //   initialDate: installmentDate.value,
                  //   firstDate: DateTime(2019),
                  //   lastDate: DateTime(2050),
                  // ).then((value) {
                  //   installmentDate.value = value ?? installmentDate.value;
                  // });
                },
                icon: Icon(
                  Icons.edit,
                  size: 1.5 * Get.textTheme.bodyMedium!.fontSize!,
                ),
                splashColor: const Color(0xffAD7BE9),
              ),
            ],
          ),
          // عرض الاجمالي قبل القسط
          Obx(
            () => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 7),
              child: Text(
                " ${'The rest on you (before)'.tr}: ${restBefore.value}",
                style: Get.textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          // عرض الاجمالي بعد القسط
          SizedBox(
            width: double.infinity,
            child: Obx(() => Text(
              " ${'The rest on you (after)'.tr}: ${restAfter.value}",
              style: Get.textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),
          ),
          ),
        ],
      ),
      actionToolsList: [
        SizedBox(
          width: Get.mediaQuery.size.width* 0.30,
          child: ElevatedButton(
            onPressed: () => saveInstallment(
                formKey: formKey, isEdit: idToEdit != null, editId: idToEdit??0),
            child: Text("Ok".tr),
          ),
        ),
        SizedBox(
          width: Get.mediaQuery.size.width* 0.30,
          child: buildCancelElevatedButton(),
        ),
      ],
    );
  }
  
  Widget buildTextFieldForm(
      {required String label,  required String hint,
      String? initialValue, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label.tr),
          hintText: hint.tr,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          fillColor: const Color(0xffdfe7fd),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffAD7BE9), width: 0.0),
            gapPadding: 0,
          ),
        ),
        initialValue: initialValue,
        style: Get.textTheme.bodyMedium,
        controller: controller,
        keyboardType: label.contains('Amount')? TextInputType.number:TextInputType.name,
        validator: (value) {          
          if (label.toLowerCase().contains('amount') && value == "") {
            return "this field shoudn't empty".tr;
          }
          if (label.toLowerCase().contains('amount') &&
              value != "" && int.tryParse(value.toString()) == null) {
            return "the installment must to be just numbers".tr;
          }
          return null;
        },
        onChanged: (value) async {
          if (label.toLowerCase().contains("amount")) {
            _amount = int.tryParse(value) ?? 0;
            if (_is_creditor) {
              restAfter.value = restBefore.value - _amount;
            } else {
              restAfter.value = restBefore.value + _amount;
            }
            // update();
          }
        },
        onSaved: (newValue) {
          if (label.toLowerCase().contains("amount")) {
            _amount = int.parse(newValue.toString());
          } else if (label.toLowerCase().contains("to")) {
            _receiver = newValue.toString();
          } else if (label.toLowerCase().contains("note")){
            _note= newValue.toString();
          }
        },
      ),
    );
  }

  // دالة لحفظ معلومات القسط في قاعدة البيانات سواء كقسط جديدي او تعديل على قسط موجود
  void saveInstallment({
    required GlobalKey<FormState> formKey,
    required bool isEdit, required int editId,}) async {

    final isValid = formKey.currentState!.validate();
    String msg= "There is error. try again";
    Get.focusScope!.unfocus();  // اخفاء الكيبورد

    if (isValid){
      formKey.currentState!.save();
      
      if (_amount == 0) {
        buildSnackbar(msg);
        return;
      }
      
      if (isEdit) {
        await appDb.updateInstallment(
          Installment(
            id: editId,
            amount: _amount,
            receiver: _receiver,
            date: installmentDate.value,
            // date: DateFormat('yyyy/MM/dd').format(installmentDate.value),
            note: _note,
            rest: restAfter.value,
            is_creditor: _is_creditor
          ),
        );
        msg = "Installment edited successfully";
      } else {
        await appDb.insertInstallment(
          Installment(
              amount: _amount,
              receiver: _receiver,
              date: installmentDate.value,
              // date: DateFormat('yyyy/MM/dd').format(installmentDate.value),
              note: _note,
              rest: restAfter.value,
              is_creditor: _is_creditor,
            ),
        );
        msg = "Installment added successfully";
      }
      Get.find<OperationsController>().updateOperation();
      Get.back();
      if (Get.isDialogOpen ?? false) Get.back();
      buildSnackbar(msg);      
      installmentDate.value= initializeDate(); //DateFormat('yyyy/MM/dd H:m:s').format(DateTime.now());
      _amount=0; _receiver=""; _note="";   _is_creditor= true;
    }
  }
}

