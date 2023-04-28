import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift/Constants/Colors.dart';
import 'package:lift/Pages/Auth/User/signupscreen.dart';
import 'package:lift/widgets/textfield.dart';
import 'package:get/get.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  final phoneController = TextEditingController();
  final pwdController = TextEditingController();

  var recievedID = '';

  @override
  void dispose() {
    phoneController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  Future<void> getOtp() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.verifyPhoneNumber(
        phoneNumber: '+91${phoneController.text}',
        verificationCompleted: (AuthCredential authCredential) async {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Phone Number Verfied')));
        },
        verificationFailed: (FirebaseAuthException firebaseAuthException) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(firebaseAuthException.toString())));
        },
        codeSent: (String verificationCode, int? forceResendingToken) {
          recievedID = verificationCode;

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP sent to above number')));
        },
        codeAutoRetrievalTimeout: (String verficationCode) {
          if (kDebugMode) {
            print(verficationCode);
          }
          if (kDebugMode) {
            print("Timout");
          }
        });
  }

  Future<void> signin() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: recievedID,
      smsCode: pwdController.text,
    );
    await auth
        .signInWithCredential(credential)
        .then((value) => print('User Login In Successful'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Rang.black,
      body: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(25.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.montserrat(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Please sign in to your account',
                  style: GoogleFonts.montserrat(
                    fontSize: 15.sp,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 80.h,
                ),
                TextFieldApp(
                    textEditingController: phoneController,
                    hintText: '',
                    keyboardtype: TextInputType.number,
                    maxlines: 1,
                    label: 'Phone'),
                SizedBox(
                  height: 10.h,
                ),
                TextFieldApp(
                    textEditingController: pwdController,
                    hintText: '',
                    keyboardtype: TextInputType.number,
                    maxlines: 1,
                    label: 'OTP'),
                SizedBox(
                  height: 15.sp,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () async {
                      await getOtp();
                    },
                    child: Text(
                      'Get OTP',
                      style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
                InkWell(
                  onTap: () async {
                    await signin();
                  },
                  child: Container(
                    width: double.maxFinite,
                    height: 65.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.h),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.alegreya(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                InkWell(
                  onTap: () async {
                    var auth = FirebaseAuth.instance;

                    await auth.signInWithProvider(GoogleAuthProvider());
                  },
                  child: Container(
                    height: 65.h,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.h),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 80.w,
                              padding: EdgeInsets.only(left: 50.w),
                              child: Image.asset(
                                './assets/Glogo.png',
                                fit: BoxFit.fitWidth,
                              )),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            'Sign In with Google',
                            style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Rang.black),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an accont?',
                      style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    TextButton(
                      onPressed: () async {
                        Get.offAll(
                          SignUpScreen(),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
