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

        if model != ImportCall
          attributes = configure_attributes(attributes, source_record)
        end

        if group == :checking
          rec = record_exist_on_destiny?(attributes)
          if rec
            add(old_id, rec.id)
            next
          end
        end

        new_record = model.using(:destiny).create!(attributes)

        add(old_id, new_record.id)
      end
    end while records.size > 0
  end

  # Transmitter.n_to_n
  def self.n_to_n(*attr)
    new(*attr).n_to_n
  end

  def n_to_n
    records = model.using(:source).all

    records.to_a.each do |source_record|
      attributes = source_record.attributes
      attributes.delete(nil)

      model.using(:destiny).create!(
        configure_attributes(attributes, source_record)
      )
    end
  end

  private

  attr_reader :model, :table_name, :group, :database, :initial_id

  def record_exist_on_destiny?(attributes)
    if model.to_s == 'User'
      model.using(:destiny).find_by(login: attributes['login'])
    else
      model.using(:destiny).find_by(attributes)
    end
  end

  def configure_attributes(attributes, source_record)
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

        if DatabaseUpdater.models_group[:one_time].include?(relation.class)
          relation_database = 'facieg'
        end

        record = relation.class.unscoped.find_by(
          old_id: value,
          database: relation_database
        )

        raise "#{model} - #{relation.class} - #{key} - #{value} (old_id) not found" unless record

        attributes[key] = record.new_id
      elsif model == AssociateUser && key == 'login'
        attributes[key] = value + '_cdl' if model.using(:destiny).find_by(login: value)
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
