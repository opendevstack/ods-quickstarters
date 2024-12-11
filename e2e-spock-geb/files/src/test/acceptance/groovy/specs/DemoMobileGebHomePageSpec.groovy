//package specs
//
//import geb.spock.GebReportingSpec
//import io.appium.java_client.AppiumDriver
//import org.openqa.selenium.WebElement
//import spock.lang.Shared
//import spock.lang.Stepwise
//import helpers.*
//
//@Stepwise
//class DemoMobileGebHomePageSpec extends GebReportingSpec {
//
//    // Shared driver instance for the AppiumDriver
//    @Shared
//    def static driver
//    // Shared result variable to track test success
//    @Shared
//    def static result = true
//
//    def setupSpec() {
//        // Initialize the Appium driver
//        driver = browser.driver as AppiumDriver
//    }
//
//    def cleanupSpec() {
//        // Set the job result and quit the driver if it is initialized
//        if (driver) {
//            driver.executeScript("sauce:job-result=$result")
//            driver.quit()
//        }
//    }
//
//    def "verify geb home page and documentation navigation"() {
//        when: "Navigating to Geb home page"
//        try {
//            // Open the Geb home page
//            driver.get("https://www.gebish.org")
//        } catch (AssertionError e) {
//            result = false
//            throw e
//        }
//
//        then: "The page title should be 'Geb - Very Groovy Browser Automation'"
//        try {
//            // Verify the page title
//            assert title == "Geb - Very Groovy Browser Automation"
//        } catch (AssertionError e) {
//            result = false
//            throw e
//        }
//
//        when: "Accessing to the Documentation page"
//        try {
//            // Wait for the Documentation button to be displayed and click it
//            waitFor { $("button.ui.blue.button", text: "Documentation").displayed }
//            WebElement documentationButton = $("button.ui.blue.button", text: "Documentation").firstElement()
//            documentationButton.click()
//
//            // Print evidence for the Documentation button
//            SpecHelper.printEvidenceForWebElement(this, 1, documentationButton, "Documentation Button Evidence")
//        } catch (AssertionError e) {
//            result = false
//            throw e
//        }
//
//        then: "The page title should be 'The Book Of Geb'"
//        try {
//            // Verify the page title
//            assert title.contains("The Book Of Geb") == "The Book Of Geb"
//        } catch (AssertionError e) {
//            result = false
//            throw e
//        }
//    }
//
//}
