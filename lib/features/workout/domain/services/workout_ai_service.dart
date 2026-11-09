import 'dart:async';
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

/// Exception specifically thrown when request times out while querying Gemini AI.
class AiTimeoutException implements Exception {
  final String message;
  const AiTimeoutException([
    this.message =
        'Délai d\'attente dépassé lors de la communication avec Google Gemini.',
  ]);

  @override
  String toString() => message;
}

/// Service interfacing directly with Google Gemini Generative AI for
/// deep athletic analysis, strength coaching insights, and BYOK validation.
class WorkoutAiService {
  final AiKeyStorageService _keyStorage;

  /// Candidate model names tried sequentially to guarantee robust discovery
  /// across API endpoints (e.g. gemini-1.5-flash, gemini-2.5-flash, gemini-1.5-flash-latest).
  static const List<String> candidateModels = [
    'gemini-1.5-flash',
    'gemini-2.5-flash',
    'gemini-1.5-flash-latest',
    'gemini-pro',
  ];

  WorkoutAiService({AiKeyStorageService? keyStorage})
    : _keyStorage = keyStorage ?? AiKeyStorageService();

  /// Creates a GenerativeModel with standard safety settings and optional system instruction.
  static GenerativeModel _createModel({
    required String modelName,
    required String apiKey,
    GenerationConfig? generationConfig,
    Content? systemInstruction,
  }) {
    return GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      generationConfig: generationConfig,
      systemInstruction: systemInstruction,
    );
  }

  /// Tests a provided Gemini API key with a minimal query to verify validity.
  /// Iterates through [candidateModels] if a specific variant returns 404/not found.
  /// Throws an informative [Exception] if invalid, expired, network unreachable, or timed out.
  Future<bool> testApiKey(String key) async {
    final sanitized = key.trim();
    if (sanitized.isEmpty) {
      throw Exception('La clé d\'API ne peut pas être vide.');
    }

    String? lastModelError;

    for (final modelName in candidateModels) {
      try {
        final model = _createModel(modelName: modelName, apiKey: sanitized);

        final response = await model
            .generateContent([Content.text('ping')])
            .timeout(const Duration(seconds: 15));

        if (response.text != null && response.text!.isNotEmpty) {
          return true;
        }
      } on TimeoutException {
        throw const AiTimeoutException();
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
        } else if (e.message.contains('is not found') ||
            e.message.contains('not supported for generateContent') ||
            e.message.contains('404')) {
          // Model variant not supported or not found in current region/endpoint; try fallback candidate
          lastModelError = e.message;
          continue;
        }
        throw Exception('Erreur Google Gemini: ${e.message}');
      } on SocketException catch (_) {
        throw const AiNetworkException();
      } on HttpException catch (_) {
        throw const AiNetworkException();
      } catch (e) {
        if (e is TimeoutException) {
          throw const AiTimeoutException();
        }
        if (_isNetworkError(e)) {
          throw const AiNetworkException();
        }
        if (e is Exception) rethrow;
        throw Exception('Erreur de connexion avec l\'API Google AI: $e');
      }
    }

    throw Exception(
      lastModelError != null
          ? 'Erreur Google Gemini: $lastModelError'
          : 'Aucune réponse reçue de Google Gemini.',
    );
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

  /// Localized system instruction for full workout session review.
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

  /// Localized system instruction for routine/program audit tailored to questionnaire and free text.
  static String buildProgramSystemInstruction(String languageCode) {
    final targetLang = switch (languageCode) {
      'ar' => 'Arabic (العربية الفصحى الرياضية الواضحة)',
      'en' => 'English',
      _ => 'French (Français)',
    };
    return '''
Tu es un préparateur physique d'élite et expert en programmation d'entraînement et biomécanique (CSCS).
Analyse le programme d'entraînement et les réponses de l'athlète (fatigue, point faible, durée par séance, gênes articulaires, et ses remarques libres).
IMPORTANT : Rédige TOUTES les valeurs textuelles du JSON dans la langue suivante : $targetLang.
Les clés du JSON ("summary", "program_match_score", etc.) doivent rester strictement en anglais comme spécifié ci-dessous.
Tu dois répondre UNIQUEMENT par un objet JSON valide, sans texte d'introduction ni backticks markdown autour.

Format JSON attendu :
{
  "summary": "Résumé de l'adéquation du programme avec les besoins et contraintes de l'athlète (2-3 phrases).",
  "program_match_score": 8,
  "volume_assessment": "Évaluation du volume par groupe musculaire et de la fréquence hebdomadaire.",
  "modifications": [
    "Ajustement ou remplacement d'exercice concret 1",
    "Ajustement 2"
  ],
  "injury_prevention": [
    "Conseil biomécanique ou d'échauffement spécifique 1 pour les zones sensibles",
    "Conseil 2"
  ],
  "periodization": [
    "Stratégie de progression et périodisation sur 4 à 6 semaines (ex: incréments, deload)",
    "Recommandation 2"
  ]
}
''';
  }

  /// Localized system instruction for longitudinal workout history analysis.
  static String buildHistorySystemInstruction(String languageCode) {
    final targetLang = switch (languageCode) {
      'ar' => 'Arabic (العربية الفصحى الرياضية الواضحة)',
      'en' => 'English',
      _ => 'French (Français)',
    };
    return '''
Tu es un préparateur physique d'élite et analyste de performance sportive (CSCS).
Analyse l'historique complet des séances d'entraînement de l'athlète pour évaluer sa progression, sa régularité, sa surcharge progressive et la gestion de la fatigue.
IMPORTANT : Rédige TOUTES les valeurs textuelles du JSON dans la langue suivante : $targetLang.
Les clés du JSON ("executive_summary", "progression_score", etc.) doivent rester strictement en anglais comme spécifié ci-dessous.
Tu dois répondre UNIQUEMENT par un objet JSON valide, sans texte d'introduction ni backticks markdown autour.

Format JSON attendu :
{
  "executive_summary": "Bilan global de la progression, régularité et investissement de l'athlète (2-3 phrases).",
  "progression_score": 8,
  "progressive_overload_rate": "Évaluation précise de la surcharge progressive (charges, répétitions, tonnage).",
  "volume_trajectory": "Tendance du volume au fil du temps (en hausse, stable, en baisse, fluctuations).",
  "muscular_balance": "Équilibre du volume entre groupes musculaires (poussée vs tirage vs bas du corps).",
  "plateaus_and_fatigue": [
    "Signalement de stagnation ou risque de surmenage 1",
    "Signalement 2"
  ],
  "next_milestones": [
    "Objectif prioritaire concret pour le prochain cycle d'entraînement 1",
    "Objectif 2"
  ]
}
''';
  }

  /// Internal helper that sends a structured prompt to Gemini with resilient model discovery.
  Future<Map<String, dynamic>> _executeGeminiQuery({
    required String systemInstruction,
    required String prompt,
    String? explicitKey,
  }) async {
    final apiKey = explicitKey ?? await _keyStorage.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'Aucune clé d\'API Gemini configurée. Veuillez renseigner votre clé dans les paramètres.',
      );
    }

    String? lastModelError;

    for (final modelName in candidateModels) {
      try {
        final model = _createModel(
          modelName: modelName,
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.3,
          ),
          systemInstruction: Content.system(systemInstruction),
        );

        final response = await model
            .generateContent([Content.text(prompt)])
            .timeout(const Duration(seconds: 30));

        final rawText = response.text;
        if (rawText == null || rawText.trim().isEmpty) {
          throw Exception('Réponse vide retournée par Gemini.');
        }

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

        return jsonDecode(cleanedJson) as Map<String, dynamic>;
      } on TimeoutException {
        throw const AiTimeoutException();
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
        } else if (e.message.contains('is not found') ||
            e.message.contains('not supported for generateContent') ||
            e.message.contains('404')) {
          lastModelError = e.message;
          continue;
        }
        throw Exception('Erreur Gemini : ${e.message}');
      } on SocketException catch (_) {
        throw const AiNetworkException();
      } on HttpException catch (_) {
        throw const AiNetworkException();
      } catch (e) {
        if (e is TimeoutException) {
          throw const AiTimeoutException();
        }
        if (_isNetworkError(e)) {
          throw const AiNetworkException();
        }
        if (e is Exception) rethrow;
        throw Exception('Erreur lors de l\'analyse IA : $e');
      }
    }

    throw Exception(
      lastModelError != null
          ? 'Erreur Gemini : $lastModelError'
          : 'Réponse vide retournée par Gemini.',
    );
  }

  /// Performs full athletic review of a single workout session.
  Future<WorkoutAiAnalysis> analyzeWorkoutData(
    WorkoutSummary payload, {
    String? explicitKey,
    String languageCode = 'fr',
  }) async {
    final prompt =
        'Voici les données de la séance à analyser :\n${jsonEncode(payload.toJson())}';
    final decoded = await _executeGeminiQuery(
      systemInstruction: buildSystemInstruction(languageCode),
      prompt: prompt,
      explicitKey: explicitKey,
    );
    return WorkoutAiAnalysis.fromJson(decoded);
  }

  /// Performs a personalized AI audit of a workout program/routine with questionnaire and athlete notes.
  Future<ProgramAiAnalysis> analyzeProgram({
    required String programName,
    String? programNotes,
    required List<Map<String, dynamic>> exercises,
    required ProgramAiQuestionnaire questionnaire,
    String? athleteName,
    String? experienceLevel,
    double? bodyWeightKg,
    String? explicitKey,
    String languageCode = 'fr',
  }) async {
    final payload = {
      'athlete': {
        'name': ?athleteName,
        'experience_level': ?experienceLevel,
        'body_weight_kg': ?bodyWeightKg,
      },
      'program': {
        'name': programName,
        'notes': ?programNotes,
        'exercises': exercises,
      },
      'questionnaire': questionnaire.toJson(),
    };

    final prompt =
        'Voici les détails du programme et les réponses de l\'athlète :\n${jsonEncode(payload)}';
    final decoded = await _executeGeminiQuery(
      systemInstruction: buildProgramSystemInstruction(languageCode),
      prompt: prompt,
      explicitKey: explicitKey,
    );
    return ProgramAiAnalysis.fromJson(decoded);
  }

  /// Performs longitudinal progression review across athlete's historical workouts.
  Future<HistoryAiAnalysis> analyzeTrainingHistory({
    required List<Map<String, dynamic>> historicalSessions,
    String? athleteName,
    String? experienceLevel,
    double? bodyWeightKg,
    String? explicitKey,
    String languageCode = 'fr',
  }) async {
    final payload = {
      'athlete': {
        'name': ?athleteName,
        'experience_level': ?experienceLevel,
        'body_weight_kg': ?bodyWeightKg,
      },
      'sessions_history': historicalSessions,
      'total_sessions_analyzed': historicalSessions.length,
    };

    final prompt =
        'Voici l\'historique des séances d\'entraînement à analyser :\n${jsonEncode(payload)}';
    final decoded = await _executeGeminiQuery(
      systemInstruction: buildHistorySystemInstruction(languageCode),
      prompt: prompt,
      explicitKey: explicitKey,
    );
    return HistoryAiAnalysis.fromJson(decoded);
  }
}
