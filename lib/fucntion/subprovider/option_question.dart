import 'option_choice.dart';

class OptionQuestion {
  final String question; // ภาษาเริ่มต้น (EN)
  final String question_th;
  final String question_cn;
  final String? question_ja;
  final String mode;
  final bool active;
  final int defaultChoice;
  final List<OptionChoice> items; // รายการ Option Choice

  OptionQuestion({
    required this.question,
    required this.question_th,
    required this.question_cn,
    this.question_ja,
    required this.mode,
    required this.active,
    required this.defaultChoice,
    required this.items,
  });

  factory OptionQuestion.fromJson(Map<String, dynamic> json) {
    return OptionQuestion(
      question: json['question'] ?? '',
      question_th: json['question_th'] ?? '',
      question_cn: json['question_cn'] ?? '',
      question_ja: json['question_ja'],
      mode: json['mode'] ?? '',
      active: json['active'] ?? false,
      defaultChoice: json['default_choice'] is int
          ? json['default_choice']
          : int.tryParse(json['default_choice'].toString()) ?? 0,
      items: (json['items'] as List? ?? [])
          .map((item) => OptionChoice.fromJson(item))
          .toList(),
    );
  }
}
