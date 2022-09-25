// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  var _token = '';
  var _expiryTime = DateTime(2000);
  var _userId = '';
  var _authTimer = Timer(const Duration(seconds: 0), () {});

  bool get isAuth {
    return _token != '';
  }

  String get token {
    if (_expiryTime != DateTime(2000) &&
        _expiryTime.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return '';
  }

  String get userId => _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDEPiksZpjCyQ7xeDBDuYCquB4aYSFhxwE');
    try {
      final response = await http.post(url,
          body: jsonEncode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ));

      //
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      //
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();

      //
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,
          'expiryTime': _expiryTime.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      // print(prefs);
      // print(prefs.getString('userData')!);
    } catch (error) {
      // throw error;
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    //
    final extractedUserData = jsonDecode(prefs.getString('userData') as String)
        as Map<String, dynamic>;

    // print(extractedUserData.toString());
    final expiryTime =
        DateTime.parse(extractedUserData['expiryTime'].toString());

    //
    if (expiryTime.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryTime = expiryTime;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryTime = DateTime(2000);
    if (_authTimer.isActive) {
      _authTimer.cancel();
      _authTimer = Timer(const Duration(seconds: 0), () {});
    }
    notifyListeners();

    //
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    // prefs.clear(); // to clear everything in sharedPreferences
  }

  void _autoLogout() {
    if (_authTimer.isActive) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryTime.difference(DateTime.now()).inSeconds;
    // print(timeToExpiry);
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
