SELECT * FROM crypto_market_data
LIMIT 100;

--пошук нульових значень
SELECT * FROM crypto_market_data
WHERE date IS NULL
   OR crypto_name IS NULL
   OR symbol IS NULL
   OR open_price IS NULL
   OR high_price IS NULL
   OR low_price IS NULL
   OR close_price IS NULL
   OR volume IS NULL
   OR market_cap IS NULL
   OR transactions IS NULL
   OR dominance IS NULL
   OR sentiment_score IS NULL
   OR news_mentions IS NULL;
--нульових значень немає

-- пошук дублів по даті та назві монети
SELECT crypto_name, date, count(*)
FROM crypto_market_data
GROUP BY crypto_name, date
HAVING COUNT(*) > 1 ;
-- немає дублів

-- пошук некоректних числових данних ціна < 0
SELECT open_price, high_price, low_price, close_price, market_cap, volume 
FROM crypto_market_data
WHERE open_price < 0 
   OR high_price < 0 
   OR low_price < 0 
   OR close_price < 0
   OR volume <= 0 
   OR market_cap <= 0;
-- ціна релевантна

-- пошук на логічні помилки(high_price > low_price )
SELECT * 
FROM crypto_market_data
WHERE high_price < low_price;
-- high_price < low_price всі ціни коректні