class ProductModel < ActiveRecord::Base
  belongs_to :product_fabricator
  belongs_to :chip_type, class_name: 'ProductModel', foreign_key: :chip_type_id
end
