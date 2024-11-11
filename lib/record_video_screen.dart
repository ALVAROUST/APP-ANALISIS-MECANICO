import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class RecordVideoScreen extends StatefulWidget {
  @override
  _RecordVideoScreenState createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> {
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
      // Aquí podrías añadir lógica adicional para manejar el archivo de video
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Grabación guardada en: ${_videoFile?.path}")));
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
        title: Text('Grabar Video'),
      ),
      body: Column(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startRecording,
                child: Text('Iniciar Grabación'),
              ),
              ElevatedButton(
                onPressed: _stopRecording,
                child: Text('Detener Grabación'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
