SELECT * FROM crypto_market_data
LIMIT 100;

-- скільки всього записів в таблиці
SELECT COUNT(*)
FROM crypto_market_data;
-- 1000 записів

-- кількість унікальних криптовалют
SELECT  COUNT(DISTINCT crypto_name)
FROM crypto_market_data;
-- 5 криптовалют зазначено в базі

--знайти максимальну та мінімальну дату в даних
SELECT MAX(date), MIN(date)
FROM crypto_market_data;
--2023-07-19(MAX DATE), 2023-01-01 (MIN DATE)

--Знайти мінімальну, максимальну та середню ціну
SELECT 
    crypto_name, 
    MAX(open_price) AS max_open_price, 
    MAX(close_price) AS max_close_price, 
    MIN(open_price) AS min_open_price, 
    MIN(close_price) AS min_close_price, 
    ROUND(AVG(open_price), 2) AS avg_open_price, 
    ROUND(AVG(close_price), 2) AS avg_close_price
FROM crypto_market_data
GROUP BY crypto_name;

-- Визначити криптовалюту з найбільшим зростанням ціни
SELECT crypto_name, ROUND(MAX(close_price - open_price),2) AS max_price_increase
FROM crypto_market_data;
-- Bitcoin має максимальне зростання ціни 2453.16

--Визначення середнього, мінімального та максимального обсягу торгів для кожної криптовалюти
SELECT crypto_name, 
    ROUND(AVG(volume), 2) AS avg_volume, 
    MIN(volume) AS min_volume, 
    MAX(volume) AS max_volume
FROM crypto_market_data
GROUP BY crypto_name
ORDER BY avg_volume;

--Знайти дні з найбільшим обсягом торгів (найбільш ліквідні дні) по кожній валюті
SELECT crypto_name, 
	date,
	MAX(volume) AS max_volume
FROM crypto_market_data
GROUP BY crypto_name, date
ORDER BY max_volume DESC
LIMIT 20;

--Знайти дні з найбільшим обсягом торгів (найбільш ліквідні дні) по дням 
SELECT 
    date, 
    SUM(volume) AS total_volume
FROM crypto_market_data
GROUP BY date
ORDER BY total_volume DESC
LIMIT 20;

-- Визначити топ-3 криптовалюти за ринковою капіталізацією 
WITH MonthlyCap AS (
    SELECT 
        crypto_name, 
        strftime('%Y', date) AS year,
        strftime('%m', date) AS month,
        AVG(market_cap) AS avg_market_cap
    FROM crypto_market_data
    GROUP BY crypto_name, year, month
),
Ranked AS (
    SELECT 
        crypto_name, 
        year,
        month,
        avg_market_cap,
        RANK() OVER (PARTITION BY year, month ORDER BY avg_market_cap DESC) AS rank
    FROM MonthlyCap
)
SELECT crypto_name, year, month, avg_market_cap
FROM Ranked
WHERE rank <= 3
ORDER BY year, month, rank;

--Середній sentiment_score для кожної криптовалюти
SELECT crypto_name, AVG(sentiment_score) AS avg_sentiment
FROM crypto_market_data
GROUP BY crypto_name;

--Обчислити зміну ціни
SELECT crypto_name, date, 
       (close_price - open_price) AS price_change, 
       sentiment_score
FROM crypto_market_data;

--Кореляція в Python
--   crypto_name  correlation
--0  Binance Coin    -0.090752
--1       Bitcoin     0.020305
--2       Cardano     0.030447
--3      Ethereum     0.102131
--4        Solana    -0.113180