credentials += Credentials(Path.userHome / ".sbt" / ".credentials")

addSbtPlugin("com.typesafe.play" % "sbt-plugin"    % "2.8.18")
addSbtPlugin("org.scalameta"     % "sbt-scalafmt"  % "2.4.6")
addSbtPlugin("org.scoverage"     % "sbt-scoverage" % "2.0.6")

// this fixes the problem with different versions of scala-xml in twirl and the scoverage sbt plugin :F
libraryDependencySchemes += "org.scala-lang.modules" %% "scala-xml" % VersionScheme.Always
