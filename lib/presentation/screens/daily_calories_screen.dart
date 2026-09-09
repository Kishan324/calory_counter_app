import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_space.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/app_back_button.dart';
import '../../controllers/profile_controller.dart';

/// Screen for updating target daily calorie allowance managed via GetX.
class DailyCaloriesScreen extends StatefulWidget {
  const DailyCaloriesScreen({super.key});

  @override
  State<DailyCaloriesScreen> createState() => _DailyCaloriesScreenState();
}

class _DailyCaloriesScreenState extends State<DailyCaloriesScreen> {
  late final TextEditingController _caloriesController;
  final _formKey = GlobalKey<FormState>();
  late final ProfileController profileController;

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();
    _caloriesController = TextEditingController(
      text: profileController.dailyCalories != null
          ? profileController.dailyCalories!.toString()
          : '',
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

    await profileController.updateProfileDetails(
      dailyCalories: calories,
      successMessage: loc.dailyCaloriesUpdated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(loc.dailyCalories, style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(AppPadding.padding24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VSpace12(),
                Text(
                  loc.dailyCaloriesTitle,
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const VSpace8(),
                Text(
                  loc.dailyCaloriesSubtitle,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const VSpace36(),
                TextFormField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: loc.dailyCalories,
                    floatingLabelStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.primary),
                    prefixIcon: Icon(Icons.local_fire_department_rounded,
                        color: theme.colorScheme.onSurfaceVariant),
                    suffixText: 'kcal',
                    suffixStyle: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.border16,
                      borderSide: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.border16,
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: AppRadius.border16,
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: AppRadius.border16,
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 2,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: AppPadding.padding20, vertical: AppPadding.padding18),
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
                const VSpace48(),
                Obx(
                  () => AppPrimaryButton(
                    text: loc.save,
                    onPressed: () => _submitForm(loc),
                    isLoading: profileController.isSaving,
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
