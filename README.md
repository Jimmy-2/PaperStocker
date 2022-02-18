# PaperStocker - iOS PaperTrading App

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Gifs](#Gifs)
4. [Todos](#Todos)

Personal iOS project. Gifs to be added once premium endpoints subscription is purchased


## Overview
### Description
Stock paper trading app for the iOS platform. 

## Product Spec
### Screens and Features

* Welcome Screen
    * A screen that appears when the user first opens the app. Allows user to choose a starting balance for paper trading.
* Home/1st tab: Portfolio
    * Screen that lists all stocks that the user currently holds. Shows the current returns of the stocks held. Features a daily balance line graph. Users can click on listed stocks to access the detail screen for the chosen stock. Users can swipe down to refresh the prices of the stocks with real time prices. 
* 2nd tab: Search Stock/Ticker
    * Users can search for a stock's ticker or name and access a list of all stocks with the searched keywords. Users can click on searched stock to access the detail screen for the chosen stock. 
* 3rd tab: News
    *  User can search for a stock's ticker and access news articles relating to the searched ticker. Users can also search for more than 1 stock ticker to access news relating to multiple stocks. 
* 4th tab: Settings
    * Users can access the change balance, daily balance, and the summary screens from this tab. 
    * Change Balance Screen: Users can change their current balance in case they need access to more money or less money.
    * Daily Balance Screen: Displays the history of the daily balance for the user. 
    * Summary Screen: Displays a pie chart of the portfolio distribution. Users can also access data relevant to their paper trading such as their best/worse stocks bought and sold as well as a list of all stocks ever bought and sold along with the profits/losses earned for the stocks.
* Detail Screen
    * Displays relevant data and price quotes for the stock as well as a historical price candle stick chart. Users can buy and sell stocks by accessing the trade screen from here.
* Trade Screen
    * Users can directly buy and sell stocks.
    
    
### Original Wireframe
<img src="https://github.com/Jimmy-2/PaperStocker/blob/main/gifs/OriginalWireframe.png?raw=true" height=300>

##### APIs Used
FinancialModelingPrep API
- Base URL - [https://financialmodelingprep.com](https://site.financialmodelingprep.com/developer/docs)

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /api/v3/quote-short/AAPL,FB | gets realtime price of stock(s) at the time of request
    `GET`    | /api/v3/quote/AAPL | gets realtime price of stock(s) at the time of request as well as other important information
    `GET`    | /api/v3/search?query=AA&limit=10&exchange=NASDAQ | gets list of stocks based on searched stock/ticker
    `GET`    | /api/v3/historical-chart/1min/AAPL | gets list of historical prices for the stock for graphs
    `GET`    | /api/v3/stock_news?tickers=AAPL,FB,GOOG,AMZN | gets list of news relating to the searched tickers
    
    

## Gifs
##### Full App Demo:

<img src='https://github.com/Jimmy-2/PaperStocker/blob/main/gifs/appDemoOldApp.gif?raw=true' title='Full Demo' width='' alt='Full Demo' />

##### Fresh App Short Demo:

<img src='https://github.com/Jimmy-2/PaperStocker/blob/main/gifs/appDemoNewApp.gif?raw=true' title='Short Demo' width='' alt='Short Demo' />

##### (Old) Home screen and stock detail screen swipe down to refresh:

<img src='https://raw.githubusercontent.com/Jimmy-2/PaperStocker/main/gifs/Refresh1.gif' title='Refresh gif' width='' alt='Refresh gif' />

##### (Old) Home screen and stock detail screen swipe down to refresh when phone has no internet(Minor adjustments need to be made on dismissing the refreshing symbol):

<img src='https://raw.githubusercontent.com/Jimmy-2/PaperStocker/main/gifs/IfNoInternet.gif' title='Refresh gif' width='' alt='Refresh gif' />

