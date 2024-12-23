# This a script for normalizing “long format” ELISA reading based on per plate
# positive and negative control.
# 
# The raw_data.csv is the default long format output from Thermal MULTISKAN GO

library(tidyverse)
library(janitor)
library(readxl)
library(gridExtra)
#E:\3HY0021_subclone_ELISA_07282023\raw\3HY0021_subclone1_07282023.csv
# User input file address and control position.
file_name <- readline("Enter file address: ")
pos_pos <- readline("Where is your positive control: ")
neg_pos <- readline("Where is your negative control: ")

# Read in the raw excel file.
elisa_raw <- read_csv(file_name, skip = 2, locale = locale(encoding = "GBK")) %>% 
  clean_names()

# Remove unused columns and label controls
elisa_reading <- elisa_raw %>% 
  select(plate = ban, well = kong, reading = xi_guang_zhi) %>% 
  mutate(label = case_when(well == pos_pos ~ "pos_control", 
                           well == neg_pos ~ "neg_control",
                           TRUE ~ "samples"))

# Normalization
mean <- mean(elisa_reading$reading[which(elisa_reading$label == "pos_control")])

plate_group <- elisa_reading %>% 
  group_by(plate) %>% 
  mutate(P_N = reading[label == "pos_control"] - min(reading),
         S_N = reading - min(reading),
         norm_reading = S_N / P_N * mean) %>% 
  ungroup() %>% 
  select(plate, well, reading, norm_reading, label)

# Quick visualization
p1 <- ggplot(plate_group) +
  geom_boxplot(mapping = aes(x = label, y = reading, color = label), 
               show.legend = FALSE)

p2 <- ggplot(plate_group) +
  geom_boxplot(mapping = aes(x = label, y = norm_reading, color = label))

grid.arrange(p1, p2, nrow = 1)

# Write outputs
out_address <- paste(dirname(file_name), "Tidy_Reading_newNorm.csv", sep = "/")
write_csv(plate_group, out_address)