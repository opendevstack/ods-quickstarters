import geb.Page
import geb.spock.GebReportingSpec
import spock.lang.Stepwise

class GitHubAcceptanceHomePage extends Page {
    static url = "/opendevstack/ods-quickstarters"
    static at = { title.contains("quickstarters")}
}

@Stepwise
class DemoAcceptance extends GebReportingSpec {

    def "goes to GH ods-quickstarters"() {
        given: "User goes to ods-quickstarters and checks the content"
        to GitHubAcceptanceHomePage

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
