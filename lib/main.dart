import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/comments_cluster/comment_cluster_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart';
import 'package:verbatica/BLOC/summary/summary_bloc.dart';
import 'package:verbatica/DummyData/UserDummyData.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/Authentication%20Screens/EmailVerification.dart';
import 'package:verbatica/Views/Authentication%20Screens/login.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/mainBottomNavigationBar.dart';

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
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<OtheruserBloc>(create: (context) => OtheruserBloc()),
        BlocProvider<SummaryBloc>(create: (context) => SummaryBloc()),
        BlocProvider<CommentClusterBloc>(
          create: (context) => CommentClusterBloc(),
        ),
        BlocProvider(create: (context) => ChatBloc()),
      ],
      child: Sizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            title: 'Verbatica',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 40, 188, 242),
                brightness: Brightness.dark,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Color.fromARGB(255, 16, 26, 32),
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
              textTheme: GoogleFonts.robotoTextTheme(
                Theme.of(context).textTheme,
              ),
              scaffoldBackgroundColor: const Color(0xFF0A0D0F),
              useMaterial3: true,
            ),
            home: const BottomNavigationBarView(),
          );
        },
      ),
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

              if (user == null) {
                return Login();
              } else {
                context.read<UserBloc>().add(UpdateUser(dummyUser, context));
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
