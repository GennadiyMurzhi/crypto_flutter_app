import 'package:crypto_flutter_app/screens/crypto_camp_screen.dart';
import 'package:crypto_flutter_app/screens/dashboard_screen.dart';
import 'package:crypto_flutter_app/screens/password_recovery_screen.dart';
import 'package:crypto_flutter_app/screens/select_country_screen.dart';
import 'package:crypto_flutter_app/screens/sign_in_screen.dart';
import 'package:crypto_flutter_app/screens/sing_up_screen.dart';
import 'package:crypto_flutter_app/screens/test_frorm_from_Artur.dart';
import 'package:crypto_flutter_app/screens/traders_screen.dart';
import 'package:flutter/widgets.dart';

class RouteMaker{
  static Route onGenerateRouteMaker(RouteSettings routeSettings){
    switch(routeSettings.name){
      case "/" :
        return RouteMaker.createScreenRoute(DashboardScreen());
        break;
      case "/testForm":
        return RouteMaker.createScreenRoute(TestFormFromArtur());
        break;
      case "/select_country" :
        return RouteMaker.createScreenRoute(SelectCountryScreen());
        break;
      case "/sign_in":
        return RouteMaker.createScreenRoute(SignInScreen());
        break;
      case "/sing_up":
        return RouteMaker.createScreenRoute(SingUpScreen());
        break;
      case "/password_recovery_screen":
        return RouteMaker.createScreenRoute(PasswordRecoveryScreen());
        break;
      case "/crypto_camp":
        return RouteMaker.createMenuRoute(CryptoCampScreen(), true);
        break;
      case "/traders":
        return RouteMaker.createScreenRoute(TradersScreen());
        break;
      default:
        return RouteMaker.createScreenRoute(DashboardScreen());
    }
  }

  static Route createScreenRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        Curve curve = Curves.ease;

        CurvedAnimation curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return ScaleTransition(
          scale: curvedAnimation,
          child: child,
        );
      },
    );
  }

  static Route createMenuRoute(Widget screen, bool isOpen){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child){

        Curve curve = Curves.easeInSine;

        Offset begin = Offset(1, 0);
        Offset end = Offset(0, 0);

        Animation<Offset> offsetAnimation = Tween<Offset>(
          begin: begin,
          end: end
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve
        ));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      }
    );
  }
}