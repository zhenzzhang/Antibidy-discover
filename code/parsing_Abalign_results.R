library(tidyverse)

fx2tab <- function (filename){
  
  #read fasta file
  
  file1 <- readLines(filename)
  
  #find the genename location by grepping >
  
  location <- which((str_sub(file1,1,1))==">")
  
  #start an empty vector to collect name and sequence 
  
  name=c()
  sequence =c()
  
  
  
  #number of genes= number of loops
  #extract name first
  for ( i in 1:length(location)){
    name_line = location[i]
    name1 = file1[name_line]
    name=c(name,name1)
    #extract sequence between the names
    #the last sequence will be missed using this strategy 
    #so, we are using if condition to extract last sequence 
    start= location[i]+1
    end = location[i+1]-1
    if ( i < length (location)){
      
      end=end
      
    } else {
      
      end=length(file1)
    }
    
    lines = start:end
    sequence1= as.character(paste(file1[lines],collapse = ""))
    sequence =c(sequence,sequence1)
  }
  
  #now create table using name and sequence vector and return
  
  tibble(name,sequence)

  #function ends
}

folder_name <- readline("Enter Abalign Folder address: ")
setwd(folder_name)

seq_annotation_rm_dup <- fx2tab(list.files()[str_detect(list.files(), "temp.txt")])

clonotype <- read_csv(list.files()[str_detect(list.files(), 
                                              "clonotype.csv")])

clonotype_seq <- read_csv(list.files()[str_detect(list.files(), 
                                                  "clonotype_seqs.csv")])

seq_annotation_split <- seq_annotation_rm_dup %>% 
  mutate(sequence = str_remove_all(sequence, "-"),
         clone_id = str_extract(name, "(?<=^>)[^|]*")) %>% 
  separate_wider_delim(sequence, delim = "*", 
                       names = c("Fw1", "CDR1", "Fw2", "CDR2", "Fw3", "CDR3", "Fw4"), 
                       cols_remove = FALSE)

clonotype_num <- clonotype %>% 
  mutate(group_id = seq_along(Clonotype))

clonotype_seq_num_annotation <- clonotype_seq %>% 
  left_join(clonotype_num, by = "Clonotype") %>% 
  mutate(clone_id = str_extract(Sequence_Name, "(?<=^>)[^|]*")) %>% 
  left_join(seq_annotation_split, by = "clone_id") %>% 
  select(group_id, Clonotype, clone_id, everything(), -name, -sequence, -Sequence_Name)

group_and_members <- clonotype_seq_num_annotation %>% 
  group_by(group_id) %>% 
  mutate(members = paste0(sort(clone_id), collapse = ",")) %>%
  ungroup() %>% 
  select(group_id, members) %>% 
  distinct_all()

write_excel_csv(clonotype_seq_num_annotation, "./Abalign_clonotype_rm_dup.csv")
write_excel_csv(group_and_members, "./group_and_members.csv")

rm(list = ls())
