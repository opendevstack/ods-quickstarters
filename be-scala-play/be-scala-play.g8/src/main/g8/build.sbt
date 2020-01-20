name := """$name$"""
organization := "$organization$"

version := "1.0-SNAPSHOT"

lazy val root = (project in file("."))
  .enablePlugins(PlayScala)
  .settings(PlayKeys.playDefaultPort := 8080)

scalaVersion := "2.13.1"

val compileDependencies = Seq(
  guice,
  "net.logstash.logback" % "logstash-logback-encoder" % "6.3"
)

val testDependencies = Seq(
  "org.scalatestplus.play" %% "scalatestplus-play" % "5.0.0" % Test
)

libraryDependencies ++= compileDependencies ++ testDependencies

// Adds additional packages into Twirl
//TwirlKeys.templateImports += "com.example.controllers._"

// Adds additional packages into conf/routes
// play.sbt.routes.RoutesKeys.routesImport += "com.example.binders._"

val copyDockerFiles =
  taskKey[Unit]("copy files to the docker dir used by ods to build the docker image")
val cleanupDockerFiles = taskKey[Unit]("delete copied docker files from docker dir")
val dockerDir          = settingKey[File]("docker dir that will be used by ods to build the docker image")
dockerDir := baseDirectory.value / "docker"

copyDockerFiles := {
  (Docker / stage).value

  val stageDir = (Docker / stagingDirectory).value / "opt" / "docker"
  val libDir   = stageDir / "lib"
  val confDir  = stageDir / "conf"

  IO.copyDirectory(libDir, dockerDir.value / "lib")
  IO.copyDirectory(confDir, dockerDir.value / "conf")
}

cleanupDockerFiles := {
  IO.delete(dockerDir.value / "lib")
  IO.delete(dockerDir.value / "conf")
}

clean := {
  cleanupDockerFiles.value
  clean.value
}
