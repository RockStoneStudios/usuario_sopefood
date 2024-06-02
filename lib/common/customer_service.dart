import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopefoodusuario/common/app_style.dart';
import 'package:sopefoodusuario/constants/constants.dart';

Future<dynamic> customerService(BuildContext context, String service) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
      title: Center(
        child: Text(
          '🍽 SopeFoods Centro Servicio 🍽',
          style: appStyle(14, kPrimary, FontWeight.bold),
        ),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      content: SizedBox(
        width: width,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Esperamos que estés disfrutando de un viaje delicioso y fluido con SopeFoods, ¡tu aplicación de referencia para todo lo sabroso y conveniente! Ya sea que se trate de una cena digna de un antojo, un desayuno acogedor o ese refrigerio del mediodía, estamos aquí para llevárselo directamente a la puerta de su casa.',
              textAlign: TextAlign.justify,
              style: appStyle(11, kDark, FontWeight.normal),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Tengo preguntas o necesito ayuda?",
              textAlign: TextAlign.justify,
              style: appStyle(14, kDark, FontWeight.w600),
            ),
            SizedBox(
              height: 10.h,
            ),
            GestureDetector(
              onTap: () {
                FlutterPhoneDirectCaller.callNumber(service);
              },
              child: Text(
                "📞 $service",
                textAlign: TextAlign.justify,
                style: appStyle(14, Colors.blue.shade600, FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
