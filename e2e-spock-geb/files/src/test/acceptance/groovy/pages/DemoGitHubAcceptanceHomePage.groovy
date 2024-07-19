package pages

import geb.Page

class DemoGitHubAcceptanceHomePage extends Page {
    static url = "/opendevstack/ods-quickstarters"
    static at = { title.contains("quickstarters")}
}
