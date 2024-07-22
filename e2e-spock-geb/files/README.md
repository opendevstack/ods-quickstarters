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

Also within the `src/test` directory, you will find a `helpers` folder. This folder contains the `SpecHelper.groovy` file, which includes several functions designed to assist you in your development process, such as functions for capturing evidence.

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

This section defines different environments such as defaultDriver, chrome, edge, android, and ios. Each environment has its own driver setup.

These three environments are dedicated to browser:
* defaultDriver - This driver is ready to use.
* chrome - To use this driver you must replace this system property:  
  ```System.setProperty("webdriver.chrome.driver", "replace by your chrome driver path")```
* edge - To use this driver you must replace this system property:  
  ```System.setProperty("webdriver.edge.driver", "replace by your edge driver path")```

And these other two are dedicated to mobile:
* android - To use this driver you must replace some capabilities showed below:
    ```
    DesiredCapabilities capabilities = new DesiredCapabilities()
    capabilities.setCapability("platformName", "Android")
    capabilities.setCapability("deviceName", "replace by your device name")
    capabilities.setCapability("app", "replace by your application mobile path")
    capabilities.setCapability("browserVersion", "replace by your android version");
    capabilities.setCapability("automationName", "UiAutomator2");
    capabilities.setCapability("autoGrantPermissions", "true");
    AndroidDriver driver = new AndroidDriver(new URL("http://127.0.0.1:4723"), caps);
    return driver
    ```
* ios - To use this driver you must replace some capabilities showed below:
    ```
    DesiredCapabilities capabilities = new DesiredCapabilities()
    capabilities.setCapability("platformName", "iOS")
    capabilities.setCapability("deviceName", "replace by your device name")
    capabilities.setCapability("app", "replace by your application mobile path")
    capabilities.setCapability("browserName", "replace by your browser name");
    capabilities.setCapability("browserVersion", "replace by your browser version");
    capabilities.setCapability("automationName", "XCUITest");
    capabilities.setCapability("autoGrantPermissions", "true");
    IOSDriver driver = new IOSDriver(new URL("https://$sauceLabsUsername:$sauceLabsAccessKey@ondemand.eu-central-1.saucelabs.com:443/wd/hub"), caps);
    return driver
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

    package pages

    import geb.Page
    import modules.DemoManualsMenuModule

    class DemoGebHomePage extends Page {

        static url = "https://gebish.org"

        static at = { title == "Geb - Very Groovy Browser Automation" }

        static content = {
            manualsMenu { module(DemoManualsMenuModule) }
        }
    }


### Modules Section
The `manuals` menu from the home page is defined as a module in this section.

    package modules

    class DemoManualsMenuModule extends geb.Module {
        static content = {
            toggle { $("div.menu a.manuals") }
            linksContainer { $("#manuals-menu") }
            links { linksContainer.find("a") }
        }

        void open() {
            toggle.click()
            waitFor { !linksContainer.hasClass("animating") }
        }
    }

### Specs Section

#### Gebish.org example

The test that utilizes these pages and modules is located in the `specs` section and is called `DemoGebHomePageSpec`.

**Setup** - In the `DemoGebHomePageSpec` test, the `def setup()` method is used to define the test environment that will be used for the test.

**Test Case** - The test case `can access The Book of Geb via homepage` is defined in this test. This test case simply accesses the `gebHomePage` and then accesses the `theBookOfGebPage` by opening the `manualsMenu` module.

**Evidence Collection** - During the process of executing this test, two pieces of evidence are collected.

	package specs
	
	import geb.spock.GebReportingSpec
	import helpers.SpecHelper
	import pages.DemoGebHomePage
	import pages.DemoTheBookOfGebPage
	
	class DemoGebHomePageSpec extends GebReportingSpec {
	
		def gebHomePage = page(DemoGebHomePage)
		def theBookOfGebPage = page(DemoTheBookOfGebPage)
	
		def setup() {
			System.setProperty("geb.env", "defaultDriver")
		}
	
		def "can access The Book of Geb via homepage"() {
			given:
			to gebHomePage
	
			when:
			SpecHelper.printEvidenceForPageElement(this, 1, $("manuals-menu"), "Manuals menu exists")
			gebHomePage.manualsMenu.open()
			SpecHelper.printEvidenceForPageElement(this, 1, $("a", xpath: '//*[@id=\"manuals-menu\"]/div/a[1]'), "Current version submenu exists")
			gebHomePage.manualsMenu.links[0].click()
	
			then:
			at theBookOfGebPage
		}
	}

#### Google Keep example
The test that utilizes these pages and modules is located in the `specs` section and is called `DemoGebHomePageSpec`.

**Setup** - In the `DemoGoogleKeepSpec` test, the `def setupSpec()` method is used to define the test environment that will be used for the test.

**Test Case** - The test case `Open Google Keep and press Start button` is defined in this test. This test case simply open the Google Keep mobile application and click on Start button.

**Evidence Collection** - During the process of executing this test, evidence is collected.

**Steps to make it work property**
This example is commented by default because android environment is not configured and apk is not part of the template.
```
	import org.openqa.selenium.WebElement
	import spock.lang.Stepwise
	
	@Stepwise
	class DemoGoogleKeepSpec extends GebReportingSpec {
	
	
		static Browser browser
	
		def setupSpec() {
			System.setProperty("geb.env", "android")
			browser = new Browser()
		}
	
		def cleanupSpec() {
			browser.driver.quit()
		}
	
		// This is a demo test for Google Keep apk
		// Please, ensure your android test environment is properly configured before uncommenting the lines below
		def "Open Google Keep and press Start button"() {
			when: "Google Keep is opened"
			browser.driver.activateApp('com.google.android.keep')
	
			then: "Press the Start button"
			SpecHelper.printEvidenceForMobileElement(this, 1, By.className("android.widget.Button"), "Current version submenu exists")
			List<WebElement> startButton = browser.driver.findElements(By.className("android.widget.Button"))
			if (!startButton.isEmpty()) {
				startButton.get(0).click()
			}
			List<WebElement> buttons = browser.driver.findElements(By.className("android.widget.Button"))
			assert !buttons.isEmpty()
		}
	
	}
```

Below there are all the steps you have to follow to prepare your locale environment:
* Download the Google Keep apk, save it in application folder, and call it Keep.apk
* Install and run Appium server:
  * Prerequisite - node and npm already installed.
  * Open a cmd console with administrator mode
  * Execute the command to install Appium server: `npm install -g appium`
  * Execute the command to run Appium server: `appium`
* Configure the `android` environment. This is an example of how to configure it with Appium server installed locally:
```
    DesiredCapabilities capabilities = new DesiredCapabilities();
    capabilities.setCapability("platformName", "Android");
    capabilities.setCapability("browserVersion", "12.0.0.149");
    capabilities.setCapability("deviceName", "HuaweiP60Pro");
    capabilities.setCapability("automationName", "UiAutomator2");
    capabilities.setCapability("app", new File(System.getProperty("user.dir"), "/application/Keep.apk").getAbsolutePath())
    AndroidDriver driver = new AndroidDriver(
        // The default URL in Appium is http://127.0.0.1:4723/wd/hub
        new URL("http://127.0.0.1:4723"), capabilities
    );
    return driver
```

## Running end-to-end tests

Run `gradlew test` to execute all end-to-end tests against the test instance of the front end.

## Links

* [gradle](https://gradle.org/)
* [spock](http://spockframework.org/)
* [geb](https://gebish.org/)
* [unirest](http://unirest.io/)
* [apium](https://appium.io/)
