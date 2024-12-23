setwd("E:/2.subclone_ELISA_04052023")

library(tidyverse)
library(ggsci)

elisa_raw <- read_csv("./raw/Tidy_Reading_newNorm.csv")
plate_map <- read_csv("./raw/plate_map.csv")

elisa_data <- elisa_raw %>% 
  left_join(plate_map, by = c("Plate" = "plate")) %>% 
  mutate(clone_id = str_extract(clone, "^\\d+[A-H]\\d+"))

ggplot(data = elisa_data) +
  geom_jitter(aes(x = clone_id, y = Norm_Reading, color = Label), 
              alpha = 0.7, width = 0.2) +
  geom_hline(yintercept = 1) +
  scale_color_nejm()

ggsave("elisa_by_clone.png", width = 15, height = 7, dpi = "retina")

selected_clone <- elisa_data %>% 
  filter(Label == "samples") %>%
  mutate(sub_plate = str_extract(clone, "\\d+$")) %>% 
  group_by(clone_id) %>% 
  slice_max(Norm_Reading, n = 30, with_ties = FALSE) %>% 
  arrange(desc(Norm_Reading), .by_group = TRUE) %>% 
  ungroup() %>% 
  arrange(as.numeric(str_extract(clone, "^\\d+"))) %>% 
  select(Clone_ID = clone_id, Clone = clone, Plate, Wells, contains("Reading"))

write_csv(selected_clone, "./selected_clone_top30.csv")
