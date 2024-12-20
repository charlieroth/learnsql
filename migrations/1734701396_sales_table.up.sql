-- Write your up sql migration here
-- Create the sales table
CREATE TABLE sales (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID REFERENCES books(id) ON DELETE SET NULL,
    isbn VARCHAR(13) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0),
    payment_method VARCHAR(10) NOT NULL CHECK (payment_method IN ('cash', 'card')),
    status VARCHAR(15) DEFAULT 'completed' CHECK (status IN ('completed', 'refunded')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT clock_timestamp()
);

-- Attach the update trigger to the sales table
CREATE TRIGGER set_updated_at_sales
BEFORE UPDATE ON sales
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();