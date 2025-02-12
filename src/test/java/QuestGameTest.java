import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Paths;

import static org.junit.jupiter.api.Assertions.*;

class QuestGameTest {

    private JSONObject questData;

    @BeforeEach
    void setUp() throws Exception {
        // Загружаем тестовый JSON-файл (имитация файла квеста)
        String jsonText = new String(Files.readAllBytes(Paths.get("src/test/resources/quest_test.json")), "UTF-8");
        questData = new JSONObject(jsonText);
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
}
