setwd("E:/HY0021/HY0021_2nd_hybridoma/1. ms_ELISA_binding_06192023")

library(tidyverse)
library(ggsci)

hu_elisa <- read_csv("./hu_reading_tidy_norm.csv")
ms_elisa <- read_csv("./ms_reading_tidy_norm.csv")

hu_ms <- hu_elisa %>% 
  left_join(ms_elisa, by = c("plate", "well"), suffix = c("_hu", "_ms"))

ggplot(data = hu_ms) +
  geom_point(aes(x = norm_reading_hu, y = norm_reading_ms, color = label_hu), size = 3) +
  xlim(0, 0.75) +
  ylim(0, 0.75) +
  scale_color_jco() +
  labs(title = "2HY21 Hybridoma ELISA Binding Hu vs Ms", 
       subtitle = "Plate 1,2, and 3, zoom in",
       x = "Human Binding, Normalized",
       y = "Mouse Binding, Normalized",
       color = "label", 
       caption = "Jun 19, 2023")

ggsave("elisa_hu_vs_ms_1-3_zoom.png", width = 25, height = 20, units = "cm", dpi = "retina")

ms_elisa_top <- ms_elisa %>% 
  filter(label == "samples") %>% 
  slice_max(norm_reading, n = 90, with_ties = FALSE) %>% 
  arrange(plate, well)

ggplot(data = ms_elisa) +
  geom_hline(yintercept = min(ms_elisa_top$norm_reading), linetype = "dashed") +
  geom_point(aes(x = plate, y = norm_reading, color = label), size = 3, alpha = 0.85) +
  labs(title = "2HY21 Hybridoma ELISA Ms Binding per Plate", 
       subtitle = "90 Selected for Reporter Clocking, min reading = 0.113",
       x = "Plate", 
       y = "ELISA Reading, Normalize", 
       caption = "Jun 19, 2023") +
  scale_color_jco()
  
ggsave("ms_binding.png", width = 35, height = 20, units = "cm", dpi = "retina")

write_csv(ms_elisa_top, "./ms_selected.csv")

