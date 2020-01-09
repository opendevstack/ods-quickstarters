import geb.Page
import geb.spock.GebReportingSpec
import spock.lang.Stepwise

class GoogleHomePage extends Page {
    static at = { title == "Google" }
}

@Stepwise
class DemoIntegration extends GebReportingSpec {

    def "Go to Google home page"() {
        given: "User goes to the Google home page and checks the title"
        to GoogleHomePage
    }
}

