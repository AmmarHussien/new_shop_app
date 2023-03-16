import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _useId;

  Future _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyA5xAT5Ikm1VGYZ08F0G5sT_y3GieYFR5M',
    );
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(
      json.decode(response.body),
    );
  }

  Future signup(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signUp');
    // final url = Uri.parse(
    //   'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA5xAT5Ikm1VGYZ08F0G5sT_y3GieYFR5M',
    // );
    // final response = await http.post(
    //   url,
    //   body: json.encode(
    //     {
    //       'email': email,
    //       'password': password,
    //       'returnSecureToken': true,
    //     },
    //   ),
    //);
  }

  Future login(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signInWithPassword');
    // final url = Uri.parse(
    //   'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA5xAT5Ikm1VGYZ08F0G5sT_y3GieYFR5M',
    // );
    // final response = await http.post(
    //   url,
    //   body: json.encode(
    //     {
    //       'email': email,
    //       'password': password,
    //       'returnSecureToken': true,
    //     },
    //   ),
    //);
  }
}
