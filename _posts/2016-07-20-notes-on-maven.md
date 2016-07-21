---
layout: post
category: [tools]
tags: [java]
infotext: "notes on using maven"
---
{% include JB/setup %}

The maven is a build tool, or more a project management tool, for java projects.

### Configuration for maven

The Pom, an acronym for project object model, file is used to configure the behaviour of maven 
projects. Any Maven project must have a  pom.xml file. And there is a default config file lies 
in `${maven.home}/conf/settings.xml`. It contains following elements:

- The localRepository element
- The offline element
- The proxies element
- The mirrors element
- The repositories element
- The pluginRepositories element
- The servers element
- The profiles element

They are for different purposes.

#### Specify JVM options

Use following command to specify JVM options for maven:

{% highlight shell linenos=table %}
export MAVEN_OPTS="-Xmx1024m"
{% endhighlight %}

To view all the environment variables and system properties:

{% highlight shell linenos=table %}
mvn help:system
{% endhighlight %}

#### The profiles element

Maven provides three type of profiles:

- Per Project profile as defined in the pom file of the project.
- Per User profile as defined in the user settings file `${user.home}/.m2/settings.xml`.
- A Global profile as defined in the global settings file `${maven.home}/conf/settings.xml`.

By creating different profiles for different variations of the project build, you can use the same 
pom file to create differing builds.

Profiles can be triggered in one of the following ways:

- Explicitly: `mvn –P dev package`, which invokes the `dev` profile
- Through settings:

{% highlight xml linenos=table %}
<activeProfiles>
  <activeProfile>dev</activeProfile>
</activeProfiles>
{% endhighlight %}

- Based on environment variables: If the system property `debug` is defined and has any value, 
then the profile is activated.

{% highlight xml linenos=table %}
<profile>
  <activation>
    <property>
      <name>debug</name>
    </property>
  </activation>
  ...
</profile>
{% endhighlight %}

- Based on OS settings:

{% highlight xml linenos=table %}
<profile>
  <activation>
    <os>
      <family>Windows</family>
    </os>
  </activation>
  ...
</profile>
{% endhighlight %}

- Present or missing files:

{% highlight xml linenos=table %}
<profile>
  <activation>
    <file>
      <missing>target/site</missing>
    </file>
  </activation>
</profile>
{% endhighlight %}

#### The properties in `pom` file

There are different types of properties. They are as follows:

- Environment variables: Prefixing a variable with `env`. will return the value of the shell's 
environment variable. For example, `${env.PATH}` will return the value of the `PATH` variable.
- pom variables: Prefixing a variable with `project`. will return the value of that element in 
the pom file. For example, `${project.version}` will return the value in the `<version>` tag of 
the pom file.
- The settings variable: Prefixing a variable with `settings`. will return the value of that 
element in the settings file. For example, `${settings.offline}` will return the value `<offline>` 
in the settings file.
- Java properties: Any property available through the `System.getProperties()` method in Java is 
available. For example, `${java.home}`.
- Normal properties: Values that are specified in the `<properties>` tag.

### Lifecycles for maven

Maven has three built-in build lifecycles:

- default: The default lifecycle handles project build and deployment.
- clean: The clean lifecycle cleans up the files and folders produced by maven.
- site: The site lifecycle handles the creation of project documentation.

Each lifecycle has a number of phases. A phase in a lifecycle is just an ordered placeholder 
in the build execution path. For example, the clean phase in the clean lifecycle cannot do 
anything on its own. In the maven architecture, it has two key elements: nouns and verbs. Both 
nouns and verbs, which are related to a given project, are defined in the POM file. The name 
of the project, the name of the parent project, the dependencies, and the type of packaging are 
nouns.

- The clean lifecycle defines three phases: pre-clean, clean, and post-clean.
  - The clean phase removes all the files and folders created by maven as part of its build.
- The site lifecycle is defined with four phases: pre-site, site, post-site, and site-deploy .
  - The site phase generates the project's documentation, which can be published, as well as a 
  template that can be customized further.
