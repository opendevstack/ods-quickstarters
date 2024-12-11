import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIf;

public class DemoInstallationTest {

    @Test
    @EnabledIf("customCondition")
    void basicTest() {
        // Assert that the condition is true
        Assertions.assertTrue(true);
    }

    boolean customCondition() {
        // Implement your custom condition logic here
        return false;
    }

}
