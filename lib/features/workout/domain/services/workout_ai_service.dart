import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/services/ai_key_storage_service.dart';
import '../models/workout_ai_models.dart';

/// Exception specifically thrown when network connectivity fails during Gemini AI operations.
class AiNetworkException implements Exception {
  final String message;
  const AiNetworkException([
    this.message = 'Vérifiez votre connexion Internet.',
  ]);

  @override
  String toString() => message;
}

/// Service interfacing directly with Google Gemini Generative AI for
/// deep athletic analysis, strength coaching insights, and BYOK validation.
class WorkoutAiService {
  final AiKeyStorageService _keyStorage;

  /// Default fast and cost-effective model recommended for structured JSON tasks.
  static const String defaultModel = 'gemini-1.5-flash';

  WorkoutAiService({AiKeyStorageService? keyStorage})
    : _keyStorage = keyStorage ?? AiKeyStorageService();

  /// Tests a provided Gemini API key with a minimal query to verify validity.
  /// Throws an informative [Exception] if invalid, expired, or network unreachable.
  Future<bool> testApiKey(String key) async {
    final sanitized = key.trim();
    if (sanitized.isEmpty) {
      throw Exception('La clé d\'API ne peut pas être vide.');
    }

    try {
      final model = GenerativeModel(model: defaultModel, apiKey: sanitized);

      final response = await model.generateContent([Content.text('ping')]);

      if (response.text != null && response.text!.isNotEmpty) {
        return true;
      }
      throw Exception('Aucune réponse reçue de Google Gemini.');
    } on GenerativeAIException catch (e) {
      if (_isNetworkError(e)) {
        throw const AiNetworkException();
      }
      if (e.message.contains('API_KEY_INVALID') ||
          e.message.contains('API key not valid')) {
        throw Exception('Clé d\'API Google AI Studio invalide.');
      } else if (e.message.contains('QUOTA_EXCEEDED') ||
          e.message.contains('Resource has been exhausted')) {
        throw Exception('Quota dépassé pour cette clé.');
      }
      throw Exception('Erreur Google Gemini: ${e.message}');
    } on SocketException catch (_) {
      throw const AiNetworkException();
    } on HttpException catch (_) {
      throw const AiNetworkException();
    } catch (e) {
      if (e is Exception) {
        if (_isNetworkError(e)) {
          throw const AiNetworkException();
        }
        rethrow;
      }
      if (_isNetworkError(e)) {
        throw const AiNetworkException();
      }
      throw Exception('Erreur de connexion avec l\'API Google AI: $e');
    }
  }

  static bool _isNetworkError(dynamic error) {
    if (error is SocketException || error is HttpException) return true;
    final msg = error.toString().toLowerCase();
    return msg.contains('socket') ||
        msg.contains('failed host lookup') ||
        msg.contains('no address associated') ||
        msg.contains('network is unreachable') ||
        msg.contains('connection refused') ||
        msg.contains('clientexception') ||
        msg.contains('handshakeexception');
  }

  /// Builds the localized system instruction acting as a world-class strength & conditioning coach.
  static String buildSystemInstruction(String languageCode) {
    final targetLang = switch (languageCode) {
      'ar' => 'Arabic (العربية الفصحى الرياضية الواضحة)',
      'en' => 'English',
      _ => 'French (Français)',
    };
    return '''
Tu es un préparateur physique d'élite et expert en biomécanique et hypertrophie (CSCS / Master en sciences du sport).
Analyse les données d'entraînement fournies au format JSON.
IMPORTANT : Rédige TOUTES les valeurs textuelles du JSON dans la langue suivante : $targetLang. Les clés du JSON ("overview", "progressive_overload", etc.) doivent rester strictement en anglais comme spécifié ci-dessous.
Tu dois répondre UNIQUEMENT par un objet JSON valide, sans texte d'introduction ni backticks markdown autour.

Format JSON attendu :
{
  "overview": "Résumé global de la séance et de l'effort produit (2-3 phrases).",
  "progressive_overload": "Analyse de la surcharge progressive par rapport aux charges et répétitions.",
  "recovery_and_rpe": "Évaluation de la fatigue perçue (RPE/RIR) et de la récupération nécessaire.",
  "highlights": ["Point fort 1 (ex: record battu, bon rep-range)", "Point fort 2"],
  "plateaus_or_risks": ["Alerte ou point de vigilance (ex: RPE 10 répété, volume excessif)"],
  "next_cycle_recommendations": ["Recommandation concrète pour la prochaine séance 1", "Recommandation 2"],
  "overall_score": 8
}
''';
  }

  /// Performs full athletic review using the saved or explicitly passed API key.
  Future<WorkoutAiAnalysis> analyzeWorkoutData(
    WorkoutSummary payload, {
    String? explicitKey,
    String languageCode = 'fr',
  }) async {
    final apiKey = explicitKey ?? await _keyStorage.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'Aucune clé d\'API Gemini configurée. Veuillez renseigner votre clé dans les paramètres.',
      );
    }

    try {
      final model = GenerativeModel(
        model: defaultModel,
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.3,
        ),
        systemInstruction: Content.system(buildSystemInstruction(languageCode)),
      );

      final prompt =
          'Voici les données de la séance à analyser :\n${jsonEncode(payload.toJson())}';

      final response = await model.generateContent([Content.text(prompt)]);

      final rawText = response.text;
      if (rawText == null || rawText.trim().isEmpty) {
        throw Exception('Réponse vide retournée par Gemini.');
      }

      // Sanitize potential backticks if returned despite responseMimeType
      var cleanedJson = rawText.trim();
      if (cleanedJson.startsWith('```json')) {
        cleanedJson = cleanedJson.substring(7);
      }
      if (cleanedJson.startsWith('```')) {
        cleanedJson = cleanedJson.substring(3);
      }
      if (cleanedJson.endsWith('```')) {
        cleanedJson = cleanedJson.substring(0, cleanedJson.length - 3);
      }
      cleanedJson = cleanedJson.trim();

      final decoded = jsonDecode(cleanedJson) as Map<String, dynamic>;
      return WorkoutAiAnalysis.fromJson(decoded);
    } on GenerativeAIException catch (e) {
      if (_isNetworkError(e)) {
        throw const AiNetworkException();
      }
      if (e.message.contains('API_KEY_INVALID')) {
        throw Exception(
          'Clé d\'API invalide. Vérifiez vos paramètres dans votre profil.',
        );
      } else if (e.message.contains('QUOTA_EXCEEDED')) {
        throw Exception(
          'Quota Gemini gratuit atteint. Réessayez dans un instant.',
        );
      }
      throw Exception('Erreur Gemini : ${e.message}');
    } on SocketException catch (_) {
      throw const AiNetworkException();
    } on HttpException catch (_) {
      throw const AiNetworkException();
    } catch (e) {
      if (e is Exception) {
        if (_isNetworkError(e)) {
          throw const AiNetworkException();
        }
        rethrow;
      }
      if (_isNetworkError(e)) {
        throw const AiNetworkException();
      }
      throw Exception('Erreur lors de l\'analyse IA : $e');
    }
  }
}
