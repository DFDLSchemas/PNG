name := "dfdl-png"

organization := "com.mitre"

version := "0.0.1"

crossPaths := false

testOptions in ThisBuild += Tests.Argument(TestFrameworks.JUnit, "-v")

libraryDependencies in ThisBuild := Seq(
  "junit" % "junit" % "4.11" % "test",
  "com.novocode" % "junit-interface" % "0.11" % "test",
  "org.apache.daffodil" %% "daffodil-tdml" % "2.2.0-SNAPSHOT" % "test"
)

scmInfo := Some(
  ScmInfo(
    browseUrl = url("https://github.com/DFDLSchemas/png"),
    connection = "scm:git:https://github.com/DFDLSchemas/png.git")
  )

homepage in ThisBuild := Some(url("https://github.com/DFDLSchemas/png"))
