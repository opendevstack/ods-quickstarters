import geb.spock.GebReportingSpec
import spock.lang.Stepwise
import spock.lang.Tag

@Stepwise
class DemoInstallationSpec extends GebReportingSpec {

    @Tag("empty")
    def "basic test"() {
        given: "Example test"
        true == true
    }
}

