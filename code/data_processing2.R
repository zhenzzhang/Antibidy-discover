setwd("E:/anti-ID/1CP-152/anti-ID_1CP152_4th_hybridoma/1.ELISA_03272023")

library(tidyverse)
library(ggsci)

drug_raw <- read_csv("./raw/anti-152-tidy.csv")
ig_raw <- read_csv("./raw/anti-huIgG-tidy.csv")

elisa_combine <- drug_raw %>% 
  mutate(match_plate = paste0("huIg-", str_extract(Plate, "\\d+$"))) %>% 
  left_join(ig_raw, by = c("match_plate" = "Plate", "Wells" = "Wells"), suffix = c("_drug", "_huIgG"))

ggplot(data = elisa_combine) +
  geom_vline(xintercept = 0.2, linetype = "dashed") +
  geom_hline(yintercept = 1.0, linetype = "dashed") +
  geom_point(aes(x = Norm_Reading_huIgG, y = Norm_Reading_drug, color = Label_drug), 
             alpha = 0.7,
             size = 3) +
  scale_color_manual(values = c("#20854EFF", "#BC3C29FF", "#6F99ADFF")) +
  labs(title = "Anti-152 4th Hybridoma ELISA Screening",
       subtitle = "51 Clones Selected. Norm_huIgG < 0.2 & Norm_152 >= 1.0",
       x = "huIgG Binding, Normalized",
       y = "1CP_152 Binding, Normalized",
       color = NULL)

ggsave("./elisa.png", width = 10, height = 7, dpi = "retina")

selected_clones <- elisa_combine %>% 
  filter(Norm_Reading_huIgG < 0.2, Norm_Reading_drug >= 1.0) %>% 
  mutate(Plate = as.numeric(str_extract(Plate, "\\d+$"))) %>% 
  arrange(Plate, Wells) %>% 
  select(Plate, Wells, contains("Reading"), Label = Label_drug)

write_csv(selected_clones, "./selected_clones.csv")


library("scales")
pal_nejm()(8)
show_col(pal_nejm()(8))

selected_clones2 <- elisa_combine %>% 
  filter(Norm_Reading_huIgG < 0.2, Norm_Reading_drug >= 1.0) %>% 
  mutate(Plate = as.numeric(str_extract(Plate, "\\d+$"))) %>% 
  arrange(Plate, Wells) %>% 
  select(Plate, Wells, contains("Reading"), Label = Label_drug)
