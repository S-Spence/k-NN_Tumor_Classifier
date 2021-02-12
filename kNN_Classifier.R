#--------------------------------------------------------------------------
# Title       : Malignant/Benign Tumor Classifier with K-NN Algorithm
# Description : ML Project for School 
# Author      : Sarah Spence
# Date        : 3/31/2020
#--------------------------------------------------------------------------

#Data Preparation 
# load file
wbcd <- read.csv("wisc_bc_data.csv", stringsAsFactors = FALSE)

# Summarize variables
str(wbcd)

# Remove the identifier
wbcd <- wbcd[-1]

# Print table of diagnoses (targets)
table(wbcd$diagnosis)

# Convert diagnosis variable to a factor
wbcd$diagnosis <- factor(wbcd$diagnosis, level = c("B", "M"),
                         labels = c("Benign", "Malignant"))

# Print percentage of benign and malignant tumors
round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)

# Print variable summary
summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])

# Create a function to normalize variables
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

# Test normalize function
normalize(c(1, 2, 3, 4, 5))
normalize(c(10, 20, 30, 40, 50))

# Normalize variables
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))

# Verify normalization
summary(wbcd_n$area_mean)

# Partition the dataset into testing/validation/training (70/15/15)
wbcd_train <- wbcd_n[1:399, ]
wbcd_val <- wbcd_n[400:485, ]
wbcd_test <- wbcd_n[485:569, ]
wbcd_train_labels <- wbcd[1:399, 1]
wbcd_val_labels <- wbcd[400:485, 1]
wbcd_test_labels <- wbcd[485:569, 1]

#Fit model
# Train kNN model
library(class)
library(caret)
wbcd_val_pred <- knn(train = wbcd_train, test = wbcd_val,
                     cl = wbcd_train_labels, k = 21)

# Create confusion matrix for evaluation on validation set
confusionMatrix(wbcd_val_pred, wbcd_val_labels)


#Test another model with z-score standardization instead of normalization 
# z-score standardization
wbcd_z <- as.data.frame(scale(wbcd[-1]))
summary(wbcd_z$area_mean)

# Partition testing/validation/training sets for z-score
wbcd_train_z <- wbcd_z[1:399, ]
wbcd_val_z <- wbcd_z[400:485, ]
wbcd_test_z <- wbcd_z[486:569, ]

# Fit model
wbcd_val_pred_z <- knn(train = wbcd_train_z, test = wbcd_val_z,
                       cl = wbcd_train_labels, k = 21)

# Evaluate z-score model
confusionMatrix(wbcd_val_pred_z, wbcd_val_labels)

# Tune the k parameter
# Get diagnosis back in dataframe with new partitions for caret package
wbcd_train_caret <- wbcd[1:399, ]
wbcd_val_caret <- wbcd[400:485, ]
wbcd_test_caret <- wbcd[486:569, ]

# use the caret package to adjust the k parameter using kappa as a metric
trControl <- trainControl(method = "repeatedcv", number = 10, repeats = 3) 
set.seed(12345)
knn_fit <- train(diagnosis~., data = wbcd_train_caret, method = "knn", trControl = trControl,
                 metric = "Kappa", tuneLength = 20, preProc = c("range"))
knn_fit

# Evaluate on validation data
knnPredict <- predict(knn_fit, newdata = wbcd_val_caret)
cmat <- confusionMatrix(knnPredict, wbcd_val_caret$diagnosis)
cmat

# Evaluate the caret model on the testing data
knnPredict <- predict(knn_fit, newdata = wbcd_test_caret)
cmat <- confusionMatrix(knnPredict, wbcd_test_caret$diagnosis)
cmat

# Evaluate original model on the testing data
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test,
                      cl = wbcd_train_labels, k = 21)
confusionMatrix(wbcd_test_pred, wbcd_test_labels)

