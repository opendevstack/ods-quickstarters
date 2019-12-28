import com.gargoylesoftware.htmlunit.BrowserVersion;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

// Load application.properties
def properties = new Properties()
this.getClass().getResource( '/application.properties' ).withInputStream {
    properties.load(it)
}

// Selenium driver (true in constructor enables JavaScript)
driver = { new HtmlUnitDriver(BrowserVersion.CHROME, true) }

// Base URL of the application to test
baseUrl = properties."config.application.url"

// Reports dir
reportsDir = new File(properties."config.reports.dir")

