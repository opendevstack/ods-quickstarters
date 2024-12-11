package specs

import geb.spock.GebReportingSpec
import pages.DemoGebHomePage
import pages.DemoTheBookOfGebPage
import spock.lang.IgnoreIf
import helpers.*

class DemoGebHomePageSpec extends GebReportingSpec {

    // Define page objects for the home page and the book page
    def gebHomePage = page(DemoGebHomePage)
    def theBookOfGebPage = page(DemoTheBookOfGebPage)

    def setupSpec() {
        // Check the environment and skip tests if it is not DESKTOP
        if (System.getProperty("geb.env") != Environments.DESKTOP) {
            println "Skipping tests - environments not supported"
            return
        }
    }

    @IgnoreIf({ System.getProperty("geb.env") != Environments.DESKTOP })
    def "can access The Book of Geb via homepage"() {
        given:
        // Navigate to the Geb home page
        to gebHomePage

        when:
        // Open the manuals menu and click the first link
        gebHomePage.manualsMenu.open()
        gebHomePage.manualsMenu.links[0].click()

        // Print evidence of the introduction header element
        SpecHelper.printEvidenceForPageElement(this, 1, $("#introduction"), "Introduction header")

        // Print evidence of the first and second paragraphs
        SpecHelper.printEvidenceForPageElements(this, 1,
            [
                [ 'fragment' : $("#content > div:nth-child(2) > div > div:nth-child(1)"), 'description' : '1st paragraph'],
                [ 'fragment' : $("#content > div:nth-child(2) > div > div:nth-child(2)"), 'description' : '2nd paragraph']
            ]
        )

        then:
        // Verify that the browser is at the book page
        at theBookOfGebPage
    }
}
