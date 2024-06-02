// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sopefoodusuario/common/address_modal.dart';
import 'package:sopefoodusuario/common/app_style.dart';
import 'package:sopefoodusuario/common/custom_textfield.dart';
import 'package:sopefoodusuario/common/reusable_text.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/controllers/address_controller.dart';
import 'package:sopefoodusuario/controllers/cart_controller.dart';
import 'package:sopefoodusuario/controllers/counter_controller.dart';
import 'package:sopefoodusuario/controllers/food_controller.dart';
import 'package:sopefoodusuario/hooks/fetchRestaurant.dart';
import 'package:sopefoodusuario/models/cart_request.dart';
import 'package:sopefoodusuario/models/foods.dart';
import 'package:sopefoodusuario/models/order_item.dart';
import 'package:sopefoodusuario/models/restaurants.dart';
import 'package:sopefoodusuario/views/auth/login_page.dart';
import 'package:sopefoodusuario/views/auth/phone_verification.dart';
import 'package:sopefoodusuario/views/home/widgets/custom_btn.dart';
import 'package:sopefoodusuario/views/orders/orders_page.dart';
import 'package:sopefoodusuario/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FoodPage extends StatefulHookWidget {
  const FoodPage({
    super.key,
    required this.food,
  });

  final Food food;

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final TextEditingController _preferences = TextEditingController();

  final CounterController counterController = Get.put(CounterController());
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var phone_verification = box.read('phone_verification');
    var address = box.read('default_address') ?? false;

    final foodController = Get.put(FoodController());
    final cartController = Get.put(CartController());

    foodController.loadAdditives(widget.food.additives);
    print('++++++++++++++++++++++++++++++++++++++++++++++');
    final hookResult = useFetchRestaurant(widget.food.restaurant);
    final restaurantData = hookResult.data;
    print(widget.food.restaurant);
    String? token = box.read('token');
    return Scaffold(
        backgroundColor: kLightWhite,
        body: ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(25)),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 230.h,
                        child: PageView.builder(
                            itemCount: widget.food.imageUrl.length,
                            controller: _pageController,
                            onPageChanged: (i) {
                              foodController.currentPage(i);
                            },
                            itemBuilder: (context, i) {
                              return Container(
                                height: 230.h,
                                width: width,
                                color: kLightWhite,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.food.imageUrl[i],
                                ),
                              );
                            }),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.food.imageUrl.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    margin: EdgeInsets.all(4.h),
                                    width: foodController.currentPage == index
                                        ? 10
                                        : 8,
                                    // ignore: unrelated_type_equality_checks
                                    height: foodController.currentPage == index
                                        ? 10
                                        : 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: foodController.currentPage == index
                                          ? kSecondary
                                          : kGrayLight,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40.h,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Ionicons.chevron_back_circle,
                          color: kPrimary,
                          size: 28,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Entypo.share,
                          color: kPrimary,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 15,
                    child: CustomButton(
                        btnWidth: width / 2.2,
                        radius: 10,
                        color: kPrimary,
                        onTap: () {
                          Get.to(
                              () => RestaurantPage(restaurant: restaurantData),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1));
                        },
                        text: "Restaurante Abierto"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                          text: widget.food.title,
                          style: appStyle(18, kDark, FontWeight.w600)),
                      Obx(
                        () => ReusableText(
                            text:
                                "\$ ${((widget.food.price + foodController.additiveTotal) * counterController.count.toDouble()).toStringAsFixed(0)}",
                            style: appStyle(18, kPrimary, FontWeight.w600)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    widget.food.description,
                    maxLines: 8,
                    style: appStyle(13, kGray, FontWeight.w400),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  SizedBox(
                    height: 16.h,
                    child: ListView.builder(
                        itemCount: widget.food.foodTags.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          final tag = widget.food.foodTags[i];
                          return Container(
                            margin: EdgeInsets.only(right: 5.h),
                            decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r))),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ReusableText(
                                    text: tag,
                                    style: appStyle(
                                        10, kLightWhite, FontWeight.w500)),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ReusableText(
                      text: "Aditivos y aderezos",
                      style: appStyle(18, kDark, FontWeight.w600)),
                  Column(
                    children:
                        List.generate(foodController.additivesList.length, (i) {
                      final additive = foodController.additivesList[i];
                      return Obx(() => CheckboxListTile(
                            title: RowText(
                                first: additive.title,
                                second: "\$ ${additive.price}"),
                            contentPadding: EdgeInsets.zero,
                            value: additive.isChecked.value,
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            onChanged: (bool? newValue) {
                              additive.toggleChecked();
                              foodController.getTotalPrice();
                              foodController.getList();
                            },
                            activeColor: kPrimary,
                            checkColor: Colors.white,
                            controlAffinity: ListTileControlAffinity.leading,
                            tristate: false,
                          ));
                    }),
                  ),
                  ReusableText(
                      text: "Preferencias",
                      style: appStyle(18, kDark, FontWeight.w600)),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    height: 64.h,
                    child: CustomTextField(
                        controller: _preferences,
                        hintText: "Ejemplo Salsas o formas de preparacion",
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a note";
                          }
                          return null;
                        }),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                          text: "Cantidad",
                          style: appStyle(18, kDark, FontWeight.w600)),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: counterController.increment,
                              child: const Icon(
                                AntDesign.plussquareo,
                                color: kPrimary,
                              )),
                          SizedBox(
                            width: 6.w,
                          ),
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: ReusableText(
                                  text: "${counterController.count}",
                                  style: appStyle(16, kDark, FontWeight.w500)),
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          GestureDetector(
                              onTap: counterController.decrement,
                              child: const Icon(
                                AntDesign.minussquareo,
                                color: kPrimary,
                              ))
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40.h,
                width: width,
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (token == null) {
                          Get.to(() => const Login(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1));
                        } else {
                          double totalPrice = (widget.food.price +
                                  foodController.additiveTotal) *
                              counterController.count.toDouble();
                          ToCart item = ToCart(
                              productId: widget.food.id,
                              instructions: _preferences.text,
                              additives: foodController.getList(),
                              quantity: counterController.count.toInt(),
                              totalPrice: totalPrice);

                          String cart = toCartToJson(item);

                          cartController.addToCart(cart);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: kSecondary,
                        radius: 20.r,
                        child: const Icon(
                          Entypo.plus,
                          color: kLightWhite,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (token == null) {
                          Get.to(() => const Login(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1));
                        } else {
                          // var user = controller.getUserData();
                          if (phone_verification == false ||
                              phone_verification == null) {
                            _showVerificationSheet(context);
                          } else if (address == false) {
                            showAddressSheet(context);
                          } else {
                            OrderItem orderItem = OrderItem(
                                foodId: widget.food.id,
                                additives: foodController.getList(),
                                quantity: counterController.count.toString(),
                                price: ((widget.food.price +
                                            foodController.additiveTotal) *
                                        counterController.count.toDouble())
                                    .toStringAsFixed(2),
                                instructions: _preferences.text);

                            Get.to(
                                () => OrderPage(
                                      food: widget.food,
                                      restaurant: restaurantData,
                                      item: orderItem,
                                    ),
                                transition: Transition.fade,
                                duration: const Duration(seconds: 1));
                          }
                        }
                      },
                      child: ReusableText(
                          text: "Ordenar",
                          style: appStyle(18, kLightWhite, FontWeight.w600)),
                    ),
                    CircleAvatar(
                      backgroundColor: kSecondary,
                      radius: 20.r,
                      child: Badge(
                        label: ReusableText(
                            text: box.read('cart') ?? "0",
                            style: appStyle(9, kLightWhite, FontWeight.normal)),
                        child: const Icon(
                          Ionicons.fast_food_outline,
                          color: kLightWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<dynamic> _showVerificationSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        showDragHandle: true,
        barrierColor: kPrimary.withOpacity(0.2),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 500.h,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/restaurant_bk.png",
                    ),
                    fit: BoxFit.fill),
                color: kOffWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Padding(
              padding: EdgeInsets.all(8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  ReusableText(
                      text: "Verifica tu Numero Celular",
                      style: appStyle(19, kPrimary, FontWeight.bold)),
                  SizedBox(
                      height: 255.h,
                      child: ListView.builder(
                          itemCount: verificationReasons.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                verificationReasons[index],
                                textAlign: TextAlign.justify,
                                style:
                                    appStyle(11, kGrayLight, FontWeight.w700),
                              ),
                              leading: const Icon(
                                Icons.check_circle_outline,
                                color: kPrimary,
                              ),
                            );
                          })),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                      onTap: () {
                        Get.to(() => const PhoneVerificationPage());
                      },
                      btnHieght: 40.h,
                      text: "Verifica tu Numero"),
                ],
              ),
            ),
          );
        });
  }
}
