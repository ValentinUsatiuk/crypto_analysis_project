import sqlite3
import pandas as pd
import numpy as np

# Підключення до бази даних
conn = sqlite3.connect('D:\Проект по крипті аналіз\crypto_market.db')

# Отримання даних з таблиці
df = pd.read_sql_query("""
SELECT 
    crypto_name,
    date,
    LOG(close_price) AS log_price
FROM crypto_market_data
""", conn)

# Перетворення стовпця 'date' на рік та місяць
df['year'] = pd.to_datetime(df['date']).dt.year
df['month'] = pd.to_datetime(df['date']).dt.month

# Обчислення стандартного відхилення для кожної криптовалюти по місяцях
volatility = df.groupby(['crypto_name', 'year', 'month'])['log_price'].std().reset_index()

# Виведення результатів
print(volatility)

# Записуємо результат у CSV файл
volatility.to_csv('volatility_data.csv', index=False)

# Закриваємо з'єднання з базою даних
conn.close()
