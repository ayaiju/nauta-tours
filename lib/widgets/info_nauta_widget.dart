import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoNautaWidget extends StatefulWidget {
  const InfoNautaWidget({super.key});

  @override
  State<InfoNautaWidget> createState() => _InfoNautaWidgetState();
}

class _InfoNautaWidgetState extends State<InfoNautaWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _sectionTitle(String text, IconData icon, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.green[800], size: fontSize),
        SizedBox(width: fontSize * 0.3),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.cambo(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionText(String text, double fontSize) {
    return Text(
      text,
      style: GoogleFonts.lora(
        fontSize: fontSize,
        color: Colors.black87,
        height: 1.6,
      ),
      textAlign: TextAlign.justify,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double w = constraints.maxWidth;

      // Ajusta tamaños según ancho
      double titleFont = w > 400 ? 22 : w * 0.055; // Títulos escalables
      double textFont = w > 400 ? 16 : w * 0.04;   // Texto escalable
      double spacing = w * 0.03;

      return FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFDCF8C6),
                Color(0xFFB2DFDB),
                Color(0xFFA5D6A7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: EdgeInsets.all(w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("📜 Fundación e Historia de Nauta", Icons.history, titleFont),
              SizedBox(height: spacing),
              _sectionText(
                "La ciudad de Nauta, conocida como la ‘Puerta del Amazonas’, fue fundada oficialmente en el año 1830 por el patriota Manuel Pacaya y Samiria, un líder indígena de la etnia Kukama-Kukamiria. "
                "Su creación simbolizó la unión entre las culturas originarias y la sociedad mestiza del Perú. "
                "Nauta fue la primera ciudad fundada por peruanos en la Amazonía baja y jugó un papel clave durante los primeros años de la independencia peruana. "
                "Hoy, se considera el punto de encuentro entre los ríos Marañón y Ucayali, donde nace el majestuoso Río Amazonas. "
                "Además, su entorno está rodeado por la Reserva Nacional Pacaya Samiria, una de las áreas naturales más ricas en biodiversidad del planeta.",
                textFont,
              ),
              SizedBox(height: spacing * 3),

              _sectionTitle("🗺️ Cómo llegar a Nauta", Icons.directions_boat, titleFont),
              SizedBox(height: spacing),
              _sectionText(
                "Para llegar a Nauta desde la capital Lima existen tres rutas principales:\n\n"
                "✈️ Vía aérea: Lima → Iquitos (1h45m). Desde Iquitos se continúa por carretera hasta Nauta (1h40m aprox).\n\n"
                "🚗 Vía terrestre y fluvial (Pucallpa): Lima → Pucallpa por carretera (18h aprox). Luego viaje fluvial por el río Ucayali.\n\n"
                "🚘 Vía terrestre y fluvial (Yurimaguas): Lima → Tarapoto → Yurimaguas por carretera. Desde allí se toma un barco hasta Nauta.",
                textFont,
              ),
              SizedBox(height: spacing * 3),

              _sectionTitle("🏞️ Distritos de la Provincia de Nauta", Icons.location_city, titleFont),
              SizedBox(height: spacing),
              _sectionText(
                "La provincia de Nauta forma parte del departamento de Loreto y está conformada por 5 distritos, cada uno con su propia capital:\n\n"
                "• Nauta – Capital: Nauta\n"
                "• Parinari – Capital: Parinari\n"
                "• Tigre – Capital: Intuto\n"
                "• Trompeteros – Capital: Villa Trompeteros\n"
                "• Urarinas – Capital: Concordia\n"
                "Cada distrito destaca por su riqueza cultural, su relación con los ríos amazónicos y sus tradiciones vivas, muchas ligadas a la cultura Kukama y al turismo ecológico.",
                textFont,
              ),
              SizedBox(height: spacing * 3),

              _sectionTitle("🌿 Cultura y Tradición", Icons.forest, titleFont),
              SizedBox(height: spacing),
              _sectionText(
                "Nauta es un lugar donde la naturaleza y la espiritualidad se entrelazan. "
                "Sus festividades religiosas, como la Fiesta de San Juan y la Semana Turística de Nauta, reflejan la alegría del pueblo loretano. "
                "El arte kukama, los tejidos con fibras naturales, la gastronomía a base de pescado de río y la música tradicional hacen de esta ciudad un punto clave del turismo amazónico en el Perú.",
                textFont,
              ),
            ],
          ),
        ),
      );
    });
  }
}
