--High-value customers
--We want to send all of our high-value customers a special VIP gift. We're defining highvalue customers as those who've made at least 1 order with a total value (not including the 
--discount) equal to $10,000 or more. We only want to consider orders made in the year 
--2016.
Select 
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
Having Sum(Quantity * UnitPrice) > 10000
Order by TotalOrderAmount DESC;



--Month-end orders
--At the end of the month, salespeople are likely to try much harder to get orders, to meet 
--their month-end quotas. Show all orders made on the last day of the month. Order by 
--EmployeeID and OrderID

Select 
 EmployeeID
 ,OrderID
 ,OrderDate 
From Orders
Where OrderDate = EOMONTH(OrderDate )
Order by
 EmployeeID
 ,OrderID;


 --Orders—accidental double-entry details
--Based on the previous question, we now want to show details of the order, for orders that 
--match the above criteria.

;with PotentialDuplicates as (
 Select 
 OrderID 
 From OrderDetails
 Where Quantity >= 60
 Group By OrderID, Quantity
 Having Count(*) > 1
 )
Select 
 OrderID
 ,ProductID
 ,UnitPrice
 ,Quantity
 ,Discount
From OrderDetails 
Where 
 OrderID in (Select OrderID from PotentialDuplicates)
Order by 
 OrderID
 ,Quantity;



 --Late orders—which employees?
Select 
 Employees.EmployeeID
 ,LastName
 ,TotalLateOrders = Count(*)
From Orders 
 Join Employees
 on Employees.EmployeeID = Orders.EmployeeID
Where 
 RequiredDate <= ShippedDate
Group By 
 Employees.EmployeeID
 ,Employees.LastName
Order by TotalLateOrders desc;


--Late orders vs. total orders—fix null
;With LateOrders as (
 Select 
 EmployeeID
 ,TotalOrders = Count(*)
 From Orders 
 Where 
 RequiredDate <= ShippedDate
 Group By 
 EmployeeID
)
, AllOrders as (
 Select 
 EmployeeID
 ,TotalOrders = Count(*)
 From Orders 
 Group By 
 EmployeeID
)
Select 
 Employees.EmployeeID
 ,LastName
 ,AllOrders = AllOrders.TotalOrders
 ,LateOrders = IsNull(LateOrders.TotalOrders, 0)
From Employees
 Join AllOrders