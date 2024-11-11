import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class UploadVideoScreen extends StatefulWidget {
  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  XFile? _videoFile;
  VideoPlayerController? _videoController;

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = pickedFile;
        _videoController = VideoPlayerController.file(File(_videoFile!.path))
          ..initialize().then((_) {
            setState(() {}); // Actualiza el estado una vez que el video esté inicializado
          });
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Seleccionar Video'),
            ),
            if (_videoFile != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Video seleccionado: ${_videoFile!.path}'),
              ),
              if (_videoController != null && _videoController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              ElevatedButton(
                onPressed: () {
                  if (_videoController != null) {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  }
                },
                child: Text(_videoController != null && _videoController!.value.isPlaying
                    ? 'Pausar'
                    : 'Reproducir'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
