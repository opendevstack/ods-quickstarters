import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIf;

public class DemoAcceptanceTest {

    @Test
    @EnabledIf("customCondition")
    void basicTest() {
        // Assert that the condition is true
        Assertions.assertTrue(true);
    }

    boolean customCondition() {
        // Custom condition logic to determine if the test should be enabled
        return false;
    }

}
