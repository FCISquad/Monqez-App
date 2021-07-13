import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Color primary = Colors.deepOrange;
Color firstColor = Colors.deepOrangeAccent;
Color secondColor = Colors.white;

void navigate(Widget map, BuildContext context, bool replace) {
  PageRouteBuilder pageRouteBuilder = PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, animationTime, child) {
        return SlideTransition(
          position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
              .animate(CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          )),
          child: child,
        );
      },
      pageBuilder: (context, animation, animationTime) {
        return map;
      });
  replace
      ? Navigator.pushReplacement(context, pageRouteBuilder)
      : Navigator.push(context, pageRouteBuilder);
}

Widget getTitle(
    String title, double size, Color color, TextAlign align, bool isBold) {
  return Text(
    title,
    style: TextStyle(
        color: color,
        fontSize: size,
        letterSpacing: 1.5,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    textAlign: align,
  );
}

Widget getIcon(IconData icon, double size, Color color) {
  return Icon(
    icon,
    color: color,
    size: size,
    semanticLabel: 'Text to announce in accessibility modes',
  );
}

Widget getRatingBar(double rating, double size, Color color) {
  return RatingBarIndicator(
    direction: Axis.horizontal,
    itemCount: 5,
    rating: rating,
    itemSize: size,
    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
    itemBuilder: (context, _) => Icon(
      Icons.star,
      color: color,
    ),
  );
}
