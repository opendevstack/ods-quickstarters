# Plain docker image (be-docker-plain)

Documentation is located in our [official documentation](https://www.opendevstack.org/ods-documentation/ods-project-quickstarters/latest/index.html)

Please update documentation in the [antora page direcotry](https://github.com/opendevstack/ods-project-quickstarters/tree/master/docs/modules/ROOT/pages)

## Release Manager compatibility

Being generic, this component does not produce any test results, which are currently required for a component to be successfully orchestrated by the *Release Manager*. That said, if you develop your application component based on this quickstarter, please make sure that test results are provided accordingly:

1) Your component has to place its test results in the xUnit XML format in the `build/test-results/test` directory. Make sure that no other `.xml` files are contained therein.

2) Your component has to provide these test results to the [Jenkins JUnit plugin](https://plugins.jenkins.io/junit) via its `junit` step function.

Please feel free to consult our existing quickstarters. An example can be found in the `be-springboot` quickstarter's [Jenkinsfile](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-springboot/Jenkinsfile).
