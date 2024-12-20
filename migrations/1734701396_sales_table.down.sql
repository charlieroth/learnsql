-- Write your down sql migration here

-- Drop the set_updated_at trigger for the sales table
DROP TRIGGER IF EXISTS set_updated_at_sales ON sales;

-- Drop the sales table
DROP TABLE IF EXISTS sales;
