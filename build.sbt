val root = (project in file("."))
  .settings(
    name := "dfdl-png",

    organization := "com.mitre",

    version := "0.0.1"
  )
  .daffodilProject()
