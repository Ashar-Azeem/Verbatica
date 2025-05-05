import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/Authentication/EmailVerification.dart';
import 'package:verbatica/Views/navBarScreens/mainBottomNavigationBar.dart';
import 'package:verbatica/Views/Authentication/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color.fromARGB(255, 10, 13, 15),
    ),
  );
  runApp(
    Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Verbatica',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 40, 188, 242),
              brightness: Brightness.dark,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(95.w, 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            buttonTheme: ButtonThemeData(buttonColor: primaryColor),
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
            scaffoldBackgroundColor: const Color(0xFF0A0D0F),
            useMaterial3: true,
          ),
          home: const BottomNavigationBarView(),
        );
      },
    ),
  );
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TokenOperations().loadUserProfile(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            {
              Map<String, dynamic>? user = snapshot.data;
              //Also adding the above data to the user bloc and that bloc will be global across the app
              //local storage to ram using BLOC
              if (user == null) {
                return Login();
              } else {
                if (user['isEmailVerified']) {
                  return BottomNavigationBarView();
                } else {
                  return EmailVerification();
                }
              }
            }
          default:
            {
              return Scaffold(
                body: Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: Colors.blue,
                    size: 12.w,
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
