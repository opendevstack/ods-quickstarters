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
        // Set the Sauce Labs result to true, indicating that the test passed successfully
        setTrueResultForSauceLabs()
    }

}
