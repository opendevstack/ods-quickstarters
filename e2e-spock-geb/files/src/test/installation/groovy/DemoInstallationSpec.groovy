import geb.spock.GebReportingSpec
import spock.lang.Stepwise
import spock.lang.Tag

@Stepwise
class DemoInstallationSpec extends GebReportingSpec {

    def "basic test"() {
        given: "Example test"
        true == true
    }
}

