import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/profile_provider.dart';

class DailyCaloriesScreen extends StatefulWidget {
  const DailyCaloriesScreen({Key? key}) : super(key: key);

  @override
  State<DailyCaloriesScreen> createState() => _DailyCaloriesScreenState();
}

class _DailyCaloriesScreenState extends State<DailyCaloriesScreen> {
  late final TextEditingController _caloriesController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profileProvider = context.read<ProfileProvider>();
    // Pre-fill if there is an existing calorie target
    _caloriesController = TextEditingController(
      text: profileProvider.dailyCalories != null ? profileProvider.dailyCalories!.toString() : '',
    );
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(AppLocalizations loc) async {
    if (!_formKey.currentState!.validate()) return;

    final calories = int.parse(_caloriesController.text.trim());
    final profileProvider = context.read<ProfileProvider>();

    final success = await profileProvider.updateProfileDetails(
      dailyCalories: calories,
      successMessage: loc.dailyCaloriesUpdated,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.dailyCalories, style: theme.textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Text(
                  loc.dailyCaloriesTitle,
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  loc.dailyCaloriesSubtitle,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 36.h),
                // Daily Calories Input
                TextFormField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: loc.dailyCalories,
                    floatingLabelStyle: TextStyle(color: theme.colorScheme.primary),
                    prefixIcon: Icon(Icons.local_fire_department_rounded,
                        color: theme.colorScheme.onSurfaceVariant),
                    suffixText: 'kcal',
                    suffixStyle: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return loc.invalidCalories;
                    }
                    final parsed = int.tryParse(value);
                    if (parsed == null || parsed <= 0) {
                      return loc.invalidCalories;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 48.h),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: profileProvider.isSaving ? null : () => _submitForm(loc),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    child: profileProvider.isSaving
                        ? SizedBox(
                            height: 20.w,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            loc.save,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
