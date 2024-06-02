import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sopefoodusuario/common/app_style.dart';
import 'package:sopefoodusuario/common/reusable_text.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/models/all_addresses.dart';
import 'package:sopefoodusuario/views/profile/default_address_page.dart';
import 'package:get/get.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
    required this.address,
  });

  final AddressesList address;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => SetDefaultAddressPage(
              address: address,
            ));
      },
      visualDensity: VisualDensity.compact,
      leading: Padding(
        padding: EdgeInsets.only(top: 0.0.r),
        child: Icon(
          SimpleLineIcons.location_pin,
          color: kPrimary,
          size: 28.h,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: ReusableText(
        text: address.addressLine1,
        style: appStyle(12, kGray, FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: address.postalCode,
            style: appStyle(11, kGray, FontWeight.normal),
          ),
          ReusableText(
            text: "Toque el mosaico para configurar",
            style: appStyle(9, kGrayLight, FontWeight.w600),
          ),
        ],
      ),
      trailing: Switch.adaptive(
          value: address.addressesListDefault,
          onChanged: (bool value) {
            // controller.setDfSwitch = value;
          }),
    );
  }
}
