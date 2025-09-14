# election-analysis-sql
Relational SQL project simulating elections in South India
# 🗳️ Election Analysis SQL Project

## 📌 Overview
This project simulates an **election dataset** for South India and performs comprehensive SQL-based analysis to uncover key electoral insights.  
It contains database setup scripts, sample data, and **22 analytical queries** that demonstrate mastery of SQL concepts — from basic aggregations to advanced Common Table Expressions (CTEs), Views, Window Functions, and Subqueries.

---

## 📂 Repository Contents
| File | Description |
|------|-------------|
| **Sql_project_election_setup.sql** | Creates the database, defines tables, and inserts sample election data |
| **Sql_project_election_queries.sql** | Contains 22 SQL queries for in-depth analysis of the election data |

---

## 🛠 Skills Demonstrated
- **Database Design** – Creating schemas and defining table relationships  
- **Data Population** – Inserting realistic sample election data  
- **Advanced Querying** – Using:
  - `JOIN` (INNER, LEFT)
  - `GROUP BY`, `HAVING`, `ORDER BY`
  - **Common Table Expressions (CTEs)**
  - **Views** for reusable query logic
  - **Subqueries** (correlated & non-correlated)
  - **Window Functions** (`RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`)
  - **Aggregate Functions** (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`)
  - **CASE Statements** for conditional logic
- **Aggregation & Ranking** – Calculating totals, averages, percentages, margins, and rankings  
- **Insight Extraction** – Identifying winners, margins, trends, turnout patterns, and party dominance  

---

## 📊 Analysis Queries Highlights
The 22 queries include:
1. **Total Registered Voters** across the dataset  
2. **Total Votes Polled** in the election  
3. **Vote Share by Party**  
4. **Top Leaders by Vote Count**  
5. **Winning Candidate in Each Constituency**  
6. **State-wise Winning Party Analysis** *(CTE-powered)*  
7. **Seats Won by Each Party**  
8. **Overall Winning Party in the Election**  
9. **Overall Winning Leader** based on vote share  
10. **Voter Turnout Percentage**  
11. **Closest Victory Margins**  
12. **Largest Victory Margins**  
13. **State-wise Turnout Rankings**  
14. **Top Parties by State** *(Window Functions)*  
15. **Using Views** to store repeated analysis queries  
16. **Deleting Views** when no longer needed  
17. **Identifying Multi-term Leaders** *(hypothetical example)*  
18. **Party Performance Trends**  
19. **CTE-based State Winner Extraction**  
20. **Overall Winner Extraction via Subquery**  
21. **Party Seat Share Percentage**  
22. **State-wise Winning Party & Leader Combined Report**  

---

## 🚀 How to Run
1. Open your SQL environment (MySQL)  
2. Run **`Sql_project_election_setup.sql`** one by one block of code from top to bottom to create and populate the database.  
3. Run **`Sql_project_election_queries.sql`** to execute all analysis queries.

---

## 📈 Future Enhancements
- Integrate with **Power BI/Tableau** for interactive dashboards  
- Automate periodic election reports  
- Add historical election data for trend analysis  
- Include demographic breakdowns for deeper insights  

