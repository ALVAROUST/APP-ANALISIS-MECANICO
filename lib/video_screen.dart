import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _videoFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras!.first,
      ResolutionPreset.high,
      enableAudio: true,
    );
    await _cameraController?.initialize();
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      await _cameraController?.startVideoRecording();
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController != null && _cameraController!.value.isRecordingVideo) {
      final videoFile = await _cameraController?.stopVideoRecording();
      setState(() {
        _videoFile = videoFile;
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grabar o Subir Video'),
      ),
      body: Column(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          if (_videoFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Video seleccionado: ${_videoFile!.path}'),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _startRecording();
                },
                child: Text('Grabar Video'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _stopRecording();
                },
                child: Text('Detener Grabación'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _pickVideo();
                },
                child: Text('Subir Video'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
