-- Write your down sql migration here
-- Drop the validate_isbn trigger
DROP TRIGGER IF EXISTS validate_isbn_trigger ON books;

-- Drop the validate_isbn function
DROP FUNCTION IF EXISTS validate_isbn;

-- Drop the isbn_valid constraint
ALTER TABLE books DROP CONSTRAINT IF EXISTS isbn_valid;

-- Drop the set_updated_at trigger
DROP TRIGGER IF EXISTS set_updated_at ON books;

-- Drop the books table
DROP TABLE IF EXISTS books;
