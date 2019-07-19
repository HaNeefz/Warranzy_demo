import 'package:url_launcher/url_launcher.dart';

class CallsAndMessageService {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email?subject=Poblem%20about%20application&body=Bug%20plugin");
}
