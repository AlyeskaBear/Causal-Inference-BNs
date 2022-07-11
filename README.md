# Learning Causal Inference Through Examples
This Shiny application is developed to help students learn basic concepts of causal inference through the five examples presented in our paper 
*Introducing Causal Inference Using Bayesian Networks and *do*-Calculus*. 
## Install and Run the Application 
### Run on [ShinyApps.io](https://www.shinyapps.io)
We have deployed this app to [https://alyeskabear.shinyapps.io/BNandCausalinference/](https://alyeskabear.shinyapps.io/BNandCausalinference/). So, you can run it as a web application without installing anything locally.
### Run on your local machine
If you prefer to run the app locally, you need to first install some prerequisite R packages. 
```R
install.packages(c("BiocManager",
                   "DT",
                   "bnlearn",
                   "gRain",
                   "arules",
                   "dplyr",
                   "shiny",
                   "shinythemes",
                   "rhandsontable",
                   "DiagrammeR"))
BiocManager::install(c("graph", "Rgraphviz", "RBGL"), dependencies=TRUE)
```
Then, you can run the app
```R
library(shiny); runGitHub("Causal-Inference-BNs", "AlyeskaBear")
```
### Use the Application 
**Step 1**: In the top panel on the left, select one of the first four examples. For instance, select Example 4 *Should I switch?* and the example’s BN model structure will show in the panel below.

![image](https://user-images.githubusercontent.com/44960049/178309268-8b17f7b9-bef3-4df7-81d3-10f3bc0e5e45.png)

Meanwhile, its DAG is shown in the DAG tab on the right

![image](https://user-images.githubusercontent.com/44960049/178309447-98214be3-8b4f-4734-9a70-cd1a0dcae762.png)

**Step 2**: In the third panel on the left, select a variable and complete its conditional probability table in the ```Prob. Table/Data File``` tab.

![image](https://user-images.githubusercontent.com/44960049/178310090-a0f56a09-b359-471d-ae53-a14dbcdd2d61.png)

![image](https://user-images.githubusercontent.com/44960049/178310432-5da7c609-f8f6-4d02-9cda-f810200b2839.png)

**Note: It is important that you complete the table as a probability table (i.e. the row sum of each row is one), not contingency table. Otherwise, the app will be 
interrupted.**

After that, press **Apply** to load the table into the BN model. Repeat this step for each variable in the example.
**Step 3**: After all the probability tables in one example are completed, press **Compile** to build the preintervention model that will be shown in the ```Preintervention Model``` tab.

![image](https://user-images.githubusercontent.com/44960049/178311507-fe1dc12e-a3b3-46e8-a12a-f881faf42e4f.png)

**Step 4**: Variable intervention and manipulation can be done in the two panels as shown below

![image](https://user-images.githubusercontent.com/44960049/178311605-f1b0c1ca-aaef-4c2f-9cd4-943c4b0f8a38.png)

First, specify the variables you want to intervene on and then fix the variables at selected states. Second, select the variable to view its postintervention conditional (and marginal, if it is the effect variable) distributions in the ```Postintervention Distribution``` tab. (Note: due to space limit, the conditional distribution for some variable is not fully displayed in the app.)

![image](https://user-images.githubusercontent.com/44960049/178311748-d5617424-8de0-41a1-9b77-443a56008550.png)

If selecting Example 5 *Effect of Smoking on Forced Expiratory Volume* in **Step 1**, instead of completing the probability tables manually in **Step 2**, you press **Load** to load the example data file directly from JSDE website

![image](https://user-images.githubusercontent.com/44960049/178312017-a9a2b1fd-c074-42e4-9495-0eafaefb0e97.png)

The loaded data will show in the ```Prob. Table/Data File``` tab.

![image](https://user-images.githubusercontent.com/44960049/178312100-2e95285a-be2f-40c0-8e8d-f8441c2bc073.png)

You can then follow the other steps instructed above to complete the example.



