-- Write your up sql migration here
-- Create the books table
CREATE TABLE books (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(255) NOT NULL,
  isbn VARCHAR(13) UNIQUE NOT NULL,
  genre VARCHAR(50),
  price DECIMAL(10, 2) NOT NULL,
  stock_quantity INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp()
);

-- Add a check constraint for simple ISBN-13 validation (13 characters, numeric only)
ALTER TABLE books
ADD CONSTRAINT isbn_valid
CHECK (
  LENGTH(isbn) = 13 AND isbn ~ '^[0-9]+$'
);

-- Create validate_isbn function
CREATE OR REPLACE FUNCTION validate_isbn()
RETURNS TRIGGER AS $$
DECLARE
  digit_sum INT;
  check_digit INT;
  calc_digit INT;
BEGIN
  -- Ensure ISBN is exactly 13 characters and numeric
  IF LENGTH(NEW.isbn) != 13 OR NEW.isbn !~ '^[0-9]+$' THEN
    RAISE EXCEPTION 'Invalid ISBN: Must be a 13-digit numeric string';
  END IF;

  -- Calculate the check digit for ISBN-13
  digit_sum := 0;
  FOR i IN 1..12 LOOP
    digit_sum := digit_sum +
      CASE WHEN MOD(i, 2) = 1 THEN
        CAST(SUBSTRING(NEW.isbn FROM i FOR 1) AS INT)
      ELSE
        CAST(SUBSTRING(NEW.isbn FROM i FOR 1) AS INT) * 3
      END;
  END LOOP;

  calc_digit := 10 - MOD(digit_sum, 10);
  IF calc_digit = 10 THEN
    calc_digit := 0;
  END IF;

  -- Check if the calculated check digit matches the 13th digit
  check_digit := CAST(SUBSTRING(NEW.isbn FROM 13 FOR 1) AS INT);
  IF calc_digit != check_digit THEN
    RAISE EXCEPTION 'Invalid ISBN: Check digit does not match';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the validate_isbn trigger to the books table
CREATE TRIGGER validate_isbn_trigger
BEFORE INSERT OR UPDATE ON books
FOR EACH ROW
EXECUTE FUNCTION validate_isbn();

-- Attach the set_updated_at trigger to the books table
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON books
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
