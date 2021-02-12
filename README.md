## **k-NN_Tumor_Classifier**
<br/>
    <p>This analysis aims to identify the k-NN parameters that produce the most accurate model for breast cancer classification. The machine learning repository at the University of California prepared the dataset used in this analysis. The University of Wisconsin developed the dataset with “measurements from digitized images of fine-needle aspiration of a breast cancer mass” (Lantz, 2015). The dataset includes 569 examples of cancer biopsies and 32 features. The features include an identifier, the cancer diagnosis, and 30 numeric measurements and characteristics (Lantz, 2015). The predictions appear as M for malignant and B for benign.</p> 
    <p>The first step in developing the k-NN algorithm is to upload the dataset to R and use the str() function to visualize the dataset’s features. The next line of code removes the identifier variable because machine learning algorithms can use the identifier to produce a false measurement of accuracy on familiar data (Lantz, 2015). The following commands print a table of the diagnosis variable and convert the labels to malignant and benign. The proportion table then shows the percentage of malignant and benign tumors.</p>
    <p>The next step in building the k-NN model is to normalize the dataset. The variable summary in the following command shows that the average area, smoothness, and radius do not follow the same measurement scale. Normalizing the data means generating the same distance between a five-number summary’s measurements for each variable in use. In other words, normalization creates a more measurable scale between the minimum and maximum values of the variable. The following block of code creates a normalize function. The lapply() function in the subsequent statement normalizes all variables in the dataset except the diagnosis because it is a categorical variable. The summary() command illustrates that the normalize function worked as intended.</p> 
    <p>The following block of code partitions the dataset into training, validation, and testing partitions, using a 70% split for the training data and 15% splits for the validation and testing sets. The next command fits the training and testing datasets to a k-NN model that compares the results to the training labels using the parameter k = 21, or 21 neighbors. The cross table below shows that the k-NN model using 21 neighbors was accurate 100% of the time on the validation set. However, this model is overfitting slightly, as shown in the test set evaluation at the end of the analysis.</P> 
<br/>
      **Model One: k = 21/normalization**
      <center><img src="/images/model1Eval.png" ...></center>
<br/>
    <p>The following block of code generates new data partitions, this time using z-score standardization instead of normalization. The confusion matrix shows that this model was less accurate than the model that normalized variables. The model using z-score standardization misclassified benign tumors three times and was 96% accurate. Adjusting the k parameter could produce a more accurate model.</P>
<br/>
      **Model Two: k = 21/z-score**
      <center><img src="/images/model2Eval.png" ...></center>
<br/>
    <p>The caret package can generate multiple models to determine which value of k produces the most accurate k -NN model. The caret package used the original dataset, including the diagnosis variable. The first lines of code set a control function and a seed value to replicate the results. The next statement used the train() command from the caret package to test several values of k using the kappa statistic for evaluation. This function’s output showed that k = 11 produced the most accurate model with 98% accuracy and one benign misclassification. The confusion matrix below shows the evaluation of this model on the validation set.</p> 
<br/>
      **Model Three: Caret Tuning k = 11/normalization**
      <center><img src="/images/model3Eval.png" ...></center>
<br/>
   <p>The first confusion matrix below shows the evaluation of the model with k set to 11, as recommended by tuning with the caret package. The second confusion matrix is the final evaluation of the original model using normalization with k set to 21. These confusion matrices evaluate the models on the test set. The first model had an accuracy of 97% with two benign tumor misclassifications. The second model had an accuracy of 96% with three benign misclassifications.</p>
<br/>
      **Model Four: k = 11/normalization Test Data**
      <center><img src="/images/model4Eval.png" ...></center>
<br/>
      **Model Five: K = 21/normalization Test Data**
      <center><img src="/images/model5Eval.png" ...></center>
<br/>
    <p>In conclusion, the k-NN algorithm performs tumor classification with a high level of accuracy. For this analysis, the parameters identified from model tuning with the caret package were the most accurate. The best model used normalization and set k equal to 11. A model that makes no misclassifications would be better. However, it is promising that none of the models misclassified a malignant tumor.</p> 
<br/>
                                           References
Lantz, Brett. (2015). Machine Learning with R Second Edition. Birmingham, UK. Packt Publishing.  
<br/>
