// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'second_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocalAuthentication local = LocalAuthentication();
  late bool check;
  List<BiometricType> _available = [];
  String auth = 'Not Authorized';

  Future<void> _check() async {
    late bool cancheck;
    try {
      cancheck = await local.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      check = cancheck;
    });
  }

  Future<void> getAvailable() async {
    List<BiometricType> available = [];
    try {
      available = await local.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _available = available;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _check();
    getAvailable();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _auth() async {
      bool authenticate = false;
      try {
        authenticate = await local.authenticate(
            biometricOnly: true,
            localizedReason: 'Scan your finger to authenticate',
            useErrorDialogs: false,
            stickyAuth: false);
      } on PlatformException catch (e) {
        print(e);
      }

      if (!mounted) return;
      setState(() {
        auth = authenticate ? 'Authorize Success' : 'Failed to Authenticate';
        if (authenticate) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SecondPage()));
        }
        print(auth);
      });
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFF3C3E52),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: const Text(
                    'Login',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      const Text(
                        'Fingerprint Auth',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        width: 150,
                        child: const Text(
                          'Authenticate using your fingerprint instead of your password',
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: Colors.white, height: 1.5),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: _auth,
                          elevation: 0,
                          color: const Color(0xFF04A5ED),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            child: Text(
                              'Authenticate',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
