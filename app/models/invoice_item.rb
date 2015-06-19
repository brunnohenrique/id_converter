class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :request_item
  belongs_to :color
end
