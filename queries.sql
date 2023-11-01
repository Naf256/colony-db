-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- add  new members
INSERT INTO "members" ("name")
VALUES 
('Carter Zenke'),
('nafis'),
('foo'),
('bar');

-- add new products
INSERT INTO "products" ("name", "catagory", "price", "quantity")
VALUES 
('Pepsi', 'beverage', 30, 100),
('Amul Yogart', 'dairy', 50, 50),
('Good day', 'snacks', 15, 30);

-- add  new transactions
INSERT INTO "transactions" (
	"product_id", "member_id", "quantity", "amount"
)
VALUES
(2, 3, 3, 150),
(1, 3, 2, 60),
(3, 1, 5, 75),
(2, 2, 4, 200);

-- find all members whose name starts with f/F
SELECT * FROM "members"
WHERE "name" LIKE 'f%'
ORDER BY "name";

-- find all the products bought by member named foo
SELECT "name" FROM "products"
WHERE "id" IN (
	SELECT "product_id" FROM "transactions"
	WHERE "member_id" = (
		SELECT "id" FROM "members"
		WHERE "name" = 'foo'
	)
);


SELECT * FROM "wealthy";
