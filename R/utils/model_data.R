source(
  here::here("R", "utils", "wrang_data.R")
)

library(tidymodels)
library(modeltime)
library(timetk)   

# Separação ----

splits <- df_soybean_price %>% initial_time_split(prop = 0.8)

# Ajuste ----

## ETS (Error Trend Seasonal) ----

model_spec_ets <- exp_smoothing() %>%
  set_engine("ets")

model_fit_ets <- model_spec_ets %>%
  fit(price_us_dollar ~ date, training(splits))

## auto ARIMA (Autoregressive Integrated Moving Average) ----

model_spec_arima <- arima_reg() %>%
  set_engine("auto_arima")

model_fit_arima <- model_spec_arima %>%
  fit(price_us_dollar ~ date, training(splits))

## NNETAR (Neural Network AutoRegression) ----

model_spec_nnetar <- nnetar_reg() %>%
  set_engine("nnetar")

model_fit_nnetar <- model_spec_nnetar %>%
  fit(price_us_dollar ~ date, training(splits))

## STL + ETS (Seasonal and Trend decomposition using Loess) ----

model_spec_stl_ets <- seasonal_reg() %>%
  set_engine("stlm_ets")

model_fit_stl_ets <- model_spec_stl_ets %>%
  fit(price_us_dollar ~ date, training(splits))

## TBATS (Exponential smoothing state space model with Box-Cox transformation, ARMA errors, Trend and Seasonal components)----

model_spec_tbats <- seasonal_reg() %>%
  set_engine("tbats")

model_fit_tbats <- model_spec_tbats %>%
  fit(price_us_dollar ~ date, training(splits))

## Prophet ----

model_spec_prophet <- prophet_reg(seasonality_daily = TRUE) %>%
  set_engine("prophet") 

model_fit_prophet <- model_spec_prophet %>%
  fit(price_us_dollar ~ date, training(splits))


# Avaliação ----

model_table <- modeltime_table(
  model_fit_arima,
  model_fit_nnetar,
  model_fit_stl_ets,
  model_fit_tbats,
  model_fit_prophet,
  model_fit_ets
)

calibration_table <- model_table %>%
  modeltime_calibrate(testing(splits))

model_accuracy_table <- calibration_table %>%
  modeltime_accuracy() 

# Projeção ----

model_forecast <- calibration_table %>%
  modeltime_refit(df_soybean_price) %>%
  modeltime_forecast(h = "30 days",
                     actual = df_soybean_price)
