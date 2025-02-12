package com.javarush.knjasev.quest.controller;


import com.javarush.knjasev.quest.entity.Quest;
import com.javarush.knjasev.quest.service.QuestService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletContext;

@WebServlet("/test")
public class QuestController extends HttpServlet {
    private static final String QUESTS_DIR = "/WEB-INF/classes/quests";
    ServletContext servletContext;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Получаем путь к папке с квестами, например "/WEB-INF/classes/quests"
        String questsDirPath = servletContext.getRealPath("/WEB-INF/classes/quests/");
        File questsDir = new File(questsDirPath);

        // Фильтр для выбора только файлов с расширением .json
        File[] files = questsDir.listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.toLowerCase().endsWith(".json");
            }
        });

        // Формируем список имен файлов (названий квестов)
        List<String> questList = new ArrayList<>();
        if (files != null) {
            for (File file : files) {
                questList.add(file.getName());
                //System.out.println(file.getName().toString());
            }
        }

        // Передаём список квестов в request
        HttpSession sessionObj = request.getSession();
        //request.setAttribute("questList", questList);
        sessionObj.setAttribute("questList", questList);

        request.setAttribute("questList", questList);
       request.getRequestDispatcher("/quest.jsp").forward(request, response);

//        HttpSession session = request.getSession();
//        // Если пользователь только что выбрал квест, параметр quest будет передан в URL
//        String questFile = request.getParameter("quest");
//        if (questFile != null && !questFile.trim().isEmpty()) {
//            // Сохраняем выбранный квест в сессии и начинаем игру с первого вопроса (id=1)
//            session.setAttribute("selectedQuest", questFile);
//            session.setAttribute("currentQuestionId", 1);
//            // Перенаправляем на представление квеста
//            response.sendRedirect(request.getContextPath() + "/quest.jsp");
//            return;
//        }
//
//        // Если квест еще не выбран, выводим список доступных квестов
//        String realPath = getServletContext().getRealPath("");
//        String questsPath = getServletContext().getRealPath(QUESTS_DIR);
//        File questsDir = new File(questsPath);
//        File[] files = questsDir.listFiles(new FilenameFilter() {
//            public boolean accept(File dir, String name) {
//                return name.toLowerCase().endsWith(".json");
//            }
//        });
//        List<String> questList = new ArrayList<>();
//        if (files != null) {
//            for (File file : files) {
//                questList.add(file.getName());
//            }
//        }
//        request.setAttribute("questList", questList);
//        request.getRequestDispatcher("/questList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        // Обработка выбора ответа или рестарта игры
//        String restart = request.getParameter("restart");
//        if ("true".equals(restart)) {
//            session.invalidate();
//            response.sendRedirect(request.getContextPath() + "/quest");
//            return;
//        }
//
//        // Получаем текущий выбранный ответ и обновляем id вопроса
//        String nextQuestionIdParam = request.getParameter("answer");
//        if (nextQuestionIdParam != null && !nextQuestionIdParam.trim().isEmpty()) {
//            try {
//                int nextQuestionId = Integer.parseInt(nextQuestionIdParam);
//                session.setAttribute("currentQuestionId", nextQuestionId);
//            } catch (NumberFormatException e) {
//                // обработка ошибки, если потребуется
//            }
//        }
//        // Перенаправляем на представление квеста
//        response.sendRedirect(request.getContextPath() + "/quest.jsp");
    }
}
