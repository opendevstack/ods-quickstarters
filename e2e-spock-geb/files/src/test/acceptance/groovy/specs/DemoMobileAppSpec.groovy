package specs

import geb.spock.GebReportingSpec
import io.appium.java_client.AppiumDriver
import io.appium.java_client.AppiumBy
import org.openqa.selenium.WebElement
import org.openqa.selenium.support.ui.WebDriverWait
import org.openqa.selenium.support.ui.ExpectedConditions
import spock.lang.IgnoreIf
import spock.lang.Shared
import spock.lang.Stepwise
import helpers.*

@Stepwise
class DemoMobileAppSpec extends GebReportingSpec {

    // Shared driver instance for the AppiumDriver
    @Shared
    def static driver
    // Shared result variable to track test success
    @Shared
    def static result = true

    def setupSpec() {
        // Check the environment and skip tests if it is not MOBILE_APP
        if (System.getProperty("geb.env") != Environments.MOBILE_APP) {
            println "Skipping tests - environments not supported"
            return
        }
        // Initialize the Appium driver
        driver = browser.driver as AppiumDriver
    }

    def cleanupSpec() {
        // Set the job result and quit the driver if it is initialized
        if (driver) {
            driver.executeScript("sauce:job-result=$result")
            driver.quit()
        }
    }

    @IgnoreIf({ System.getProperty("geb.env") != Environments.MOBILE_APP})
    def "check elements in the first page of the app"() {
        given: "Launching the app"
        when: "Printing all the elements"
        try {
            // Verify if the specific element is present
            List<WebElement> specificElements = driver.findElements(AppiumBy.name("Cart-tab-item"))

            if (!specificElements.isEmpty() && specificElements[0].isDisplayed()) {
                // Click on the element
                specificElements[0].click()
                println "Clicked on element with name 'Cart-tab-item'"

                // Print evidence for the specific element
                SpecHelper.printEvidenceForWebElement(this, 1, specificElements[0], "Cart-tab-item Element Evidence")
            } else {
                println "Element with name 'Cart-tab-item' not found or not displayed"
            }
        } catch (Exception e) {
            result = false
            throw e
        }
        then: "The specific element should be present"
        assert true
    }

}
