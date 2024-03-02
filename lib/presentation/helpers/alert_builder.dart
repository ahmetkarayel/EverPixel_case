import 'package:flutter/material.dart';

class AlertBuilder{

static Future<void> basicShowProgressDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcı arkaplandaki alana dokunarak iletişim kutusunu kapatabilir mi?
      builder: (BuildContext context) {
        return const AlertDialog.adaptive(
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
                SizedBox(height: 16,),
                Text("Resim işleniyor...")
              ],
            )
          ),
        );
      },
    );
  }

}