class Response1 {
    String info;
    String name;
    List<Question> questions;

    Response1({
        required this.info,
        required this.name,
        required this.questions,
    });

}

class Question {
    String answer;
    String question;
    

    Question({
        required this.answer,
        required this.question,
    });

}
