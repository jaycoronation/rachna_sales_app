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

  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _addressLine1Controller = TextEditingController();
  TextEditingController _addressLine2Controller = TextEditingController();
  TextEditingController _addressLine3Controller = TextEditingController();
  TextEditingController _addressLine4Controller = TextEditingController();
  TextEditingController _addressLine5Controller = TextEditingController();

  TextEditingController _areaNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  TextEditingController _contactPersonController = TextEditingController();
  TextEditingController _GSTTypeController = TextEditingController();
  TextEditingController _parentController = TextEditingController();
  TextEditingController _GSTApplicableController = TextEditingController();
  TextEditingController _creditDaysController = TextEditingController();

  TextEditingController _bankDetailController = TextEditingController();
  TextEditingController _ledgerEmailController = TextEditingController();
  TextEditingController _ledgerPhoneController = TextEditingController();
  TextEditingController _ledgerContactController = TextEditingController();
  TextEditingController _ledgerMobileController = TextEditingController();

  TextEditingController _ledgerBankNameController = TextEditingController();
  TextEditingController _ledgerBankACNoController = TextEditingController();
  TextEditingController _ledgerBankIFSCCodeController = TextEditingController();
  TextEditingController _ledgerBankSwiftCodeController = TextEditingController();

  TextEditingController _GSTINNoController = TextEditingController();
  TextEditingController _creditLimitController = TextEditingController();
  TextEditingController _companyIDController = TextEditingController();
  TextEditingController _tallyIDController = TextEditingController();

  FocusNode inputNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if ((widget as AddCustomerPage).isFromList == true) {
      _customerNameController.text = checkValidString((widget as AddCustomerPage).getSet.customerName).toString();
      _addressLine1Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine1).toString();
      _addressLine2Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine2).toString();
      _addressLine3Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine3).toString();
      _addressLine4Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine4).toString();
      _addressLine5Controller.text = checkValidString((widget as AddCustomerPage).getSet.addressLine5).toString();

      _areaNameController.text = checkValidString((widget as AddCustomerPage).getSet.areaName).toString();
      _cityController.text = checkValidString((widget as AddCustomerPage).getSet.cityName).toString();
      _pincodeController.text = checkValidString((widget as AddCustomerPage).getSet.pincode).toString();
      _stateController.text = checkValidString((widget as AddCustomerPage).getSet.stateName).toString();
      _countryController.text = checkValidString((widget as AddCustomerPage).getSet.countryName).toString();

      _contactPersonController.text = checkValidString((widget as AddCustomerPage).getSet.contactPerson).toString();
      _GSTTypeController.text = checkValidString((widget as AddCustomerPage).getSet.gstType).toString();
      _parentController.text = checkValidString((widget as AddCustomerPage).getSet.parent).toString();
      _GSTApplicableController.text = checkValidString((widget as AddCustomerPage).getSet.gstApplicable).toString();
      _creditDaysController.text = checkValidString((widget as AddCustomerPage).getSet.billCreditPeriod).toString();

      _bankDetailController.text = checkValidString((widget as AddCustomerPage).getSet.bankDetails).toString();
      _ledgerEmailController.text = checkValidString((widget as AddCustomerPage).getSet.emailCc).toString();
      _ledgerPhoneController.text = checkValidString((widget as AddCustomerPage).getSet.ledgerPhone).toString();
      _ledgerContactController.text = checkValidString((widget as AddCustomerPage).getSet.ledgerContact).toString();
      _ledgerMobileController.text = checkValidString((widget as AddCustomerPage).getSet.ledgerMobile).toString();

      _ledgerBankNameController.text = checkValidString((widget as AddCustomerPage).getSet.ledBankName).toString();
      _ledgerBankACNoController.text = checkValidString((widget as AddCustomerPage).getSet.ledBankAcNo).toString();
      _ledgerBankIFSCCodeController.text = checkValidString((widget as AddCustomerPage).getSet.ledBankIfscCode).toString();
      _ledgerBankSwiftCodeController.text = checkValidString((widget as AddCustomerPage).getSet.ledBankSwiftCode).toString();

      _GSTINNoController.text = checkValidString((widget as AddCustomerPage).getSet.customerGst).toString();
      _creditLimitController.text = checkValidString((widget as AddCustomerPage).getSet.creditLimit).toString();
      _companyIDController.text = checkValidString((widget as AddCustomerPage).getSet.companyId).toString();
      _tallyIDController.text = checkValidString((widget as AddCustomerPage).getSet.tallyId).toString();

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 55,
        automaticallyImplyLeading: false,
        title: const Text(""),
        leading: GestureDetector(
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
                      Container(
                        color: kBlue,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 22, top: 10, bottom: 15),
                        child: Text((widget as AddCustomerPage).isFromList ? "Update Customer" : "Add Customer",
                            style: const TextStyle(fontWeight: FontWeight.w700, color: white, fontSize: 20)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _customerNameController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _addressLine1Controller,
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
                          controller: _addressLine2Controller,
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
                          controller: _addressLine3Controller,
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
                          controller: _addressLine4Controller,
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
                          controller: _addressLine5Controller,
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
                          controller: _areaNameController,
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
                          controller: _cityController,
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
                          controller: _pincodeController,
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
                          controller: _countryController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Country',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _contactPersonController,
                          keyboardType: TextInputType.text,
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
                          controller: _GSTTypeController,
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
                          controller: _stateController,
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
                          controller: _parentController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Parent',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _GSTApplicableController,
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
                          controller: _creditDaysController,
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
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _bankDetailController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Bank Detail',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _ledgerEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Ledger Email',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _ledgerPhoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Ledger Phone',
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
                          controller: _ledgerContactController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Ledger Contact',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _ledgerMobileController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Ledger Mobile',
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
                          controller: _ledgerBankNameController,
                          keyboardType: TextInputType.name,
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
                          controller: _ledgerBankACNoController,
                          keyboardType: TextInputType.name,
                          maxLength: 17,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Ledger Bank AC No.',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _ledgerBankIFSCCodeController,
                          keyboardType: TextInputType.text,
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
                          controller: _ledgerBankSwiftCodeController,
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
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _GSTINNoController,
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
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _creditLimitController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Credit Limit',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      /*Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _companyIDController,
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
                          controller: _tallyIDController,
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
                        margin: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
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
                            String name = _customerNameController.text.toString();
                            String addressLine1 = _addressLine1Controller.text.toString();
                            String addressLine2 = _addressLine2Controller.text.toString();
                            String area = _areaNameController.text.toString();
                            String city = _cityController.text.toString();
                            String pinCode = _pincodeController.text.toString();
                            String country = _countryController.text.toString();
                            String state = _stateController.text.toString();
                            String gstNo = _GSTINNoController.text.toString();
                            String creditDays = _creditDaysController.text.toString();

                            if (name.trim().isEmpty) {
                              showSnackBar("Please enter a name", context);
                            }
                            else if (_ledgerEmailController.text.isNotEmpty && !isValidEmail(_ledgerEmailController.text.trim())) {
                              showSnackBar("Please enter valid email", context);
                            }
                            else if (_ledgerPhoneController.text.trim().length > 0 && _ledgerPhoneController.text.trim().length != 8) {
                              showSnackBar('Please enter valid phone number',context);
                            }
                            else if (_ledgerMobileController.text.trim().length > 0 && _ledgerMobileController.text.trim().length != 10) {
                              showSnackBar('Please enter valid phone number',context);
                            }
                            else if (gstNo.isNotEmpty && !isValidGSTNo(gstNo.trim())) {
                              showSnackBar('Please enter valid GST number',context);
                            }
                            else if (creditDays.trim().isNotEmpty && int.parse(creditDays.trim()) > 365) {
                              showSnackBar('Please enter valid credit days',context);
                            }

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
                    const Text(
                      "Select GST Type",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          _GSTTypeController.text = "Regular";
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
                          _GSTTypeController.text = "Unregistered";
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
                    const Text(
                      "Select GST Applicable",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          _GSTApplicableController.text = "Yes";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Yes",
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
                          _GSTApplicableController.text = "No";
                        });
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        child: const Text(
                          "No",
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
      'PartyName': _customerNameController.value.text.trim(),
      'Address1': _addressLine1Controller.value.text.trim(),
      'Address2': _addressLine2Controller.value.text.trim(),
      'Address3': _addressLine3Controller.value.text.trim(),
      'Address4': _addressLine4Controller.value.text.trim(),
      'Address5': _addressLine5Controller.value.text.trim(),
      'CityName': _cityController.value.text.trim(),
      'PinCode': _pincodeController.value.text.trim(),
      'Country': _countryController.value.text.trim(),
      'ContactPerson': _contactPersonController.value.text.trim(),
      'Parent': _parentController.value.text.trim(),
      'GSTApplicable': _GSTApplicableController.value.text.trim(),
      'CreditDays': _creditDaysController.value.text.trim(),
      'BankDetail': _bankDetailController.value.text.trim(),
      'LedgerEmail': _ledgerEmailController.value.text.trim(),
      'LedgerPhone': _ledgerPhoneController.value.text.trim(),
      'LedgerContact': _ledgerContactController.value.text.trim(),
      'LedgerMobile': _ledgerMobileController.value.text.trim(),
      'LedBankName': _ledgerBankNameController.value.text.trim(),
      'LedBankACNo': _ledgerBankACNoController.value.text.trim(),
      'LedBankIFSCCode': _ledgerBankIFSCCodeController.value.text.trim(),
      'LedBankSwiftCode': _ledgerBankSwiftCodeController.value.text.trim(),
      'CreditLimit': _creditLimitController.value.text.trim(),
      'CmpID': "RBC",
      'TallyID': _tallyIDController.value.text.trim(),
      'from_app' : FROM_APP,
      'AreaName': _areaNameController.value.text.trim(),
      'State': _stateController.value.text.trim(),
      'GSTType' : _GSTTypeController.value.text.trim(),
      'GSTINNo' : _GSTINNoController.value.text.trim()
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
      'PartyName': _customerNameController.value.text.trim(),
      'Address1': _addressLine1Controller.value.text.trim(),
      'Address2': _addressLine2Controller.value.text.trim(),
      'Address3': _addressLine3Controller.value.text.trim(),
      'Address4': _addressLine4Controller.value.text.trim(),
      'Address5': _addressLine5Controller.value.text.trim(),
      'CityName': _cityController.value.text.trim(),
      'PinCode': _pincodeController.value.text.trim(),
      'Country': _countryController.value.text.trim(),
      'ContactPerson': _contactPersonController.value.text.trim(),
      'Parent': _parentController.value.text.trim(),
      'GSTApplicable': _GSTApplicableController.value.text.trim(),
      'CreditDays': _creditDaysController.value.text.trim(),
      'BankDetail': _bankDetailController.value.text.trim(),
      'LedgerEmail': _ledgerEmailController.value.text.trim(),
      'LedgerPhone': _ledgerPhoneController.value.text.trim(),
      'LedgerContact': _ledgerContactController.value.text.trim(),
      'LedgerMobile': _ledgerMobileController.value.text.trim(),
      'LedBankName': _ledgerBankNameController.value.text.trim(),
      'LedBankACNo': _ledgerBankACNoController.value.text.trim(),
      'LedBankIFSCCode': _ledgerBankIFSCCodeController.value.text.trim(),
      'LedBankSwiftCode': _ledgerBankSwiftCodeController.value.text.trim(),
      'CreditLimit': _creditLimitController.value.text.trim(),
      'CmpID': "RBC",
      'TallyID': "1",
      'from_app' : FROM_APP,
      'customer_id' : checkValidString((widget as AddCustomerPage).getSet.customerId.toString()),
      'AreaName': _areaNameController.value.text.trim(),
      'State': _stateController.value.text.trim(),
      'GSTType' : _GSTTypeController.value.text.trim(),
      'GSTINNo' : _GSTINNoController.value.text.trim()
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