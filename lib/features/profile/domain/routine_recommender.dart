import 'package:flutter/widgets.dart';
import '../../../../core/enums/experience_level.dart';

/// Athlete's primary training goal.
enum TrainingGoal { hypertrophy, strength, fitness }

/// Algorithmic match result linking athlete availability and level to the optimal routine.
class RoutineRecommendation {
  final String templateSlug;
  final String routineName;
  final String rationale;
  final int recommendedDaysPerWeek;
  final ExperienceLevel recommendedLevel;
  final TrainingGoal goal;

  const RoutineRecommendation({
    required this.templateSlug,
    required this.routineName,
    required this.rationale,
    required this.recommendedDaysPerWeek,
    required this.recommendedLevel,
    required this.goal,
  });

  String localizedRoutineName(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (templateSlug) {
      case 'full_body_split':
        if (lang == 'ar') return 'برنامج الجسم بالكامل (الأساس)';
        if (lang == 'fr') return 'Full Body Split (Fondation)';
        return 'Full Body Split (Foundation)';
      case 'upper_body_power':
        if (lang == 'ar') return 'الجزء العلوي قوة وضخامة';
        if (lang == 'fr') return 'Haut du corps Force & Hypertrophie';
        return 'Upper Body Power & Hypertrophy';
      case 'pull_strength':
        if (lang == 'ar') return 'يوم السحب (الظهر، البايسبس)';
        if (lang == 'fr') return 'Pull Day (Dos, Biceps, Chaîne postérieure)';
        return 'Pull Day (Back, Biceps, Posterior Chain)';
      case 'push_hypertrophy':
      default:
        if (lang == 'ar') return 'يوم الدفع (الصدر، الأكتاف، الترايسبس)';
        if (lang == 'fr') return 'Push Day (Pectoraux, Épaules, Triceps)';
        return 'Push Day (Chest, Shoulders, Triceps)';
    }
  }

  String localizedRationale(BuildContext context, {int? requestedDays}) {
    final lang = Localizations.localeOf(context).languageCode;
    String baseRationale;
    switch (templateSlug) {
      case 'full_body_split':
        if (lang == 'ar') {
          baseRationale =
              'يوفر تكرار الجسم بالكامل (3 مرات/أسبوعياً) تكيفاً عصبياً عضلياً مثالياً، وتعزيزاً للأنماط الحركية واستشفاءً جهازياً كافياً.';
        } else if (lang == 'fr') {
          baseRationale =
              'Une fréquence Full Body (3x/semaine) offre une adaptation neuromusculaire optimale, le renforcement des schémas moteurs et 48h de récupération.';
        } else {
          baseRationale =
              'Full-body frequency (3x/week) provides optimal neuromuscular adaptation, motor pattern reinforcement, and 48h systemic recovery.';
        }
        break;
      case 'upper_body_power':
        if (lang == 'ar') {
          baseRationale =
              'يوفر تقسيم الجزء العلوي/السفلي لمدة 4 أيام توزيعاً ممتازاً لتضخيم العضلات واستعادة الاستشفاء من التمارين المركبة الثقيلة.';
        } else if (lang == 'fr') {
          baseRationale =
              'Un split Haut/Bas du corps sur 4 jours offre la répartition idéale pour l\'hypertrophie et la récupération sur les mouvements lourds.';
        } else {
          baseRationale =
              'An Upper/Lower 4-day split offers the ideal distribution for hypertrophy and heavy compound recovery across the week.';
        }
        break;
      case 'pull_strength':
        if (lang == 'ar') {
          baseRationale =
              'دورة دفع/سحب/أرجل عالية التردد تعزل ميكانيكا السلسلة الخلفية وكثافة السحب الثقيل للرياضيين المتقدمين.';
        } else if (lang == 'fr') {
          baseRationale =
              'Rotation Push/Pull/Legs à haute fréquence isolant la chaîne postérieure et la densité de tirage lourd pour athlètes confirmés.';
        } else {
          baseRationale =
              'High-frequency Push/Pull/Legs rotation isolating posterior chain mechanics and heavy pulling density for advanced athletes.';
        }
        break;
      case 'push_hypertrophy':
      default:
        if (lang == 'ar') {
          baseRationale =
              'تقسيم حجم متخصص دفع/سحب/أرجل يزيد التوتر الميكانيكي والإجهاد الأيضي عبر عضلات الدفع.';
        } else if (lang == 'fr') {
          baseRationale =
              'Split Push/Pull/Legs axé volume maximisant la tension mécanique et le stress métabolique sur les groupes musculaires de poussée.';
        } else {
          baseRationale =
              'Specialized Push/Pull/Legs volume split maximizing mechanical tension and metabolic stress across pressing muscle groups.';
        }
        break;
    }

    if (requestedDays != null &&
        requestedDays > 3 &&
        recommendedDaysPerWeek == 3) {
      if (lang == 'ar') {
        baseRationale +=
            '\n\n💡 ملاحظة: على الرغم من توفرك لمدة $requestedDays أيام، نوصي بالبدء بـ 3 أيام كرياضي مبتدئ لضمان استشفاء أوتارك ومفاصلك.';
      } else if (lang == 'fr') {
        baseRationale +=
            '\n\n💡 Note : Bien que vous soyez disponible $requestedDays jours, nous préconisons 3 jours pour consolider vos bases biomécaniques sans surentraînement.';
      } else {
        baseRationale +=
            '\n\n💡 Note: Although you are available for $requestedDays days, we recommend 3 days for beginners to build consistent recovery habits.';
      }
    }

    return baseRationale;
  }
}

