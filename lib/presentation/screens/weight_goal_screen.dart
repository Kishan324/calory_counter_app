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

/// Screen for modifying target weight goal managed via GetX.
class WeightGoalScreen extends StatefulWidget {
  const WeightGoalScreen({super.key});

  @override
  State<WeightGoalScreen> createState() => _WeightGoalScreenState();
}

class _WeightGoalScreenState extends State<WeightGoalScreen> {
  late final TextEditingController _weightController;
  final _formKey = GlobalKey<FormState>();
  late final ProfileController profileController;

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();
    _weightController = TextEditingController(
      text: profileController.weightGoal != null
          ? profileController.weightGoal!.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(AppLocalizations loc) async {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.parse(_weightController.text.trim());

    await profileController.updateProfileDetails(
      weightGoal: weight,
      successMessage: loc.weightGoalUpdated,
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
        title: Text(loc.weightGoal, style: theme.textTheme.headlineMedium),
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
                  loc.weightGoalTitle,
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const VSpace8(),
                Text(
                  loc.weightGoalSubtitle,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const VSpace36(),
                TextFormField(
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: loc.weightGoal,
                    floatingLabelStyle: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.primary),
                    prefixIcon: Icon(Icons.scale_rounded,
                        color: theme.colorScheme.onSurfaceVariant),
                    suffixText: 'kg',
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
                      return loc.invalidWeight;
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed <= 0) {
                      return loc.invalidWeight;
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
