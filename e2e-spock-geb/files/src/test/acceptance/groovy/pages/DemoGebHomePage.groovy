package pages

import geb.Page
import modules.DemoManualMenuModule

class DemoGebHomePage extends Page {
    // URL of the Geb home page
    static url = "https://gebish.org"

    // Condition to verify that the browser is at the correct page
    static at = { title == "Geb - Very Groovy Browser Automation" }

    static content = {
        // Define the manuals menu module
        manualsMenu { module(DemoManualMenuModule) }
    }
}
