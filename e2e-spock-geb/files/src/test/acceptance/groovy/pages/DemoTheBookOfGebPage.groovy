package pages

import geb.Page

class DemoTheBookOfGebPage extends Page {
    static at = { title.startsWith("The Book Of Geb") }
}
