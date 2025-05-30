import 'package:flutter/material.dart';
import 'package:usuario_inri/service/storage_service.dart';
import 'package:usuario_inri/utils/viaje_util.dart';
import 'package:usuario_inri/pages/login_page.dart';

class ProfileMenuModal {
  static void show(BuildContext context) {
    final storage = StorageService.instance;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (modalContext) {
        return Container(
          //padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mi cuenta',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 12),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.black),
                ),
                title: const Text('Perfil'),
                onTap: () {
                  Navigator.pop(context);
                  // navegación a perfil
                },
              ),
              const Divider(height: 20, thickness: 0.6),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.shade50,
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                title: const Text('Cerrar sesión'),
                onTap: () async {
                  Navigator.of(modalContext).pop(); // cerrar el modal primero

                  await storage.deleteIdOrder();

                  if (!modalContext.mounted) return;
                  await ViajeUtils.finalizarViajeYLimpiarTodo(context);

                  Future.microtask(() {
                    if (!modalContext.mounted) return;
                    Navigator.of(modalContext).pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginPage(),
                        transitionDuration: const Duration(milliseconds: 400),
                        transitionsBuilder: (_, animation, __, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
                      (_) => false,
                    );
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
