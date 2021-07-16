source(
  here::here("R", "utils", "load_data.R")
)

temp_file <- load_data()

raw_df_soybean_price <-  readxl::read_xls(temp_file, skip = 3)

df_soybean_price <- raw_df_soybean_price %>%
  janitor::clean_names() %>%
  rename(date = data,
         price_us_dollar = a_vista_us) %>%
  mutate(date = dmy(date),
         price_us_dollar = price_us_dollar %>% 
           str_replace(",", ".") %>%
           as.numeric())  %>%
  select(date, price_us_dollar)


