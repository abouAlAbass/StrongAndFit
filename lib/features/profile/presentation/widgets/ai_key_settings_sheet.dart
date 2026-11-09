import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/services/ai_key_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../workout/domain/services/workout_ai_service.dart';

/// Modal bottom sheet enabling athletes to configure and securely persist
/// their Google AI Studio (Gemini) API key ("Bring Your Own Key").
class AiKeySettingsSheet extends StatefulWidget {
  final AiKeyStorageService keyStorage;
  final WorkoutAiService aiService;
  final VoidCallback? onKeyUpdated;

  const AiKeySettingsSheet({
    super.key,
    required this.keyStorage,
    required this.aiService,
    this.onKeyUpdated,
  });

  /// Displays the modal sheet with standard responsive styling.
  static Future<bool?> show(
    BuildContext context, {
    AiKeyStorageService? keyStorage,
    WorkoutAiService? aiService,
    VoidCallback? onKeyUpdated,
  }) {
    final storage = keyStorage ?? AiKeyStorageService();
    final service = aiService ?? WorkoutAiService(keyStorage: storage);

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: AiKeySettingsSheet(
            keyStorage: storage,
            aiService: service,
            onKeyUpdated: onKeyUpdated,
          ),
        ),
      ),
    );
  }

  @override
  State<AiKeySettingsSheet> createState() => _AiKeySettingsSheetState();
}

class _AiKeySettingsSheetState extends State<AiKeySettingsSheet> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  bool _isCheckingInitialKey = true;
  bool _hasSavedKey = false;
  String? _errorMessage;
  String? _successMessage;

  static const String _kAiStudioUrl = 'https://aistudio.google.com/app/apikey';

  @override
  void initState() {
    super.initState();
    _loadExistingKey();
  }

  Future<void> _loadExistingKey() async {
    final key = await widget.keyStorage.getApiKey();
    if (mounted) {
      setState(() {
        _hasSavedKey = key != null && key.isNotEmpty;
        if (_hasSavedKey) {
          _apiKeyController.text = key!;
        }
        _isCheckingInitialKey = false;
      });
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _launchAiStudioUrl() async {
    final uri = Uri.parse(_kAiStudioUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        setState(
          () => _errorMessage = 'Impossible d\'ouvrir le lien : $_kAiStudioUrl',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Erreur ouverture navigateur: $e');
      }
    }
  }

  Future<void> _validateAndSaveKey() async {
    final inputKey = _apiKeyController.text.trim();
    if (inputKey.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez saisir ou coller votre clé API Gemini.';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // 1. Verify key connectivity via lightweight ping
      await widget.aiService.testApiKey(inputKey);

      // 2. Persist in Keystore / Keychain
      await widget.keyStorage.saveApiKey(inputKey);

      HapticFeedback.mediumImpact();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasSavedKey = true;
          _successMessage =
              'Clé Gemini validée et enregistrée de façon sécurisée !';
        });
        widget.onKeyUpdated?.call();

        // Close after a brief moment of positive feedback
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) Navigator.of(context).pop(true);
        });
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  Future<void> _deleteKey() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la clé Gemini ?'),
        content: const Text(
          'Les fonctionnalités d\'analyse automatique de séances et de records seront désactivées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.keyStorage.deleteApiKey();
      HapticFeedback.mediumImpact();
      if (mounted) {
        setState(() {
          _apiKeyController.clear();
          _hasSavedKey = false;
          _successMessage = 'Clé supprimée.';
          _errorMessage = null;
        });
        widget.onKeyUpdated?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.ofSurfaceElevated(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: _isCheckingInitialKey
          ? const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.ofBorder(context),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header with AI Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF387BFF), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coach IA — Clé Google Gemini',
                              style: AppTypography.ofTitleLarge(
                                context,
                              ).copyWith(fontSize: 18),
                            ),
                            Text(
                              'Bring Your Own Key (BYOK) — 100% Gratuit',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.ofTextSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Privacy & Security Callout
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.ofBorder(
                        context,
                      ).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.ofBorder(context),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          size: 18,
                          color: AppColors.completed,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Votre clé reste sur votre appareil. Elle est chiffrée dans le Keystore Android / Keychain iOS et n\'est jamais transmise à un serveur tiers.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.ofTextSecondary(context),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Step-by-Step Instructions
                  Text(
                    'Comment obtenir votre clé gratuite en 30 secondes :',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ofTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStepRow(
                    context,
                    '1',
                    'Connectez-vous avec votre compte Google sur AI Studio.',
                  ),
                  _buildStepRow(
                    context,
                    '2',
                    'Cliquez sur "Create API Key" (aucun moyen de paiement requis).',
                  ),
                  _buildStepRow(
                    context,
                    '3',
                    'Copiez la clé et collez-la dans le champ ci-dessous.',
                  ),
                  const SizedBox(height: 12),

                  // Direct Button to Google AI Studio
                  OutlinedButton.icon(
                    onPressed: _launchAiStudioUrl,
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: const Text(
                      'Obtenir une clé gratuite sur Google AI Studio',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Input field
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Clé d\'API Google Gemini (ex: AIzaSy...)',
                      hintText: 'Collez votre clé ici',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.ofBorder(context),
                        ),
                      ),
                      prefixIcon: const Icon(Icons.key_rounded),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                          ),
                          IconButton(
                            icon: const Icon(Icons.content_paste_rounded),
                            tooltip: 'Coller',
                            onPressed: () async {
                              final data = await Clipboard.getData(
                                'text/plain',
                              );
                              if (data?.text != null && mounted) {
                                _apiKeyController.text = data!.text!.trim();
                                HapticFeedback.selectionClick();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status / Error / Success Messages
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_successMessage != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.completed.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.completed.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.completed,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _successMessage!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.completed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Actions Buttons
                  ElevatedButton(
                    onPressed: _isLoading ? null : _validateAndSaveKey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Valider et Sauvegarder',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),

                  // Delete option if key already exists
                  if (_hasSavedKey) ...[
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _isLoading ? null : _deleteKey,
                      icon: const Icon(Icons.delete_outline_rounded, size: 16),
                      label: const Text('Supprimer la clé enregistrée'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildStepRow(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.ofTextSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
