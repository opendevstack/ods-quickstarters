# Spock & Geb end-to-end tests

This end-to-end testing project was generated from the *e2e-spock-geb* ODS quickstarter.

## Description

This QuickStarter integrates three powerful tools: Spock, Geb, and Appium, each serving a unique purpose in the realm of testing and automation.

Spock is a dynamic and comprehensive testing and specification framework designed specifically for Java and Groovy.
It allows for clear and concise testing, making it easier to write and understand tests.

Geb, on the other hand, is a robust solution for browser automation.
It caters to functional, web, and acceptance testing, providing a seamless way to automate browser interactions.

Appium is a versatile platform for automating mobile testing.
It supports a wide range of languages and testing frameworks, making it a go-to solution for mobile application testing.

The purpose of this QuickStarter is to provide a customized, integrated environment that leverages the strengths of these three tools.
It simplifies the setup process, allowing you to focus on writing and executing tests.
It's designed to accelerate your testing efforts, improve efficiency, and ultimately, help deliver high-quality software.

## Project Organization

The project is structured as follows:

The `src/test` directory contains all the tests, which are further divided into `acceptance`, `installation`, and `integration` subdirectories.
These directories accommodate tests written in both `groovy` and `java`. The classes are organized in a structured manner,
with designated spaces for `modules`, `pages`, and `specs`.

In addition to these, within the src/test directory, there is a resources section. Here, you will find important configuration files such as `application.properties` and `GebConfig.groovy`.
These resources are crucial for the configuration and efficient operation of the project.

Also within the `src/test` directory, you will find a `helpers` folder. This folder contains the `SpecHelper.groovy` file, which includes several functions designed to assist you in your development process, such as functions for capturing evidence, and the `Environments.groovy` to define the different environments in which the tests can be executed.

## Working with GebConfig.groovy

The `GebConfig.groovy` file is a configuration file used by Geb for browser automation. It allows you to define various environments and set up different drivers for testing.

### Application Properties
Loading Application Properties: This section loads the application properties using the SpecHelper class.
```
// Load application.properties
def properties = new SpecHelper().getApplicationProperties()
```

### SauceLabs
SauceLabs Environment Variables: If you're using SauceLabs for testing, these environment variables are used to configure the iOS device.
Please note that a SauceLabs account is a prerequisite for this process.
```
// Getting SauceLabs environment variables to configure IOs device
def sauceLabsUsername = System.getenv('SAUCE_LABS_USERNAME')
def sauceLabsAccessKey = System.getenv('SAUCE_LABS_ACCESS_KEY')
...
ios {
driver = {
...
IOSDriver driver = new IOSDriver(new URL("https://$sauceLabsUsername:$sauceLabsAccessKey@ondemand.eu-central-1.saucelabs.com:443/wd/hub"), caps);
return driver
}
```

### Environments

This section defines different environments such as DESKTOP, MOBILE_BROWSER, and MOBILE_APP. Each environment has its own driver setup.

These environments are dedicated to browser testing: 
	DESKTOP - This environment uses the HtmlUnitDriver for headless browser testing.
	MOBILE_BROWSER - This environment uses the AndroidDriver for testing on mobile browsers.
And this environment is dedicated to mobile app testing:  
  MOBILE_APP - This environment uses the IOSDriver for testing on iOS mobile applications.

* Desktop Environment - The DESKTOP environment is configured to use the HtmlUnitDriver:
		```
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
        return driver
			}
		}
		```
* Mobile Browser Environment - The MOBILE_BROWSER environment is configured to use the AndroidDriver:
  ```
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
	```
* Mobile App Environment - The MOBILE_APP environment is configured to use the IOSDriver:  
  ```
	"${Environments.MOBILE_APP}" {
    driver = {
        MutableCapabilities caps = new MutableCapabilities()
        caps.setCapability("platformName", "iOS")
        caps.setCapability("appium:app", "storage:filename=SauceLabs-Demo-App.Simulator.XCUITest.zip")
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
	```

### Base URL

This refers to the root URL of the application under test. Please modify config.application.url in the 'application.properties' file, located within 'src\test\resources'.

    ```baseUrl = properties."config.application.url"```

### Reports Directory

