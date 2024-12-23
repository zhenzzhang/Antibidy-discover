setwd("E:/HY01-planB/HY01B_6th_hybridoma_03082023/4.subclone_cell_binding_03182023")

library(tidyverse)
library(ggsci)

facs_raw <- readxl::read_xlsx("./subclone_cell_binding_03182023.xlsx")

ggplot(data = facs_raw %>% mutate(clone = as.factor(clone),
                                  clone = reorder(clone, sw900_logshift, max, decreasing = TRUE))) +
  geom_point(aes(x = hela_logshift, y = sw900_logshift, color = clone), size = 3) +
  scale_color_nejm()

ggsave("./sw900_hela.png", dpi = "retina")

ggplot(data = facs_raw %>% mutate(clone = as.factor(clone),
                                  clone = reorder(clone, sw900_logshift, max, decreasing = TRUE))) +
  geom_point(aes(x = h23_logshift, y = sw900_logshift, color = clone), size = 3) +
  scale_color_nejm()

ggsave("./sw900_h23.png", dpi = "retina")

ggplot(data = facs_raw %>% mutate(clone = as.factor(clone),
                                  clone = reorder(clone, sw900_logshift, max, decreasing = TRUE))) +
  geom_point(aes(x = hela_logshift, y = h23_logshift, color = clone), size = 3) +
  scale_color_nejm()

ggsave("./h23_hela.png", dpi = "retina")
