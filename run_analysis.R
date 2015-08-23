library(plyr)

dataSourceUri <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dataZipFile <- 'FUCI HAR Dataset.zip'
dataFolder <- 'UCI HAR Dataset'
mergedFile <- 'merged-data.csv'
summaryFile <- 'summary-data.csv'

joinPath <- function(...) {
  paste(..., sep='/')
}

attempt_data_download <- function() {
  if (!file.exists(dataZipFile)) {
    print(paste('test data missing; attempting to download from', dataSourceUri))
    download.file(dataSourceUri, dataZipFile)
  }
  if (file.exists(dataZipFile)) {
    unzip(dataZipFile)
  }
}

can_read <- function(filePath) {
  if (file.exists(filePath)) {
    TRUE
  } else {
    attempt_data_download()
    file.exists(filePath)
  }
}

get_table_data <- function(folder, filename) {
  toRead <- joinPath(dataFolder, folder, filename)
  if (!can_read(toRead)) {
    stop(paste('Can\'t locate or download required data file:', toRead))
  }
  read.table(toRead, header=F, stringsAsFactors=F)
}

activities <- get_table_data('','activity_labels.txt')
names(activities) <- c('activityid', 'activity')



get_data <- function(fromFolder) {
  print(paste('collecting', fromFolder, 'data...'))
  dataX <- get_table_data(fromFolder, paste('X_', fromFolder,'.txt', sep=''))
  dataY <- get_table_data(fromFolder, paste('y_', fromFolder, '.txt', sep=''))
  subjects <- get_table_data(fromFolder, paste('subject_', fromFolder, '.txt', sep=''))
  names(dataY) <- c('activityid')
  names(subjects) <- c('subject')
  merged <- cbind(subjects, dataY, dataX)
  join(activities, merged, by=c('activityid'))
}

get_test_data <- function() {
  get_data('test')
}

get_train_data <- function() {
  get_data('train')
}

get_combined_data <- function() {
  testData <- get_test_data()
  trainData <- get_train_data()
  allData <- rbind(testData, trainData)
  allData[with(allData, order(subject, activity)),]
}

combinedData <- get_combined_data()
dataCols <- sprintf('V%d', 1:561)
justData <- combinedData[dataCols]
final <- data.frame(combinedData$subject, combinedData$activity)
final$mean <- apply(justData, 1, mean, na.rm=T)
final$sd <- apply(justData, 1, sd, na.rm=T)
names(final) <- c('subject', 'activity', 'recorded data mean', 'recorded data standard deviation')
print(paste('writing merged data out to', mergedFile))
write.csv(combinedData, mergedFile, row.names=F)

print('generating summary...')
summary <- ddply(final, .(subject, activity), function(x) { mean(x$`recorded data mean`)})
names(summary) <- c('subject', 'activity', 'average value')
write.csv(summary, summaryFile, row.names=F)
print('done.')
