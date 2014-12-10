class ExportBill < ActiveRecord::Base
  belongs_to :master, class_name: 'Distributor'
end
