import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:warranzy_demo/services/calls_and_message/calls_and_message.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_field_builder.dart';

class ProfilePage extends StatefulWidget {
  final String heroTag;

  const ProfilePage({Key key, this.heroTag}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final CallsAndMessageService _service = CallsAndMessageService();
  bool checkInformationChange = false;
  Map<String, bool> enableRead = {
    "id": true,
    "name": true,
    "address": true,
    "pin": true
  };

  @override
  void initState() {
    super.initState();
    getDataCustomers();
  }

  void getDataCustomers() async {
    var dataCust = await DBProviderCustomer.db.getDataCustomer();
    print("ID Customer => ${await DBProviderCustomer.db.getIDCustomer()}");
    print(
        "<=========================MAS_CUSTOMER=========================>\n${dataCust.toJson()}\n<================================================================>");
  }

  sendTocloudFireStore() async {
    try {
      Firestore.instance.collection("BrandName").snapshots().listen((onData) {
        onData.documents.forEach((doc) {
          print("${doc.data}");
        });
        // print("${onData["CustName"]}");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        // backgroundColor: Colors.grey[400],
        body: FormBuilder(
          key: _fbKey,
          onChanged: (data) {
            print(data);
          },
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: COLOR_WHITE,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.lock_open,
                    size: 30,
                    color: COLOR_WHITE,
                  ),
                  onPressed: () {
                    ecsLib.pushPageAndClearAllScene(
                      context: context,
                      pageWidget: LoginPage(),
                    );
                  },
                )
              ],
              elevation: 5,
              forceElevated: true,
              flexibleSpace: Container(
                  color: COLOR_WHITE,
                  child: Stack(children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(
                        Assets.BACK_GROUND_APP,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Hero(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3)),
                          child: Center(
                            child: FlutterLogo(
                              size: 100,
                              colors: COLOR_THEME_APP,
                            ),
                          ),
                        ),
                        tag: "PhotoProfile",
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: TextBuilder.build(
                            title: "Username",
                            style: TextStyleCustom.STYLE_APPBAR
                                .copyWith(color: COLOR_WHITE)),
                      ),
                    )
                  ])
                  // child: Image.asset(Assets.BACK_GROUND_APP,fit: BoxFit.cover,),
                  ),
              // pinned: true,
              // snap: true,
              // floating: true,
              expandedHeight: 300,

              // title: TextBuilder.build(
              //     title: "Profile", style: TextStyleCustom.STYLE_APPBAR),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              [
                formInformation(
                    "ID",
                    TextFieldBuilder.enterInformation(
                        key: "ID",
                        initialValue: "IdTesting",
                        readOnly: true, //enableRead['id'],
                        borderOutLine: false,
                        size: 20,
                        validators: [FormBuilderValidators.required()]),
                    showTextReadOnly: true,
                    editAble: false //enableRead['id'],
                    ),
                formInformation(
                    "Name",
                    TextFieldBuilder.enterInformation(
                        key: "fullName",
                        initialValue: "Name",
                        borderOutLine: false,
                        size: 20,
                        readOnly: true, //enableRead['name'],
                        validators: [FormBuilderValidators.required()]),
                    showTextReadOnly: true,
                    editAble: false //enableRead['name'],
                    ),
                formInformation(
                    "Address",
                    TextFieldBuilder.enterInformation(
                        key: "address",
                        initialValue: "Address",
                        borderOutLine: false,
                        readOnly: enableRead['address'],
                        size: 20,
                        validators: [FormBuilderValidators.required()]),
                    showTextReadOnly: false,
                    editAble: true, onTapEdit: () {
                  setState(() {
                    enableRead['address'] = !enableRead['address'];
                  });
                }),
                formInformation(
                    "PIN",
                    TextFieldBuilder.enterInformation(
                        key: "pin",
                        initialValue: "******",
                        borderOutLine: false,
                        obsecure: true,
                        size: 20,
                        readOnly: enableRead['pin'],
                        validators: [FormBuilderValidators.required()]),
                    showTextReadOnly: false,
                    editAble: true, onTapEdit: () {
                  setState(() {
                    enableRead['pin'] = !enableRead['pin'];
                  });
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buttonContact(Icons.call, "Call Center", Colors.green,
                        () => _service.call("0123456789")),
                    buttonContact(Icons.sms, "Send Sms", Colors.blue,
                        () => _service.sendSms("0123456789")),
                    buttonContact(Icons.email, "Email us", Colors.redAccent,
                        () => _service.sendEmail("wpoungchoo@gmail.com")),
                  ],
                ),
                RaisedButton(
                  child: Icon(Icons.check),
                  onPressed: () {
                    _fbKey.currentState.save();
                    if (_fbKey.currentState.validate()) {
                      print(_fbKey.currentState.value);
                    }
                  },
                ),
                RaisedButton(
                  child: Text("Send to cloud_firestore"),
                  onPressed: sendTocloudFireStore,
                ),
              ],
            )),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate([
                Container(color: Colors.red),
                Container(color: Colors.green),
                Container(color: Colors.blue),
                Container(color: Colors.pink),
                Container(color: Colors.yellow),
                Container(color: Colors.orange),
                Container(color: Colors.purple),
                Container(color: Colors.black),
                Container(color: Colors.grey),
              ]),
            )
          ]),
        ));
  }

  Widget buttonContact(
      [IconData icons, String title, Color colors, Function onPressed]) {
    return RaisedButton.icon(
      color: colors,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: Icon(icons),
      label: TextBuilder.build(
          title: title,
          textAlign: TextAlign.center,
          style: TextStyleCustom.STYLE_LABEL.copyWith(fontSize: 12)),
      onPressed: onPressed,
    );
  }

  Widget formInformation(title, widget,
      {@required bool showTextReadOnly,
      @required bool editAble,
      Function onTapEdit}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: RichText(
            text: TextSpan(children: [
              TextSpan(text: title, style: TextStyleCustom.STYLE_LABEL),
              showTextReadOnly == true ? TextSpan(text: '\n') : TextSpan(),
              showTextReadOnly == true
                  ? TextSpan(
                      text: "(ReadOnly)",
                      style: TextStyleCustom.STYLE_ERROR.copyWith(fontSize: 10))
                  : TextSpan()
            ]),
          )),
          Expanded(flex: 3, child: widget),
          editAble == true
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onTapEdit,
                )
              : Container()
        ],
      ),
    );
  }
}
