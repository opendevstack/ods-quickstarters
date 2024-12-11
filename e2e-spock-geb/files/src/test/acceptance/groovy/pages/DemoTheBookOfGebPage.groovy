package pages

import geb.Page

class DemoTheBookOfGebPage extends Page {
    // Verify that the page title starts with "The Book Of Geb"
    static at = { title.startsWith("The Book Of Geb") }
}
