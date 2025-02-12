package com.javarush.knjasev.quest.entity;

public class Answer {
    private String id;
    private String text;
    private int nextQuestionId;

    public Answer() { }

    public Answer(String id, String text, int nextQuestionId) {
        this.id = id;
        this.text = text;
        this.nextQuestionId = nextQuestionId;
    }

    // Getters и setters
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }
    public void setText(String text) {
        this.text = text;
    }

    public int getNextQuestionId() {
        return nextQuestionId;
    }
    public void setNextQuestionId(int nextQuestionId) {
        this.nextQuestionId = nextQuestionId;
    }
}
