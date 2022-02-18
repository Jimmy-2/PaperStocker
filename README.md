# PaperStocker - iOS PaperTrading App

## Table of Contents (to be added)
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Gifs](#Gifs)
4. [Todos](#Todos)

Personal iOS project. Gifs to be added once premium endpoints subscription is purchased


## Overview

## Product Spec
##### API
FinancialModelingPrep API
- Base URL - [https://financialmodelingprep.com](https://site.financialmodelingprep.com/developer/docs)

   HTTP Verb | Endpoint | Demolink| Description
   ----------|----------|------------|------------
    `GET`    | /api/v3/quote-short/AAPL,FB | gets realtime price of stock(s) at the time of request
    `GET`    | /api/v3/quote/AAPL | gets realtime price of stock(s) at the time of request as well as other important information
    `GET`    | /api/v3/search?query=AA&limit=10&exchange=NASDAQ | gets list of stocks based on searched stock/ticker
    `GET`    | /api/v3/historical-chart/1min/AAPL | gets list of historical prices for the stock for graphs
    
    

## Gifs

##### Home screen and stock detail screen swipe down to refresh:

<img src='https://raw.githubusercontent.com/Jimmy-2/PaperStocker/main/gifs/Refresh1.gif' title='Refresh gif' width='' alt='Refresh gif' />

##### Home screen and stock detail screen swipe down to refresh when phone has no internet(Minor adjustments need to be made on dismissing the refreshing symbol):

<img src='https://raw.githubusercontent.com/Jimmy-2/PaperStocker/main/gifs/IfNoInternet.gif' title='Refresh gif' width='' alt='Refresh gif' />

