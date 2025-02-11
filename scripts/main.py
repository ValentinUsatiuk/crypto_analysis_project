import pandas as pd
import sqlite3
import numpy as np

'''D:\Проект по крипті аналіз\crypto_market.db'''

conn = sqlite3.connect('D:\Проект по крипті аналіз\crypto_market.db')

# Завантажуємо дані з бази даних
query = """
SELECT crypto_name, 
       (close_price - open_price) AS price_change, 
       sentiment_score
FROM crypto_market_data
"""
df = pd.read_sql(query, conn)

# Функція для обчислення кореляції для кожної криптовалюти
def calculate_correlation(group):
    return group['price_change'].corr(group['sentiment_score'])

# Групуємо по криптовалютам і обчислюємо кореляцію
correlation_df = df.groupby('crypto_name').apply(calculate_correlation).reset_index()

# Переіменовуємо стовпці для зручності
correlation_df.columns = ['crypto_name', 'correlation']

# Виводимо результат
print(correlation_df)

# Записуємо результат у CSV файл
correlation_df.to_csv('correlation_df.csv', index=False)

# Закриваємо з'єднання з базою даних
conn.close()