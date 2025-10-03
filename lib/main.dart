// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/Search%20Bloc/search_bloc.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/Votes%20Restriction/votes_restrictor_bloc.dart';
import 'package:verbatica/BLOC/comments_cluster/comment_cluster_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_bloc.dart';
import 'package:verbatica/BLOC/summary/summary_bloc.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Utilities/theme_provider.dart';
import 'package:verbatica/Views/Authentication%20Screens/EmailVerification.dart';
import 'package:verbatica/Views/Authentication%20Screens/login.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/mainBottomNavigationBar.dart';
import 'package:verbatica/model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  User? user = await TokenOperations().loadUserProfile();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<OtheruserBloc>(create: (context) => OtheruserBloc()),
        BlocProvider<PostBloc>(create: (context) => PostBloc()),

        BlocProvider<SummaryBloc>(create: (context) => SummaryBloc()),
        BlocProvider<VotesRestrictorBloc>(
          create: (context) => VotesRestrictorBloc(),
        ),
        BlocProvider<CommentClusterBloc>(
          create: (context) => CommentClusterBloc(),
        ),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => TrendingViewBloc()),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => HomeBloc()),
      ],
      child: MyApp(user: user),
    ),
  );
}

class MyApp extends StatelessWidget {
final User? user;
  const MyApp({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Verbatica',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            dividerColor: const Color.fromARGB(255, 181, 181, 181),

            scaffoldBackgroundColor: const Color.fromARGB(255, 230, 230, 230),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 230, 230, 230),
              foregroundColor: Colors.black,
            ),
            colorScheme: ColorScheme(
              primary: const Color.fromARGB(255, 102, 161, 221),
              onPrimary: const Color.fromARGB(255, 255, 255, 255),

              secondary: const Color.fromARGB(255, 103, 103, 103),
              onSecondary: Colors.orange,
              error: const Color.fromARGB(255, 252, 17, 0),
              onError: Colors.white,
              surface: const Color.fromARGB(255, 238, 237, 237),
              onSurface: const Color.fromARGB(255, 208, 207, 207),
              brightness: Brightness.light,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28BCF2),
                foregroundColor: Colors.white,
                minimumSize: Size(95.w, 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            textTheme: GoogleFonts.robotoTextTheme(
              ThemeData(brightness: Brightness.light).textTheme,
            ),

            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            dividerColor: Color.fromARGB(255, 57, 75, 85),
            primaryColor: Colors.white,
            colorScheme: ColorScheme(
              primary: primaryColor,
              onPrimary: Colors.white,
              secondary: Colors.white,
              onSecondary: Colors.white,
              error: const Color.fromARGB(255, 252, 17, 0),
              onError: Colors.white,
              surface: Color(0xFF0F1417),
              onSurface: Colors.white,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F1417)),
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
            textTheme: GoogleFonts.robotoTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),

            scaffoldBackgroundColor: const Color(0xFF0A0D0F),
            useMaterial3: true,
          ),
          home:
              user == null
                  ? Login()
                  : user!.isVerified
                  ? 
                  BottomNavigationBarView(user: user)
                  : EmailVerification(),
        );
      },
    );
  }
}
