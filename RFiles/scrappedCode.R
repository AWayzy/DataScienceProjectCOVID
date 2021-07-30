SCRAP CODE!!! 
  
  test <- as.data.frame(df$submission_date)
  test2 <- as.data.frame(jointVacc$week_of_allocations)
  
  library(lubridate)
  isoweek(ymd(test))
  isoweek(ymd(test2))
  test$week2020 <- rep(10, length(test))
  test$week2021 <- rep(10, length(test$week2020))
  
  test2$week2020 <- rep(10, length(test2))
  test2$week2021 <- rep(10, length(test2$week2020))
  
  test <- rename(test, df = `df$submission_date`)
  test2 <- rename(test2, df = `jointVacc$week_of_allocations`)
  
  
  ## CHANGING DF TO WEEK OF
  for(i in 1:length(test$df)){
    year = isoyear(test$df[i])
    week = isoweek(test$df[i])
    if(year == 2020){
      test$week2020[i] <- week
      test$week2021[i] <- -5
    }
    if(year == 2021){
      test$week2020[i] <- -5
      test$week2021[i] <- week
    }
  }
  
  test$weekOf <- rep(as.Date("2000-01-01"), length(test$df))
  
  for(i in 1:length(test$week2020)){
    year <- isoyear(test$df[i])
    if(year == 2020){
      weekNum = test$week2020[i]
      test$weekOf[i] <- as.Date(ymd("2020-01-01")+ weeks(weekNum - 1))
      print(test$weekOf[i])
    }
    if(year == 2021){
      weekNum = test$week2021[i]
      test$weekOf[i] <- as.Date(ymd("2021-01-01")+ weeks(weekNum - 1))
      print(test$weekOf[i])
    }
  }
  
  
  ## CHANGING JOINTVACC WEEK OF TO STANDARD WEEKOF
  
  for(i in 1:length(test2$df)){
    year = isoyear(test2$df[i])
    week = isoweek(test2$df[i])
    if(year == 2020){
      test2$week2020[i] <- week
      test2$week2021[i] <- -5
    }
    if(year == 2021){
      test2$week2020[i] <- -5
      test2$week2021[i] <- week
    }
  }
  
  test2$weekOf <- rep(as.Date("2000-01-01"), length(test2$df))
  
  for(i in 1:length(test2$week2020)){
    year <- isoyear(test2$df[i])
    if(year == 2020){
      weekNum = test2$week2020[i]
      test2$weekOf[i] <- as.Date(ymd("2020-01-01")+ weeks(weekNum - 1))
      print(test2$weekOf[i])
    }
    if(year == 2021){
      weekNum = test2$week2021[i]
      test2$weekOf[i] <- as.Date(ymd("2021-01-01")+ weeks(weekNum - 1))
      print(test2$weekOf[i])
    }
  }
  
  use1 <- jointVacc
  use1$weekOfShared <- rep(as.Date(ymd("2000-01-01"), length(use1$jurisdiction)))
  for(i in 1:length(use1$week_of_allocations)){
    ogweek <- use1$week_of_allocations[i]
    weekof <- test2[which(test2$df == ogweek),]$weekOf[1]
    use1$weekOfShared[i] <- weekof
  }
  
  use2 <- subset(df, select = c(state, names, submission_date, new_case, new_death))
  use2$weekOfShared <- rep(as.Date(ymd("2000-01-01"), length(use2$state)))
  for(i in 1:length(use2$submission_date)){
    ogdate <- use2$submission_date[i]
    weekof <- test[which(test$df == ogdate),]$weekOf[1]
    use2$weekOfShared[i] <- weekof
  }
  
  use2 <- rename(use2, jurisdiction = names)
  dim(use1)
  dim(use2)
  
  
  maybe <- merge(use2, use1, by = c("jurisdiction", "weekOfShared"), all.x = TRUE)
  dim(maybe)
  
  ## has a lot of NA's bc of merge with no data. replacing with 0
  ## week of allocations is no longer required, so i will remove the columns
  
  maybe <- subset(maybe, select = -c(week_of_allocations))
  maybe[is.na(maybe)] <- 0
  
  head(maybe)
  
  lindf <- subset(maybe, select = -c(PfizerDose1, pfizerDose2, DernaDose1, DernaDose2))
  lindf <- maybe
  ## since totalvacc is the same for each element of the week, replace it by totalvacc / 7
  lindf$totalVacc <- maybe$totalVacc / 7
  
  head(lindf)
  
  
  lindf[order("weekOfShared"),]
  data_to_use <- data.frame()
  
  lindf$totalVacc = rep(0, nrow(lindf))
  for(i in 1:length(unique(lindf$weekOfShared))){
    week = unique(lindf$weekOfShared)[i]
    whicht = which(lindf$weekOfShared == week)
    lindf$totalVacc[whicht] <- rep(sum(lindf[whicht,]$PfizerDose1,
                                       lindf[whicht,]$pfizerDose2, 
                                       lindf[whicht,]$DernaDose1,
                                       lindf[whicht,]$DernaDose2), length(whicht))
  }
  
  lindf$new_cases_allUS <- rep(10, nrow(lindf))
  lindf$new_deaths_allUS <- rep(10, nrow(lindf))
  
  for(i in 1:length(unique(lindf$weekOfShared))){
    date <- unique(lindf$weekOfShared)[i]
    lindf$new_cases_allUS[which(lindf$weekOfShared == date)] <- rep(sum(df[which(lindf$weekOfShared == date),]$new_case), 
                                                                    length(which(lindf$weekOfShared == date)))
    lindf$new_deaths_allUS[which(lindf$weekOfShared == date)] <- rep(sum(df[which(lindf$weekOfShared == date),]$new_death), 
                                                                     length(which(lindf$weekOfShared == date)))
  }
  
  dataToUse <- distinct(subset(lindf, select = c(weekOfShared, new_cases_allUS, new_deaths_allUS, totalVacc)))
  
  summary(glm(dataToUse$new_case ~ dataToUse$totalVacc))
  
  
  
