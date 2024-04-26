# Northwind_sql
A sql project aims to provide insights in a demo company

### Project Overview

A database diagram is a visualization of all the tables, fields, and relationships in a database. It can help you understand how the tables are related to each other. 
This is the database diagram for the Northwind_SPP practice database we will be using.
![Screenshot 2024-04-26 032545](https://github.com/teeceeNoUsername/Northwind_sql/assets/64446759/9c66a7fa-1aa7-49bd-988b-b8cd550f5c0d)

### Data Source
It is not the standard Northwind database that was the sample included with several Microsoft database products

### Tools

Microsoft SQL Server

### Data Analysis
High-value customers
---
We want to send all of our high-value customers a special VIP gift. We're defining high value customers as those who've made at least 1 order with a total value (not including the 
discount) equal to $10,000 or more. We only want to consider orders made in the year 
2016.
```Select 
 Customers.CustomerID
 ,Customers.CompanyName
 ,Orders.OrderID
 ,TotalOrderAmount = SUM(Quantity * UnitPrice)
From Customers
 Join Orders
 on Orders.CustomerID = Customers.CustomerID
 Join OrderDetails
 on Orders.OrderID = OrderDetails.OrderID
Where
 OrderDate >= '20160101' 
 and OrderDate < '20170101'
Group by 
 Customers.CustomerID
 ,Customers.CompanyName
 ,Orders.Orderid
Having Sum(Quantity * UnitPrice) > 10000;
Order by TotalOrderAmount DESC
```

###  Expected Output
![Screenshot 2024-04-26 035124](https://github.com/teeceeNoUsername/Northwind_sql/assets/64446759/454e50c2-2820-4350-9ddb-8abfd113de66)


