import 'package:travell_app/theme/app_assets.dart';

class Destination {
  final String label;
  final String icon;

  const Destination({required this.label, required this.icon});
}

const List<Destination> destinations = [
  Destination(label: 'Inicio', icon: AppAssets.home),
  Destination(label: 'Perfil', icon: AppAssets.profile),
];