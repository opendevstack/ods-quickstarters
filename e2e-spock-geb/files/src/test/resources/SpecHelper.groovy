import geb.Page
import geb.navigator.Navigator
import geb.spock.GebReportingSpec

import java.util.regex.Pattern

class SpecHelper {

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

    public static void printEvidenceForPageElement(GebReportingSpec spec, int testStepNumber, Navigator fragment, String description = '', int desiredLevel = -1) {
        printEvidenceForPageElements(spec, testStepNumber, [ [ 'fragment' : fragment, 'description' :  description] ], desiredLevel)
    }

    public static void printEvidenceForPageElements(GebReportingSpec spec, int testStepNumber, List<Map> fragmentsAndDiscriptions, int desiredLevel = -1) {
        println '====================================='
        println "Test Case: ${spec.specificationContext.currentIteration.name}"
        println "Test Step: ${testStepNumber}"
        println "Page URL: ${spec.getBrowser().getPage().getDriver().getCurrentUrl()}"

        if (!fragmentsAndDiscriptions || fragmentsAndDiscriptions.isEmpty()) {
            throw new IllegalArgumentException("Error: evidence fragment is empty!")
        }

        println "----- Test Evidence STARTS Here -----"
        fragmentsAndDiscriptions.each { fragmentAndDescription ->
            println "Description: ${fragmentAndDescription.description}"
            printEvidenceRecursive(fragmentAndDescription.fragment, 0, desiredLevel)
        }
        println "----- Test Evidence ENDS Here -----"
    }

    private static printEvidenceRecursive(Navigator fragment, int level = 0, int desiredLevel = -1) {
        if (!fragment) {
            return
        }

        if (level == desiredLevel) {
            return
        }

        // create fragmentIndentation based on level
        String fragmentIndentation = ''
        for (int i = 0; i < level; i++) {
            fragmentIndentation += '   '
        }

        // create the prepend for the fragment, current level, plus strings
        String fragmentPrepend = "(${level})${fragmentIndentation}"

        Navigator children = fragment.children();
        // no children of current fragment - print fragment and content
        // (value for input types, text or for images or links, nothing)
        if (children.size() == 0) {
            def value = fragment.value() ?: fragment.text()
            println "${fragmentPrepend}${fragment} ${value}"
        } else {
            // print the current fragment without any content
            println "${fragmentPrepend}${fragment}"

            // for each child print the evidence recursively
            children.each { child ->
                printEvidenceRecursive(child, (level + 1), desiredLevel)
            }
        }
    }
}
