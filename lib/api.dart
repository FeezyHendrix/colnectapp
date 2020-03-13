

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiProvider {
  static Future<dynamic> fetchMessage(String pageToken) async {
    var response;
    if(pageToken == '') {
      response =  await http.get('http://message-list.appspot.com/messages');
    } else {
      
      response =  await http.get('http://message-list.appspot.com/messages?pageToken=$pageToken');
    }


    if(response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load messages');
    }
  }
}