####
  
  df2 <- df[which(df$submission_date == as.Date("2020-04-01")),]
  df2 <- df2[!is.na("consent_cases"),]
  df2 <- df2[!is.na("consent_deaths"),]
  df3 <- subset(df2, select = -c(conf_cases, prob_cases, pnew_case, conf_death, prob_death, pnew_death, created_at, consent_cases, consent_deaths))
  names(df3)
  df3$mortality <- df3$tot_death / df3$tot_cases
  df4 <- merge(df3, toPlot, by = c("state", "submission_date", "new_case"))
  df4 <- subset(df4, select = -c(names.y, X2018.Population))
  df5 <- merge(df4, pop, by.x = "names.x", by.y = "State")
  
  df5$casesByPop <- df5$tot_cases / df5$X2018.Population
  df6 <- subset(df5, select = c(new_case, tot_cases, new_death, tot_death, new_admin, mortality, casesByPop))
  df6[which(is.na(df6$new_admin)),]$new_admin <- rep(0, length(which(is.na(df6$new_admin))))
  # no vaccines, so remove for this one
  df6 <- subset(df6, select = -c(new_admin))
  pca2 <- princomp(df6, cor = T, scores = T)
  summary(pca2, loadings = T)
  
  
  ## pca2 done
  df2 <- df[which(df$submission_date == as.Date("2021-01-07")),]
  df2 <- df2[!is.na("consent_cases"),]
  df2 <- df2[!is.na("consent_deaths"),]
  df3 <- subset(df2, select = -c(conf_cases, prob_cases, pnew_case, conf_death, prob_death, pnew_death, created_at, consent_cases, consent_deaths))
  names(df3)
  df3$mortality <- df3$tot_death / df3$tot_cases
  df4 <- merge(df3, toPlot, by = c("state", "submission_date", "new_case"))
  df4 <- subset(df4, select = -c(names.y, X2018.Population))
  df5 <- merge(df4, pop, by.x = "names.x", by.y = "State")
  
  df5$casesByPop <- df5$tot_cases / df5$X2018.Population
  df6 <- subset(df5, select = c(new_case, tot_cases, new_death, tot_death, new_admin, mortality, casesByPop))
  df6[which(is.na(df6$new_admin)),]$new_admin <- rep(0, length(which(is.na(df6$new_admin))))
  
  pca3 <- princomp(df6, cor = T, scores = T)
  summary(pca3, loadings = T)
  
  # pca3 done
  
  df2 <- df[which(df$submission_date == as.Date("2020-03-15")),]
  df2 <- df2[!is.na("consent_cases"),]
  df2 <- df2[!is.na("consent_deaths"),]
  df3 <- subset(df2, select = -c(conf_cases, prob_cases, pnew_case, conf_death, prob_death, pnew_death, created_at, consent_cases, consent_deaths))
  names(df3)
  df3$mortality <- df3$tot_death / df3$tot_cases
  df4 <- merge(df3, toPlot, by = c("state", "submission_date", "new_case"))
  df4 <- subset(df4, select = -c(names.y, X2018.Population))
  df5 <- merge(df4, pop, by.x = "names.x", by.y = "State")
  
  df5$casesByPop <- df5$tot_cases / df5$X2018.Population
  df6 <- subset(df5, select = c(new_case, tot_cases, new_death, tot_death, new_admin, mortality, casesByPop))
  df6[which(is.na(df6$new_admin)),]$new_admin <- rep(0, length(which(is.na(df6$new_admin))))
  df6[which(is.na(df6$mortality)),]$mortality <- 0
  df6 <- subset(df6, select = -c(new_admin))
  pca4 <- princomp(df6, cor = T, scores = T)
  summary(pca4, loadings = T, cutoff = .2)
  
  
  sqrt(eigen(cor(df6))$vectors)
  
  
