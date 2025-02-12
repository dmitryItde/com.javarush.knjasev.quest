<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>


<%
    // Получаем параметры сессии
    String playerName = (String) session.getAttribute("playerName");
    String gameState = (String) session.getAttribute("gameState");
    String questionText = (String) session.getAttribute("questionText");
    List<String> answers = (List<String>) session.getAttribute("answers");
    String resultMessage = (String) session.getAttribute("resultMessage");
    Integer gamesPlayed = (Integer) session.getAttribute("gamesPlayed");

    if (gamesPlayed == null) {
        gamesPlayed = 0;
        session.setAttribute("gamesPlayed", gamesPlayed);
    }
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Текстовый квест</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .hidden { display: none; }
        .container { width: 50%; margin: auto; text-align: center; }
        button { margin-top: 10px; }
    </style>

    <!-- Подключаем Bootstrap -->
    <link href="css/index.css">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<div class="container">

    <!-- Блок приветствия -->
    <div id="welcomeBlock" class="${not empty playerName ? 'hidden' : ''}">
        <h2>Добро пожаловать!</h2>
        <form action="GameServlet" method="post">
            <label>Введите ваше имя: <input type="text" name="playerName" required></label>
            <button type="submit">Начать игру</button>
        </form>
    </div>

    <!-- Блок описания квеста -->
    <div id="introBlock">
        <h2>Пролог</h2>
        <p>Ты очнулся в темноте, не помня, кто ты и где находишься...</p>
        <button onclick="toggleBlock('introBlock')">Скрыть/Показать</button>
    </div>

    <!-- Блок с вопросом -->
    <div id="questionBlock" class="${empty questionText ? 'hidden' : ''}">
        <h2>Вопрос</h2>
        <p><c:out value="${questionText}" /></p>
        <button onclick="toggleBlock('questionBlock')">Скрыть/Показать</button>
    </div>

    <!-- Блок с ответами -->
    <div id="answersBlock" class="${empty answers ? 'hidden' : ''}">
        <h2>Выберите ответ</h2>
        <form action="GameServlet" method="post">
            <c:forEach var="answer" items="${answers}">
                <label><input type="radio" name="answer" value="${answer}" required> <c:out value="${answer}" /></label><br>
            </c:forEach>
            <button type="submit">Ответить</button>
        </form>
        <button onclick="toggleBlock('answersBlock')">Скрыть/Показать</button>
    </div>

    <!-- Блок с результатом игры -->
    <div id="resultBlock" class="${empty resultMessage ? 'hidden' : ''}">
        <h2>Результат</h2>
        <p><c:out value="${resultMessage}" /></p>
        <form action="GameServlet" method="post">
            <button type="submit" name="restart" value="true">Играть снова</button>
        </form>
        <button onclick="toggleBlock('resultBlock')">Скрыть/Показать</button>
    </div>

    <!-- Блок статистики -->
    <div id="statsBlock">
        <h2>Статистика</h2>
        <p>Игр сыграно: <c:out value="${gamesPlayed}" /></p>
        <button onclick="toggleBlock('statsBlock')">Скрыть/Показать</button>
    </div>

</div>

<script>
    function toggleBlock(id) {
        $("#" + id).toggle();
    }
</script>

</body>
</html>
