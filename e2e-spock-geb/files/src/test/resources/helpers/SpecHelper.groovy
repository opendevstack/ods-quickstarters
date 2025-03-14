package helpers

import geb.navigator.Navigator
import geb.spock.GebReportingSpec
import io.appium.java_client.AppiumDriver
import org.openqa.selenium.By
import org.openqa.selenium.StaleElementReferenceException
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement

import java.util.regex.Pattern

class SpecHelper {

    // Load application properties and replace placeholders with environment variables
    public Properties getApplicationProperties() {
        def env = System.getenv()

        def properties = new Properties()
        this.getClass().getResource('/application.properties').withInputStream {
            properties.load(it)
        }

        properties.each { key, value ->
            def matcher = value =~ /\$\{(.*?)\}/
            if (matcher.find()) {
                matcher.each { match ->
                    def nameToReplace = match[0]
                    def valueToReplace = env[match[1]]

                    value = value.replaceAll(Pattern.quote(nameToReplace), valueToReplace)
                    properties[key] = value
                }
            }
        }

        return properties
    }

    // Print evidence for a single page element
    public static void printEvidenceForPageElement(GebReportingSpec spec, int testStepNumber, Navigator fragment, String description = '', int desiredLevel = -1) {
        printEvidenceForPageElements(spec, testStepNumber, [ [ 'fragment' : fragment, 'description' :  description] ], desiredLevel)
    }

    // Print evidence for multiple page elements
    public static void printEvidenceForPageElements(GebReportingSpec spec, int testStepNumber, List<Map> fragmentsAndDescriptions, int desiredLevel = -1) {
        println '====================================='
        println "Test Case: ${spec.specificationContext.currentIteration.name}"
        println "Test Step: ${testStepNumber}"
        println "Page URL: ${spec.getBrowser().getPage().getDriver().getCurrentUrl()}"

        if (!fragmentsAndDescriptions || fragmentsAndDescriptions.isEmpty()) {
            throw new IllegalArgumentException("Error: evidence fragment is empty!")
        }

        println "----- Test Evidence STARTS Here -----"
        fragmentsAndDescriptions.each { fragmentAndDescription ->
            println "Description: ${fragmentAndDescription.description}"
            printEvidenceRecursive(fragmentAndDescription.fragment, 0, desiredLevel)
        }
        println "----- Test Evidence ENDS Here -----"
    }

    // Recursively print evidence for a page element and its children
    private static void printEvidenceRecursive(Navigator fragment, int level = 0, int desiredLevel = -1) {
        if (!fragment) {
            return
        }

        if (level == desiredLevel) {
            return
        }

        // Create indentation based on the level
        String fragmentIndentation = ''
        for (int i = 0; i < level; i++) {
            fragmentIndentation += '   '
        }

        // Prepend the fragment with the current level and indentation
        String fragmentPrepend = "(${level})${fragmentIndentation}"

        Navigator children = fragment.children()
        // If no children, print the fragment and its content
        if (children.size() == 0) {
            def value = fragment.value() ?: fragment.text()
            println "${fragmentPrepend}${fragment} ${value}"
        } else {
            // Print the current fragment without content
            println "${fragmentPrepend}${fragment}"

            // Recursively print each child
            children.each { child ->
                printEvidenceRecursive(child, (level + 1), desiredLevel)
            }
        }
    }

    // Print evidence for a single web element
    public static void printEvidenceForWebElement(GebReportingSpec spec, int testStepNumber, WebElement element, String description = '', int desiredLevel = -1) {
        printEvidenceForWebElements(spec, testStepNumber, [ ['element': element, 'description': description] ], desiredLevel)
    }

    // Print evidence for multiple web elements
    public static void printEvidenceForWebElements(GebReportingSpec spec, int testStepNumber, List<Map> elementsAndDescriptions, int desiredLevel = -1) {
        println '====================================='
        println "Test Case: ${spec.specificationContext.currentIteration.name}"
        println "Test Step: ${testStepNumber}"

        if (!elementsAndDescriptions || elementsAndDescriptions.isEmpty()) {
            throw new IllegalArgumentException("Error: evidence element is empty!")
        }

        println "----- Test Evidence STARTS Here -----"
        elementsAndDescriptions.each { elementAndDescriptions ->
            println "Description: ${elementAndDescriptions.description}"
            printEvidenceRecursive(elementAndDescriptions.element, 0, desiredLevel)
        }
        println "----- Test Evidence ENDS Here -----"
    }

    // Recursively print evidence for a web element and its children
    private static void printEvidenceRecursive(WebElement element, int level = 0, int desiredLevel = -1) {
        if (element == null) {
            return
        }

        if (level == desiredLevel) {
            return
        }

        // Create indentation based on the level
        String fragmentIndentation = ''
        for (int i = 0; i < level; i++) {
            fragmentIndentation += '   '
        }

        // Prepend the element with the current level and indentation
        String fragmentPrepend = "(${level})${fragmentIndentation}"

        List<WebElement> children
        try {
            children = element.findElements(By.xpath("./*"))
        } catch (StaleElementReferenceException e) {
            println "${fragmentPrepend}${element} [Stale Element]"
            return
        }

        // If no children, print the element and its content
        if (children.isEmpty()) {
            try {
                def value = element.getAttribute("value") ?: element.getText()
                println "${fragmentPrepend}${element} ${value}"
            } catch (StaleElementReferenceException e) {
                println "${fragmentPrepend}${element} [Stale Element]"
            }
        } else {
            // Print the current element without content
            println "${fragmentPrepend}${element}"

            // Recursively print each child
            children.each { child ->
                printEvidenceRecursive(child, (level + 1), desiredLevel)
            }
        }
    }

}
