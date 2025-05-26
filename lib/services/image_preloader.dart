import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePreloader {
  static final Map<String, bool> _loadedImages = {};
  static bool _isPreloading = false;
  
  // 모든 게임 이미지 경로 리스트
  static const List<String> _allImagePaths = [
    // 배경 이미지들
    'assets/images/intro_background.png',
    'assets/images/livingroom_background.png',
    'assets/images/angelcat_background.png',
    'assets/images/angelcat_ending_background.png',
    
    // 후보 1 (이재명)
    'assets/images/candidate_1/room_background_1_empty.png',
    'assets/images/candidate_1/avatar_1.png',
    'assets/images/candidate_1/room_flowerPot.png',
    'assets/images/candidate_1/room_computer.png',
    'assets/images/candidate_1/room_apartment.png',
    'assets/images/candidate_1/room_suitcase.png',
    
    // 후보 2 (김문수)
    'assets/images/candidate_2/room_background_2_empty.png',
    'assets/images/candidate_2/avatar_2.png',
    'assets/images/candidate_2/room_train.png',
    'assets/images/candidate_2/room_moneybox.png',
    'assets/images/candidate_2/room_militarycap.png',
    'assets/images/candidate_2/room_lawbook.png',
    
    // 후보 4 (이준석)
    'assets/images/candidate_4/room_background_4_empty.png',
    'assets/images/candidate_4/avatar_4.png',
    'assets/images/candidate_4/room_table.png',
    'assets/images/candidate_4/room_plask.png',
    'assets/images/candidate_4/room_document.png',
    'assets/images/candidate_4/room_book.png',
    
    // 후보 5 (권영국)
    'assets/images/candidate_5/room_background_5_empty.png',
    'assets/images/candidate_5/avatar_5.png',
    'assets/images/candidate_5/room_scale.png',
    'assets/images/candidate_5/room_plant.png',
    'assets/images/candidate_5/room_helmet.png',
    'assets/images/candidate_5/room_blanket.png',
  ];
  
  // 특정 후보 방 이미지들만 프리로드
  static List<String> getCandidateImages(String candidateId) {
    return _allImagePaths.where((path) => path.contains(candidateId)).toList();
  }
  
  // 모든 이미지 프리로드 (게임 시작 시)
  static Future<void> preloadAllImages(BuildContext context) async {
    if (_isPreloading) return;
    _isPreloading = true;
    
    try {
      final futures = _allImagePaths.map((path) => _preloadSingleImage(context, path));
      await Future.wait(futures);
      print('모든 이미지 프리로드 완료: ${_allImagePaths.length}개');
    } catch (e) {
      print('이미지 프리로드 오류: $e');
    } finally {
      _isPreloading = false;
    }
  }
  
  // 특정 후보 이미지들만 프리로드 (후보 방 진입 전)
  static Future<void> preloadCandidateImages(BuildContext context, String candidateId) async {
    final candidateImages = getCandidateImages(candidateId);
    
    try {
      final futures = candidateImages.map((path) => _preloadSingleImage(context, path));
      await Future.wait(futures);
      print('후보 $candidateId 이미지 프리로드 완료: ${candidateImages.length}개');
    } catch (e) {
      print('후보 이미지 프리로드 오류: $e');
    }
  }
  
  // 단일 이미지 프리로드
  static Future<void> _preloadSingleImage(BuildContext context, String path) async {
    if (_loadedImages[path] == true) return;
    
    try {
      await precacheImage(AssetImage(path), context);
      _loadedImages[path] = true;
    } catch (e) {
      print('이미지 로드 실패: $path - $e');
      _loadedImages[path] = false;
    }
  }
  
  // 이미지가 로드되었는지 확인
  static bool isImageLoaded(String path) {
    return _loadedImages[path] == true;
  }
  
  // 로딩 진행률 확인
  static double getLoadingProgress() {
    final totalImages = _allImagePaths.length;
    final loadedCount = _loadedImages.values.where((loaded) => loaded == true).length;
    return totalImages > 0 ? loadedCount / totalImages : 0.0;
  }
  
  // 캐시 초기화
  static void clearCache() {
    _loadedImages.clear();
    _isPreloading = false;
  }
} 