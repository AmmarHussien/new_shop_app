import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'auth_screen.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<Size>(
      begin: const Size(double.infinity, 260),
      end: const Size(double.infinity, 320),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(
          context,
          listen: false,
        ).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Log user signup
        await Provider.of<Auth>(
          context,
          listen: false,
        ).signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
      //Navigator.of(context).pushReplacementNamed('/products-overview');
    } on HttpException catch (error) {
      var errorMessage = 'Authentcation faild';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Cloud not authenticate you. Plase try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        //height: _authMode == AuthMode.Signup ? 320 : 260,
        height: _heightAnimation.value.height,
        constraints:
            //BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
            BoxConstraints(
          minHeight: _heightAnimation.value.height,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                      ),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.button!.color,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.purple,
                      ),
                    ),
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    ),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  child: Text(
                    _authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
