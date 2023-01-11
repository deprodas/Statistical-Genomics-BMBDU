# Necessary packages

library(R.utils) 


# Process-1 : Manually download the file from NCBI, and Run the following codes 

gunzip("GSE183947_fpkm.csv.gz", remove = FALSE) 


# Process-2 : Copy the URL of the file, and and Run the following codes

download.file(url = "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE183947&format=file&file=GSE183947%5Ffpkm%2Ecsv%2Egz",
              mode = "wb", 
              destfile = file.path("GSE183947_fpkm.csv.gz")) 

gunzip("GSE183947_fpkm.csv.gz", remove = FALSE) 
