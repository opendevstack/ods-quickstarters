package helpers

class Environments {
    // Define environment constants using system properties
    // Check the build.gradle file for the defined properties
    static final String DESKTOP = System.getProperty('environments.desktop')
    static final String MOBILE_BROWSER = System.getProperty('environments.mobile_browser')
    static final String MOBILE_APP = System.getProperty('environments.mobile_app')
}
