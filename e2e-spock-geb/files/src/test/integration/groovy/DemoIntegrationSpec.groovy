import geb.spock.GebReportingSpec
import spock.lang.Stepwise

@Stepwise
class DemoIntegration extends GebReportingSpec {

    def "basic test"() {
        given: "Example test"
        true == true
    }
}

