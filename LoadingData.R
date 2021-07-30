library("RSocrata")
library(dotenv)

load_dot_env()

deathsBySex <- read.socrata(
  "https://data.cdc.gov/resource/9bhg-hcku.csv",
  app_token = Sys.getenv("CDC_API"),
  email     = "arway@ucdavis.edu",
  password  = Sys.getenv("Password")
)
# https://data.cdc.gov/NCHS/Provisional-COVID-19-Deaths-by-Sex-and-Age/9bhg-hcku - link


PfizerAlloc <- read.socrata(
  "https://data.cdc.gov/resource/saz5-9hgg.csv",
  app_token = Sys.getenv("CDC_API"),
  email     = "arway@ucdavis.edu",
  password  = Sys.getenv("Password")
)

DernaAlloc <- read.socrata(
  "https://data.cdc.gov/resource/b7pe-5nws.csv",
  app_token = Sys.getenv("CDC_API"),
  email     = "arway@ucdavis.edu",
  password  = Sys.getenv("Password")
)

StateTimeSeries <- read.socrata(
    "https://data.cdc.gov/resource/9mfq-cb36.csv",
    app_token = Sys.getenv("CDC_API"),
    email     = "arway@ucdavis.edu",
    password  = Sys.getenv("Password")
  )
# https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36

CaseData <- read.socrata(
  "https://data.cdc.gov/resource/n8mc-b4w4.csv",
  app_token = Sys.getenv("CDC_API"),
  email     = "arway@ucdavis.edu",
  password  = Sys.getenv("Password")
)
  


Conditions <- read.socrata(
  "https://data.cdc.gov/resource/hk9y-quqm.csv",
  app_token = Sys.getenv("CDC_API"),
  email     = "arway@ucdavis.edu",
  password = Sys.getenv("Password")
)

# https://data.cdc.gov/NCHS/Conditions-Contributing-to-COVID-19-Deaths-by-Stat/hk9y-quqm
  

WeekSexAge <- read.socrata(
  "https://data.cdc.gov/resource/vsak-wrfu.csv",
  app_token = Sys.getenv("CDC_API"),
  email     = "arway@ucdavis.edu",
  password = Sys.getenv("Password")
)
  
# https://data.cdc.gov/NCHS/Provisional-COVID-19-Deaths-by-Week-Sex-and-Age/vsak-wrfu


SupportingData <- read.socrata(
  "https://data.cdc.gov/resource/vbim-akqf.json",
  app_token = Sys.getenv("CDC_API"),
  email     = "arway@ucdavis.edu",
  password = Sys.getenv("Password")
)

# https://data.cdc.gov/Case-Surveillance/COVID-19-Case-Surveillance-Public-Use-Data-Profile/xigx-wn5e


DistributedVaccines <- read.socrata(
  "https://data.cdc.gov/resource/unsk-b7fc.csv",
  app_token = Sys.getenv("CDC_API"),
  email     = "arway@ucdavis.edu",
  password = Sys.getenv("Password")
)




# https://data.cdc.gov/Vaccinations/COVID-19-Vaccinations-in-the-United-States-Jurisdi/unsk-b7fc
  