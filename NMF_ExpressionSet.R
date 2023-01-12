# Non-negative matrix factorization (NMF) for an Expression Set object

# Installation of packages 

install.packages('NMF') 
BiocManager::install("Biobase") 

# Necessary libraries 

library(NMF) 
library(Biobase) 

# Dummy data : Visualizing esGolub dataset  

data(esGolub) 

sabiha <- exprs(esGolub) 
shakil <- pData(esGolub) 
faijan <- cbind(shakil, t(sabiha)) 

# Conversion of our experimental data to expression matrix 

ourData <- read.csv("15geneexpressionucscxena.csv") 
ourData <- as.matrix(ourData)
exprSet <- ExpressionSet(assayData = ourData)
estim.r <- NMF::nmf(exprSet, 2:6, nrun=1, seed=123) 

# Plot the data 

plot(estim.r) 
