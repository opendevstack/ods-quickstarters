package specs

import geb.Browser
import geb.spock.GebReportingSpec
import helpers.SpecHelper
import org.openqa.selenium.By
import org.openqa.selenium.WebElement
import spock.lang.Stepwise

@Stepwise
class DemoGoogleKeepSpec extends GebReportingSpec {

    static Browser browser

    def setupSpec() {
        System.setProperty("geb.env", "android")
        browser = new Browser()
    }

    def cleanupSpec() {
        browser.driver.quit()
    }

    // This is a demo test for Google Keep apk
    // Please, ensure your android test environment is properly configured before uncommenting the lines below
    // In README file, Google Keep example subsection, you will find the necessary steps to configure the environment locally.
    //def "Open Google Keep and press Start button"() {
    //    when: "Google Keep is opened"
    //    browser.driver.activateApp('com.google.android.keep')
    //
    //    then: "Press the Start button"
    //    SpecHelper.printEvidenceForMobileElement(this, 1, By.className("android.widget.Button"), "Current version submenu exists")
    //    List<WebElement> startButton = browser.driver.findElements(By.className("android.widget.Button"))
    //    if (!startButton.isEmpty()) {
    //        startButton.get(0).click()
    //    }
    //    List<WebElement> buttons = browser.driver.findElements(By.className("android.widget.Button"))
    //    assert !buttons.isEmpty()
    //}

}
