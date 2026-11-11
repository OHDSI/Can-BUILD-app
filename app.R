# Results viewer for the Can-BUILD study. All connection values come from
# environment variables (ShinyProxy mounts them via /root/.Renviron); none are stored in the image.
options(java.parameters = "-Xss15m")

required <- c("OHDSI_RESULTS_DATABASE_SERVER", "OHDSI_RESULTS_DATABASE_USER", "OHDSI_RESULTS_DATABASE_PASSWORD")
missing <- required[!nzchar(Sys.getenv(required))]
if (length(missing) > 0) {
  stop("Missing environment variables: ", paste(missing, collapse = ", "))
}

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = Sys.getenv("OHDSI_RESULTS_DATABASE_SERVER"),
  user = Sys.getenv("OHDSI_RESULTS_DATABASE_USER"),
  password = Sys.getenv("OHDSI_RESULTS_DATABASE_PASSWORD"),
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
