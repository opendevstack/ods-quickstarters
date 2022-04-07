import com.gargoylesoftware.htmlunit.BrowserVersion
import com.gargoylesoftware.htmlunit.WebClient
import org.openqa.selenium.htmlunit.HtmlUnitDriver
import org.openqa.selenium.Proxy

// Load application.properties
def properties = new SpecHelper().getApplicationProperties()

// Selenium driver (True in constructor to use JavaScript)
driver = {
    HtmlUnitDriver driver = new HtmlUnitDriver(BrowserVersion.BEST_SUPPORTED, true) {
      @Override
      protected WebClient newWebClient(BrowserVersion version) {
          WebClient webClient = super.newWebClient(version);
          // don't throw on script errors
          webClient.getOptions().setThrowExceptionOnScriptError(false);
          return webClient;
      }
    };

    def env = System.getenv()
    if(env.HTTP_PROXY) {
        Proxy proxy = new Proxy();
        URL url = new URL(env.HTTP_PROXY);
        proxy.setHttpProxy("${url.getHost()}:${url.getPort()}");
        proxy.setNoProxy(env.NO_PROXY)
        driver.setProxySettings(proxy);
    }

    return driver
}

waiting {
    timeout = 25
    retryInterval = 0.5
    includeCauseInMessage = true
    presets {
        slow {
            timeout = 50
            retryInterval = 1
        }
        quick {
            timeout = 10
        }
    }
}

// Base URL of the application to test
baseUrl = properties."config.application.url"

// Reports dir
reportsDir = new File(properties."config.reports.dir")

