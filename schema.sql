-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- This is a database for all members living in a colony and their consumption habits

-- It has these entities (members, products, transactions)

-- Represents members in the society

DROP VIEW IF EXISTS "spent_on_dairy";
DROP VIEW IF EXISTS "wealthy";
DROP VIEW IF EXISTS "average_consumption";

DROP TRIGGER IF EXISTS "buy";

DROP INDEX IF EXISTS "person_index";

DROP TABLE IF EXISTS "members";
DROP TABLE IF EXISTS "products";
DROP TABLE IF EXISTS "transactions";


CREATE TABLE IF NOT EXISTS "members" (
	"id" INTEGER,
	"name" TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id")
);

-- Represents products people consume
CREATE TABLE IF NOT EXISTS "products" (
	"id" INTEGER,
	"name" TEXT NOT NULL UNIQUE,
	"catagory" TEXT NOT NULL CHECK ("catagory" IN ('dairy', 'snacks', 'beverage', 'clothing', 'utility', 'hygiene')),
	"price" NUMERIC NOT NULL CHECK ("price" > 0),
	"quantity" INTEGER NOT NULL CHECK ("quantity" > -1),
	PRIMARY KEY("id")
);

-- Represents buying information for each product sold
CREATE TABLE IF NOT EXISTS "transactions" (
	"id" INTEGER,
	"product_id" INTEGER,
	"member_id" INTEGER,
	"quantity" INTEGER NOT NULL CHECK ("quantity" > 0),
	"amount" NUMERIC NOT NULL CHECK ("amount" > 0),
	"datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("product_id") REFERENCES "products"("id"),
	FOREIGN KEY("member_id") REFERENCES "members"("id"),
	PRIMARY KEY("id")
);

CREATE INDEX "person_index" ON "members" ("name");

-- Represents money spent on dairy on October 2023
CREATE VIEW "spent_on_dairy" AS
SELECT SUM("amount") AS "dairy_spenditure" FROM "transactions"
WHERE "datetime" LIKE '2023-10%'
AND 
"catagory" = 'dairy';

-- Represents top 3 richest person according to their consumption
CREATE VIEW "wealthy" AS
SELECT "members"."name", SUM("amount") AS "amount" FROM "transactions"
JOIN "members" on "members"."id" = "transactions"."member_id"
GROUP BY "members"."name"
ORDER BY "amount" DESC LIMIT 3;

-- Represents average money spent by members in October 2023
CREATE VIEW "average_consumption" AS
SELECT AVG("amount") AS "average_spent" FROM "transactions"
WHERE "datetime" LIKE '2023-10%';

-- Everytime anyone creates a transaction it triggers the products table to update their quantity
CREATE TRIGGER "buy"
BEFORE INSERT ON "transactions"
FOR EACH ROW
BEGIN
	UPDATE "products" SET "quantity" = "quantity" - 1 
	WHERE "id" = NEW."product_id";
END;
