import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/common_response_model.dart';
import 'package:salesapp/Model/customer_list_response_model.dart';

import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class AddCustomerPage extends StatefulWidget {
  final CustomerList getSet;
  final bool isFromList;
  const AddCustomerPage(this.getSet, this.isFromList, {Key? key}) : super(key: key);

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends BaseState<AddCustomerPage> {
  bool _isLoading = false;

  TextEditingController customerNameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController addressLine3Controller = TextEditingController();
  TextEditingController addressLine4Controller = TextEditingController();
  TextEditingController addressLine5Controller = TextEditingController();

  TextEditingController areaNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  TextEditingController contactPersonController = TextEditingController();
  TextEditingController GSTTypeController = TextEditingController();
  TextEditingController parentController = TextEditingController();
  TextEditingController GSTApplicableController = TextEditingController();
  TextEditingController creditDaysController = TextEditingController();

  TextEditingController bankDetailController = TextEditingController();
  TextEditingController ledgerEmailController = TextEditingController();
  TextEditingController ledgerPhoneController = TextEditingController();
  TextEditingController ledgerContactController = TextEditingController();
  TextEditingController ledgerMobileController = TextEditingController();

  TextEditingController ledgerBankNameController = TextEditingController();
  TextEditingController ledgerBankACNoController = TextEditingController();
  TextEditingController ledgerBankIFSCCodeController = TextEditingController();
  TextEditingController ledgerBankSwiftCodeController = TextEditingController();

  TextEditingController GSTINNoController = TextEditingController();
  TextEditingController creditLimitController = TextEditingController();
  TextEditingController companyIDController = TextEditingController();
  TextEditingController tallyIDController = TextEditingController();

  FocusNode inputNode = FocusNode();
  bool _isHideAddressDetail = true;
  bool _isHideBankDetail = true;
  bool _isHide = true;
  bool _isHideGSTDetail = true;

  @override
  void initState() {
    super.initState();

    if ((widget as AddCustomerPage).isFromList == true) {
      customerNameController.text = checkValidString((widget as AddCustomerPage).getSet.customerName).toString();
      addressLine1Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine1).toString();
      addressLine2Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine2).toString();
      addressLine3Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine3).toString();
      addressLine4Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine4).toString();
      addressLine5Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine5).toString();

      areaNameController.text = checkValidString((widget as AddCustomerPage).getSet.areaName).toString();
      cityController.text = checkValidString((widget as AddCustomerPage).getSet.cityName).toString();
      pinCodeController.text = checkValidString((widget as AddCustomerPage).getSet.pincode).toString();
      stateController.text = checkValidString((widget as AddCustomerPage).getSet.stateName).toString();
      countryController.text = checkValidString((widget as AddCustomerPage).getSet.countryName).toString();

      contactPersonController.text = checkValidString((widget as AddCustomerPage).getSet.contactPerson).toString();
      GSTTypeController.text = checkValidString((widget as AddCustomerPage).getSet.gstType).toString();
      parentController.text = checkValidString((widget as AddCustomerPage).getSet.parent).toString();
      GSTApplicableController.text = checkValidString((widget as AddCustomerPage).getSet.gstApplicable).toString();
      creditDaysController.text = checkValidString((widget as AddCustomerPage).getSet.billCreditPeriod).toString();

      bankDetailController.text = checkValidString((widget as AddCustomerPage).getSet.bankDetails).toString();
      ledgerEmailController.text = checkValidString((widget as AddCustomerPage).getSet.emailCc).toString();
      ledgerPhoneController.text = checkValidString((widget as AddCustomerPage).getSet.ledgerPhone).toString();
      ledgerContactController.text = checkValidString((widget as AddCustomerPage).getSet.ledgerContact).toString();
      ledgerMobileController.text = checkValidString((widget as AddCustomerPage).getSet.ledgerMobile).toString();

      ledgerBankNameController.text = checkValidString((widget as AddCustomerPage).getSet.ledBankName).toString();
      ledgerBankACNoController.text = checkValidString((widget as AddCustomerPage).getSet.ledBankAcNo).toString();
      ledgerBankIFSCCodeController.text = checkValidString((widget as AddCustomerPage).getSet.ledBankIfscCode).toString();
      ledgerBankSwiftCodeController.text = checkValidString((widget as AddCustomerPage).getSet.ledBankSwiftCode).toString();

      GSTINNoController.text = checkValidString((widget as AddCustomerPage).getSet.customerGst).toString();
      creditLimitController.text = checkValidString((widget as AddCustomerPage).getSet.creditLimit).toString();
      companyIDController.text = checkValidString((widget as AddCustomerPage).getSet.companyId).toString();
      tallyIDController.text = checkValidString((widget as AddCustomerPage).getSet.tallyId).toString();

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Text((widget as AddCustomerPage).isFromList ? "Update Customer" : "Add Customer",
            style: const TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
        leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap:() {
              Navigator.pop(context);
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                  color: kBlue
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/images/ic_back_arrow.png', color: white, height: 22, width: 22),
            )
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
      ),
      body: _isLoading ? const LoadingWidget()
          : LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Container(
                      //   color: kBlue,
                      //   alignment: Alignment.topLeft,
                      //   padding: const EdgeInsets.only(left: 22, top: 10, bottom: 15),
                      //   child: Text((widget as AddCustomerPage).isFromList ? "Update Customer" : "Add Customer",
                      //       style: const TextStyle(fontWeight: FontWeight.w700, color: white, fontSize: 20)),
                      // ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(top: 20, left: 22, right: 22, bottom: 10),
                        child: const Text("Basic Details",
                          style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: customerNameController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: ledgerEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: ledgerPhoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Phone',
                              prefixText: '079 ',
                              counterText: '',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: ledgerContactController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Contact Name',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: ledgerMobileController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Mobile',
                              prefixText: '+91 ',
                              counterText: '',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: creditLimitController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Credit Limit',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: creditDaysController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Credit Days',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _isHideGSTDetail = !_isHideGSTDetail;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, left: 22, right: 22, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("GST Details",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w600),
                              ),
                              _isHideGSTDetail ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !_isHideGSTDetail,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: GSTTypeController,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'GST Type',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                                onTap: () {
                                  showGSTTypeActionDialog();
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: GSTApplicableController,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'GST Applicable',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                                onTap: () {
                                  showGSTApplicableActionDialog();
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: GSTINNoController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.characters,
                                maxLength: 15,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'GST No',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _isHideAddressDetail = !_isHideAddressDetail;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, left: 22, right: 22, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Address Details",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w600),
                              ),
                              _isHideAddressDetail ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !_isHideAddressDetail,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: addressLine1Controller,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                    labelText: 'AddressLine 1',
                                    prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: addressLine2Controller,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                    labelText: 'AddressLine 2',
                                    prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: addressLine3Controller,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                    labelText: 'AddressLine 3',
                                    prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: addressLine4Controller,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                    labelText: 'AddressLine 4',
                                    prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: addressLine5Controller,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                    labelText: 'AddressLine 5',
                                    prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: areaNameController,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                                decoration: const InputDecoration(
                                    labelText: 'Area Name',
                                    prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: cityController,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'City Name',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: pinCodeController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'Pin Code',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: stateController,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'State',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: countryController,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'Country',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _isHideBankDetail = !_isHideBankDetail;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, left: 22, right: 22, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Bank Details",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w600),
                              ),
                              _isHideBankDetail ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                            ],
                          ),
                        ),
                      ),
                      /*  Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: bankDetailController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Bank Detail',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),*/
                      Visibility(
                        visible: !_isHideBankDetail,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: ledgerBankNameController,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'Ledger Bank Name',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: ledgerBankACNoController,
                                keyboardType: TextInputType.number,
                                maxLength: 17,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'Ledger Bank AC No.',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: ledgerBankIFSCCodeController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.characters,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'Ledger IFSC Code',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: ledgerBankSwiftCodeController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.characters,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'Ledger Bank Swift Code',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _isHide = !_isHide;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, left: 22, right: 22, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Other Details",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w600),
                              ),
                              _isHide ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !_isHide,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: contactPersonController,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'Contact Person',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextField(
                                cursorColor: black,
                                controller: parentController,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                decoration: const InputDecoration(
                                  labelText: 'Parent',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: companyIDController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Company Id',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: tallyIDController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Tally Id',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),*/
                      Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kLightGradient, kDarkGradient],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            String name = customerNameController.text.toString();
                            String addressLine1 = addressLine1Controller.text.toString();
                            String addressLine2 = addressLine2Controller.text.toString();
                            String area = areaNameController.text.toString();
                            String city = cityController.text.toString();
                            String pinCode = pinCodeController.text.toString();
                            String country = countryController.text.toString();
                            String state = stateController.text.toString();
                            String creditDays = creditDaysController.text.toString();
                            String ledgerEmail = ledgerEmailController.text.toString();
                            String ledgerPhone = ledgerPhoneController.text.toString();
                            String ledgerMobile = ledgerMobileController.text.toString();
                            String ledgerIfsc = ledgerBankIFSCCodeController.text.toString();
                            String swiftCode = ledgerBankSwiftCodeController.text.toString();
                            String gstNo = GSTINNoController.text.toString();

                            if (name.trim().isEmpty) {
                              showSnackBar("Please enter a name", context);
                            } else if (ledgerEmail.isNotEmpty && !isValidEmail(ledgerEmail.trim())) {
                              showSnackBar("Please enter valid email", context);
                            } else if (ledgerPhone.trim().isNotEmpty && ledgerPhone.trim().length != 8) {
                              showSnackBar('Please enter valid phone number',context);
                            } else if (ledgerMobile.trim().isNotEmpty && ledgerMobile.trim().length != 10) {
                              showSnackBar('Please enter valid mobile number',context);
                            } else if (ledgerIfsc.trim().isNotEmpty && !isValidIFSCCode(ledgerIfsc.trim())) {
                              showSnackBar('Please enter valid IFSC number',context);
                            } else if (swiftCode.trim().isNotEmpty && !isValidSwiftCode(swiftCode.trim())) {
                              showSnackBar('Please enter valid SWIFT Code',context);
                            } else if (gstNo.trim().isNotEmpty && !isValidGSTNo(gstNo.trim())) {
                              showSnackBar('Please enter valid GST number',context);
                            }
                            // else if (creditDays.trim().isNotEmpty && int.parse(creditDays.trim()) > 365) {
                            //   showSnackBar('Please enter valid credit days',context);
                            // }

                          /*  else if (addressLine1.trim().isEmpty) {
                              showSnackBar("Please enter a addressLine1", context);
                            }
                            else if(addressLine2.isEmpty) {
                              showSnackBar('Please enter a addressLine2',context);
                            }
                            else if (area.trim().isEmpty) {
                              showToast("Please enter a area");
                            }
                            else if (city.trim().isEmpty) {
                              showToast("Please enter a city");
                            }
                            else if (pinCode.trim().isEmpty) {
                              showToast("Please enter a pin code");
                            }
                            else if (country.trim().isEmpty) {
                              showToast("Please enter a country");
                            }
                            else if (state.trim().isEmpty) {
                              showToast("Please enter a state");
                            }*/
                            else {
                                if ((widget as AddCustomerPage).isFromList == true) {
                                  if(isInternetConnected) {
                                    _makeCallUpdateCustomer();
                                  }else{
                                    noInterNet(context);
                                  }
                                } else {
                                  if(isInternetConnected) {
                                    _makeCallAddCustomer();
                                  }else{
                                    noInterNet(context);
                                  }
                                }
                            }
                          },
                          child: const Text("Submit",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white),),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  void showGSTTypeActionDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      elevation: 5,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Container(height: 2, width: 40, color: kBlue, margin: const EdgeInsets.only(bottom: 12)),
                    const Text("Select GST Type", textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          GSTTypeController.text = "Regular";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Regular",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    const Divider(
                      color: kLightestGray,
                      height: 1,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          GSTTypeController.text = "Unregistered";
                        });
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        child: const Text(
                          "Unregistered",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Container(height: 12)
                  ],
                ))
          ],
        );
      },
    );
  }

  void showGSTApplicableActionDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      elevation: 5,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Container(height: 2, width: 40, color: kBlue, margin: const EdgeInsets.only(bottom: 12)),
                    const Text("Select GST Applicable",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          GSTApplicableController.text = "Yes";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        alignment: Alignment.topLeft,
                        child: const Text("Yes",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    const Divider(
                      color: kLightestGray,
                      height: 1,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          GSTApplicableController.text = "No";
                        });
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        child: const Text("No",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Container(height: 12)
                  ],
                ))
          ],
        );
      },
    );
  }

  _makeCallAddCustomer() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + addCustomer);

    Map<String, String> jsonBody = {
      'PartyName': customerNameController.value.text.trim(),
      'Address1': addressLine1Controller.value.text.trim(),
      'Address2': addressLine2Controller.value.text.trim(),
      'Address3': addressLine3Controller.value.text.trim(),
      'Address4': addressLine4Controller.value.text.trim(),
      'Address5': addressLine5Controller.value.text.trim(),
      'CityName': cityController.value.text.trim(),
      'PinCode': pinCodeController.value.text.trim(),
      'Country': countryController.value.text.trim(),
      'ContactPerson': contactPersonController.value.text.trim(),
      'Parent': parentController.value.text.trim(),
      'GSTApplicable': GSTApplicableController.value.text.trim(),
      'CreditDays': creditDaysController.value.text.trim(),
      'BankDetail': bankDetailController.value.text.trim(),
      'LedgerEmail': ledgerEmailController.value.text.trim(),
      'LedgerPhone': ledgerPhoneController.value.text.trim(),
      'LedgerContact': ledgerContactController.value.text.trim(),
      'LedgerMobile': ledgerMobileController.value.text.trim(),
      'LedBankName': ledgerBankNameController.value.text.trim(),
      'LedBankACNo': ledgerBankACNoController.value.text.trim(),
      'LedBankIFSCCode': ledgerBankIFSCCodeController.value.text.trim(),
      'LedBankSwiftCode': ledgerBankSwiftCodeController.value.text.trim(),
      'CreditLimit': creditLimitController.value.text.trim(),
      'CmpID': "RBC",
      'TallyID': tallyIDController.value.text.trim(),
      'from_app' : FROM_APP,
      'AreaName': areaNameController.value.text.trim(),
      'State': stateController.value.text.trim(),
      'GSTType' : GSTTypeController.value.text.trim(),
      'GSTINNo' : GSTINNoController.value.text.trim(),
      'customer_id' : '',
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);

      Navigator.pop(context, "success");
      tabNavigationReload();

      setState(() {
        _isLoading = false;
      });
    }else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _makeCallUpdateCustomer() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + addCustomer);

    Map<String, String> jsonBody = {
      'PartyName': customerNameController.value.text.trim(),
      'Address1': addressLine1Controller.value.text.trim(),
      'Address2': addressLine2Controller.value.text.trim(),
      'Address3': addressLine3Controller.value.text.trim(),
      'Address4': addressLine4Controller.value.text.trim(),
      'Address5': addressLine5Controller.value.text.trim(),
      'CityName': cityController.value.text.trim(),
      'PinCode': pinCodeController.value.text.trim(),
      'Country': countryController.value.text.trim(),
      'ContactPerson': contactPersonController.value.text.trim(),
      'Parent': parentController.value.text.trim(),
      'GSTApplicable': GSTApplicableController.value.text.trim(),
      'CreditDays': creditDaysController.value.text.trim(),
      'BankDetail': bankDetailController.value.text.trim(),
      'LedgerEmail': ledgerEmailController.value.text.trim(),
      'LedgerPhone': ledgerPhoneController.value.text.trim(),
      'LedgerContact': ledgerContactController.value.text.trim(),
      'LedgerMobile': ledgerMobileController.value.text.trim(),
      'LedBankName': ledgerBankNameController.value.text.trim(),
      'LedBankACNo': ledgerBankACNoController.value.text.trim(),
      'LedBankIFSCCode': ledgerBankIFSCCodeController.value.text.trim(),
      'LedBankSwiftCode': ledgerBankSwiftCodeController.value.text.trim(),
      'CreditLimit': creditLimitController.value.text.trim(),
      'CmpID': "RBC",
      'TallyID': "1",
      'from_app' : FROM_APP,
      'customer_id' : checkValidString((widget as AddCustomerPage).getSet.customerId.toString()),
      'AreaName': areaNameController.value.text.trim(),
      'State': stateController.value.text.trim(),
      'GSTType' : GSTTypeController.value.text.trim(),
      'GSTINNo' : GSTINNoController.value.text.trim()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);

      Navigator.pop(context, "success");
      tabNavigationReload();

      setState(() {
        _isLoading = false;
      });
    }else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is AddCustomerPage;
  }

}