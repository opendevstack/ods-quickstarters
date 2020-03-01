class SpecHelper {

    public Properties getApplicationProperties() {
        def properties = new Properties()
        this.getClass().getResource('/application.properties').withInputStream {
            properties.load(it)
        }

        return properties
    }
}

