import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopefoodusuario/common/shimmers/foodlist_shimmer.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/hooks/fetchRecommendations.dart';
import 'package:sopefoodusuario/models/foods.dart';
import 'package:sopefoodusuario/views/food/widgets/food_tile.dart';

class Explore extends HookWidget {
  const Explore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchRecommendations("41007428", false);
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      backgroundColor: kLightWhite,
      body: isLoading
          ? const FoodsListShimmer()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              height: hieght * 0.7,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: foods.length,
                  itemBuilder: (context, i) {
                    Food food = foods[i];
                    return FoodTile(food: food);
                  }),
            ),
    );
  }
}
