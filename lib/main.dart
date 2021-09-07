import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './amplifyconfiguration.dart';

// import './screens/onBoardingScreens/onboarding_screen.dart';
import './screens/authenticationScreens/login_screen.dart';
import './screens/authenticationScreens/signup_screen.dart';
import './screens/authenticationScreens/forgot_password_screen.dart';
import './screens/authenticationScreens/reset_new_password_screen.dart';
import './screens/authenticationScreens/reset_password_successful_screen.dart';
import './screens/confirmationCodeScreen/confirmation_code_screen.dart';
import './screens/homeScreen/home_screen.dart';
import './screens/categoryScreen/category_screen.dart';
import './screens/searchScreen/search_screen.dart';
import './screens/subscriptionScreen/subscription_screen.dart';
import './screens/accountScreen/account_screen.dart';
import './screens/editAccountDetilsScreen/edit_account_details_screen.dart';
import './screens/audioUploadScreen/audio_upload_screen.dart';
import './screens/playingAudioScreen/playing_audio_screen.dart';

import './models/bloc/userAuthentication/registerNewUser/register_new_user_bloc.dart';
import './models/bloc/userAuthentication/confirmNewUser/confirm_new_user_bloc.dart';
import './models/bloc/userAuthentication/signInUser/sign_in_user_bloc.dart';
import './models/bloc/userAuthentication/forgotPassword/forgotPasswordEmail/forgot_password_bloc.dart';
import './models/bloc/userAuthentication/forgotPassword/newPasswordReset/reset_new_password_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugins([authPlugin]);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterNewUserBloc>(
          create: (context) => RegisterNewUserBloc(),
        ),
        BlocProvider<ConfirmNewUserBloc>(
          create: (context) => ConfirmNewUserBloc(),
        ),
        BlocProvider<SignInUserBloc>(
          create: (context) => SignInUserBloc(),
        ),
        BlocProvider<ForgotPasswordBloc>(
          create: (context) => ForgotPasswordBloc(),
        ),
        BlocProvider<ResetNewPasswordBloc>(
          create: (context) => ResetNewPasswordBloc(),
        ),
      ],
      child: MaterialApp(
        title: "Audio Entertainment",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          SignupScreen.routeName: (context) => const SignupScreen(),
          ForgotPasswordScreen.routeName: (context) =>
              const ForgotPasswordScreen(),
          ResetNewPasswordScreen.routeName: (context) =>
              const ResetNewPasswordScreen(),
          ResetPasswordSuccessfulScreen.routeName: (context) =>
              const ResetPasswordSuccessfulScreen(),
          ConfirmationCodeScreen.routeName: (context) =>
              const ConfirmationCodeScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          CategoryScreen.routeName: (context) => const CategoryScreen(),
          SearchScreen.routeName: (context) => SearchScreen(),
          SubscriptionScreen.routeName: (context) => const SubscriptionScreen(),
          AccountScreen.routeName: (context) => const AccountScreen(),
          EditAccountDetilsScreen.routeName: (context) =>
              EditAccountDetilsScreen(),
          AudioUploadScreen.routeName: (context) => AudioUploadScreen(),
          PlayingAudioScreen.routeName: (context) => const PlayingAudioScreen(),
        },
        home: const AudioApp(),
      ),
    );
  }
}

class AudioApp extends StatelessWidget {
  const AudioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginScreen(),
    );
  }
}

void main() {
  runApp(const MyApp());
}
