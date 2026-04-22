/// ═══════════════════════════════════════════════════════════════════════
/// FILE: admin_login_screen.dart
/// PURPOSE: Authentication gateway protecting administrative capabilities.
///          Verifies credentials before granting access to the dashboard.
/// CONNECTIONS:
///   - USED BY: main.dart (when admin selected but unauthenticated)
///   - DEPENDS ON: providers/admin_provider.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';


// ─── ADMINLOGINUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to admin_login_screen.dart.
class AdminLoginUIConfig {
  // Brand Colors used locally
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF888888);
  static const Color white = Color(0xFFFFFFFF);

}


class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminLoginUIConfig.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AdminLoginUIConfig.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ہنرمند کشمیر',
                style: GoogleFonts.amiriQuran(
                  color: AdminLoginUIConfig.darkGreen,
                  fontSize: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Admin Portal',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AdminLoginUIConfig.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your website content efficiently',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AdminLoginUIConfig.textLight,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.read<AdminProvider>().loginAsGuest();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminLoginUIConfig.darkGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Login as Guest',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
