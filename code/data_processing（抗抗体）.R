setwd("E:/HY0015_03112024")

library(tidyverse)
library(ggsci)

drug_raw <- read_csv("./HY0015-15Y1-073_Norm.csv")
ig_raw <- read_csv("./HY0015-huIgG_Norm.csv")

elisa_combine <- drug_raw %>% 
  left_join(ig_raw, by = c("plate", "well"), suffix = c("_drug", "_ig"))

ggplot(data = elisa_combine) +
  geom_vline(xintercept = 0.2, linetype = "dashed") +
  geom_hline(yintercept = 0.8, linetype = "dashed") +
  geom_point(aes(x = norm_reading_ig, y = norm_reading_drug, color = label_drug), 
             alpha = 0.7,
             size = 3) +
  scale_color_manual(values = c("#20854EFF", "#BC3C29FF", "#6F99ADFF")) +
  labs(title = "Anti-15Y1-073 Hybridoma ELISA Screening",
       subtitle = "179 Clones Selected. Norm_huIgG < 0.2 & Norm_15Y1-073 >= 0.8",
       x = "huIgG Binding, Normalized",
       y = "15Y1-073 Binding, Normalized",
       color = NULL)

ggsave("./elisa.png", width = 10, height = 7, dpi = "retina")

selected_clones <- elisa_combine %>% 
  filter(norm_reading_ig < 0.2, norm_reading_drug >= 0.8) %>% 
  mutate(plate = as.numeric(str_extract(plate, "\\d+$"))) %>% 
  arrange(plate, well) %>% 
  select(plate, well, contains("Reading"), label = label_drug)

write_csv(selected_clones, "./selected_clones.csv")

