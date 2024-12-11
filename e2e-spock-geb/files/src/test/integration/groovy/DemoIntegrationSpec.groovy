import geb.spock.GebReportingSpec
import helpers.Environments
import spock.lang.IgnoreIf
import spock.lang.Stepwise

@Stepwise
class DemoIntegrationSpec extends GebReportingSpec {

    def setupSpec() {
        // Check the environment and skip tests if it is not DESKTOP
        if (System.getProperty("geb.env") != Environments.DESKTOP) {
            println "Skipping tests - environments not supported"
            return
        }
    }

    @IgnoreIf({ System.getProperty("geb.env") != Environments.DESKTOP })
    def "basic test"() {
        given: "An example test scenario"
        // This is a placeholder assertion for demonstration purposes
        true == true
    }
}
