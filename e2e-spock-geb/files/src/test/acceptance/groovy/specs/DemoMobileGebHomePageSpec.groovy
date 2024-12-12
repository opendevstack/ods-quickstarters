package specs

import geb.spock.GebReportingSpec
import io.appium.java_client.AppiumDriver
import org.openqa.selenium.WebElement
import spock.lang.Shared
import spock.lang.Stepwise
import spock.lang.Tag
import helpers.SpecHelper

@Stepwise
class DemoMobileGebHomePageSpec extends GebReportingSpec {

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

    // Add this @Tag to include this test in the 'test_mobile_browser' group.
    // This tag ensures the test runs in the Environment.MOBILE_BROWSER configuration.
    @Tag("test_mobile_browser")
    def "verify geb home page and documentation navigation"() {
        when: "Navigating to Geb home page"
        // Open the Geb home page
        driver.get("https://www.gebish.org")
        then: "The page title should be 'Geb - Very Groovy Browser Automation'"
        // Verify the page title
        assert title == "Geb - Very Groovy Browser Automation"
        when: "Accessing to the Documentation page"
        // Wait for the Documentation button to be displayed and click it
        waitFor { $("button.ui.blue.button", text: "Documentation").displayed }
        WebElement documentationButton = $("button.ui.blue.button", text: "Documentation").firstElement()
        documentationButton.click()

        // Print evidence for the Documentation button
        SpecHelper.printEvidenceForWebElement(this, 1, documentationButton, "Documentation Button Evidence")
        then: "The page title should be 'The Book Of Geb'"
        // Verify the page title
        assert title == "The Book Of Geb"
        // Set the job result to true if the assertion passes
        (result = true) != null
    }

}
