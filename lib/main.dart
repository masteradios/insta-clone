import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/post_provider.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout.dart';
import 'package:insta_clone/responsive/web_layout.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBZQTMD7h4lMIt8BSddik1vhXhdNziahxk",
            authDomain: "insta-clone-33281.firebaseapp.com",
            projectId: "insta-clone-33281",
            storageBucket: "insta-clone-33281.appspot.com",
            messagingSenderId: "744133681799",
            appId: "1:744133681799:web:9436a7e09c44df97ab4e22",
            measurementId: "G-QC35B9BP71"));
  }
    await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:
      [
        ChangeNotifierProvider(create: (context)=>PostProvider()),
        ChangeNotifierProvider(create: (context)=>UserProvider())
      ],
      child: MaterialApp(
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder
          (
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot)
          {
            if(snapshot.connectionState==ConnectionState.active)
            {
              if(snapshot.hasData)
              {
                return ResponsiveUI(MobileScreenLayout: MobileScreenLayout(),WebLayout: WebLayout(),);
              }
              else if(snapshot.hasError)
              {
                return Scaffold(body: Center(child: Text('${snapshot.error}'),),);
              }
            }
            if(snapshot.connectionState==ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator(color: blueColor,),);
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
