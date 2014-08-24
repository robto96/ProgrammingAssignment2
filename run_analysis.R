##Get the data

data.source.file <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
data.file <- './original-dataset.zip'
data.dir <- './UCI HAR Dataset'
out.file <- './tidy-UCI-HAR-dataset.csv'
out.file.aggregates <- './tidy-UCI-HAR-avgs-dataset.txt'

download.file(data.source.file, destfile = data.file, method = 'auto')


## Decompress me

unzip(data.file)


## Get activity labels
acts <- read.table(paste(local.data.dir, 'activity_labels.txt', sep = '/'), header = FALSE)
names(acts) <- c('id', 'name')

## Get feature labels
feats <- read.table(paste(local.data.dir, 'features.txt', sep = '/'), header = FALSE)
names(feats) <- c('id', 'name')

## Read the plain data files, assigning sensible column names
train.X <- read.table(paste(data.dir, 'train', 'X_train.txt', sep = '/'), header = FALSE)
names(train.X) <- feats$name
train.y <- read.table(paste(data.dir, 'train', 'y_train.txt', sep = '/'), header = FALSE)
names(train.y) <- c('activity')
train.subject <- read.table(paste(data.dir, 'train', 'subject_train.txt', sep = '/'), header = FALSE)
names(train.subject) <- c('subject')
test.X <- read.table(paste(data.dir, 'test', 'X_test.txt', sep = '/'), header = FALSE)
names(test.X) <- feats$name
test.y <- read.table(paste(data.dir, 'test', 'y_test.txt', sep = '/'), header = FALSE)
names(test.y) <- c('activity')
test.subject <- read.table(paste(data.dir, 'test', 'subject_test.txt', sep = '/'), header = FALSE)
names(test.subject) <- c('subject')

## Merge the training and test data sets
X <- rbind(train.X, test.X)
y <- rbind(train.y, test.y)
subject <- rbind(train.subject, test.subject)

## Get the aggregate facts required 
X <- X[, grep('mean|std', feats$name)]
y$activity <- acts[y$activity,]$name

final.data.set <- cbind(subject, y, X)

write.csv(final.data.set, out.file)

tidy.avgs.data.set <- aggregate(final.data.set[, 3:dim(final.data.set)[2]], list(final.data.set$subject
                                                                                 , final.data.set$activity),  mean)
names(tidy.avgs.data.set)[1:2] <- c('subject', 'activity')

##Write it out
write.csv(tidy.avgs.data.set, out.file.aggregates)

