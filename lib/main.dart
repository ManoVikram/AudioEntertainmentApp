import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './amplifyconfiguration.dart';

import './screens/onBoardingScreens/onboarding_screen.dart';
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
import './models/bloc/uploadAudio/upload_audio_bloc.dart';
import './models/bloc/featchAudioThumbnailURL/fetch_audio_thumbnail_url_bloc.dart';
import './models/bloc/updateUserData/update_user_data_bloc.dart';
import './models/bloc/fetchCategories/fetch_categories_bloc.dart';
import './models/bloc/fetchAudio/fetch_audio_bloc.dart';

import './models/provider/user_data.dart';

import './models/ModelProvider.dart';

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
    AmplifyDataStore dataStorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);
    AmplifyAPI apiPlugin = AmplifyAPI();
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();

    await Amplify.addPlugins([
      authPlugin,
      dataStorePlugin,
      apiPlugin,
      storagePlugin,
    ]);

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
        /* BlocProvider<UploadAudioBloc>(
          create: (context) => UploadAudioBloc(),
        ), */
        BlocProvider<FetchAudioThumbnailUrlBloc>(
          create: (context) => FetchAudioThumbnailUrlBloc(),
        ),
        BlocProvider<UpdateUserDataBloc>(
          create: (context) => UpdateUserDataBloc(),
        ),
        BlocProvider<FetchCategoriesBloc>(
          create: (context) => FetchCategoriesBloc(),
        ),
        BlocProvider<FetchAudioBloc>(
          create: (context) => FetchAudioBloc(),
        ),
        /* BlocProvider(
          create: (context) => FetchAudioBloc()..add(const FetchAllAudio()),
          child: Container(),
        ), */
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CurrentUserData(),
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
            SubscriptionScreen.routeName: (context) =>
                const SubscriptionScreen(),
            AccountScreen.routeName: (context) => const AccountScreen(),
            EditAccountDetilsScreen.routeName: (context) =>
                const EditAccountDetilsScreen(),
            // AudioUploadScreen.routeName: (context) => const AudioUploadScreen(),
            AudioUploadScreen.routeName: (context) =>
                BlocProvider<UploadAudioBloc>(
                  create: (context) => UploadAudioBloc(),
                  child: const AudioUploadScreen(),
                ),
            PlayingAudioScreen.routeName: (context) =>
                const PlayingAudioScreen(),
          },
          home: const AudioApp(),
        ),
      ),
    );
  }
}

class AudioApp extends StatefulWidget {
  const AudioApp({
    Key? key,
  }) : super(key: key);

  @override
  State<AudioApp> createState() => _AudioAppState();
}

class _AudioAppState extends State<AudioApp> with AfterLayoutMixin<AudioApp> {
  SharedPreferences? _prefs;
  bool _seen = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> checkAlreadySeen() async {
    _prefs = await SharedPreferences.getInstance();
    _seen = (_prefs?.getBool("seen") ?? false);

    // BlocProvider.of<FetchAudioBloc>(context).add(const FetchAllAudio());
  }

  Future<bool> _fetchSession() async {
    // final currentUserDataProvider = context.watch<CurrentUserData>();
    // context.read<FetchAudioBloc>().add(const FetchAllAudio());

    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );

      /* AuthUser currentUser = await Amplify.Auth.getCurrentUser();
      User currentUserData = (await Amplify.DataStore.query(User.classType,
          where: User.EMAIL.eq(currentUser.username)))[0];

      if (currentUserData.profilePictureKey != null) {
        GetUrlResult profilePictureURL = await Amplify.Storage.getUrl(
            key: currentUserData.profilePictureKey!);

        currentUserDataProvider.setCurrentUserData = CurrentUser(
          email: currentUser.username,
          userID: currentUser.userId,
          profilePictureURL: profilePictureURL.url,
          isCreator: currentUserData.isCreator,
          name: currentUserData.name,
          description: currentUserData.description,
          followers: currentUserData.followers ?? [],
        );
      } else {
        currentUserDataProvider.setCurrentUserData = CurrentUser(
          email: currentUser.username,
          userID: currentUser.userId,
          isCreator: currentUserData.isCreator,
          name: currentUserData.name,
          description: currentUserData.description,
          followers: currentUserData.followers ?? [],
        );
      }

      print(currentUserDataProvider.currentUser.isCreator); */

      return res.isSignedIn;
    } on AuthException catch (error) {
      print(error.message);
      return false;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkAlreadySeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkAlreadySeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (_seen) {
              return FutureBuilder(
                future: _fetchSession(),
                builder: (context, sessionSnapshot) {
                  if (sessionSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (sessionSnapshot.connectionState ==
                      ConnectionState.done) {
                    if (sessionSnapshot.hasData &&
                        sessionSnapshot.data == true) {
                      context.read<FetchAudioBloc>().add(const FetchAllAudio());
                      return const HomeScreen();
                    } else if (sessionSnapshot.hasData &&
                        sessionSnapshot.data == false) {
                      return const LoginScreen();
                    } else {
                      return const Center(
                        child: Text("ERROR!"),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text("ERROR!"),
                    );
                  }
                },
              );
            } else {
              _prefs?.setBool("seen", true);
              return const OnboardingScreen();
            }
          } else {
            return const Center(
              child: Text("ERROR!!"),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}