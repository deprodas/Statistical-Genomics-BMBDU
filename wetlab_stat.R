# Necessary libraries 

library(dplyr) 
library(tidyverse) 
library(janitor) 
library(openxlsx) 
library(ggplot2) 
library(patchwork)

# Read the data 

lamia_aml <- read.xlsx("AML_Control-1.xlsx") 
colnames(lamia_aml) 

# Data manipulation 

lamia_aml[lamia_aml == ""] <- NA    

gene_194 <- lamia_aml %>% dplyr::select(XRCC1_194, Control_194, Age, Gender, AML) %>% na.omit() 
gene_399 <- lamia_aml %>% dplyr::select(XRCC1_399, Control_399, Age, Gender, AML) %>% na.omit() 


# Gene-194 

gene_194 %>% dplyr::count(XRCC1_194) 
gene_194 %>% dplyr::count(Control_194) 

tab_gene194 <- gene_194 %>% tabyl(XRCC1_194, Control_194) 
tab_gene194 <- tab_gene194 %>% dplyr::rename("SC_ctrl194" = "SC", "UC_ctrl194" = "UC") 
tab_gene194[tab_gene194 == "DC"] <- "DC_gene194" 
tab_gene194[tab_gene194 == "SC"] <- "SC_gene194" 
tab_gene194[tab_gene194 == "UC"] <- "UC_gene194" 
tab_gene194 %>% column_to_rownames(var = "XRCC1_194") %>% janitor::fisher.test() 

gene194_tidy <- tab_gene194 %>% pivot_longer(cols = c(SC_ctrl194, UC_ctrl194), names_to = "Control", values_to = "Count")

p194_bar <- gene194_tidy %>% group_by(XRCC1_194) %>% 
  ggplot(aes(x = XRCC1_194, y = Count, fill = Control)) + 
  geom_bar(stat = "identity", position = position_dodge()) + 
  xlab("Treatment group") + 
  scale_fill_manual(values = c("#E76BF3", "#00BCD8", "#6BB100")) + 
  theme_bw()

p194_bar <- p194_bar + theme(axis.text.x = element_text(size = 8, colour = "black"), 
                             axis.text.y = element_text(size = 10, colour = "black")) 
p194_bar

ggsave(filename = "Gene194_barplot.pdf", plot = p194_bar, width = 4, height = 4, units = "in")


# Gene-399 

colnames(gene_399)

gene_399 %>% dplyr::count(XRCC1_399) 
gene_399 %>% dplyr::count(Control_399) 

tab_gene399 <- gene_399 %>% tabyl(XRCC1_399, Control_399) 
tab_gene399 <- tab_gene399 %>% dplyr::rename("DC_ctrl399" = "DC", "SC_ctrl399" = "SC", "UC_ctrl399" = "UC") 
tab_gene399[tab_gene399 == "DC"] <- "DC_gene399" 
tab_gene399[tab_gene399 == "SC"] <- "SC_gene399" 
tab_gene399[tab_gene399 == "UC"] <- "UC_gene399" 
tab_gene399 %>% janitor::fisher.test()   

gene399_tidy <- tab_gene399 %>% pivot_longer(cols = c(SC_ctrl399, UC_ctrl399, DC_ctrl399), names_to = "Control", values_to = "Count")

p399_bar <- gene399_tidy %>% group_by(XRCC1_399) %>% 
  ggplot(aes(x = XRCC1_399, y = Count, fill = Control)) + 
  geom_bar(stat= "identity", position = position_dodge()) + 
  xlab("Treatment group") + 
  scale_fill_manual(values = c("#6BB100", "#E76BF3", "#00BCD8")) + 
  theme_bw() 

p399_bar <- p399_bar + theme(axis.text.x = element_text(size = 8, colour = "black"), 
                             axis.text.y = element_text(size = 10, colour = "black")) 
p399_bar

ggsave(filename = "Gene399_barplot.pdf", plot = p399_bar, width = 5, height = 4, units = "in")


# Plot - ALL 

barplot_lamia <- p194_bar + p399_bar  
barplot_lamia 

ggsave(filename = "All_barplot.pdf", plot = barplot_lamia, width = 9, height = 4, units = "in")


# Extra / Separated P-values 

tab_gene399 %>% dplyr::filter(XRCC1_399 != "DC_gene399") %>% 
  dplyr::select(!DC_ctrl399) %>% 
  column_to_rownames(var = "XRCC1_399") %>% 
  janitor::fisher.test() 

tab_gene399 %>% dplyr::filter(XRCC1_399 != "SC_gene399") %>% 
  dplyr::select(!SC_ctrl399) %>% 
  column_to_rownames(var = "XRCC1_399") %>% 
  janitor::fisher.test() 

tab_gene399 %>% dplyr::filter(XRCC1_399 != "UC_gene399") %>% 
  dplyr::select(!UC_ctrl399) %>% 
  column_to_rownames(var = "XRCC1_399") %>% 
  janitor::fisher.test() 
