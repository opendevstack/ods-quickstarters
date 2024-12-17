import com.gargoylesoftware.htmlunit.BrowserVersion
import com.gargoylesoftware.htmlunit.WebClient
import io.appium.java_client.android.AndroidDriver
import io.appium.java_client.ios.IOSDriver
import org.openqa.selenium.MutableCapabilities
import org.openqa.selenium.htmlunit.HtmlUnitDriver
import org.openqa.selenium.Proxy
import helpers.*

// Load application properties from application.properties file
def properties = new SpecHelper().getApplicationProperties()

// Get SauceLabs environment variables for configuring iOS device
def sauceLabsUsername = System.getenv('SAUCE_LABS_USERNAME')
def sauceLabsAccessKey = System.getenv('SAUCE_LABS_ACCESS_KEY')

environments {

    // Configuration for desktop environment using HtmlUnitDriver
    "${Environments.DESKTOP}" {
        driver = {
            HtmlUnitDriver driver = new HtmlUnitDriver(BrowserVersion.BEST_SUPPORTED, true) {
                @Override
                protected WebClient newWebClient(BrowserVersion version) {
                    WebClient webClient = super.newWebClient(version)
                    webClient.getOptions().setThrowExceptionOnScriptError(false)
                    webClient.getOptions().setCssEnabled(false)
                    return webClient
                }
            }
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

    // Configuration for mobile browser environment using AndroidDriver
    "${Environments.MOBILE_BROWSER}" {
        driver = {
            MutableCapabilities caps = new MutableCapabilities()
            caps.setCapability("platformName", "Android")
            caps.setCapability("browserName", "Chrome")
            caps.setCapability("appium:deviceName", "Google Pixel 7a GoogleAPI Emulator")
            caps.setCapability("appium:platformVersion", "13.0")
            caps.setCapability("appium:automationName", "UiAutomator2")
            MutableCapabilities sauceOptions = new MutableCapabilities()
            sauceOptions.setCapability("appiumVersion", "2.11.0")
            sauceOptions.setCapability("username", sauceLabsUsername)
            sauceOptions.setCapability("accessKey", sauceLabsAccessKey)
            sauceOptions.setCapability("build", "<your build id>")
            sauceOptions.setCapability("name", "<MOBILE_BROWSER test name>")
            sauceOptions.setCapability("deviceOrientation", "PORTRAIT")
            caps.setCapability("sauce:options", sauceOptions)
            URL url = new URL("https://ondemand.eu-central-1.saucelabs.com:443/wd/hub")
            AndroidDriver driver = new AndroidDriver(url, caps)
            return driver
        }
    }

    // Configuration for mobile app environment using IOSDriver
    "${Environments.MOBILE_APP}" {
        driver = {
            MutableCapabilities caps = new MutableCapabilities()
            caps.setCapability("platformName", "iOS")
            caps.setCapability("appium:app", "storage:filename=SauceLabs-Demo-App.Simulator.XCUITest.zip")  // The filename of the mobile app
            caps.setCapability("appium:deviceName", "iPhone Simulator")
            caps.setCapability("appium:platformVersion", "17.0")
            caps.setCapability("appium:automationName", "XCUITest")
            MutableCapabilities sauceOptions = new MutableCapabilities()
            sauceOptions.setCapability("appiumVersion", "2.1.3")
            sauceOptions.setCapability("username", sauceLabsUsername)
            sauceOptions.setCapability("accessKey", sauceLabsAccessKey)
            sauceOptions.setCapability("build", "<your build id>")
            sauceOptions.setCapability("name", "<MOBILE_APP test name>")
            sauceOptions.setCapability("deviceOrientation", "PORTRAIT")
            caps.setCapability("sauce:options", sauceOptions)
            URL url = new URL("https://ondemand.eu-central-1.saucelabs.com:443/wd/hub")
            IOSDriver driver = new IOSDriver(url, caps)
            return driver
        }
    }
}

// Configure waiting settings
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

// Set the base URL of the application to test
baseUrl = properties."config.application.url"

// Set the directory for storing reports
reportsDir = new File(properties."config.reports.dir")
