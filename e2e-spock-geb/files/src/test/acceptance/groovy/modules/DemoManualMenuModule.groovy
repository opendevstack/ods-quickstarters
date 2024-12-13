package modules

class DemoManualMenuModule extends geb.Module {
    static content = {
        // Define the toggle element for the manuals menu
        toggle { $("div.menu a.manuals") }

        // Define the container for the links in the manuals menu
        linksContainer { $("#manuals-menu") }

        // Define the links within the links container
        links { linksContainer.find("a") }
    }

    // Method to open the manuals menu
    void open() {
        toggle.click()
        // Wait until the links container is no longer animating
        waitFor { !linksContainer.hasClass("animating") }
    }
}
