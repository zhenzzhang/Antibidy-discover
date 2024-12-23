setwd("E:/152_sbclone_ELISA_7072023")

library(tidyverse)
library(janitor)
library(ggsci)

plate_group <- read_csv("./raw/152_subclone_Tidy_Reading_newNorm.csv", skip = 0)


plate_group <- plate_group %>% 
  mutate(clone_id  = str_extract(plate, "^\\d+[A-H]\\d+"))

write_excel_csv(plate_group, "./clone_reading_tidy_norm.csv")

ggplot(data = plate_group) +
  geom_jitter(aes(x = clone_id, y = norm_reading, color = label), width = 0.1, size = 2.5, alpha = 0.9) +
  labs(title = "152 Subclone, 152 ELISA Binding",
       x = "Clone ID",
       y = "ELISA Reading, Normalized", 
       caption = "Jul 07, 2023") +
  scale_color_jco()

ggsave("./152_binding_per_plate.png", width = 20, height = 15, units = "cm", dpi = "retina")

selected <- plate_group %>% 
  group_by(clone_id) %>% 
  filter(label == "samples") %>% 
  slice_max(order_by = norm_reading, n = 30, with_ties = FALSE) %>% 
  ungroup() %>% 
  arrange(as.numeric(str_extract(clone_id, "^\\d+")))

write_excel_csv(selected, "./pos_wells.csv")  
