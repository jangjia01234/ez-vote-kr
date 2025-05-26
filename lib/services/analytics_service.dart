import 'package:flutter/foundation.dart';
import 'dart:js' as js;
import 'dart:js_util' as js_util;

class AnalyticsService {
  static void trackPageView(String pageName) {
    if (kIsWeb) {
      try {
        // Firebase Analytics 페이지 뷰 추적
        _logFirebaseEvent('page_view', {
          'page_title': pageName,
          'page_location': js.context['location']['href'],
        });
        
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
        // Firebase Analytics 이벤트 추적
        _logFirebaseEvent(eventName, {
          'event_category': 'engagement',
          if (properties != null) ...properties,
        });
        
        // Vercel Analytics 이벤트 추적
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
  
  // Firebase Analytics 전용 이벤트
  static void trackCustomEvent(String eventName, {
    String? category,
    String? label,
    int? value,
    Map<String, dynamic>? customParameters,
  }) {
    if (kIsWeb) {
      try {
        final eventData = <String, dynamic>{
          if (category != null) 'event_category': category,
          if (label != null) 'event_label': label,
          if (value != null) 'value': value,
          if (customParameters != null) ...customParameters,
        };
        
        _logFirebaseEvent(eventName, eventData);
        print('Firebase Custom Event: $eventName');
      } catch (e) {
        print('Firebase Custom Event 오류: $e');
      }
    }
  }
  
  // 사용자 속성 설정
  static void setUserProperty(String propertyName, String value) {
    if (kIsWeb) {
      try {
        _setFirebaseUserProperty(propertyName, value);
        print('Firebase User Property: $propertyName = $value');
      } catch (e) {
        print('Firebase User Property 오류: $e');
      }
    }
  }
  
  // Firebase Analytics 이벤트 로깅 (내부 메서드)
  static void _logFirebaseEvent(String eventName, Map<String, dynamic> parameters) {
    try {
      final analytics = js.context['firebaseAnalytics'];
      if (analytics != null) {
        // Firebase Analytics logEvent 호출
        js.context.callMethod('eval', ['''
          import('https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js')
            .then(module => {
              module.logEvent(window.firebaseAnalytics, "$eventName", ${js.context['JSON'].callMethod('stringify', [js.JsObject.jsify(parameters)])});
            });
        ''']);
      }
    } catch (e) {
      print('Firebase 이벤트 로깅 오류: $e');
    }
  }
  
  // Firebase Analytics 사용자 속성 설정 (내부 메서드)
  static void _setFirebaseUserProperty(String propertyName, String value) {
    try {
      final analytics = js.context['firebaseAnalytics'];
      if (analytics != null) {
        js.context.callMethod('eval', ['''
          import('https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js')
            .then(module => {
              module.setUserProperties(window.firebaseAnalytics, {"$propertyName": "$value"});
            });
        ''']);
      }
    } catch (e) {
      print('Firebase 사용자 속성 설정 오류: $e');
    }
  }
} 