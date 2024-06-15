import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopefoodusuario/common/custom_appbar.dart';
import 'package:sopefoodusuario/common/custom_container.dart';
import 'package:sopefoodusuario/common/heading.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/controllers/catergory_controller.dart';
import 'package:sopefoodusuario/views/home/all_nearby_restaurants.dart';
import 'package:sopefoodusuario/views/home/fastest_foods_page.dart';
import 'package:sopefoodusuario/views/home/recommendations.dart';
import 'package:sopefoodusuario/views/home/widgets/categories_list.dart';
import 'package:sopefoodusuario/views/home/widgets/category_foodlist.dart';
import 'package:sopefoodusuario/views/home/widgets/food_list.dart';
import 'package:sopefoodusuario/views/home/widgets/nearby_restaurants.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.h), child: const CustomAppBar()),
      body: SafeArea(
          child: CustomContainer(
              containerContent: Column(
        children: [
          const CategoriesWidget(),
          Obx(
            () => categoryController.categoryValue == ''
                ? Column(
                    children: [
                      // HomeHeading(
                      //   heading: "Pick Restaurants",
                      //   restaurant: true,
                      // ),
                      // const RestaurantOptions(),
                      HomeHeading(
                        heading: "Restaurantes Cerca",
                        onTap: () {
                          Get.to(() => const AllNearbyRestaurants());
                        },
                      ),
                      const NearbyRestaurants(),
                      HomeHeading(
                        heading: "Intenta Algo Nuevo",
                        onTap: () {
                          Get.to(() => const Recommendations());
                        },
                      ),
                      const FoodList(),
                      HomeHeading(
                        heading: "Comida rápida más cerca de ti",
                        onTap: () {
                          Get.to(() => const FastestFoods());
                        },
                      ),
                      const FoodList(),
                    ],
                  )
                : CustomContainer(
                    containerContent: Column(
                      children: [
                        HomeHeading(
                          heading:
                              "Explore Categoria ${categoryController.titleValue} ",
                          restaurant: true,
                        ),
                        const CategoryFoodList(),
                      ],
                    ),
                  ),
          ),
        ],
      ))),
    );
  }
}
