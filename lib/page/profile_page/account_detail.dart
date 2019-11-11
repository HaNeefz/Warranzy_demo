import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';

class AccountDetail extends StatefulWidget {
  final ModelCustomers modelCustomers;

  const AccountDetail({Key key, this.modelCustomers}) : super(key: key);
  @override
  _AccountDetailState createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  ModelCustomers get modelCustomers => widget.modelCustomers;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userID;
  TextEditingController _fullName;
  TextEditingController _email;
  TextEditingController _mobileNo;
  TextEditingController _address;

  bool _changeNoMobile = false;

  @override
  void initState() {
    super.initState();
    if (modelCustomers != null) {
      setState(() {
        _userID = TextEditingController(text: modelCustomers.custUserID);
        _fullName = TextEditingController(text: modelCustomers.custName);
        _email = TextEditingController(text: modelCustomers.custEmail);
        _mobileNo = TextEditingController(
            text: modelCustomers.mobilePhone
                .substring(2, modelCustomers.mobilePhone.length));
        _address = TextEditingController(text: modelCustomers.homeAddress);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userID.dispose();
    _fullName.dispose();
    _email.dispose();
    _mobileNo.dispose();
    _address.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "Account Details", style: TextStyleCustom.STYLE_APPBAR),
        actions: <Widget>[
          FlatButton(
            child: TextBuilder.build(title: allTranslations.text("save")),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  showDetail(
                      title: "User ID", controller: _userID, readOnly: true),
                  showDetail(
                      title: "Full Name",
                      controller: _fullName,
                      onChange: (text) =>
                          setState(() => _fullName.text = text)),
                  showDetail(
                      title: "Email",
                      controller: _email,
                      onChange: (text) => setState(() => _email.text = text)),
                  showDetail(
                      title: "Address",
                      controller: _address,
                      onChange: (text) => setState(() => _address.text = text)),
                  showDetail(
                      title: "Mobile No",
                      controller: _mobileNo,
                      leader: Container(
                        margin: EdgeInsets.only(right: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        // decoration: BoxDecoration(
                        //     border: Border.all(width: 0.7),
                        //     borderRadius: BorderRadius.circular(5)),
                        child: TextBuilder.build(
                            title:
                                "+ ${modelCustomers.mobilePhone.substring(0, 2)}"),
                      ),
                      onChange: (text) {
                        if (modelCustomers.mobilePhone == _mobileNo.text) {
                          _changeNoMobile = false;
                        } else
                          _changeNoMobile = true;
                        print("Text : $text , change : $_changeNoMobile");
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text headLine(String title) {
    return TextBuilder.build(
        title: title ?? "", style: TextStyleCustom.STYLE_CONTENT);
  }

  Widget showDetail(
      {String title,
      TextEditingController controller,
      bool readOnly = false,
      Function(String) onChange,
      Widget leader}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextFieldBuilder.textFormFieldCustom(
              controller: controller,
              borderOutLine: false,
              leader: leader,
              validate: true,
              readOnly: readOnly,
              onChange: (text) => onChange(text),
              title: title ?? "",
              titleStyle: TextStyleCustom.STYLE_CONTENT),
        )
      ],
    );
  }
}
