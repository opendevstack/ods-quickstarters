package specs

import geb.spock.GebReportingSpec
import helpers.SpecHelper
import pages.DemoGebHomePage
import pages.DemoTheBookOfGebPage

class DemoGebHomePageSpec extends GebReportingSpec {

    def gebHomePage = page(DemoGebHomePage)
    def theBookOfGebPage = page(DemoTheBookOfGebPage)

    def setup() {
        System.setProperty("geb.env", "defaultDriver")
    }

    def "can access The Book of Geb via homepage"() {
        given:
        to gebHomePage

        when:
        SpecHelper.printEvidenceForPageElement(this, 1, $("manuals-menu"), "Manuals menu exists")
        gebHomePage.manualsMenu.open()
        SpecHelper.printEvidenceForPageElement(this, 1, $("a", xpath: '//*[@id=\"manuals-menu\"]/div/a[1]'), "Current version submenu exists")
        gebHomePage.manualsMenu.links[0].click()

        then:
        at theBookOfGebPage
    }
}
