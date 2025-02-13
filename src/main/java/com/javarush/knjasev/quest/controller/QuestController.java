package com.javarush.knjasev.quest.controller;


import com.javarush.knjasev.quest.entity.Quest;
import com.javarush.knjasev.quest.service.QuestService;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


//@WebServlet("/test")
@WebServlet(name = "test", value = "")
public class QuestController extends HttpServlet {
    private static final String QUESTS_DIR = "/WEB-INF/classes/quests";


    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=========== QuestList doGet");

        HttpSession session = request.getSession();

        List<String> questList = null;
        if (session.getAttribute("questList") == null) {
            QuestService questService = new QuestService();
            questList = questService.getQuestName(getServletContext());
        }
        // Передаём список квестов в request
        request.setAttribute("questList", questList);
        System.out.println("=========== Реквест 1");
        request.getRequestDispatcher("/index.jsp").forward(request, response);

    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=========== QuestList doPost");
        HttpSession session = request.getSession();

        // Обработка выбора ответа или рестарта игры
        String restart = request.getParameter("restart");
        if ("true".equals(restart)) {
            session.invalidate();
            System.out.println("=========== Реквест 0");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        //ищем имя в параметрах сессии
        String playerName = (String) session.getAttribute("playerName");
        String questName = (String) session.getAttribute("questName");
        //String selectedAnswer = (String) session.getAttribute("answer");
        String selectedAnswer = request.getParameter("answer");
        System.out.println("Answer from request " + selectedAnswer);

        //если имени в параметрах сессии нет, то ищем имя в параметрах request
        if (playerName == null) {
            playerName = request.getParameter("playerName");
            questName = request.getParameter("questName");

            //если нашли имя в  параметрах request, то записываем его в сессию,
            //также записываем в параметры сессии имя квеста
            if (playerName != null && !playerName.trim().isEmpty()) {
                session.setAttribute("playerName", playerName);
                session.setAttribute("questName", questName);
                session.setAttribute("answer", "1"); // Начальный вопрос с id = 1
                //request.setAttribute("answer", "1"); // Начальный вопрос с id = 1

                //response.sendRedirect("index.jsp"); // Перезагружаем страницу, чтобы начать квест
                System.out.println("=========== Реквест 2");
                //request.getRequestDispatcher("/index.jsp").forward(request, response);
                request.getRequestDispatcher("/").forward(request, response);
                return;
            }
        } else {
            // Если имя уже установлено, обновляем номер следующего вопроса, полученный из выбранного ответа
            //selectedAnswer = request.getParameter("answer");
            //selectedAnswer = session.getParameter("answer");
            if (selectedAnswer == null) {
                selectedAnswer = "1";
                request.setAttribute("answer", selectedAnswer);
                session.setAttribute("answer", selectedAnswer);
                System.out.println("Set1 answer to " + selectedAnswer);
            } else {
                session.setAttribute("answer", selectedAnswer);
                System.out.println("Set2 answer to " + selectedAnswer);
            }
        }

//==============
        // Переменные для данных квеста
        String questionText = "Ошибка загрузки квеста";
        JSONArray answers = new JSONArray();
        String questTitle = "";
        String questDescription = "";
        String endingType = "";

        if (playerName != null) {
            try {
                //String path = application.getRealPath("/WEB-INF/classes/quests/Quest2.json");
                System.out.println("======Probyem zagruzit infu o Quest");
                String path = getServletContext().getRealPath("/WEB-INF/classes/quests/"+questName);
                String jsonText = new String(Files.readAllBytes(Paths.get(path)), "UTF-8");

                JSONObject questData = new JSONObject(jsonText);
                // Извлекаем данные пролога
                JSONObject intro = questData.getJSONObject("intro");
                questTitle = intro.getString("title");
                questDescription = intro.getString("description");

                // Ищем нужный вопрос по id
                JSONArray questions = questData.getJSONArray("questions");
                for (int i = 0; i < questions.length(); i++) {
                    JSONObject question = questions.getJSONObject(i);
                    System.out.println("===== selectedAnswer "+selectedAnswer);
                    if (question.getInt("id") == Integer.parseInt(selectedAnswer)) {
                        questionText = question.getString("text");
                        if (question.has("answers")) {
                            answers = question.getJSONArray("answers");
                            System.out.println("===========Anwer find");
                        }
                        if (question.has("endingType")) {
                            endingType = question.getString("endingType");
                        }
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Сохраним полученные данные в request для удобства использования JSTL
        request.setAttribute("questionText", questionText);
        request.setAttribute("answers", answers);
        request.setAttribute("questTitle", questTitle);
        request.setAttribute("questDescription", questDescription);
        request.setAttribute("endingType", endingType);

        session.setAttribute("questionText", questionText);
        session.setAttribute("answers", answers);
        session.setAttribute("questTitle", questTitle);
        session.setAttribute("questDescription", questDescription);
        session.setAttribute("endingType", endingType);


        // Преобразование JSONArray в List<Map<String, Object>>
        List<Map<String, Object>> answersList = new ArrayList<>();
        for (int i = 0; i < answers.length(); i++) {
            JSONObject answerObj = answers.getJSONObject(i);
            Map<String, Object> answerMap = new HashMap<>();
            answerMap.put("id", answerObj.get("id"));
            answerMap.put("text", answerObj.get("text"));
            answerMap.put("nextQuestionId", answerObj.get("nextQuestionId"));
            answersList.add(answerMap);
        }
        // Передаем список в request
        request.setAttribute("answersList", answersList);
        session.setAttribute("answersList", answersList);

        System.out.println("=========== Реквест 3");
        request.getRequestDispatcher("/index.jsp").forward(request, response);

    }
}
