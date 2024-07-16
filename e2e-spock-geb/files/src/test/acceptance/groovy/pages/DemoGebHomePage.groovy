package pages

import geb.Page
import modules.DemoManualsMenuModule

class DemoGebHomePage extends Page {
    static url = "https://gebish.org"

    static at = { title == "Geb - Very Groovy Browser Automation" }

    static content = {
        manualsMenu { module(DemoManualsMenuModule) }
    }

}
