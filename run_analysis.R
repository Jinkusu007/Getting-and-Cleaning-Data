
library(reshape2)

setwd("../UCI HAR Dataset/")

#Get Column names from feature.txt and created vector of columns needed i.e Mean and SD
header = read.table("features.txt")
header = as.character(header[,2])
mean_std <- grep(".*mean.*|.*std.*", tolower(header))

#Add the Subject and Label header for future use
adjusted_header = c("subject","label",header[mean_std])

#load label mapping table
label_mapping = read.table("activity_labels.txt")

#load training data and bind label and subject as columns to data frame
x_train = read.table("train/X_train.txt")
y_train_label = read.table("train/y_train.txt")
train_subject = read.table("train/subject_train.txt")
x_train = cbind(train_subject,y_train_label,x_train)

#load Test data and bind label and subject as columns to data frame
x_test = read.table("test/X_test.txt")
y_test_label = read.table("test/y_test.txt")
test_subject = read.table("test/subject_test.txt")
x_test = cbind(test_subject,y_test_label,x_test)

#Bind both Training and Test data frame to create a single table.
all_samples = rbind(x_train, x_test)

#Add column names including subject and label column
colnames(all_samples) = c("subject","label",header)

#filter column header to subject, label, mean and std columns
all_samples = all_samples[,adjusted_header]

#map labels to actuall character labels and create a factor type column
all_samples$label <- factor(all_samples$label, levels = label_mapping[,1], labels = label_mapping[,2])

#reformat table to long version by subject and label then find average by both attributes (subject and label)
new_sample <- melt(all_samples, id = c("subject", "label"))
clean_data_file <- dcast(new_sample, subject + label ~ variable, mean)
