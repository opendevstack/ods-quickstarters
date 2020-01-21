import geb.Page
import geb.spock.GebReportingSpec
import spock.lang.Stepwise

class GoogleInstallationHomePage extends Page {
    static at = { title == "Google" }
}

@Stepwise
class DemoInstallation extends GebReportingSpec {

    def "Go to Google home page"() {
        given: "User goes to the Google home page and checks the title"
        to GoogleInstallationHomePage
    }
}