This is the directory where the Geb reports will be stored.  Please modify config.reports.dir in the 'application.properties' file, located within 'src\test\resources'.

    ```reportsDir = new File(properties."config.reports.dir")```

## Test example

This project is structured with different sections for `pages`, `modules`, and `specs`. Here is a walkthrough of how they interact:

### Pages Section
In this section, we have the `DemoGebHomePage` class which defines the home page, https://gebish.org.
This class includes the title of the page and some of its content, specifically the `manuals` menu.
There is a second web page defined called DemoTheBookOfGebPage, which can be accessed through the 'manuals' menu.
	```
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
	```

### Modules Section
The `manuals` menu from the home page is defined as a module in this section.
	```
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
	```
	
### Specs Section

#### Gebish.org example - for DESKTOP

The test that utilizes these pages and modules is located in the `specs` section and is called `DemoGebHomePageSpec`.

**Setup** - In the `DemoGebHomePageSpec` test, the `def setupSpec()` method is used to check the environment and skips tests if it is not DESKTOP.

**Test Case** - The test case `can access The Book of Geb via homepage` is defined in this test. This test case simply accesses the `gebHomePage` and then accesses the `theBookOfGebPage` by opening the `manualsMenu` module.

**Evidence Collection** - During the process of executing this test, multiple pieces of evidence are collected.
	```
	package specs
  
  import geb.spock.GebReportingSpec
  import helpers.SpecHelper
  import pages.DemoGebHomePage
  import pages.DemoTheBookOfGebPage
  import spock.lang.IgnoreIf
  import helpers.*
  
  class DemoGebHomePageSpec extends GebReportingSpec {
  
    def gebHomePage = page(DemoGebHomePage)
    def theBookOfGebPage = page(DemoTheBookOfGebPage)
  
    def setupSpec() {
      if (System.getProperty("geb.env") != Environments.DESKTOP) {
        println "Skipping tests - environments not supported"
        return
      }
    }
  
    @IgnoreIf({ System.getProperty("geb.env") != Environments.DESKTOP })
    def "can access The Book of Geb via homepage"() {
      given:
      to gebHomePage
  
      when:
      gebHomePage.manualsMenu.open()
      gebHomePage.manualsMenu.links[0].click()
  
      SpecHelper.printEvidenceForPageElement(this, 1, $("#introduction"), "Introduction header")
      SpecHelper.printEvidenceForPageElements(this, 1,
        [
          [ 'fragment' : $("#content > div:nth-child(2) > div > div:nth-child(1)"), 'description' : '1st paragraph'],
          [ 'fragment' : $("#content > div:nth-child(2) > div > div:nth-child(2)"), 'description' : '2nd paragraph']
        ]
      )
  
      then:
      at theBookOfGebPage
    }
  }
	```
	
#### Gebish.org example - for MOBILE_BROWSER
The test that utilizes these elements is located in the `specs` section and is called `DemoMobileGebHomePageSpec`.

**Setup** - In the `DemoMobileGebHomePageSpec` test, the `def setupSpec()` method is used to check the environment and skips tests if it is not MOBILE_BROWSER, and initialize the Appium driver.

**Test Case** - The test case ` verify geb home page and documentation navigation` is defined in this test. This test case navigates to the Geb home page and then accesses the Documentation page.

