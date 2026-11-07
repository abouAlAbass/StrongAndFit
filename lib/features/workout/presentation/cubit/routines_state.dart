import 'package:equatable/equatable.dart';
import '../../../../core/database/daos/template_dao.dart';

enum RoutinesStatus { initial, loading, loaded, error }

class RoutinesState extends Equatable {
  final RoutinesStatus status;
  final List<TemplateDetail> templates;
  final String? errorMessage;

  const RoutinesState({
    this.status = RoutinesStatus.initial,
    this.templates = const [],
    this.errorMessage,
  });

  RoutinesState copyWith({
    RoutinesStatus? status,
    List<TemplateDetail>? templates,
    String? errorMessage,
  }) {
    return RoutinesState(
      status: status ?? this.status,
      templates: templates ?? this.templates,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, templates, errorMessage];
}
