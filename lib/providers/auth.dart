import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _useId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyA5xAT5Ikm1VGYZ08F0G5sT_y3GieYFR5M',
    );

    try {
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
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _useId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
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
