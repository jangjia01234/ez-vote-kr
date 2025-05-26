import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ImageHelper {
  static Widget buildAssetImage(
    String assetPath, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Widget? errorWidget,
  }) {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        print('이미지 로드 실패: $assetPath - $error');
        
        if (errorWidget != null) {
          return errorWidget;
        }
        
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  '이미지 로드 실패',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> preloadImage(String assetPath, BuildContext context) async {
    try {
      await precacheImage(AssetImage(assetPath), context);
      print('이미지 미리 로드 성공: $assetPath');
    } catch (e) {
      print('이미지 미리 로드 실패: $assetPath - $e');
    }
  }
} 