import geb.spock.GebReportingSpec
import helpers.Environments
import spock.lang.IgnoreIf
import spock.lang.Stepwise

@Stepwise
class DemoInstallationSpec extends GebReportingSpec {

    def setupSpec() {
        // Check the environment and skip tests if necessary
        if (System.getProperty("geb.env") != Environments.DESKTOP) {
            println "Skipping tests - environments not supported"
            return
        }
    }

    @IgnoreIf({ System.getProperty("geb.env") != Environments.DESKTOP })
    def "basic test"() {
        given: "Example test"
        true == true
    }
}

