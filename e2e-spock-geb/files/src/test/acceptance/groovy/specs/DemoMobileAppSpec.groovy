package specs

import geb.spock.GebReportingSpec
import io.appium.java_client.AppiumDriver
import io.appium.java_client.AppiumBy
import org.openqa.selenium.WebElement
import spock.lang.Shared
import spock.lang.Stepwise
import spock.lang.Tag
import helpers.SpecHelper

@Stepwise
class DemoMobileAppSpec extends GebReportingSpec {

    // Shared driver instance for the AppiumDriver
    @Shared
    def static driver
    // Shared variable to indicate the success of the test for Sauce Labs
    @Shared
    def static sauceLabsResult = false

    def setupSpec() {
        // Initialize the Appium driver
        driver = browser.driver as AppiumDriver
    }
    def cleanupSpec() {
        // Quit the driver if it is initialized
        driver.quit()
    }
    def setup() {
        // Initialize the Sauce Labs result to false
        sauceLabsResult = false
    }
    def cleanup() {
        // Set the job result in
        driver.executeScript("sauce:job-result=$sauceLabsResult")
    }

    // This function sets the Sauce Labs result to true, indicating that the test passed successfully.
    // We use this variable to inform Sauce Labs about the test results, storing whether there were any failures.
    // By setting it to true at the end of each test, we ensure that Sauce Labs is updated with the correct test status.
    def setTrueResultForSauceLabs() {
        (sauceLabsResult = true) != null
    }

    // Add this @Tag to include this test in the 'test_mobile_app' group.
    // This tag ensures the test runs in the Environment.MOBILE_APP configuration.
    @Tag("test_mobile_app")
    def "check elements in the first page of the app"() {
        given: "Launching the app"
        when: "Printing all the elements"
        // Verify if the specific element is present
        List<WebElement> specificElements = driver.findElements(AppiumBy.name("Cart-tab-item"))

        then: "The specific element should be present"
        assert specificElements != null && !specificElements.isEmpty()
        assert specificElements[0] != null

        // Click on the element
        specificElements[0].click()
        // Print evidence for the specific element
        SpecHelper.printEvidenceForWebElement(this, 1, specificElements[0], "Cart-tab-item Element Evidence")

        // Set the Sauce Labs result to true, indicating that the test passed successfully
        setTrueResultForSauceLabs()
    }

}
