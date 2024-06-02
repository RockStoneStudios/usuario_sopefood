import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopefoodusuario/common/app_style.dart';
import 'package:sopefoodusuario/common/reusable_text.dart';
import 'package:sopefoodusuario/common/shimmers/foodlist_shimmer.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/hooks/fetchAllNearbyRestaurants.dart';
import 'package:sopefoodusuario/models/restaurants.dart';
import 'package:sopefoodusuario/views/home/widgets/restaurant_tile.dart';

class AllNearbyRestaurants extends HookWidget {
  const AllNearbyRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllRestaurants("41007428");
    final restaurants = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: AppBar(
        elevation: .4,
        backgroundColor: kLightWhite,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view),
          ),
        ],
        title: ReusableText(
            text: "Restaurantes Cercas",
            style: appStyle(12, kGray, FontWeight.w600)),
      ),
      body: isLoading
          ? const FoodsListShimmer()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              height: hieght,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: restaurants.length,
                  itemBuilder: (context, i) {
                    Restaurants restaurant = restaurants[i];
                    return RestaurantTile(restaurant: restaurant);
                  }),
            ),
    );
  }
}
