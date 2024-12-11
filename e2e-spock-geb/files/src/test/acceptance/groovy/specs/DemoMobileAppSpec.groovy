//package specs
//
//import geb.spock.GebReportingSpec
//import io.appium.java_client.AppiumDriver
//import io.appium.java_client.AppiumBy
//import org.openqa.selenium.WebElement
//import spock.lang.Shared
//import spock.lang.Stepwise
//import helpers.*
//
//@Stepwise
//class DemoMobileAppSpec extends GebReportingSpec {
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
//    def "check elements in the first page of the app"() {
//        given: "Launching the app"
//        when: "Printing all the elements"
//        try {
//            // Verify if the specific element is present
//            List<WebElement> specificElements = driver.findElements(AppiumBy.name("Cart-tab-item"))
//            // Click on the element
//            specificElements[0].click()
//            // Print evidence for the specific element
//            SpecHelper.printEvidenceForWebElement(this, 1, specificElements[0], "Cart-tab-item Element Evidence")
//        } catch (Exception e) {
//            result = false
//            throw e
//        }
//        then: "The specific element should be present"
//        assert true
//    }
//
//}
