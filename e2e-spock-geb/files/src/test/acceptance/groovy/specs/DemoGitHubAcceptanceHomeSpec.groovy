package specs

import geb.spock.GebReportingSpec
import helpers.SpecHelper
import pages.DemoGitHubAcceptanceHomePage
import spock.lang.Stepwise

@Stepwise
class DemoGitHubAcceptanceHomeSpec extends GebReportingSpec {

    def gitHubAcceptanceHomePage = page(DemoGitHubAcceptanceHomePage)

    def "goes to GH ods-quickstarters"() {
        given: "User goes to ods-quickstarters and checks the content"
        to gitHubAcceptanceHomePage

        // print evidence of two fields (the input area and iframe content)
        SpecHelper.printEvidenceForPageElement(this, 1, $("[data-content='Code']"), "code area")
        SpecHelper.printEvidenceForPageElement(this, 1, $("#iframecontainer"), "rendered code area")

        // print the two evidence fields through map
        SpecHelper.printEvidenceForPageElements(this, 1,
            [
                [ 'fragment' : $("#textareaCode"), 'description' : 'code area'],
                [ 'fragment' : $("#iframecontainer"), 'description' : 'rendered code area']
            ]
        )
    }
}
