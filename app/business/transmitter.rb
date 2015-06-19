class Transmitter
  def initialize(model, group, database, options = {})
    @model = model
    @group = group
    @database = database
    @table_name = model.table_name

    @initial_id = options.delete(:initial_id) || -1
    model.connection
  end

  # Transmitter.start(Country)
  def self.start(*attr)
    new(*attr).start
  end

  def start
    last_id = initial_id

    begin
      records = model.using(:source).order('id').limit(1000).where('id > ?', last_id)

      break if records.size == 0

      last_id = records.last.id

      records.to_a.each do |source_record|
        attributes = source_record.attributes
        old_id = attributes.delete('id')

        puts "Modelo: #{model} ID: #{old_id}"

        if model != ImportCall
          attributes = configure_attributes(attributes, source_record)
        end

        if group == :checking
          puts "Checking modelo: #{model} ID: #{old_id}"
          rec = record_exist_on_destiny?(attributes)
          if rec
            puts "Modelo #{model} encontrado OLD_ID: #{old_id} -> NEW_ID #{rec.id}"
            add(old_id, rec.id)
            next
          end
        end

        new_record = model.using(:destiny).create!(attributes)

        puts "Criado modelo #{model} encontrado OLD_ID: #{old_id} -> NEW_ID #{new_record.id}"

        add(old_id, new_record.id)
      end
    end while records.size > 0
  end

  private

  attr_reader :model, :table_name, :group, :database, :initial_id

  def record_exist_on_destiny?(attributes)
    case model.to_s
    when 'User'
      model.using(:destiny).find_by(login: attributes['login'])
    when 'Brand'
      model.using(:destiny).find_by(name: attributes['name'])
    when 'ProductModel'
      model.using(:destiny).find_by(name: attributes['name'])
    when 'Operator'
      model.using(:destiny).find_by(name: attributes['name'])
    else
      attributes.delete("created_at")
      attributes.delete("updated_at")
      model.using(:destiny).find_by(attributes)
    end
  end

  def configure_attributes(attributes, source_record)
    puts "Configurando modelo #{model} #{attributes['id']}"
    attributes.each do |key, value|
      if key.include?('_id') && value.present? && key != 'hawk_id' && key != 'hawk_number_id'
        methods = model.reflect_on_all_associations(:belongs_to).
          select { |a| a.foreign_key.to_sym == key.to_sym }

        if methods.size == 1
          method = methods.last.name
        else
          method = key.gsub('_id', '')
        end

        relation = source_record.send(method)

        raise "#{method} not found at #{model} #{source_record.id}" if relation.blank?

        relation_database = database

        record = relation.class.unscoped.find_by(
          old_id: value,
          database: relation_database
        )

        raise "#{model} - #{relation.class} - #{key} - #{value} (old_id) not found" unless record

        attributes[key] = record.new_id
      elsif model == AssociateUser
        case key
        when 'login'
          attributes[key] = value + '_migracao' if model.using(:destiny).find_by(login: value)
        when 'email'
          attributes[key] = 'migracao_' + value if model.using(:destiny).find_by(email: value)
        end
      end
    end

    attributes
  end

  def add(old_id, new_id)
    ActiveRecord::Base.connection.execute <<-SQL
      INSERT INTO #{table_name} (old_id, new_id, database)
      VALUES (#{old_id}, #{new_id}, '#{database}');
    SQL
  end
end