- The default lifecycle defines 23 phases, the following points summarize all the phases defined 
under the default lifecycle in their order of execution:
  - validate: This phase validates that all project information is available and correct.
  - initialize: This phase initializes the build by setting up the right directory structure and 
  initializing properties.
  - generate-sources: This phase generates any required source code.
  - process-sources: This phase processes the generated source code; there can be a plugin running 
  in this phase to filter the source code based on some defined criteria.
  - generate-resources: This phase generates any resources that need to be packaged with the 
  final artifact.
  - process-resources: This phase copies project resources to the destination to package.
  - compile: This phase compiles the source code.
  - process-classes: This phase can be used to carry out any bytecode enhancements after the 
  compile phase.
  - generate-test-sources: This phase generates the required source code for tests.
  - process-test-sources: This phase processes the generated test source code.
  - generate-test-resources: This phase generates all the resources required to run tests.
  - process-test-resources: This phase processes the generated test resources. It copies the 
  resources to their destination directories and makes them ready for testing.
  - test-compile: This phase compiles the source code for tests.
  - process-test-classes: This phase can be used to carry out any bytecode enhancements after the 
  test-compile phase.
  - test: This phase runs unit tests within a suitable framework.
  - prepare-package: This phase is useful in organizing the artifacts to be packaged.
  - package: This phase packages the compiled code in its distribution format.
  - pre-integration-test: This phase performs the actions required (if any) before running 
  integration tests. This may be used to start any external application servers and deploy the 
  artifacts into different test environments.
  - integration-test: This phase processes the package in the integration test environment.
  - post-integration-test: This phase can be used to perform any cleanup tasks after running the 
  integration tests.
  - verify: This phase runs checks to verify that the package is valid.
  - install: This phase installs the package in the local repository.
  - deploy: This phase installs the final package in the configured repository.

Each phase is made up of plugin goals. A plugin goal is a specific task that builds the project. 
Plugins bring verbs into the maven build system, and they define what needs to be done 
during the build execution via its goals. A plugin is a group of goals. Each goal of a plugin can 
be executed on its own or can be registered as part of a phase in a Maven build lifecycle.
Some goals make sense only in specific phases (for example, the compile goal of the Maven Compiler 
plugin makes sense in the compile phase, but the checkstyle goal of the Maven Checkstyle plugin 
can potentially be run in any phase). So some goals are bound to a specific phase of a lifecycle, 
while others are not.

When you execute a maven plugin on its own, it only runs the goal specified in the command; however, 
when you run it as a part of a lifecycle, then maven executes all the plugin goals associated with 
the corresponding lifecycle up until the specified phase (including that phase).

Here is a table of phases, plugins, and goals:

<style>
table.ppg {
  border: 1px solid black;
}
.ppg th {
  border: 1px solid black;
}
.ppg td {
  border: 1px solid black;
  padding-left: 3px;
  padding-right: 3px;
}
</style>

