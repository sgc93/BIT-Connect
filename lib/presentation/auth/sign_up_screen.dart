import 'package:bit_connect/presentation/auth/components/error_snack_bar.dart';
import 'package:bit_connect/presentation/auth/components/input_field.dart';
import 'package:bit_connect/presentation/auth/components/loading_spinner.dart';
import 'package:bit_connect/searvices/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SignUP extends StatefulWidget {
  final VoidCallback toggleToLogin;
  final Function(String, String) setSignUpData;
  const SignUP(
      {super.key, required this.toggleToLogin, required this.setSignUpData});

  @override
  State<SignUP> createState() => _SignUpState();
}

class _SignUpState extends State<SignUP> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passConfirmController = TextEditingController();
  String _signUpError = "";

  @override
  void initState() {
    super.initState();

    _idController.text = "";
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _passConfirmController.dispose();
    super.dispose();
  }

  // handling signing up
  Future<void> signUp() async {
    LoadingSpinner.load(context);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "${_idController.text.toLowerCase()}@gmail.com",
        password: _passwordController.text,
      );

      widget.setSignUpData(
        "${_idController.text.toLowerCase()}@gmail.com",
        _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'Email-already-in-use') {
        setState(() {
          _signUpError = "The ID is already in use. Please Sign In instead.";
        });
      } else if (error.code == 'Network-request-Failed') {
        ErrorSnackBar snackBar = ErrorSnackBar(
            content:
                "You have lost connection. Please check your internet connection.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar.getSnackBar());
        }
      } else {
        ErrorSnackBar snackBar = ErrorSnackBar(content: error.message ?? "");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar.getSnackBar());
        }
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  // handling form submitting

  void handleFormSubmitting() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      signUp();
    }
  }

  // validate id

  String? validateScannedId(value) {
    if (value == "") {
      return "Scan your ID again, Please";
    } else {
      return null;
    }
  }

  // validate password
  String? validatePassword(value) {
    if (value.isEmpty) {
      return "Password must not be empty!";
    } else if (value.length < 6) {
      return "Password length must be at least 6";
    } else {
      return null;
    }
  }

  // confirm password
  String? passwordConfirmationValidator(value) {
    if (value.isEmpty) {
      return "Please confirm you password!";
    } else if (_passwordController.text != value) {
      return "Please confirm password correctly!";
    } else {
      return null;
    }
  }

  // handling scanning id with flutter_barcode_scanner widget
  Future<void> handleScanningId() async {
    String? barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#57ADF6",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );

      RegExp pattern = RegExp(r'\d{7}[A-Z]');
      if (pattern.hasMatch(barcodeScanRes)) {
        final idNo = barcodeScanRes.split(RegExp(r'[A-Z]'))[0];
        setState(() {
          _idController.text = "BDU$idNo";
          _signUpError = "";
        });
      } else if (barcodeScanRes != "-1") {
        setState(() {
          _signUpError =
              "Scanned ID is not valid, Please try again with clear scan!";
          _idController.text = "";
        });
      }
    } on PlatformException catch (error) {
      setState(() {
        _signUpError = error.message ?? "Unable to scan, try again!";
      });
    }
  }

  void clearError() {
    if (_signUpError != "") {
      setState(() {
        _signUpError = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: getHeight(context) * 1 / 3,
                  child: const Image(
                    image: AssetImage(
                      "assets/logo.png",
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      _signUpError,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: getWidth(context),
                        child: Stack(
                          children: [
                            InputField(
                              validator: validateScannedId,
                              onChange: (value) => clearError(),
                              controller: _idController,
                              width: getWidth(context) * 5 / 6 - 45,
                              hintText: 'Scan Your ID',
                              isReadOnly: true,
                              isObscured: false,
                              hasObscure: false,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  handleScanningId();
                                },
                                child: Container(
                                  width: getWidth(context) * 1 / 6 - 10,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(100, 0, 0, 0),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Image(
                                    image: AssetImage(
                                      "assets/icons/barcode.png",
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      InputField(
                        validator: validatePassword,
                        onChange: (value) => clearError(),
                        controller: _passwordController,
                        width: getWidth(context),
                        hintText: 'Enter Password',
                        isReadOnly: false,
                        isObscured: true,
                        hasObscure: true,
                      ),
                      InputField(
                        validator: passwordConfirmationValidator,
                        onChange: (value) => clearError(),
                        controller: _passConfirmController,
                        width: getWidth(context),
                        hintText: 'Confirm Password',
                        isReadOnly: false,
                        isObscured: true,
                        hasObscure: true,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => handleFormSubmitting(),
                  child: Container(
                    width: getWidth(context),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 87, 172, 246),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: widget.toggleToLogin,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(255, 87, 172, 246),
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromARGB(255, 87, 172, 246),
                          ),
                        ),
                      )
                    ],
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
