// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sopefoodusuario/common/app_style.dart';
import 'package:sopefoodusuario/common/reusable_text.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/models/restaurants.dart';
import 'package:sopefoodusuario/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    super.key,
    required this.restaurant,
  });

  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => RestaurantPage(
                  restaurant: restaurant,
                ),
            transition: Transition.native,
            duration: const Duration(seconds: 1));
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 86.h,
            width: width,
            decoration: const BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 82.h,
                            width: 84.w,
                            child: Image.network(
                              restaurant.imageUrl,
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 6, bottom: 2),
                              color: kGray.withOpacity(0.6),
                              height: 16,
                              width: width,
                              child: RatingBarIndicator(
                                rating: 5,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text: restaurant.title,
                          style: appStyle(15, kDark, FontWeight.w600)),
                      SizedBox(
                        height: 5.h,
                      ),
                      ReusableText(
                          text: "Tiempo Domicilio ${restaurant.time}",
                          style: appStyle(10, kGray, FontWeight.w600)),
                      const SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: width * 0.62,
                        child: Text(restaurant.coords.address,
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(9, kGray, FontWeight.w500)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 6.h,
            child: Container(
              width: 62.h,
              height: 20.h,
              decoration: BoxDecoration(
                  color: restaurant.isAvailable == true ||
                          restaurant.isAvailable == null
                      ? kPrimary
                      : kSecondaryLight,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: ReusableText(
                  text: restaurant.isAvailable == null ||
                          restaurant.isAvailable == true
                      ? "Abierto"
                      : "Cerrado",
                  style: appStyle(12, kLightWhite, FontWeight.w900),
                ),
              ),
            ),
          ),
          Positioned(
              right: 70.h,
              top: 6.h,
              child: Container(
                width: 19.h,
                height: 19.h,
                decoration: const BoxDecoration(
                    color: kSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: GestureDetector(
                  onTap: () {},
                  child: const Center(
                    child: Icon(
                      MaterialCommunityIcons.shopping_outline,
                      size: 15,
                      color: kLightWhite,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
