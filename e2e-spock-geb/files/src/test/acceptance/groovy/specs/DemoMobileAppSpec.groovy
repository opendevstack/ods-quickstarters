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
    // Shared result variable to track test success
    @Shared
    def static result = false

    def setupSpec() {
        // Initialize the Appium driver
        driver = browser.driver as AppiumDriver
    }
    def cleanupSpec() {
        // Quit the driver if it is initialized
        driver.quit()
    }
    def setup() {
        // Set the job result to false
        result = false
    }
    def cleanup() {
        // Set the job result in Sauce Labs
        driver.executeScript("sauce:job-result=$result")
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

        // Set the job result to true if the assertion passes
        (result = true) != null
    }

}
