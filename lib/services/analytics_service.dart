import 'package:flutter/foundation.dart';
import 'dart:js' as js;

class AnalyticsService {
  static void trackPageView(String pageName) {
    if (kIsWeb) {
      try {
        // Vercel Analytics 페이지 뷰 추적
        js.context.callMethod('va', ['track', 'pageview', js.JsObject.jsify({
          'page': pageName,
        })]);
        print('Analytics: 페이지 뷰 추적 - $pageName');
      } catch (e) {
        print('Analytics 오류: $e');
      }
    }
  }

  static void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    if (kIsWeb) {
      try {
        final eventData = <String, dynamic>{
          'name': eventName,
          if (properties != null) ...properties,
        };
        
        js.context.callMethod('va', ['track', eventData]);
        print('Analytics: 이벤트 추적 - $eventName');
      } catch (e) {
        print('Analytics 오류: $e');
      }
    }
  }
} 