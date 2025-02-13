<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession();
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
    <form action="" method="get">
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
    <h3>Квест тест: ${questTitle}</h3>
    <h4>Описание тест: ${questDescription}</h4>
    </c:if>

    <!-- Выводим сообщение о результате, если игра закончена -->
    <c:choose>
    <c:when test="${endingType eq 'win'}">
    <p>${questionText} Вы победили!</p>
    <!-- Кнопка для рестарта игры -->
    <form method="post" action="">
        <input type="hidden" name="restart" value="true">
        <button type="submit" class="btn btn-warning">Начать игру заново</button>
    </form>
    </c:when>
    <c:when test="${endingType eq 'loss'}">
    <p>${questionText} Вы проиграли...</p>
    <!-- Кнопка для рестарта игры -->
    <form method="post" action="">
        <input type="hidden" name="restart" value="true">
        <button type="submit" class="btn btn-warning">Начать игру заново</button>
    </form>
    </c:when>
    <c:otherwise>

    <!-- Выводим вопрос и список вариантов ответа -->
    <p>${questionText}</p>
    <form method="post" action="">
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
