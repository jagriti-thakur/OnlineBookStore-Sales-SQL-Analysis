--create tables
CREATE TABLE books(
BOOK_ID	INT PRIMARY KEY,
TITAL VARCHAR(100),
AUTHOR VARCHAR(50),
GENRE VARCHAR(100),
published_year INT,
Price NUMERIC(10,2),
Stock INT
);

CREATE TABLE customers(
Customer_id INT PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),
Country VARCHAR(50)
);

CREATE TABLE orders(
Order_id SERIAL PRIMARY KEY,
Customer_id INT REFERENCES customers(Customer_id),
Book_id INT REFERENCES books(BOOK_ID),
Order_date DATE,
Quantity INT,
Total_amount NUMERIC(10,2)
);

SELECT*FROM books;
SELECT * FROM customers;
SELECT * FROM orders;


--BASIC QUERIES

--1) retrieve all books in ficional genre
SELECT * FROM books
WHERE genre='Fiction';

--2) Find books published after the year 1950
SELECT * FROM books
WHERE published_year>1950;

--3) list all customers from the canada
SELECT * FROM customers
WHERE country='Canada';

--4) show order placed in nov 2023
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) retrieve the total stock of books available
SELECT SUM(stock) AS total_stock
FROM books;

--6) find the detail of the most expensive book
SELECT * FROM books ORDER BY price DESC limit 1;

--7) Show all customer who order more than 1 quantity of books;
SELECT * FROM orders
WHERE quantity>1;

--8) all orders where the total amount exceed 200
SELECT * FROM orders
WHERE total_amount>200;

--9) List all genre available in the book table
SELECT DISTINCT genre FROM books;

--10) find the book with the lowest stock
SELECT * FROM books ORDER BY stock ASC limit 1;

--11) calculate the tottal revenue generated from all books
SELECT SUM(total_amount) AS revenue FROM orders;


--ADVANCED QUERIES

--1) The total no. of books sold from each genre
SELECT * FROM orders;
SELECT b.genre , SUM(o.quantity) AS total_books_sold
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY b.genre;

--2) find the avg price of books in 'fantasy' genre
SELECT AVG(price) AS average_price
FROM books
WHERE genre='Fantasy';

--3) list customers who have placed atleast two orders
SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(o.order_id)>=2;

--4) find the most frequent order book

SELECT o.book_id, b.tital, COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.tital
ORDER BY order_count DESC LIMIT 1;

--5) Show top 3 most expensive books for 'fantasy' genre
SELECT * FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--6) Retrieve the total quantity of books sold by each author
SELECT b.author , SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id= b.book_id
GROUP BY b.author;

--7) list the cities where customer who spend over 200 are located
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>100;

--8) find the customer who spend most on orders
SELECT c.customer_id, c.name, sum(o.total_amount) AS total_spend
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spend DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.tital, b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity,
b.stock- COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id= o.book_id
GROUP BY b.book_id ORDER BY b.book_id;



