# Learning Causal Inference Through Examples
This Shiny application is developed to help students learn basic concepts of causal inference through the five examples presented in our paper 
*Introducing Causal Inference Using Bayesian Networks and *do*-Calculus*. 
## Run the Application 
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
## Use the Application 
**Step 1**: In the top panel on the left, select one of the first four examples. For instance, select Example 4 *Color Preference by Culture* and the example’s BN model structure will show in the panel below.

![image](https://user-images.githubusercontent.com/44960049/178742721-e73a0a56-15e1-4b77-9d00-c1dde3170e86.png)

Meanwhile, its DAG is shown in the DAG tab on the right

![image](https://user-images.githubusercontent.com/44960049/178742662-979bd8b6-ffbd-455a-adc5-7d6e71aebb82.png)

**Step 2**: In the third panel on the left, select a variable and complete its probability table in the ```Prob. Table/Data File``` tab.

![image](https://user-images.githubusercontent.com/44960049/178743108-488afa3f-734e-4c8e-a046-1b5db5bd1b52.png)

![image](https://user-images.githubusercontent.com/44960049/178743176-48cb5bcc-475b-4a9d-a939-3744675de81c.png)

After that, press **Apply** to load the table into the BN model. Repeat this step for each of the other variables in the example.

![image](https://user-images.githubusercontent.com/44960049/178743372-e4923f78-aa3c-4af2-a050-a76b1016f78e.png)

![image](https://user-images.githubusercontent.com/44960049/178743441-4b027752-671f-4d4f-988c-40b700613569.png)

**Note: It is important that you complete the table as a probability table (i.e. the row sum of each row is one), not contingency table. Otherwise, the app will be 
interrupted.**

**Step 3**: After all the probability tables in one example are completed, press **Compile** to build the preintervention model that will be shown in the ```Preintervention Model``` tab.

![image](https://user-images.githubusercontent.com/44960049/178744561-46b01c37-03cd-47c9-94ea-6b236d386db8.png)

**Step 4**: Variable intervention and manipulation can be done in the two panels as shown below

![image](https://user-images.githubusercontent.com/44960049/178744242-f3d512e0-97b0-4eda-ae72-d12cb0534786.png)

First, specify the variable(s) you want to intervene on and then fix the variables at selected state(s). Second, select the variable to view its postintervention conditional (and marginal, if it is the effect variable) distributions in the ```Postintervention Distribution``` tab. 

**Note: due to space limit, the conditional distribution for some variable is not fully displayed in the app.**

![image](https://user-images.githubusercontent.com/44960049/178744395-f3ab1623-de32-4d36-aca4-3409923aee2c.png)

If selecting Example 5 *Effect of Smoking on Forced Expiratory Volume* in **Step 1**, instead of completing the probability tables manually in **Step 2**, you press **Load** to load the example data file directly from JSDE website

![image](https://user-images.githubusercontent.com/44960049/178312017-a9a2b1fd-c074-42e4-9495-0eafaefb0e97.png)

The loaded data will show in the ```Prob. Table/Data File``` tab.

![image](https://user-images.githubusercontent.com/44960049/178312100-2e95285a-be2f-40c0-8e8d-f8441c2bc073.png)

You can then follow the other steps instructed above to complete this example.



