
plate1 <- c(c("NB_Ctrl","B_Ctrl","Drug_Only"), selected$clone_id[1:93]) %>% 
  matrix(nrow = 8, ncol = 12, byrow = T,
         dimnames = list(LETTERS[1:8], c(1:12))) %>% 
  tibble()


plate2 <- c(c("NB_Ctrl","B_Ctrl","Drug_Only"), selected$clone_id[94:186]) %>% 
  matrix(nrow = 8, ncol = 12, byrow = T,
         dimnames = list(LETTERS[1:8], c(1:12))) %>% 
  tibble() 
