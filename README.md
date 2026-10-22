# E-Commerce Sales Analysis (SQL)

A beginner-friendly SQL project where I explore two years of sales data from an online store, check the data for problems, clean it, and answer 11 business questions.

**Tools:** SQL (SQLite), DB Browser for SQLite

**Data:** 2,500 customers · 60 products · 4,781 orders · 8,382 order lines (Jan 2024 – Dec 2025)

**Note:** The data is a synthetic practice dataset, not real company data.

## Questions I Wanted to Answer
1. How much money did the store make, and how is it growing?
2. Which categories, products, and countries sell the most?
3. Which sales channel has the most cancelled orders?
4. Do discounts hurt profit?
5. How many customers come back to buy again?

## SQL Skills Used
- Creating tables with primary keys, foreign keys, and constraints
- `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
- `INNER JOIN` across multiple tables
- `GROUP BY` with `COUNT`, `SUM`, `AVG`, `ROUND`
- `CASE WHEN` for grouping and conditional counts
- Subqueries
- Date functions (`STRFTIME`, `SUBSTR`)
- Views to keep cleaning logic in one place
- Data quality checks (NULLs, duplicates, orphan records, inconsistent text)

## Database Tables
| Table | What it holds |
|---|---|
| `customers` | who the customers are (name, country, city, signup date) |
| `products` | product name, category, price, cost |
| `orders` | one row per order (date, status, sales channel) |
| `order_items` | the products inside each order (quantity, discount) |

## Project Files
```
sql/01_schema.sql                  creates the tables
sql/02_data_quality_checks.sql     looks for problems in the raw data
sql/03_clean_views.sql             cleans the data using views
sql/04_analysis.sql                the 11 business questions
data/                         the tables as CSV files
results/                      the output of each query as CSV
ecommerce.db                  the finished database
```
To explore: open `ecommerce.db` in [DB Browser for SQLite](https://sqlitebrowser.org/) and copy any query from `sql/04_analysis.sql` into the "Execute SQL" tab.

## Step 1: Checking the Data
Before analysing anything I checked the raw data and found:
- 39 customers with a missing email
- 85 customers with a missing city
- 83 customers where the country was written inconsistently (for example `us`, ` UK `, `saudi arabia`)
- No orphan records and no impossible dates

## Step 2: Cleaning
I did not change the raw tables. Instead I created views:
- `v_customers` fixes country spelling, spaces, and missing cities
- `v_order_lines` calculates revenue and profit for every order line
- `v_sales` keeps only **completed** orders (cancelled and returned orders are not counted as sales)

Revenue = quantity × price × (1 − discount). Profit = revenue − quantity × cost.

## Step 3: Findings

**Overall:** 4,393 completed orders, **$765K revenue**, $293K profit, **38.3% margin**, average order $174.

**1. The business is growing.** Revenue rose from $303.8K in 2024 to $461.2K in 2025, about **+52%**.

**2. November and December are the busiest months.** Nov + Dec made roughly 31% of 2025 revenue. November 2025 alone was $81K, more than double the average month before it.

**3. Electronics is the main category.** It makes **44% of revenue** and has the highest margin (42.6%). 9 of the top 10 products are Electronics, led by the LED Monitor ($56.8K).

**4. Discounts reduce profit.** 

| Discount | Profit margin |
|---|---|
| None | 42.6% |
| 10% off | 36.1% |
| 20% off | 28.9% |
| 30% off | 18.5% |

Customers did not buy more units per order when the discount was bigger (about 1.3 units in every group).

**5. Most customers buy only once.** 46% of customers placed just one order.

**6. Countries.** The US is the biggest market ($299K), then the UK ($134K). Australia has the lowest spend per customer ($289 vs about $345–385 elsewhere).

**7. Cancellations.** The mobile app has the highest cancel rate (5.5%); the marketplace has the lowest (4.7%).

## Recommendations
1. Limit big discounts (30%) outside the Nov–Dec season because they cut profit by more than half.
2. Prepare stock and marketing for November and December.
3. Try to bring back one-time customers with follow-up offers.
4. Keep focusing on Electronics, and review prices in Home & Kitchen (lowest margin at 32.9%).

## What I Would Do Next
- Build a dashboard in Power BI or Tableau using the CSV files in `results/`
- Learn window functions and add customer segmentation and monthly growth analysis

---
**Author:** Abdullah Alharthi · [LinkedIn](https://www.linkedin.com/in/abdullahh-alharthi-)
