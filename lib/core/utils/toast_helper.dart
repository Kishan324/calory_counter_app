import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/locale_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_durations.dart';
import '../theme/app_radius.dart';
import '../theme/app_space.dart';

enum ToastType { success, error, info }

/// Premium Full-Width Glassmorphic Toast Notification utility with full RTL and Multi-Language support.
class ToastHelper {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'Success': 'Success',
      'Notice': 'Notice',
      'Information': 'Information',
      'Preferences': 'Preferences',
      'Theme': 'Theme',
      'Appearance': 'Appearance',
      'Required Field': 'Required Field',
      'Invalid Input': 'Invalid Input',
      'Scan Error': 'Scan Error',
      'Setup Complete': 'Setup Complete',
      'Language updated successfully': 'Language updated successfully',
      'Theme updated successfully': 'Theme updated successfully',
      'Profile updated successfully!': 'Profile updated successfully!',
      'Weight goal updated successfully!': 'Weight goal updated successfully!',
      'Daily calories updated successfully!': 'Daily calories updated successfully!',
      'Logged out successfully': 'Logged out successfully',
      'Welcome to FitCal!': 'Welcome to FitCal!',
      'Food added successfully': 'Food added successfully',
      'Failed to analyze food item': 'Failed to analyze food item',
      'Email and password cannot be empty': 'Email and password cannot be empty',
      'All fields are required': 'All fields are required',
      'Password must be at least 6 characters': 'Password must be at least 6 characters',
      'Passwords do not match': 'Passwords do not match',
      'Login successful!': 'Login successful!',
      'Signup successful!': 'Signup successful!',
      'Login failed': 'Login failed',
      'Signup failed': 'Signup failed',
      'Food Logged': 'Food Logged',
      'Food item added to history': 'Food item added to history',
    },
    'hi': {
      'Success': 'सफलता',
      'Notice': 'सूचना',
      'Information': 'जानकारी',
      'Preferences': 'प्राथमिकताएं',
      'Theme': 'थीम',
      'Appearance': 'दिखावट',
      'Required Field': 'आवश्यक फ़ील्ड',
      'Invalid Input': 'अमान्य इनपुट',
      'Scan Error': 'स्कैन त्रुटि',
      'Setup Complete': 'सेटअप पूरा हुआ',
      'Language updated successfully': 'भाषा सफलतापूर्वक अपडेट की गई',
      'Theme updated successfully': 'थीम सफलतापूर्वक अपडेट की गई',
      'Profile updated successfully!': 'प्रोफ़ाइल सफलतापूर्वक अपडेट की गई!',
      'Weight goal updated successfully!': 'वजन लक्ष्य सफलतापूर्वक अपडेट किया गया!',
      'Daily calories updated successfully!': 'दैनिक कैलोरी लक्ष्य सफलतापूर्वक अपडेट किया गया!',
      'Logged out successfully': 'सफलतापूर्वक लॉग आउट हो गया',
      'Welcome to FitCal!': 'फिटकैल में आपका स्वागत है!',
      'Food added successfully': 'भोजन सफलतापूर्वक जोड़ा गया',
      'Failed to analyze food item': 'खाद्य वस्तु का विश्लेषण करने में विफल',
      'Email and password cannot be empty': 'ईमेल और पासवर्ड खाली नहीं हो सकते',
      'All fields are required': 'सभी फ़ील्ड आवश्यक हैं',
      'Password must be at least 6 characters': 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए',
      'Passwords do not match': 'पासवर्ड मेल नहीं खाते',
      'Login successful!': 'लॉगिन सफल!',
      'Signup successful!': 'साइनअप सफल!',
      'Login failed': 'लॉगिन विफल',
      'Signup failed': 'साइनअप विफल',
      'Food Logged': 'भोजन दर्ज किया गया',
      'Food item added to history': 'भोजन इतिहास में जोड़ा गया',
    },
    'ar': {
      'Success': 'نجاح',
      'Notice': 'إشعار',
      'Information': 'معلومات',
      'Preferences': 'التفضيلات',
      'Theme': 'المظهر',
      'Appearance': 'المظهر',
      'Required Field': 'حقل مطلوب',
      'Invalid Input': 'إدخال غير صالح',
      'Scan Error': 'خطأ في المسح',
      'Setup Complete': 'اكتمل الإعداد',
      'Language updated successfully': 'تم تحديث اللغة بنجاح',
      'Theme updated successfully': 'تم تحديث المظهر بنجاح',
      'Profile updated successfully!': 'تم تحديث الملف الشخصي بنجاح!',
      'Weight goal updated successfully!': 'تم تحديث هدف الوزن بنجاح!',
      'Daily calories updated successfully!': 'تم تحديث السعرات الحرارية اليومية بنجاح!',
      'Logged out successfully': 'تم تسجيل الخروج بنجاح',
      'Welcome to FitCal!': 'مرحباً بك في FitCal!',
      'Food added successfully': 'تم إضافة الطعام بنجاح',
      'Failed to analyze food item': 'فشل في تحليل عنصر الطعام',
      'Email and password cannot be empty': 'لا يمكن أن يكون البريد الإلكتروني وكلمة المرور فارغين',
      'All fields are required': 'جميع الحقول مطلوبة',
      'Password must be at least 6 characters': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      'Passwords do not match': 'كلمات المرور غير متطابقة',
      'Login successful!': 'تم تسجيل الدخول بنجاح!',
      'Signup successful!': 'تم إنشاء الحساب بنجاح!',
      'Login failed': 'فشل تسجيل الدخول',
      'Signup failed': 'فشل إنشاء الحساب',
      'Food Logged': 'تم تسجيل الطعام',
      'Food item added to history': 'تم إضافة عنصر الطعام إلى السجل',
    },
    'de': {
      'Success': 'Erfolg',
      'Notice': 'Hinweis',
      'Information': 'Information',
      'Preferences': 'Einstellungen',
      'Theme': 'Design',
      'Appearance': 'Erscheinungsbild',
      'Required Field': 'Pflichtfeld',
      'Invalid Input': 'Ungültige Eingabe',
      'Scan Error': 'Scan-Fehler',
      'Setup Complete': 'Einrichtung abgeschlossen',
      'Language updated successfully': 'Sprache erfolgreich aktualisiert',
      'Theme updated successfully': 'Design erfolgreich aktualisiert',
      'Profile updated successfully!': 'Profil erfolgreich aktualisiert!',
      'Weight goal updated successfully!': 'Gewichtsziel erfolgreich aktualisiert!',
      'Daily calories updated successfully!': 'Tageskalorienziel erfolgreich aktualisiert!',
      'Logged out successfully': 'Erfolgreich abgemeldet',
      'Welcome to FitCal!': 'Willkommen bei FitCal!',
      'Food added successfully': 'Essen erfolgreich hinzugefügt',
      'Failed to analyze food item': 'Lebensmittelanalyse fehlgeschlagen',
      'Email and password cannot be empty': 'E-Mail und Passwort dürfen nicht leer sein',
      'All fields are required': 'Alle Felder sind erforderlich',
      'Password must be at least 6 characters': 'Passwort muss mindestens 6 Zeichen lang sein',
      'Passwords do not match': 'Passwörter stimmen nicht überein',
      'Login successful!': 'Anmeldung erfolgreich!',
      'Signup successful!': 'Registrierung erfolgreich!',
      'Login failed': 'Anmeldung fehlgeschlagen',
      'Signup failed': 'Registrierung fehlgeschlagen',
      'Food Logged': 'Essen protokolliert',
      'Food item added to history': 'Essen zum Verlauf hinzugefügt',
    },
    'gu': {
      'Success': 'સફળતા',
      'Notice': 'સૂચના',
      'Information': 'માહિતી',
      'Preferences': 'પસંદગીઓ',
      'Theme': 'થીમ',
      'Appearance': 'દેખાવ',
      'Required Field': 'જરૂરી ફીલ્ડ',
      'Invalid Input': 'અમાન્ય ઈનપુટ',
      'Scan Error': 'સ્કેન ભૂલ',
      'Setup Complete': 'સેટઅપ પૂર્ણ થયું',
      'Language updated successfully': 'ભાષા સફળતાપૂર્વક અપડેટ થઈ',
      'Theme updated successfully': 'થીમ સફળતાપૂર્વક અપડેટ થઈ',
      'Profile updated successfully!': 'પ્રોફાઇલ સફળતાપૂર્વક અપડેટ થઈ!',
      'Weight goal updated successfully!': 'વજનનું લક્ષ્ય સફળતાપૂર્વક અપડેટ થયું!',
      'Daily calories updated successfully!': 'દૈનિક કેલરી લક્ષ્ય સફળતાપૂર્વક અપડેટ થયું!',
      'Logged out successfully': 'સફળતાપૂર્વક લૉગ આઉટ થયા',
      'Welcome to FitCal!': 'FitCal માં આપનું સ્વાગત છે!',
      'Food added successfully': 'ખોરાક સફળતાપૂર્વક ઉમેરાયો',
      'Failed to analyze food item': 'ખોરાકની વિશ્લેષણ કરવામાં નિષ્ફળ',
      'Email and password cannot be empty': 'ઈમેઇલ અને પાસવર્ડ ખાલી હોઈ શકતા નથી',
      'All fields are required': 'બધા ક્ષેત્રો જરૂરી છે',
      'Password must be at least 6 characters': 'પાસવર્ડ ઓછામાં ઓછા ૬ અક્ષરોનો હોવો જોઈએ',
      'Passwords do not match': 'પાસવર્ડ મેળ ખાતા નથી',
      'Login successful!': 'લૉગિન સફળ!',
      'Signup successful!': 'સાઇનઅપ સફળ!',
      'Login failed': 'લૉગિન નિષ્ફળ',
      'Signup failed': 'સાઇનઅપ નિષ્ફળ',
      'Food Logged': 'ખોરાક લૉગ થયો',
      'Food item added to history': 'ઇતિહાસમાં ખોરાક ઉમેરાયો',
    },
    'es': {
      'Success': 'Éxito',
      'Notice': 'Aviso',
      'Information': 'Información',
      'Preferences': 'Preferencias',
      'Theme': 'Tema',
      'Appearance': 'Apariencia',
      'Required Field': 'Campo requerido',
      'Invalid Input': 'Entrada no válida',
      'Scan Error': 'Error de escaneo',
      'Setup Complete': 'Configuración completada',
      'Language updated successfully': 'Idioma actualizado con éxito',
      'Theme updated successfully': 'Tema actualizado con éxito',
      'Profile updated successfully!': '¡Perfil actualizado con éxito!',
      'Weight goal updated successfully!': '¡Objetivo de peso actualizado con éxito!',
      'Daily calories updated successfully!': '¡Calorías diarias actualizadas con éxito!',
      'Logged out successfully': 'Sesión cerrada con éxito',
      'Welcome to FitCal!': '¡Bienvenido a FitCal!',
      'Food added successfully': 'Comida añadida con éxito',
      'Failed to analyze food item': 'Error al analizar el alimento',
      'Email and password cannot be empty': 'El correo y la contraseña no pueden estar vacíos',
      'All fields are required': 'Todos los campos son obligatorios',
      'Password must be at least 6 characters': 'La contraseña debe tener al menos 6 caracteres',
      'Passwords do not match': 'Las contraseñas no coinciden',
      'Login successful!': '¡Inicio de sesión exitoso!',
      'Signup successful!': '¡Registro exitoso!',
      'Login failed': 'Error de inicio de sesión',
      'Signup failed': 'Error de registro',
      'Food Logged': 'Comida registrada',
      'Food item added to history': 'Alimento añadido al historial',
    },
    'fr': {
      'Success': 'Succès',
      'Notice': 'Avis',
      'Information': 'Information',
      'Preferences': 'Préférences',
      'Theme': 'Thème',
      'Appearance': 'Apparence',
      'Required Field': 'Champ obligatoire',
      'Invalid Input': 'Saisie invalide',
      'Scan Error': 'Erreur de scan',
      'Setup Complete': 'Configuration terminée',
      'Language updated successfully': 'Langue mise à jour avec succès',
      'Theme updated successfully': 'Thème mis à jour avec succès',
      'Profile updated successfully!': 'Profil mis à jour avec succès !',
      'Weight goal updated successfully!': 'Objectif de poids mis à jour avec succès !',
      'Daily calories updated successfully!': 'Objectif de calories quotidiennes mis à jour !',
      'Logged out successfully': 'Déconnexion réussie',
      'Welcome to FitCal!': 'Bienvenue sur FitCal !',
      'Food added successfully': 'Aliment ajouté avec succès',
      'Failed to analyze food item': 'Échec de l\'analyse de l\'aliment',
      'Email and password cannot be empty': 'L\'e-mail et le mot de passe ne peuvent pas être vides',
      'All fields are required': 'Tous les champs sont obligatoires',
      'Password must be at least 6 characters': 'Le mot de passe doit contenir au moins 6 caractères',
      'Passwords do not match': 'Les mots de passe ne correspondent pas',
      'Login successful!': 'Connexion réussie !',
      'Signup successful!': 'Inscription réussie !',
      'Login failed': 'Échec de la connexion',
      'Signup failed': 'Échec de l\'inscription',
      'Food Logged': 'Repas enregistré',
      'Food item added to history': 'Aliment ajouté à l\'historique',
    },
  };

  static String _translate(String text, String langCode) {
    if (_translations.containsKey(langCode)) {
      final langMap = _translations[langCode]!;
      if (langMap.containsKey(text)) {
        return langMap[text]!;
      }
    }
    return text;
  }

  static String _getActiveLanguageCode() {
    try {
      if (Get.isRegistered<LocaleController>()) {
        return Get.find<LocaleController>().locale.languageCode;
      }
      final context = Get.context;
      if (context != null) {
        return Localizations.localeOf(context).languageCode;
      }
    } catch (_) {}
    return 'en';
  }

  static void showSuccess(String message, {String? title}) {
    showGlassToast(
      message: message,
      title: title,
      type: ToastType.success,
    );
  }

  static void showError(String message, {String? title}) {
    showGlassToast(
      message: message,
      title: title,
      type: ToastType.error,
    );
  }

  static void showInfo(String message, {String? title}) {
    showGlassToast(
      message: message,
      title: title,
      type: ToastType.info,
    );
  }

  static void showGlassToast({
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Duration? duration,
  }) {
    final context = Get.context;
    final isDark = context != null
        ? Theme.of(context).brightness == Brightness.dark
        : true;

    final langCode = _getActiveLanguageCode();
    final TextDirection textDirection =
        langCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

    Color accentColor;
    IconData icon;
    String defaultTitle;

    switch (type) {
      case ToastType.success:
        accentColor = AppColors.primary;
        icon = Icons.check_circle_rounded;
        defaultTitle = 'Success';
        break;
      case ToastType.error:
        accentColor = AppColors.error;
        icon = Icons.error_rounded;
        defaultTitle = 'Notice';
        break;
      case ToastType.info:
        accentColor = AppColors.accent;
        icon = Icons.info_rounded;
        defaultTitle = 'Information';
        break;
    }

    final rawTitle = title ?? defaultTitle;
    final displayTitle = _translate(rawTitle, langCode);
    final displayMessage = _translate(message, langCode);

    Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      duration: duration ?? AppDurations.splashDelay,
      backgroundColor: AppColors.transparent,
      barBlur: 0,
      overlayBlur: 0,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.zero,
      messageText: Directionality(
        textDirection: textDirection,
        child: ClipRRect(
          borderRadius: AppRadius.border20,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.black.withOpacity(0.7)
                    : AppColors.white.withOpacity(0.85),
                borderRadius: AppRadius.border20,
                border: Border.all(
                  color: accentColor.withOpacity(0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: accentColor,
                      size: 24.sp,
                    ),
                  ),
                  const HSpace14(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayTitle,
                          style: GoogleFonts.sora(
                            color: isDark ? AppColors.white : AppColors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const VSpace2(),
                        Text(
                          displayMessage,
                          style: GoogleFonts.inter(
                            color:
                                isDark ? AppColors.white70 : AppColors.black54,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

