# Results viewer for the Can-BUILD study. Connection values come from environment
# variables (ShinyProxy mounts /root/.Renviron); none are stored in the image.
options(java.parameters = "-Xss15m")

# Same shared .Renviron variables as the other OHDSI apps (shinydb*)
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = paste0(Sys.getenv("shinydbServer"), "/", Sys.getenv("shinydbDatabase")),
  port = Sys.getenv("shinydbPort"),
  user = "shinyproxy",
  password = Sys.getenv("shinydbPw"),
  pathToDriver = Sys.getenv("DATABASECONNECTOR_JAR_FOLDER", "/root")
)

resultsSchema <- Sys.getenv("RESULT_DATABASE_SCHEMA", "skeletoncohortdiagnosticsstudy")

shinyConfig <- OhdsiShinyAppBuilder::initializeModuleConfig() |>
  OhdsiShinyAppBuilder::addModuleConfig(OhdsiShinyAppBuilder::createDefaultAboutConfig()) |>
  OhdsiShinyAppBuilder::addModuleConfig(OhdsiShinyAppBuilder::createDefaultDatasourcesConfig()) |>
  OhdsiShinyAppBuilder::addModuleConfig(OhdsiShinyAppBuilder::createDefaultCohortGeneratorConfig()) |>
  OhdsiShinyAppBuilder::addModuleConfig(OhdsiShinyAppBuilder::createDefaultCohortDiagnosticsConfig()) |>
  OhdsiShinyAppBuilder::addModuleConfig(OhdsiShinyAppBuilder::createDefaultCharacterizationConfig())

app <- OhdsiShinyAppBuilder::createShinyApp(
  title = "Can-BUILD",
  studyDescription = "Can-BUILD study results",
  config = shinyConfig,
  connectionDetails = connectionDetails,
  resultDatabaseSettings = OhdsiShinyAppBuilder::createDefaultResultDatabaseSettings(schema = resultsSchema),
  themePackage = "OhdsiShinyAppBuilder"
)

app
