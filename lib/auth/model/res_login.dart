import 'package:stockbuddy_flutter_app/base/base_response_data.dart';

class ResLogin extends BaseResponseData{
  String? token;

  ResLogin({this.token}) : super();

  ResLogin.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json['data'];
    token = data['token'];
  }

}