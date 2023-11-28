# Rails Ecommerce Microservices Workshop app

This application was built as part of the ROR Microservices Worshop.
This application is running Rails 7.1 in Ruby 3.2.2.

## Running the product service

```bash
cd product_service
rails db:{create,migrate,seed}
rails s -p 3001
```

## Running the order service

```bash
cd order_service
rails db:{create,migrate}
rails s -p 3002
```

## Running the frontend service

```bash
cd ecommerce_frontend
npm install
npm start
```
