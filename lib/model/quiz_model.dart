class QuizModel {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String image;
  final String answer;
  String? tempAnswerLabel;
  final int value;
  bool? tempAnswer = false;
  bool? isActivedQuiz = false;
  final String id;

  QuizModel(
      {required this.question,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.option4,
      required this.image,
      required this.id,
      required this.value,
      this.tempAnswer,
      this.tempAnswerLabel,
      this.isActivedQuiz,
      required this.answer});

  QuizModel.fromMap(Map<String, dynamic> data, this.id)
      : question = data['question'] ?? 'data not found',
        option1 = data['option1'] ?? 'data not found',
        option2 = data['option2'] ?? 'data not found',
        option3 = data['option3'] ?? 'data not found',
        option4 = data['option4'] ?? 'data not found',
        image = data['image'] ?? 'data not found',
        answer = data['answer'] ?? 'data not found',
        value = data['value'];
  // tempAnswer = false;

  Map<String, dynamic> toMap() {
    return {
      "name": question,
      "option1": option1,
      "option2": option2,
      "option3": option3,
      "option4": option4,
      "image": image,
      "answer": answer,
      id: id
    };
  }
}
