import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/l10n/generated/app_localizations_fr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../history/domain/services/workout_import_service.dart';

/// Modal dialog enabling users to restore a Strong Track JSON backup file
/// or JSON payload with a confirmation notice, overwrite toggle, and progress state.
class BackupImportDialog extends StatefulWidget {
  final WorkoutImportService importService;

  const BackupImportDialog({super.key, required this.importService});

  static Future<BackupImportResult?> show(
    BuildContext context, {
    required WorkoutImportService importService,
  }) {
    return showDialog<BackupImportResult>(
      context: context,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: BackupImportDialog(importService: importService),
        ),
      ),
    );
  }

  @override
  State<BackupImportDialog> createState() => _BackupImportDialogState();
}

class _BackupImportDialogState extends State<BackupImportDialog> {
  final TextEditingController _payloadController = TextEditingController();
  List<File> _localBackups = const [];
  File? _selectedFile;
  bool _overwrite = false;
  bool _isLoading = false;
  String? _errorMessage;

  AppLocalizations get _l10n =>
      AppLocalizations.of(context) ?? AppLocalizationsFr();

  @override
  void initState() {
    super.initState();
    _discoverLocalFiles();
  }

  Future<void> _discoverLocalFiles() async {
    try {
      final files = await widget.importService.listAvailableLocalBackups();
      if (mounted) {
        setState(() {
          _localBackups = files;
          if (files.isNotEmpty) {
            _selectedFile = files.first;
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _payloadController.dispose();
    super.dispose();
  }

  Future<void> _runImport() async {
    final l10n = _l10n;
    final rawInput = _payloadController.text.trim();

    if (rawInput.isEmpty && _selectedFile == null) {
      setState(() {
        _errorMessage = l10n.importErrorMessage('JSON');
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      BackupImportResult result;
      if (rawInput.startsWith('{')) {
        result = await widget.importService.importFromJsonString(
          rawInput,
          overwrite: _overwrite,
        );
      } else if (rawInput.isNotEmpty) {
        result = await widget.importService.importFromFile(
          File(rawInput),
          overwrite: _overwrite,
          purgeTempFileAfterRead: false,
        );
      } else {
        result = await widget.importService.importFromFile(
          _selectedFile!,
          overwrite: _overwrite,
          purgeTempFileAfterRead: true,
        );
      }

      HapticFeedback.mediumImpact();
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = l10n.importErrorMessage(
            e.toString().replaceAll('FormatException: ', ''),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n;

    return AlertDialog(
      backgroundColor: AppColors.ofSurfaceElevated(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.settings_backup_restore_rounded,
              color: AppColors.secondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.importConfirmTitle,
              style: AppTypography.ofTitleLarge(context).copyWith(fontSize: 17),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Confirmation warning callout
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.ofSurface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.ofBorder(context),
                  width: 0.8,
                ),
              ),
              child: Text(
                l10n.importConfirmMessage,
                style: AppTypography.ofBodySecondary(
                  context,
                ).copyWith(fontSize: 12.5, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),

            // Overwrite toggle
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _overwrite,
              activeThumbColor: AppColors.failure,
              title: Text(
                l10n.importOverwriteOption,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: _overwrite
                      ? AppColors.failure
                      : AppColors.ofTextPrimary(context),
                ),
              ),
              onChanged: _isLoading
                  ? null
                  : (val) => setState(() => _overwrite = val),
            ),

            // Discovered local backups (if any)
            if (_localBackups.isNotEmpty) ...[
              const SizedBox(height: 8),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.importJsonTitle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<File>(
                    value: _selectedFile,
                    isExpanded: true,
                    items: _localBackups.map((file) {
                      final name = file.path.split(Platform.pathSeparator).last;
                      return DropdownMenuItem<File>(
                        value: file,
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      );
                    }).toList(),
                    onChanged: _isLoading
                        ? null
                        : (file) => setState(() => _selectedFile = file),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Paste JSON or File path input
            TextField(
              controller: _payloadController,
              maxLines: 4,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: l10n.importFilePathHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.content_paste_rounded),
                  tooltip: l10n.aiKeyPasteTooltip,
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final clip = await Clipboard.getData('text/plain');
                          if (clip?.text != null && mounted) {
                            setState(() {
                              _payloadController.text = clip!.text!.trim();
                            });
                          }
                        },
                ),
              ),
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.failure.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.failure.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.failure,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _runImport,
          style: ElevatedButton.styleFrom(
            backgroundColor: _overwrite ? AppColors.failure : AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.upload_file_rounded, size: 18),
          label: Text(l10n.importStartButton),
        ),
      ],
    );
  }
}
