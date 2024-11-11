import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nombre = '';
  String _sexo = '';
  int _edad = 0;
  double _longitudMuslo = 0.0;
  double _longitudPierna = 0.0;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController musloController = TextEditingController();
  final TextEditingController piernaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Cargar datos del perfil desde SharedPreferences
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombre = prefs.getString('nombre') ?? '';
      _sexo = prefs.getString('sexo') ?? '';
      _edad = prefs.getInt('edad') ?? 0;
      _longitudMuslo = prefs.getDouble('longitudMuslo') ?? 0.0;
      _longitudPierna = prefs.getDouble('longitudPierna') ?? 0.0;

      // Configurar los controladores de texto con los valores cargados
      nombreController.text = _nombre;
      edadController.text = _edad > 0 ? _edad.toString() : '';
      musloController.text = _longitudMuslo > 0 ? _longitudMuslo.toString() : '';
      piernaController.text = _longitudPierna > 0 ? _longitudPierna.toString() : '';
    });
  }

  // Guardar datos del perfil en SharedPreferences
  Future<void> _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', nombreController.text);
    await prefs.setString('sexo', _sexo);
    await prefs.setInt('edad', int.tryParse(edadController.text) ?? 0);
    await prefs.setDouble('longitudMuslo', double.tryParse(musloController.text) ?? 0.0);
    await prefs.setDouble('longitudPierna', double.tryParse(piernaController.text) ?? 0.0);

    // Agregar el nombre a la lista de perfiles si no está ya en la lista
    List<String> perfiles = prefs.getStringList('perfiles') ?? [];
    if (!perfiles.contains(nombreController.text)) {
      perfiles.add(nombreController.text);
      await prefs.setStringList('perfiles', perfiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: edadController,
              decoration: InputDecoration(
                labelText: 'Edad',
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Sexo'),
              items: ['Masculino', 'Femenino'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _sexo = newValue!;
                });
              },
              value: _sexo.isNotEmpty ? _sexo : null,
            ),
            TextField(
              controller: musloController,
              decoration: InputDecoration(
                labelText: 'Longitud del muslo (cm)',
                hintText: 'Desde el trocánter mayor hasta el epicóndilo lateral de la rodilla',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: piernaController,
              decoration: InputDecoration(
                labelText: 'Longitud de la pierna (cm)',
                hintText: 'Desde el epicóndilo lateral de la rodilla hasta el suelo',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveProfileData();

                // Muestra un mensaje de confirmación
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('¡Perfil creado exitosamente!')),
                );

                // Espera un momento y regresa a la pantalla anterior
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
