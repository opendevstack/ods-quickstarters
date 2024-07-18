import com.gargoylesoftware.htmlunit.BrowserVersion
import com.gargoylesoftware.htmlunit.WebClient
import helpers.SpecHelper
import io.appium.java_client.android.AndroidDriver
import io.appium.java_client.ios.IOSDriver
import org.openqa.selenium.htmlunit.HtmlUnitDriver
import org.openqa.selenium.Proxy
import org.openqa.selenium.remote.DesiredCapabilities
import org.openqa.selenium.edge.EdgeDriver
import org.openqa.selenium.chrome.ChromeDriver

// Load application.properties
def properties = new SpecHelper().getApplicationProperties()

// Getting SauceLabs environment variables to configure IOs device
def sauceLabsUsername = System.getenv('SAUCE_LABS_USERNAME')
def sauceLabsAccessKey = System.getenv('SAUCE_LABS_ACCESS_KEY')

// These are examples of configuring the URLs to Appium Server in different ways
// Localhost if you are working in your local environment
// SauceLabs connection if you are working with a SauceLabs device
// Both are interchangeable
def androidURL = "http://127.0.0.1:4723"
def iosURL = "https://$sauceLabsUsername:$sauceLabsAccessKey@ondemand.eu-central-1.saucelabs.com:443/wd/hub"

// Creating test environments
// Please, configure the test environments properly, replacing the indicated values ("REPLACE...")
// Feel free to remove/add as test environments as you need
environments {

    defaultDriver {
        driver = {
            HtmlUnitDriver driver = new HtmlUnitDriver(BrowserVersion.BEST_SUPPORTED, true) {
                @Override
                protected WebClient newWebClient(BrowserVersion version) {
                    WebClient webClient = super.newWebClient(version);
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
    }

    chrome {
        driver = {
            System.setProperty("webdriver.chrome.driver", "REPLACE with your chrome driver path")
            ChromeDriver driver = new ChromeDriver()

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
    }

    edge {
        driver = {
            System.setProperty("webdriver.edge.driver", "REPLACE with your edge driver path")

            EdgeDriver driver = new EdgeDriver()
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
    }

    android {
        driver = {
            DesiredCapabilities capabilities = new DesiredCapabilities()
            capabilities.setCapability("platformName", "Android")
            capabilities.setCapability("deviceName", "REPLACE with your device name")
            capabilities.setCapability("app", "REPLACE with your application mobile path")
            capabilities.setCapability("browserVersion", "REPLACE with your android version");
            capabilities.setCapability("automationName", "UiAutomator2");
            capabilities.setCapability("autoGrantPermissions", "true");
            AndroidDriver driver = new AndroidDriver(new URL(androidURL), caps);
            return driver
        }
    }

    ios {
        driver = {
            DesiredCapabilities capabilities = new DesiredCapabilities()
            capabilities.setCapability("platformName", "iOS")
            capabilities.setCapability("deviceName", "REPLACE with your device name")
            capabilities.setCapability("app", "REPLACE with your application mobile path")
            capabilities.setCapability("browserName", "REPLACE with your browser name");
            capabilities.setCapability("browserVersion", "REPLACE with your browser version");
            capabilities.setCapability("automationName", "XCUITest");
            capabilities.setCapability("autoGrantPermissions", "true");
            IOSDriver driver = new IOSDriver(new URL(iosURL), caps);
            return driver
        }
    }
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

