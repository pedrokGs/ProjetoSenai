import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudiobookPlayer extends StatefulWidget {
  const AudiobookPlayer({super.key});

  @override
  State<AudiobookPlayer> createState() => _AudiobookPlayerState();
}

class _AudiobookPlayerState extends State<AudiobookPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Primeiro inicialize o player
      await _audioPlayer.setSource(AssetSource('audiobooks/pequenoprincipe.mp3'));

      // Depois configure os listeners
      _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (mounted) {
          setState(() {
            _playerState = state;
            _isLoading = false;
          });
        }
      });

      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _playerState = PlayerState.stopped;
          });
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao inicializar player: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _playAudio() async {
    if (!_isInitialized) return;

    setState(() => _isLoading = true);
    try {
      await _audioPlayer.resume();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao reproduzir: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _pauseAudio() async {
    if (!_isInitialized) return;
    await _audioPlayer.pause();
  }

  Future<void> _stopAudio() async {
    if (!_isInitialized) return;
    await _audioPlayer.stop();
    setState(() {
      _playerState = PlayerState.stopped;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audiobook Player - O Pequeno Príncipe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isInitialized)
              const CircularProgressIndicator()
            else if (_isLoading)
              const CircularProgressIndicator()
            else ...[
                IconButton(
                  icon: Icon(
                    _playerState == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 100,
                  ),
                  onPressed: _playerState == PlayerState.playing
                      ? _pauseAudio
                      : _playAudio,
                ),
                const SizedBox(height: 20),
                Text(
                  _playerState == PlayerState.playing
                      ? 'Tocando'
                      : _playerState == PlayerState.paused
                      ? 'Pausado'
                      : 'Parado',
                  style: const TextStyle(fontSize: 20),
                ),
                if (_playerState != PlayerState.stopped)
                  TextButton(
                    onPressed: _stopAudio,
                    child: const Text('Parar'),
                  ),
              ],
          ],
        ),
      ),
    );
  }
}