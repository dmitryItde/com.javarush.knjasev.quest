<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.io.*, java.nio.file.*, org.json.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>

<%
    // Если пришёл параметр рестарта, сбрасываем сессию и перезагружаем страницу
    if ("true".equals(request.getParameter("restart"))) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }
%>

<%
    // Получаем путь к папке с квестами, например "/WEB-INF/classes/quests"
    String questsDirPath = application.getRealPath("/WEB-INF/classes/quests");
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
        }
    }

    // Передаём список квестов в request
    request.setAttribute("questList", questList);
%>

<%

    HttpSession sessionObj = request.getSession();
    String playerName = (String) sessionObj.getAttribute("playerName");
    String questName = (String) sessionObj.getAttribute("questName");

    // Если форма отправлена методом POST
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Если имя ещё не установлено, сохраняем его в сессии и устанавливаем начальный вопрос (id = "1")
        if (playerName == null) {
            playerName = request.getParameter("playerName");
            questName = request.getParameter("questName");

            if (playerName != null && !playerName.trim().isEmpty()) {
                sessionObj.setAttribute("playerName", playerName);
                sessionObj.setAttribute("questName", questName);
                sessionObj.setAttribute("answer", "1"); // Начальный вопрос с id = 1
                response.sendRedirect("index.jsp"); // Перезагружаем страницу, чтобы начать квест
                return;
            }
        } else {
            // Если имя уже установлено, обновляем номер следующего вопроса, полученный из выбранного ответа
            String selectedAnswer = request.getParameter("answer");
            if (selectedAnswer != null) {
                sessionObj.setAttribute("answer", selectedAnswer);
            } else {
                sessionObj.setAttribute("answer", "1");
            }
        }
    }

    // Определяем текущий вопрос
    String idQuestions = (String) sessionObj.getAttribute("answer");
    if (idQuestions == null) {
        idQuestions = "1"; // Значение по умолчанию, если не установлено
    }

    // Переменные для данных квеста
    String questionText = "Ошибка загрузки квеста";
    JSONArray answers = new JSONArray();
    String questTitle = "";
    String questDescription = "";
    String endingType = "";

    if (playerName != null) {
        try {
            //String path = application.getRealPath("/WEB-INF/classes/quests/Quest2.json");
            String path = application.getRealPath("/WEB-INF/classes/quests/" + questName);
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
                if (question.getInt("id") == Integer.parseInt(idQuestions)) {
                    questionText = question.getString("text");
                    if (question.has("answers")) {
                        answers = question.getJSONArray("answers");
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
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Текстовый квест</title>
    <!-- Подключаем Bootstrap для стилизации -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container mt-4">
<!-- Если имя не задано, предлагаем ввести его -->
<c:choose>
<c:when test="${empty sessionScope.playerName}">
<h2>Добро пожаловать в текстовый квест!</h2>
<form method="post">
    <div class="mb-3">
        <label for="playerName" class="form-label">Введите ваше имя:</label>
        <input type="text" name="playerName" id="playerName" class="form-control" required>
    </div>

    <h2>Выберите квест:</h2>
    <form action="index.jsp" method="get">
        <!-- Используем JSTL для перебора списка квестов -->
        <c:forEach var="quest" items="${questList}">
            <div class="form-check">
                <input class="form-check-input" type="radio" name="questName"
                       id="quest_${quest}" value="${quest}" required>
                <label class="form-check-label" for="quest_${quest}">
                        ${quest}
                </label>
            </div>
        </c:forEach>

        <button type="submit" class="btn btn-primary">Начать игру</button>
    </form>
    </c:when>
    <c:otherwise>
    <!-- Если имя задано, показываем квест -->
    <h2>Привет, ${sessionScope.playerName}!</h2>
    <!-- Выводим название и описание квеста только для первого вопроса -->
    <c:if test="${sessionScope.answer eq '1'}">
    <h3>Квест: ${questTitle}</h3>
    <h4>Описание: ${questDescription}</h4>
    </c:if>

    <!-- Выводим сообщение о результате, если игра закончена -->
    <c:choose>
    <c:when test="${endingType eq 'win'}">
    <p>${questionText} Вы победили!</p>
    <!-- Кнопка для рестарта игры -->
    <form method="post" action="index.jsp">
        <input type="hidden" name="restart" value="true">
        <button type="submit" class="btn btn-warning">Начать игру заново</button>
    </form>
    </c:when>
    <c:when test="${endingType eq 'loss'}">
    <p>${questionText} Вы проиграли...</p>
    <!-- Кнопка для рестарта игры -->
    <form method="post" action="index.jsp">
        <input type="hidden" name="restart" value="true">
        <button type="submit" class="btn btn-warning">Начать игру заново</button>
    </form>
    </c:when>
    <c:otherwise>
    <!-- Выводим вопрос и список вариантов ответа -->
            <%
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
                %>


    <p>${questionText}</p>
    <form method="post" action="index.jsp">
        <c:forEach var="ans" items="${answersList}">
            <div class="form-check">
                <input class="form-check-input" type="radio" name="answer"
                       id="ans_${ans.id}" value="${ans.nextQuestionId}" required>
                <label class="form-check-label" for="ans_${ans.id}">
                        ${ans.text}
                </label>
            </div>
        </c:forEach>
        <button type="submit" class="btn btn-primary mt-3">Ответить</button>
    </form>
    </c:otherwise>
    </c:choose>
    </c:otherwise>
    </c:choose>

    <!-- Блок с параметрами сессии -->
    <div class="card mt-4">
        <div class="card-header">
            Информация о сессии
        </div>
        <div class="card-body">
            <p><strong>Имя игрока:</strong> ${sessionScope.playerName}</p>
            <p><strong>Название квеста:</strong> ${sessionScope.questName}</p>
        </div>
    </div>
</body>
</html>
