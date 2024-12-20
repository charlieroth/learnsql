-- Write your down sql migration here
DROP IF EXISTS EXTENSION "uuid-ossp";

DROP FUNCTION IF EXISTS update_updated_at_column();
