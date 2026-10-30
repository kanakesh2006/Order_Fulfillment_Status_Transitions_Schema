CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(100) NOT NULL,
  "email" varchar(100) UNIQUE NOT NULL,
  "phone" varchar(20),
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "products" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(150) NOT NULL,
  "price" decimal(10,2) NOT NULL,
  "stock" int NOT NULL DEFAULT 0,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "orders" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int NOT NULL,
  "status" varchar(30) NOT NULL DEFAULT 'Pending',
  "total_amount" decimal(10,2) NOT NULL,
  "shipping_address" text NOT NULL,
  "carrier" varchar(50),
  "tracking_number" varchar(100),
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "order_items" (
  "id" SERIAL PRIMARY KEY,
  "order_id" int NOT NULL,
  "product_id" int NOT NULL,
  "quantity" int NOT NULL,
  "price" decimal(10,2) NOT NULL
);

CREATE TABLE "order_status_history" (
  "id" SERIAL PRIMARY KEY,
  "order_id" int NOT NULL,
  "status" varchar(30) NOT NULL,
  "notes" text,
  "changed_at" timestamp DEFAULT (now())
);

ALTER TABLE "orders" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "order_items" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "order_items" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "order_status_history" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id") DEFERRABLE INITIALLY IMMEDIATE;
