import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mi_primera_app/profile_screen.dart';
import 'package:mi_primera_app/select_profile_screen.dart';
import 'package:mi_primera_app/record_video_screen.dart'; // Pantalla para grabar video
import 'package:mi_primera_app/upload_video_screen.dart'; // Pantalla para subir video

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Análisis de Sentadillas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _nombreUsuario = '';

  @override
  void initState() {
    super.initState();
    _loadNombreUsuario();
  }

  // Cargar el nombre del usuario desde SharedPreferences
  Future<void> _loadNombreUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombre') ?? 'Usuario';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido${_nombreUsuario.isNotEmpty ? ', $_nombreUsuario' : ''}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordVideoScreen()),
                );
              },
              child: Text('Grabar Sentadilla'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadVideoScreen()),
                );
              },
              child: Text('Subir Video'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
                _loadNombreUsuario(); // Recargar el nombre después de volver
              },
              child: Text('Perfil'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nombreSeleccionado = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectProfileScreen()),
                );
                if (nombreSeleccionado != null) {
                  setState(() {
                    _nombreUsuario = nombreSeleccionado;
                  });
                }
              },
              child: Text('Cambiar de Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
