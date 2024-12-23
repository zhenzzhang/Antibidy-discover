library(tidyverse)
library(stringr)
 str_length("i am a student")

 str_c(c("x", "y", "z"), sep = ", ")
?str_c
 str_c("Letter: ", letters)
 str_c("Letter", letters, sep = ": ")
 str_c(letters, " is for", "...")
 str_c(letters[-26], " comes before ", letters[-1])
 
 str_c(letters, collapse = "")
 str_c(letters, collapse = ", ")
 
 # Differences from paste() ----------------------
 # Missing inputs give missing outputs
 str_c(c("a", NA, "b"), "-d")
 paste0(c("a", NA, "b"), "-d")
 # Use str_replace_NA to display literal NAs:
 str_c(str_replace_na(c("a", NA, "b")), "-d")
 
 # Uses tidyverse recycling rules
 ## Not run: str_c(1:2, 1:3) # errors
 paste0(1:2, 1:3)
 
 str_c("x", character())
 paste0("x", character())
 
 x <- c("Apple", "Banana", "Pear")
 str_sub(x, -4, -1)
 
 str_sub(x, 1, 1)
 str_sub(x, 2, 4) <- "Q" 
x 
x <- c("apple", "banana", "pear")
str_view(string = x, pattern = "an")

x <- c("apple", "banana", "pear")
str_view(x, ".a.")

c("s.d") %>%
  str_view(".")
c("s.d") %>%
  str_view("\\.")
x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "^apple$")
str_view(c("grey", "gray"), "gr[ea]y")

x <- "Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "X+")
x <- "Roman numerals: MDCCCLXXXVIII"
str_view(x, "C{2}")
str_view(x, "C{2,}")  
str_view(x, "C{2,3}")
str_view(x, "CLX+")
str_view(x, "CL+X")
str_view(x, "CLX+?")



ft <- fruit %>% head(10)
ft
str_view(ft, ".{2}", match = TRUE)
str_view(ft, "(.)\\1", match = TRUE)
str_view(ft, "(..)\\1", match = TRUE)
str_view(ft, "(.)(.)\\2\\1", match = TRUE)


