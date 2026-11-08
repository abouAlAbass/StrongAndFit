import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/enums/experience_level.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Interactive modal sheet to update biometrics, weekly frequency target, and experience level.
class EditProfileDialog extends StatefulWidget {
  final UserProfile profile;
  final void Function({
    required String name,
    required double? weightKg,
    required double? heightCm,
    required int weeklyGoal,
    required ExperienceLevel experienceLevel,
  }) onSave;

  const EditProfileDialog({
    super.key,
    required this.profile,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required UserProfile profile,
    required void Function({
      required String name,
      required double? weightKg,
      required double? heightCm,
      required int weeklyGoal,
      required ExperienceLevel experienceLevel,
    }) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.ofCard(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditProfileDialog(profile: profile, onSave: onSave),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late int _weeklyGoal;
  late ExperienceLevel _experienceLevel;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _weightController = TextEditingController(
      text: widget.profile.weightKg != null
          ? widget.profile.weightKg!.toStringAsFixed(1)
          : '',
    );
    _heightController = TextEditingController(
      text: widget.profile.heightCm != null
          ? widget.profile.heightCm!.toStringAsFixed(0)
          : '',
    );
    _weeklyGoal = widget.profile.weeklyWorkoutGoal;
    _experienceLevel = widget.profile.experienceLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 20,
        end: 20,
        top: 16,
        bottom: bottomInset + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sheet Title
            Text(l10n.editProfile, style: AppTypography.ofTitleLarge(context)),
            const SizedBox(height: 20),

            // 1. Name Input
            Text(l10n.athleteName, style: AppTypography.ofCaption(context)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: l10n.athleteName),
            ),
            const SizedBox(height: 16),

            // 2. Weight (kg) & Height (cm) side-by-side
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.weightKg, style: AppTypography.ofCaption(context)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _weightController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          hintText: '75.0',
                          suffixText: 'kg',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.heightCm, style: AppTypography.ofCaption(context)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          hintText: '178',
                          suffixText: 'cm',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3. Weekly Workout Target Frequency
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.weeklyGoal, style: AppTypography.ofCaption(context)),
                Text(
                  l10n.workoutsPerWeek(_weeklyGoal),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [2, 3, 4, 5, 6].map((days) {
                final isSelected = _weeklyGoal == days;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 3),
                    child: InkWell(
                      onTap: () => setState(() => _weeklyGoal = days),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.ofPrimaryContainer(context)
                              : AppColors.ofSurface(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.ofBorder(context),
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$days d',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.ofTextSecondary(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 4. Experience Level
            Text(l10n.experienceLevel, style: AppTypography.ofCaption(context)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildExperienceOption(
                  context: context,
                  level: ExperienceLevel.beginner,
                  label: l10n.beginner,
                ),
                const SizedBox(width: 8),
                _buildExperienceOption(
                  context: context,
                  level: ExperienceLevel.intermediate,
                  label: l10n.intermediate,
                ),
                const SizedBox(width: 8),
                _buildExperienceOption(
                  context: context,
                  level: ExperienceLevel.advanced,
                  label: l10n.advanced,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final weight = double.tryParse(_weightController.text.trim());
                  final height = double.tryParse(_heightController.text.trim());
                  final name = _nameController.text.trim().isNotEmpty
                      ? _nameController.text.trim()
                      : widget.profile.name;

                  widget.onSave(
                    name: name,
                    weightKg: weight,
                    heightCm: height,
                    weeklyGoal: _weeklyGoal,
                    experienceLevel: _experienceLevel,
                  );
                  Navigator.pop(context);
                },
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceOption({
    required BuildContext context,
    required ExperienceLevel level,
    required String label,
  }) {
    final isSelected = _experienceLevel == level;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _experienceLevel = level),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.ofPrimaryContainer(context)
                : AppColors.ofSurface(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.ofBorder(context),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.ofTextSecondary(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
