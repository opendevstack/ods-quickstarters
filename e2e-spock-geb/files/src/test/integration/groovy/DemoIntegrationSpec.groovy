import geb.spock.GebReportingSpec
import spock.lang.Stepwise
import spock.lang.Tag

@Stepwise
class DemoIntegrationSpec extends GebReportingSpec {

    @Tag("empty")
    def "basic test"() {
        given: "An example test scenario"
        // This is a placeholder assertion for demonstration purposes
        true == true
    }
}
