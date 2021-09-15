# Creation of hyperlinks to instructions

# Load packages 
library(fs)
library(tidyverse)

# Set root-url
git_url <- "(https://kirenz.github.io/instructions/"

# Obtain html-files from directory
html_files <- 
  dir_info(recurse = TRUE, glob = "hw-instructions/*.html") %>% 
  pull(path)

# Combine root-url with html-files
html_links <- 
  html_files %>% 
  map_chr(~ paste0(git_url, ., ")  ")) %>% 
  tibble() 

# Obtain names of homeworks and add text
homework_names <- 
  dir_ls(recurse = 1, type = "directory") %>%
  word(., 2, sep="/") %>% 
  map_chr(~ paste0("- [Aufgabenstellung für ", ., "]")) %>% 
  tibble() %>% 
  filter(str_detect(.,"\\d+"))
  
# Combine homework names with html links
html_links_hw_names <- 
  homework_names %>%
  bind_cols(html_links) %>% 
  mutate(links = paste0(`....1`, `....2`)) %>% 
  select(links)
 
# Write csv
write_csv(html_links_hw_names, "html-links.csv", col_names=FALSE)
