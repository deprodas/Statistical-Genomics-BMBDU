# Microarray data normalization and annotation Workflow 

# Temozolomide (TMZ) treatment on 3,000 cells. Dose range - 0.39-100 µM. 

# Trial for different probe libraries due to insufficiency in manufacturer information 

BiocManager::install("hgu95av2.db")
BiocManager::install("hgu133plus2.db")
BiocManager::install("hugene10stv1probe")
BiocManager::install("hugene10sttranscriptcluster.db")

# Necessary Libraries 
library(tidyverse) 
library(affy) 
library(Biobase)
library(oligo) 
library(oligoClasses)
library("AnnotationDbi") 
library(hgu95av2.db)
library(hgu133plus2.db)
library(hugene10stv1probe)
library(hugene10sttranscriptcluster.db) 


# Raw data input & Background correction, Normalization, Calculating Expression 

rawdata_1 <- ReadAffy() 
Biobase::exprs(rawdata_1) 

normalized_data <- oligo::rma(raw_data, target = "core")  
normalized_express_data <- as.data.frame(exprs(normalized_data))

# Map probe IDs to gene symbols 

anno_palmieri <- AnnotationDbi::select(hugene10sttranscriptcluster.db,
                                       keys = (featureNames(normalized_data)),
                                       columns = c("SYMBOL", "GENENAME"),
                                       keytype = "PROBEID") 

anno_palmieri <- subset(anno_palmieri, !is.na(SYMBOL)) 

# Remove multiple mappings (probe IDs) from the assay data  

anno_grouped <- group_by(anno_palmieri, PROBEID)
anno_summarized <- dplyr::summarize(anno_grouped, no_of_matches = n_distinct(SYMBOL))
anno_filtered <- filter(anno_summarized, no_of_matches > 1) 
head(anno_filtered) 

probe_stats <- anno_filtered 
nrow(probe_stats)

ids_to_exlude <- (featureNames(normalized_data) %in% probe_stats$PROBEID)
table(ids_to_exlude)

normalized_express_final <- subset(normalized_express_data, !ids_to_exlude)
normalized_express_final$PROBEID <- rownames(normalized_express_final)

normalized_final <- subset(normalized_data, !ids_to_exlude) 
validObject(normalized_final) 

# Selection  

all(normalized_express_final$PROBEID %in% anno_palmieri$PROBEID) 
normalized_express_final$PROBEID %in% anno_palmieri$PROBEID
class(normalized_express_final$PROBEID) 
class(anno_palmieri$PROBEID) 

all(anno_palmieri$PROBEID %in% normalized_express_final$PROBEID) 
anno_palmieri$PROBEID %in% normalized_express_final$PROBEID
class(anno_palmieri)
class(normalized_express_final)

Joined_df <- dplyr::left_join(anno_palmieri, normalized_express_final, by= c("PROBEID"= "PROBEID"))

Joined_norExp_ID <- na.omit(Joined_df) 

write.csv(Joined_norExp_ID, "Drug response Normalized expression.csv") 
