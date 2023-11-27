
30.times do
  product = Product.new(
    name: Faker::Commerce.product_name,
    price: Faker::Commerce.price(range: 0.99..99.99),
    description: Faker::Lorem.sentence(word_count: 20)
  )

  # Attach an image from the fixtures file
  file_path = Rails.root.join("spec", "fixtures", "files", "image.png")
  product.images.attach(io: File.open(file_path), filename: "image.png")

  if product.save!
    puts "Created Product - " + product.name
  end

end
