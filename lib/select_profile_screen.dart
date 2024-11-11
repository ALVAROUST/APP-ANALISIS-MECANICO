import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectProfileScreen extends StatefulWidget {
  @override
  _SelectProfileScreenState createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<SelectProfileScreen> {
  List<String> perfiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  // Cargar todos los perfiles guardados
  Future<void> _loadProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      perfiles = prefs.getStringList('perfiles') ?? [];
    });
  }

  // Seleccionar un perfil
  Future<void> _selectProfile(String nombre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', nombre);
    Navigator.pop(context, nombre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Perfil'),
      ),
      body: ListView.builder(
        itemCount: perfiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(perfiles[index]),
            onTap: () {
              _selectProfile(perfiles[index]);
            },
          );
        },
      ),
    );
  }
}
