import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import jakarta.servlet.http.HttpSession;
import java.nio.file.Files;
import java.nio.file.Paths;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class Quest_GameTest {

    private JSONObject questData;
    private HttpSession session;

    @BeforeEach
    void setUp() throws Exception {
        // Загружаем тестовый JSON-файл (имитация файла квеста)
        String jsonText = new String(Files.readAllBytes(Paths.get("src/test/resources/quest_test.json")), "UTF-8");
        questData = new JSONObject(jsonText);

        // Мокаем объект сессии
        session = Mockito.mock(HttpSession.class);
    }

    @Test
    void testLoadQuestData() {
        assertNotNull(questData);
        assertTrue(questData.has("intro"));
        assertTrue(questData.has("questions"));
    }

    @Test
    void testParseFirstQuestion() {
        JSONArray questions = questData.getJSONArray("questions");
        assertFalse(questions.isEmpty());

        JSONObject firstQuestion = questions.getJSONObject(0);
        assertEquals(1, firstQuestion.getInt("id"));
        assertTrue(firstQuestion.has("text"));
        assertTrue(firstQuestion.has("answers"));
    }

    @Test
    void testQuestTitle() {
        JSONObject intro = questData.getJSONObject("intro");
        assertNotNull(intro.getString("title"));
        assertFalse(intro.getString("title").isEmpty());
    }

    @Test
    void testSessionAttributes() {
        when(session.getAttribute("playerName")).thenReturn("TestPlayer");
        when(session.getAttribute("questName")).thenReturn("TestQuest.json");

        assertEquals("TestPlayer", session.getAttribute("playerName"));
        assertEquals("TestQuest.json", session.getAttribute("questName"));
    }
}
