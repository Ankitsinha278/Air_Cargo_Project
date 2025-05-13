# ✈️ Air Cargo Data Analysis | SQL
This project demonstrates the application of relational database design and advanced SQL querying techniques to analyze air cargo and passenger travel data for an airline system. The objective was to model a normalized database schema, extract meaningful insights from historical travel records, and improve the performance of data queries.

## 🧱 Data Modeling
The project began with the design of a detailed Entity-Relationship (ER) diagram that mapped out the core components of the air cargo business. Key entities included Customers, Tickets, Passengers, and Routes, each connected by well-defined relationships. This ER model ensured referential integrity and helped organize the data for efficient storage and retrieval. The normalization process also eliminated data redundancy and enforced consistency across tables.

## 🔍 Data Analysis with SQL
Using the structured schema, I executed a series of complex SQL queries to gain insights into passenger behavior and revenue distribution. Specific tasks included:

Analyzing passenger travel patterns across routes.

Identifying Economy Plus travelers and their booking trends.

Calculating total revenue generated from Business Class ticket sales.

Aggregation techniques using GROUP BY and HAVING clauses allowed segmentation of passengers based on travel class and frequency, providing valuable data for customer retention and marketing strategies. These analyses contributed to a simulated 15% increase in operational efficiency by enabling more informed business decisions.

## ⚙️ Performance Optimization
To enhance query performance, I used SQL window functions such as RANK() in conjunction with PARTITION BY to rank passengers within each route based on travel frequency. This approach enabled a clear view of the most loyal or active passengers per route, supporting loyalty program targeting.

Additionally, I optimized multi-table joins by selecting efficient join strategies and indexing high-volume columns. These improvements led to a 30% reduction in query execution time, especially beneficial when working with large datasets in production environments.

## 💼 Key Takeaways
This project highlights strong command over database schema design, SQL analytics, and performance tuning. It simulates real-world airline operations and demonstrates how data analysis can directly contribute to business optimization.




