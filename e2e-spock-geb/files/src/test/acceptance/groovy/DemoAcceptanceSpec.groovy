import geb.spock.GebReportingSpec
import spock.lang.Stepwise

@Stepwise
class DemoAcceptance extends GebReportingSpec {

    def "basic test"() {
        given: "Example test"
        true == true
    }
}

