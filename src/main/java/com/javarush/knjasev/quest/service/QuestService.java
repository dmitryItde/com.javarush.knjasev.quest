package com.javarush.knjasev.quest.service;


import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.util.List;

import com.javarush.knjasev.quest.entity.*;
import com.javarush.knjasev.quest.repository.QuestRepository;
import jakarta.servlet.ServletContext;

public class QuestService {
    private static final String QUESTS_PATH = "/WEB-INF/classes/quests/";

    //public Quest loadQuest(String questFileName, String realPath) throws Exception {
    // realPath — это корневой путь приложения
    //String fullPath = realPath + QUESTS_PATH + questFileName;
    public Quest loadQuest(String questFileName) throws Exception {
        String fullPath = QUESTS_PATH + questFileName;
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(new File(fullPath), Quest.class);
    }

    public List<String> getQuestName(ServletContext servletContext){
        QuestRepository questRepository = new QuestRepository();
        List<String> questList = questRepository.getAllQuestName(servletContext);
        return questList;

    }

}
