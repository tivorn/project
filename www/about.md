#### Objetivo

Este painel foi desenvolvido para visualizar as projeções dos preços pagos aos produtos na comercialização da soja em dólares americanos por saca de 60kg.

#### Motivação

A soja desempenha papel fundamental na avicultura, um dos principais insumos agrícolas utilizados como ração para aves. Diante disso, os tomadores de decisão precisam antecipar as oscilações possíveis deste insumo para projetar curvas de custos de produção, em virtude dos preços desses produtos serem instáveis temporalmente (não estacionários) por influência de fatores exógenos.

#### Atualização

O processo de atualização dos dados dos preços da soja é realizado automaticamente e diariamente via técnicas de raspagem (web scraping) da base disponibilizada pela CEPEA-ESALQ/USP. 

#### Métodos

As projeções são geradas com a utilização de 6 modelos de previsão de séries temporais distintos, são eles:

1. ARIMA (Autoregressive Integrated Moving Average)
2. ETS (Error Trend Seasonal)
3. NNETAR (Neural Network AutoRegression)
4. STL + ETS (Seasonal and Trend decomposition using Loess)
5. TBATS (Exponential smoothing state space model with Box-Cox transformation, ARMA errors, Trend and Seasonal components)
6. Prophet