/// Science-based routine recommender matching frequency, athletic maturity,
/// and muscular adaptation goals to pre-designed training splits.
class RoutineRecommender {
  RoutineRecommender._();

  static RoutineRecommendation match({
    required TrainingGoal goal,
    required int daysPerWeek,
    required ExperienceLevel experienceLevel,
  }) {
    // 1. Beginners (< 1 year) or 3-day lifters -> Full Body Split
    if (daysPerWeek <= 3 || experienceLevel == ExperienceLevel.beginner) {
      return RoutineRecommendation(
        templateSlug: 'full_body_split',
        routineName: 'Full Body Split (Foundation)',
        rationale:
            'Full-body frequency (3x/week) provides optimal neuromuscular adaptation, motor pattern reinforcement, and 48h systemic recovery.',
        recommendedDaysPerWeek: 3,
        recommendedLevel: experienceLevel,
        goal: goal,
      );
    }

    // 2. 4 days availability -> Upper / Lower Split
    if (daysPerWeek == 4) {
      return RoutineRecommendation(
        templateSlug: 'upper_body_power',
        routineName: 'Upper Body Power & Hypertrophy',
        rationale:
            'An Upper/Lower 4-day split offers the ideal distribution for hypertrophy and heavy compound recovery across the week.',
        recommendedDaysPerWeek: 4,
        recommendedLevel: experienceLevel,
        goal: goal,
      );
    }

    // 3. 5+ days availability -> Push / Pull / Legs Split
    if (goal == TrainingGoal.strength) {
      return RoutineRecommendation(
        templateSlug: 'pull_strength',
        routineName: 'Pull Day (Back, Biceps, Posterior Chain)',
        rationale:
            'High-frequency Push/Pull/Legs rotation isolating posterior chain mechanics and heavy pulling density for advanced athletes.',
        recommendedDaysPerWeek: 5,
        recommendedLevel: experienceLevel,
        goal: goal,
      );
    }

    return RoutineRecommendation(
      templateSlug: 'push_hypertrophy',
      routineName: 'Push Day (Chest, Shoulders, Triceps)',
      rationale:
          'Specialized Push/Pull/Legs volume split maximizing mechanical tension and metabolic stress across pressing muscle groups.',
      recommendedDaysPerWeek: 5,
      recommendedLevel: experienceLevel,
      goal: goal,
    );
  }
}
