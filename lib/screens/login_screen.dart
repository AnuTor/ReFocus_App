import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _finish() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _submitLoginForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _finish();
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      var message = 'Ocurrió un error inesperado.';
      switch (err.code) {
        case 'invalid-email':
          message =
              'El mail ingresado es incorrecto. Por favor intente nuevamente';
          break;
        case 'user-disabled':
          message = 'El mail ingresado se encuentra deshabilitado.';
          break;
        case 'user-not-found':
          message =
              'El mail ingresado es incorrecto. Por favor intente nuevamente.';
          break;
        case 'wrong-password':
          message =
              'La contraseña ingresada es incorrecta. Por favor intente nuevamente.';
          break;
        default:
          break;
      }
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          Image.asset(
            'assets/images/refocus-fondo.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: LoginForm(
              key: const ValueKey('LoginForm'),
              submitFn: _submitLoginForm,
              isLoading: _isLoading,
            ),
          ),
        ]),
      ),
    );
  }
}