{:.ppg}
| Phase | Plugiin | Goal |
|:-:|:-:|:-:|
| clean | Maven Clean Plugin | clean |
| site | Maven Site plugin | site |
| process-resources | Maven Resources plugin | resource |
| compile | Maven Compiler plugin | compile |
| test | Maven Surefire plugin | test |
| package | Maven JAR plugin (it varies, it's an example) | jar (in case of a Maven JAR plugin) |
| install | Maven Install plugin | install |
| deploy | Maven Deploy plugin | deploy |

#### Lifecycle extensions

The lifecycle extensions in maven allow you to customize the standard build behavior. Take 
`org.apache.maven.AbstractMavenLifecycleParticipant` as example. A custom lifecycle extension 
should extend from the AbstractMavenLifecycleParticipant class, which provides the following 
three methods that you can override:

- afterProjectsRead(MavenSession session): This method is invoked after all the maven project 
instances have been created. There will be one project instance for each POM file. In a large-scale 
build system, you have one parent POM and it points to multiple child POM files.
- afterSessionEnd(MavenSession session): This method is invoked after all Maven projects are built.
- afterSessionStart(MavenSession session) : This method is invoked after the  MavenSession 
instance is created.

### Plugins

A maven plugin can be executed in two ways:

- Using a lifecycle
- Directly invoking a plugin goal

If it is executed via a lifecycle, then there are plugin goals associated with different phases of 
the lifecycle. When each phase gets executed, all the plugin goals will also get executed only if 
the effective POM file of the project has defined the corresponding plugins under its plugins 
configuration. The same applies even when you try to invoke a plugin goal directly (for example, 
mvn jar:jar), the goal will be executed only if the corresponding plugin is associated with the 
project.

- Using the Maven Clean plugin
  - maven-clean-plugin
  - usages
    - Cleaning automatically
    - Skipping the deletion of the working directory
    - Deleting additional folders/files
- Using the Maven Compiler plugin
  - maven-compiler-plugin
    - mvn compile, for compile source file
    - mvn test, for compile test source file
  - two goals:
    - The compile goal is bound to the compile phase of the maven default lifecycle
    - The compileTest goal
  - usages
    - Changing the compiler used by the Maven Compiler plugin
    - Specifying the Java version for the Compiler plugin
- Using the Maven Install plugin
  - maven-install-plugin
  - usages
    - Deploy the final project artifacts into the local maven repository
- Using the Maven Surefire plugin to run unit tests
  - maven-surefire-plugin
  - Its goal is bound to the test phase of the default maven lifecycle
  - usages
    - Skipping tests
    - Skipping the compilation of test sources
      - mvn –Dmaven.test.skip=true package
- Using the Maven Failsafe plugin to run integration tests
  - maven-failsafe-plugin
    - mvn verify
- Using the Maven Resources plugin
  - maven-resources-plugin
  - usages
    - Filtering using resources
- Using the Maven Deploy plugin
  - maven-deploy-plugin
  - usages
    - Deploy  the final project artifacts into a remote Maven repository. The deploy goal of the 
    deploy plugin is associated with the deploy phase of the default maven lifecycle

{% highlight xml linenos=table %}
<distributionManagement>
  <repository>
    <id>???-repository</id>
    <name>??? Repository</name>
    <url>???</url>
  </repository>
</distributionManagement>
{% endhighlight %}

- Using the Maven Site plugin
  - maven-site-plugin
  - It generates static HTML web content for a Maven project, including the reports configured in 
  the project.
- Using the Maven Jar plugin
  - maven-jar-plugin
  - It creates a JAR file from the maven project
  - Its goal is bound to the package phase of the maven default lifecycle.
- Using the Maven Source plugin
  - maven-source-plugin
  - It defines five goals: aggregate, jar, test-jar, jar-no-fork, and test-jar-no-fork. All these 
  five goals of the source plugin run under the package phase of the default lifecycle.
- Using the Maven Resource plugin
  - maven-resource-plugin
  - It copies the resources associated with the main project as well as the tests to the project 
  output directory.
- Using the Maven Release plugin
  - maven-release-plugin
- Using the Maven Assembly plugin
  - maven-assembly-plugin
  - single goal

Following is an example for assembly: 

{% highlight xml linenos=table %}
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-assembly-plugin</artifactId>
  <executions>
    <execution>
      <id>copy_components</id>
      <phase>test</phase>
      <goals>
        <goal>attached</goal>
      </goals>
      <configuration>
        <filters>
          <filter>
            ${basedir}/src/assembly/filter.properties
          </filter>
        </filters>
        <descriptors>
          <descriptor>src/assembly/dist.xml</descriptor>
        </descriptors>
      </configuration>
    </execution>
    <execution>
      <id>dist</id>
      <phase>package</phase>
      <goals>
        <goal>attached</goal>
      </goals>
      <configuration>
        <filters>
          <filter>
            ${basedir}/src/assembly/filter.properties
          </filter>
        </filters>
        <descriptors>
          <descriptor>src/assembly/bin.xml</descriptor>
          <descriptor>src/assembly/src.xml</descriptor>
          <descriptor>src/assembly/docs.xml</descriptor>
        </descriptors>
      </configuration>
    </execution>
  </executions>
</plugin>
{% endhighlight %}

If you look at the first execution element, it associates the attached goal (deprecated) of the 
assembly plugin with the test phase of the  default lifecycle. In the same manner, the second 
execution element associates the attached goal with the package phase of the default lifecycle.

### Dependency scopes

There are six different dependency scopes available:

- compile: This dependency is required for compilation. This automatically means it is required 
for testing as well as runtime (when the project is run).
- test: This dependency is only required for tests. This means the dependency is typically in 
the test code. As the test code is not used to run the project, these dependencies are not 
required for runtime.
- runtime: These dependencies are not required during compilation, but only required to run the 
project.
- provided: This tells Maven that dependency is required for compilation and runtime, but this 
dependency need not be packaged with the package for distribution. The dependency will be provided 
by the user.
- system: This is similar to the provided scope. Here, we need to explicitly provide the location 
of the JAR file. It is not looked up from the repository.

{% highlight xml linenos=table %}
<dependency>
  <groupId>com.myorg</groupId>
  <artifactId>some-jar</artifactId>
  <version>2.0</version>
  <scope>system</scope>
  <systemPath>${basedir}/lib/some.jar</systemPath>
</dependency>
{% endhighlight %}

- import: This is only used on a dependency of the pom type in the dependencyManagement section. 
It indicates that the specified pom should be replaced with the dependencies in that pom's 
dependencyManagement section. This is intended to centralize dependencies of large multi-module 
projects.

#### commands of dependency

{% highlight shell linenos=table %}
mvn dependency:tree -Dverbose

mvn dependency:analyze

mvn dependency:build-classpath # viewing the dependency classpath
{% endhighlight %}

#### SNAPSHOT dependencies

In Maven, a SNAPSHOT version is a version of the project/dependency that has not been released. 
This is indicated by suffixing SNAPSHOT to the version number.

Maven treats  \SNAPSHOT versions differently from release versions:

- For a release version, Maven checks if the artifact is available in the local repository that is 
already downloaded. If so, it does not attempt to fetch the same from the remote repositories.
- For SNAPSHOT versions, even if the artifact is available locally, it checks the SNAPSHOT version 
for updates in the remote repository based on the update policy that can be configured.
  - By default, the update interval is once a day. The update interval can be specified in the 
  repository section of the pom or settings file as follows:

{% highlight xml linenos=table %}
<updatePolicy>always<updatePolicy>
{% endhighlight %}

  - The choices are:
    - always, This checks for updates for every Maven run.
    - daily (default), This checks for updates once a day. This does not necessarily mean exactly 
    24 hours from the last check; just once a day at the start of the day.
    - interval:X (where  X is an integer in minutes), This checks for updates after a specified 
    time. or
    - never.

### Manually installing dependencies

The `install-file` goal of the Maven Install plugin allows dependencies to be installed to the 
local repository. It takes `groupId`, `artifactId`, `version`, and `packaging` type as parameters 
so that it can place the dependency suitably in the repository as well as create a simple pom 
file for it.

For example:

{% highlight shell linenos=table %}
mvn install:install-file -DgroupId=org.apache.tomcat -DartifactId=apache-tomcat -Dversion=8.0.14 -Dpackaging=tar.gz -Dfile=/some/path/to/apache-tomcat-8.0.14.tar.gz -DgeneratePom=true -DlocalRepositoryPath=lib
{% endhighlight %}

### Include and Exclude

You can also specify to include or exclude specific files for sources, resources, and dependencies.

In following example, it excludes all files under scripts folder in resources folder:

{% highlight xml linenos=table %}
<resources>
  <resource>
    <excludes>
      <exclude>scripts/**</exclude>
    </excludes>
  </resource>
</resources>
{% endhighlight %}