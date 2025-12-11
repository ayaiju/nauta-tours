import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({Key? key}) : super(key: key);

  @override
  _ClimaScreenState createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  Map<String, dynamic>? climaData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    obtenerClima();
  }

  Future<void> obtenerClima() async {
    try {
      const apiKey = 'c7d9be9a4a30832b191bfc7afa9bf7ba';
      const ciudad = 'Nauta,PE';
      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=$ciudad&units=metric&lang=es&appid=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          climaData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double w = constraints.maxWidth;

      // Limitar tamaños máximos
      double maxWidth = math.min(w * 0.95, 400);
      double fontTitle = math.min(w * 0.08, 28);
      double fontTemp = math.min(w * 0.12, 38);
      double fontDesc = math.min(w * 0.05, 18);
      double iconSize = math.min(w * 0.25, 100);
      double padding = math.min(w * 0.04, 20);
      double infoFont = math.min(w * 0.045, 16);

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (hasError || climaData == null) {
        return Center(
          child: Text(
            'No se pudo obtener el clima 😕',
            style: TextStyle(fontSize: fontDesc),
          ),
        );
      }

      final temp = climaData!['main']['temp'];
      final desc = climaData!['weather'][0]['description'];
      final icon = climaData!['weather'][0]['icon'];
      final ciudad = climaData!['name'];
      final sensacion = climaData!['main']['feels_like'];
      final humedad = climaData!['main']['humidity'];
      final viento = climaData!['wind']['speed'];

      return Center(
        child: Container(
          width: maxWidth,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ciudad,
                style: TextStyle(
                  fontSize: fontTitle,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: padding * 0.5),
              Image.network(
                'https://openweathermap.org/img/wn/$icon@2x.png',
                width: iconSize,
                height: iconSize,
              ),
              Text(
                '${temp.toStringAsFixed(1)}°C',
                style: TextStyle(
                  fontSize: fontTemp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                desc.toString().toUpperCase(),
                style: TextStyle(fontSize: fontDesc, color: Colors.black87),
              ),
              SizedBox(height: padding * 0.75),
              _buildInfoRow(Icons.thermostat, 'Sensación térmica',
                  '$sensacion°C', infoFont),
              _buildInfoRow(Icons.water_drop, 'Humedad', '$humedad%', infoFont),
              _buildInfoRow(Icons.air, 'Viento', '${viento} m/s', infoFont),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String label, String value, double font) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: font * 0.25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: font + 2),
              SizedBox(width: font * 0.5),
              Text(label,
                  style: TextStyle(fontSize: font, color: Colors.black87)),
            ],
          ),
          Text(value,
              style: TextStyle(
                  fontSize: font,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
