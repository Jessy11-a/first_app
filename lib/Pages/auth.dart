import 'package:flutter/material.dart';
import './products.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue = '';
  String _passwordValue = '';
  bool _acceptTerms = false;

  _buildDecorationImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage('assets/background.jpg'));
  }

  _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        setState(() {
          _emailValue = value;
        });
      },
    );
  }

  _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _passwordValue = value;
        });
      },
    );
  }

  _buildAcceptSwitch() {
    return SwitchListTile(
      value: _acceptTerms,
      onChanged: (bool value) {
        setState(() {
          _acceptTerms = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  _submitForm() {
    return Navigator.pushReplacementNamed(context, '/admin');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: _buildDecorationImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Column(children: <Widget>[
                _buildEmailTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _buildPasswordTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _buildAcceptSwitch(),
                ElevatedButton(
                  child: Text('LOGIN'),
                  onPressed: _submitForm,
                )
              ]),
            ),
          ))),
    );
  }
}
 