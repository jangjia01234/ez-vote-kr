import 'dart:html' as html;
import 'dart:async';

class BGMService {
  static final BGMService _instance = BGMService._internal();
  factory BGMService() => _instance;
  BGMService._internal();

  html.AudioElement? _audioElement;
  bool _isPlaying = false;
  bool _isMuted = true; // 초기에는 음소거 상태

  // 상태 변경을 알리는 스트림
  static final StreamController<bool> _isPlayingController = StreamController<bool>.broadcast();
  static Stream<bool> get isPlayingStream => _isPlayingController.stream;

  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;

  Future<void> initialize() async {
    try {
      _audioElement = html.AudioElement('assets/bgm/8bit_healing_loop_softer.mp3');
      _audioElement!.loop = true;
      _audioElement!.volume = 0.3; // 볼륨을 30%로 설정
      _audioElement!.preload = 'auto';
      
      // 오디오 로드 완료 이벤트 리스너
      _audioElement!.onLoadedData.listen((_) {
        print('BGM 로드 완료');
      });
      
      // 오디오 재생 시작 이벤트 리스너
      _audioElement!.onPlay.listen((_) {
        print('오디오 재생 이벤트 감지');
      });
      
      // 오디오 일시정지 이벤트 리스너
      _audioElement!.onPause.listen((_) {
        print('오디오 일시정지 이벤트 감지');
      });
      
      // 오디오 에러 이벤트 리스너
      _audioElement!.onError.listen((error) {
        print('BGM 에러: $error');
      });
      
    } catch (e) {
      print('BGM 초기화 실패: $e');
    }
  }

  Future<void> playBgm() async {
    if (_audioElement != null && !_isPlaying) {
      try {
        print('BGM 재생 시도 중...');
        await _audioElement!.play();
        _isPlaying = true;
        _isMuted = false;
        _isPlayingController.add(true);
        print('BGM 재생 성공 - 상태: muted=$_isMuted, playing=$_isPlaying');
      } catch (e) {
        print('BGM 재생 실패: $e');
      }
    } else {
      print('BGM 재생 건너뜀 - audioElement: ${_audioElement != null}, isPlaying: $_isPlaying');
    }
  }

  Future<void> pauseBgm() async {
    if (_audioElement != null && _isPlaying) {
      print('BGM 일시정지 시도 중...');
      _audioElement!.pause();
      _isPlaying = false;
      _isMuted = true;
      _isPlayingController.add(false);
      print('BGM 일시정지 성공 - 상태: muted=$_isMuted, playing=$_isPlaying');
    } else {
      print('BGM 일시정지 건너뜀 - audioElement: ${_audioElement != null}, isPlaying: $_isPlaying');
    }
  }

  static Future<void> toggleBGM() async {
    final instance = BGMService();
    await instance.toggleBgm();
  }

  Future<void> toggleBgm() async {
    print('BGM 토글 시작 - 현재 상태: muted=$_isMuted, playing=$_isPlaying');
    
    if (_isMuted || !_isPlaying) {
      // 음소거 상태이거나 재생 중이 아니면 재생
      print('재생 모드로 전환');
      await playBgm();
    } else {
      // 재생 중이면 일시정지
      print('일시정지 모드로 전환');
      await pauseBgm();
    }
    
    print('BGM 토글 완료 - 최종 상태: muted=$_isMuted, playing=$_isPlaying');
  }

  Future<void> stopBgm() async {
    if (_audioElement != null) {
      _audioElement!.pause();
      _audioElement!.currentTime = 0;
      _isPlaying = false;
    }
  }

  void dispose() {
    if (_audioElement != null) {
      _audioElement!.pause();
      _audioElement = null;
    }
    _isPlayingController.close();
  }
} 