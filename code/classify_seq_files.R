# This script will put sequence files from "生工" to different folders based on
# the sequencing condition, for example "正常" and "重叠峰". And it will rename
# the file with only sample ID.
# 
# Input is the folder address.
# 
# Inside the folder are sequencing results and a xls file containing sequencing
# condition downloaded from "生工" website. 


library(tidyverse)
library(fs)

folder_name <- readline("Enter Folder address: ")
setwd(folder_name)

seq_condition <- readxl::read_csv(dir_ls()[str_detect(dir_ls(), ".csv")]) %>% 
  janitor::clean_names()

conditions <- seq_condition %>% 
  pull(ce_xu_jie_guo) %>% 
  unique()

for (i in seq(length(conditions))){
  condition <- conditions[i]
  dir_create(condition)
  id_to_mv <- seq_condition %>% 
    filter(ce_xu_jie_guo == condition) %>% 
    pull(yang_pin_ming_cheng)
  file_to_mv <- dir_ls()[str_detect(dir_ls(), 
                                    paste(id_to_mv, 
                                          collapse = "\\)|"
                                          )
                                    )
                         ]
  file_move(file_to_mv, 
            paste0(path(condition, 
                                    str_extract(file_to_mv, 
                                                "(?<=\\().*(?=\\))"
                                                )
                                    ), 
                               ".",  
                               path_ext(file_to_mv)
                               )
            )
}
