import geb.Page
import geb.spock.GebReportingSpec
import spock.lang.Stepwise

class W3CAcceptanceHomePage extends Page {
    static url = "/html/tryit.asp?filename=tryhtml_basic_paragraphs"
    static at = { title == "Tryit Editor v3.6" }
}

@Stepwise
class DemoAcceptance extends GebReportingSpec {

    def "goes to W3C editor"() {
        given: "User goes to we3 editor for paragraphs and checks the content"
        to W3CAcceptanceHomePage
        sleep (2000)
        // print evidence of two fields (the input area and iframe content)
        SpecHelper.printEvidenceForPageElement(this, 1, $("#textareaCode"), "code area")
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