**Evidence Collection** - During the process of executing this test, evidence is collected.
  ```
  package specs
  
  import geb.spock.GebReportingSpec
  import io.appium.java_client.AppiumDriver
  import org.openqa.selenium.WebElement
  import spock.lang.Shared
  import spock.lang.Stepwise
  import spock.lang.IgnoreIf
  import helpers.*
  
  @Stepwise
  class DemoMobileGebHomePageSpec extends GebReportingSpec {

    // Shared driver instance for the AppiumDriver
    @Shared
    def static driver
    // Shared result variable to track test success
    @Shared
    def static result = true

    def setupSpec() {
      // Check the environment and skip tests if it is not MOBILE_BROWSER
      if (System.getProperty("geb.env") != Environments.MOBILE_BROWSER) {
        println "Skipping tests - environments not supported"
        return
      }

      // Initialize the Appium driver
      driver = browser.driver as AppiumDriver
    }

    def cleanupSpec() {
      // Set the job result and quit the driver if it is initialized
      if (driver) {
        driver.executeScript("sauce:job-result=$result")
        driver.quit()
      }
    }

    @IgnoreIf({ System.getProperty("geb.env") != Environments.MOBILE_BROWSER })
    def "verify geb home page and documentation navigation"() {
      when: "Navigating to Geb home page"
      try {
        // Open the Geb home page
        driver.get("https://www.gebish.org")
      } catch (AssertionError e) {
        result = false
        throw e
      }

      then: "The page title should be 'Geb - Very Groovy Browser Automation'"
      try {
        // Verify the page title
        assert title == "Geb - Very Groovy Browser Automation"
      } catch (AssertionError e) {
        result = false
        throw e
      }

      when: "Accessing to the Documentation page"
      try {
        // Wait for the Documentation button to be displayed and click it
        waitFor { $("button.ui.blue.button", text: "Documentation").displayed }
        WebElement documentationButton = $("button.ui.blue.button", text: "Documentation").firstElement()
        documentationButton.click()

        // Print evidence for the Documentation button
        SpecHelper.printEvidenceForWebElement(this, 1, documentationButton, "Documentation Button Evidence")
      } catch (AssertionError e) {
        result = false
        throw e
      }

      then: "The page title should be 'The Book Of Geb'"
      try {
        // Verify the page title
        assert title == "The Book Of Geb"
      } catch (AssertionError e) {
        result = false
        throw e
      }
    }

	}
	```
#### My Demo App Sauce Labs example - for MOBILE_APP
The test that utilizes these elements is located in the `specs` section and is called `DemoMobileGebHomePageSpec`.

**Setup** - In the `DemoMobileAppSpec` test,  the `def setupSpec()` method is used to check the environment and skips tests if it is not MOBILE_APP, and initialize the Appium driver

**Test Case** - The test case `check elements in the first page of the app` is defined in this test. This test case verifies the presence of a specific element and interacts with it.

**Evidence Collection** - During the process of executing this test, evidence is collected for the specific element.

```
	package specs

  import geb.spock.GebReportingSpec
  import io.appium.java_client.AppiumDriver
  import io.appium.java_client.AppiumBy
  import org.openqa.selenium.WebElement
  import spock.lang.IgnoreIf
  import spock.lang.Shared
  import spock.lang.Stepwise
  import helpers.*
  
  @Stepwise
  class DemoMobileAppSpec extends GebReportingSpec {

    // Shared driver instance for the AppiumDriver
    @Shared
    def static driver
    // Shared result variable to track test success
    @Shared
    def static result = true

    def setupSpec() {
      // Check the environment and skip tests if it is not MOBILE_APP
      if (System.getProperty("geb.env") != Environments.MOBILE_APP) {
        println "Skipping tests - environments not supported"
        return
      }
      // Initialize the Appium driver
      driver = browser.driver as AppiumDriver
    }

    def cleanupSpec() {
      // Set the job result and quit the driver if it is initialized
      if (driver) {
        driver.executeScript("sauce:job-result=$result")
        driver.quit()
      }
    }

    @IgnoreIf({ System.getProperty("geb.env") != Environments.MOBILE_APP})
    def "check elements in the first page of the app"() {
      given: "Launching the app"
      when: "Printing all the elements"
      try {
        // Verify if the specific element is present
        List<WebElement> specificElements = driver.findElements(AppiumBy.name("Cart-tab-item"))

        if (!specificElements.isEmpty() && specificElements[0].isDisplayed()) {
          // Click on the element
          specificElements[0].click()
          println "Clicked on element with name 'Cart-tab-item'"
					
          // Print evidence for the specific element
          SpecHelper.printEvidenceForWebElement(this, 1, specificElements[0], "Cart-tab-item Element Evidence")
        } else {
          println "Element with name 'Cart-tab-item' not found or not displayed"
        }
      } catch (Exception e) {
        result = false
        throw e
      }
      then: "The specific element should be present"
      assert true
    }

  }
  ```

## Running end-to-end tests

Run `gradlew test` to execute all end-to-end tests against the test instance of the front end.

## Links

* [gradle](https://gradle.org/)
* [spock](http://spockframework.org/)
* [geb](https://gebish.org/)
* [unirest](http://unirest.io/)
* [apium](https://appium.io/)
