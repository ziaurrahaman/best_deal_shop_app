import 'package:best_deal_shop_app/providers/auth_provider.dart';
import 'package:best_deal_shop_app/providers/home_provider.dart';
import 'package:best_deal_shop_app/providers/page_provider.dart';
import 'package:best_deal_shop_app/ui/auth/info_screen.dart';
import 'package:best_deal_shop_app/ui/library_screen.dart';
import 'package:best_deal_shop_app/ui/main_screen.dart';
import 'package:best_deal_shop_app/ui/on_boarding_screen.dart';
import 'package:best_deal_shop_app/ui/splash_screen.dart';
import 'package:best_deal_shop_app/utils/analytics_client.dart';
import 'package:best_deal_shop_app/utils/app_theme.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Crashlytics.instance.enableInDevMode = false;
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;

  // Analytics.instance.logAppOpen();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // runApp(PromoHunterApp());
  runApp(BestDealShopApp());
}

class BestDealShopApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _BestDealShopAppState createState() => _BestDealShopAppState();
}

class _BestDealShopAppState extends State<BestDealShopApp>
    with TickerProviderStateMixin {
  Widget _getHomeWidget(AuthService auth) {
    if (auth.isLogged && auth.userExist) return MainScreen();

    return FutureBuilder<bool>(
      future: auth.autoLogin(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        return snapshot.data && auth.userExist
            ? MainScreen()
            : snapshot.data && !auth.userExist
                ? InfoScreen()
                : ChangeNotifierProvider(
                    create: (context) => PageProvider(),
                    child: OnBoardingScreen(),
                  );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (BuildContext context) => AuthService(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (BuildContext context) => HomeProvider(),
        ),
        ChangeNotifierProvider<TabIndexProvider>(
          create: (BuildContext context) => TabIndexProvider(
            TabController(
              length: 4,
              initialIndex: 0,
              vsync: this,
            ),
            2,
          ),
        )
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Promo Hunter',
          theme: AppTheme.theme,
          home: _getHomeWidget(auth),
          // navigatorObservers: <NavigatorObserver>[
          // Analytics.instance.observer,
          // ],
        ),
      ),
    );
  }
}
