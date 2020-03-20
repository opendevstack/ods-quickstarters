import geb.Page
import geb.spock.GebReportingSpec
import spock.lang.Stepwise

class GoogleAcceptanceHomePage extends Page {
    static at = { title == "Google" }
}

@Stepwise
class DemoAcceptance extends GebReportingSpec {

    def "Go to Google home page"() {
        given: "User goes to the Google home page and checks the title"
        to GoogleAcceptanceHomePage
    }
}

