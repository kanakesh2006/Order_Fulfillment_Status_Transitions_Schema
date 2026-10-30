-- Order Fulfillment & Status Transitions Schema (Implemented on Postgres)


-- Clean up tables if they already exist
DROP TABLE IF EXISTS order_status_history CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. USERS
-- Stores simple customer profile details
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. PRODUCTS
-- Stores items available for sale in the catalog
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 3. ORDERS
-- The main order record placed by a customer
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address TEXT NOT NULL,
    carrier VARCHAR(50),
    tracking_number VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 4. ORDER_ITEMS
-- Items and quantities inside an order (Many-to-Many bridge)
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(id),
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- 5. ORDER_STATUS_HISTORY
-- Tracks every status change of an order over time (Fulfillment timeline)
CREATE TABLE order_status_history (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    status VARCHAR(30) NOT NULL,
    notes TEXT,
    changed_at TIMESTAMP DEFAULT NOW()
);


-- BASIC INDEXES
-- Speed up foreign key lookups and frequent filter queries


-- Fast lookup of all orders placed by a specific user
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Fast filtering of orders by current status (e.g., finding all 'Pending' or 'Shipped' orders)
CREATE INDEX idx_orders_status ON orders(status);

-- Fast lookup of items belonging to an order
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- Fast lookup of which orders contain a specific product
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Fast lookup of status history for an order
CREATE INDEX idx_order_status_history_order_id ON order_status_history(order_id);
