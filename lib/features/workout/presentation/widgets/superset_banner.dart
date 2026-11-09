import 'package:flutter/material.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/models/workout_session_detail.dart';

/// Pure utility and visual badge component for Superset group identification (A1/A2, B1/B2).
class SupersetBanner extends StatelessWidget {
  final String supersetLabel;

  const SupersetBanner({super.key, required this.supersetLabel});

  /// Computes workoutExerciseId -> superset badge label (e.g. 'A1', 'A2', 'B1')
  /// for all grouped exercises in a session.
  static Map<int, String> buildLabels(List<WorkoutExerciseDetail> exercises) {
    final groupToLetter = <int, String>{};
    final groupCounts = <int, int>{};
    final result = <int, String>{};

    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    int letterIndex = 0;

    for (final item in exercises) {
      final gid = item.workoutExercise.supersetGroupId;
      if (gid != null) {
        if (!groupToLetter.containsKey(gid)) {
          groupToLetter[gid] = letters[letterIndex % letters.length];
          letterIndex++;
        }
        final letter = groupToLetter[gid]!;
        final count = (groupCounts[gid] ?? 0) + 1;
        groupCounts[gid] = count;
        result[item.workoutExercise.id] = '$letter$count';
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link_rounded, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            '${l10n.supersetLabel} $supersetLabel',
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
