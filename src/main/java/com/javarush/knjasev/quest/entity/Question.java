package  com.javarush.knjasev.quest.entity;

import java.util.List;

public class Question {
    private int id;
    private String text;
    private List<Answer> answers;
    private String endingType; // Может быть "win", "loss" или null, если вопрос обычный

    public Question() { }

    public Question(int id, String text, List<Answer> answers, String endingType) {
        this.id = id;
        this.text = text;
        this.answers = answers;
        this.endingType = endingType;
    }

    // Getters и setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public List<Answer> getAnswers() { return answers; }
    public void setAnswers(List<Answer> answers) { this.answers = answers; }

    public String getEndingType() { return endingType; }
    public void setEndingType(String endingType) { this.endingType = endingType; }
}
