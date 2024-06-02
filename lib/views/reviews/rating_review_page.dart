import 'package:flutter/material.dart';
import 'package:sopefoodusuario/common/app_style.dart';
import 'package:sopefoodusuario/common/reusable_text.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/views/reviews/widgets/orders_to_rate.dart';

class RatingReview extends StatelessWidget {
  const RatingReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kLightWhite,
        elevation: 0,
        title: ReusableText(
          text: "reseñas y calificaciones",
          style: appStyle(16, Colors.black, FontWeight.w600),
        ),
      ),
      body: const RateOrders(),
    );
  }
}
