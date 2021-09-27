import 'package:frederic/admin_panel/backend/admin_icon_manager.dart';
import 'package:frederic/main.dart';

class AdminBackend {
  AdminBackend() : iconManager = AdminIconManager();

  static AdminBackend get instance => getIt<AdminBackend>();

  final AdminIconManager iconManager;
}
