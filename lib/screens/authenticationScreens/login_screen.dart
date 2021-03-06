import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import './signup_screen.dart';
import './forgot_password_screen.dart';
import '../homeScreen/home_screen.dart';
import '../confirmationCodeScreen/confirmation_code_screen.dart';
import '../../widgets/text_field_with_icon.dart';

import '../../models/bloc/userAuthentication/signInUser/sign_in_user_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/loginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignInUserBloc signInUserBloc =
        BlocProvider.of<SignInUserBloc>(context);
    final Size size = MediaQuery.of(context).size;

    return BlocConsumer<SignInUserBloc, SignInUserState>(
      listener: (context, state) {
        if (state is SignInUserSuccess) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else if (state is SignInUserNotConfirmed) {
          Navigator.of(context).pushNamed(
            ConfirmationCodeScreen.routeName,
            arguments: {
              "email": _emailController.text.trim(),
            },
          );
        } else if (state is SignInUserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? "ERROR!!"),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFf3fbf8),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // ignore: sized_box_for_whitespace
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/authenticationScreens/SignInIllustration.png",
                    height: size.height * 0.25,
                  ),
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 26.0,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFieldWithIcon(
                    textController: _emailController,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 14.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.redAccent,
                      ),
                    ),
                    title: "Email",
                    isPasswordField: false,
                    borderColor: Colors.greenAccent,
                    iconColor: Colors.redAccent,
                  ),
                  TextFieldWithIcon(
                    textController: _passwordController,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 14.0),
                      child: Icon(
                        Icons.lock,
                        color: Colors.redAccent,
                      ),
                    ),
                    title: "Password",
                    textInputAction: TextInputAction.done,
                    isPasswordField: true,
                    borderColor: Colors.greenAccent,
                    iconColor: Colors.redAccent,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ForgotPasswordScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Amplify.Auth.signOut();
                      signInUserBloc.add(SignInUser(
                        userEmail: _emailController.text.trim(),
                        userPassword: _passwordController.text.trim(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fixedSize: Size(size.width * 0.6, 60),
                      textStyle: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 20,
                      ),
                      /* padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 13,
                      ), */
                    ),
                    child: state is SignInUserInProgress
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Log In",
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 16,
                      ),
                      fixedSize: Size(size.width * 0.6, 60),
                      /* padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ), */
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset("assets/icons/Google_Logo.svg"),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: AutoSizeText(
                            "Log In With Google",
                            style: TextStyle(
                              fontSize: 16
                            ),
                            minFontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "New here?",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignupScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                            fontFamily: GoogleFonts.roboto().fontFamily,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Create An Account",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
