import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:warranzy_demo/services/method/mark_text_input_format.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class PayMentAboutClaim extends StatefulWidget {
  @override
  _PayMentAboutClaimState createState() => _PayMentAboutClaimState();
}

class _PayMentAboutClaimState extends State<PayMentAboutClaim> {
  bool activeCard = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "Payment", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            TextBuilder.build(
                title: "Payment methods",
                style: TextStyleCustom.STYLE_LABEL_BOLD
                    .copyWith(color: COLOR_THEME_APP, fontSize: 30)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: <Widget>[
                  buttonCredit(Icons.credit_card, "Credit Card", activeCard),
                  SizedBox(
                    width: 10,
                  ),
                  buttonCredit(Icons.credit_card, "Debit Card", !activeCard)
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            TextBuilder.build(
                title: "Detail",
                style: TextStyleCustom.STYLE_LABEL_BOLD
                    .copyWith(color: COLOR_THEME_APP, fontSize: 20)),
            // CreditCardWidget(
            //   cardNumber: "1234123123",
            //   expiryDate: "12/20",
            //   cardHolderName: "Sandy Kim",
            //   cvvCode: "245",
            //   showBackView:
            //       true, //true when you want to show cvv(back) view
            // ),
            buildFormdata(
              "Card Number",
              hint: "1111-2222-3333-4444",
              formatter: [
                MaskedTextInputFormatter(
                  mask: 'xxxx-xxxx-xxxx-xxxx',
                  separator: '-',
                ),
              ],
            ),
            buildFormdata("Name on Card", hint: "Sandy Kim"),
            Row(
              children: <Widget>[
                Expanded(
                  child: buildFormdata("Expiry Date", hint: "12/05"),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: buildFormdata("CVV", hint: "243"),
                ),
              ],
            ),
            buildCardData(),
            SizedBox(
              height: 20,
            ),
            ButtonBuilder.buttonCustom(
              paddingValue: 0,
              context: context,
              label: "Pay Now",
            ),
          ],
        ),
      ),
    );
  }

  Container buildCardData() => Container(
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 120,
                      height: 140,
                      child: Image.asset(
                        Assets.BACK_GROUND_APP,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "500 THB\n",
                                style: TextStyleCustom.STYLE_TITLE.copyWith(
                                    fontSize: 25, color: COLOR_THEME_APP),
                              ),
                              TextSpan(
                                text: "Dyson V7 Trigger\n\n",
                                style: TextStyleCustom.STYLE_TITLE.copyWith(
                                  fontSize: 20,
                                ), //Fix Motors
                              ),
                              TextSpan(
                                  text: "Fix Motors\n",
                                  style: TextStyleCustom.STYLE_LABEL),
                              TextSpan(
                                  text:
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                  style: TextStyleCustom.STYLE_CONTENT),
                            ]),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Container buildFormdata(title, {hint, formatter}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: COLOR_GREY),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextBuilder.build(title: title, style: TextStyleCustom.STYLE_CONTENT),
          TextField(
            inputFormatters: formatter,
            decoration: InputDecoration(
                hintText: hint,
                // hintStyle: TextStyleCustom.STYLE_CONTENT,
                contentPadding: EdgeInsets.symmetric(vertical: 5)),
          ),
        ],
      ),
    );
  }

  Widget buttonCredit(icons, title, actived) {
    return Expanded(
      child: Container(
        height: 100,
        child: RaisedButton.icon(
          elevation: 5,
          color: actived ? COLOR_THEME_APP : COLOR_WHITE,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          icon: Icon(icons),
          label: TextBuilder.build(title: title),
          onPressed: () {
            setState(() {
              activeCard = !activeCard;
            });
          },
        ),
      ),
    );
  }
}
