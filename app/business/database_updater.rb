class DatabaseUpdater
  def initialize(database = 'facieg', options = {})
    @database = database

    @model_list = options.delete(:models)
    @initial_id = options.delete(:initial_id) || -1
  end

  # DatabaseUpdater.start
  def self.start
    new.start
  end

  def start
    created_tables = 0

    models.each do |model|
      next if model.table_exists?

      created_tables += 1

      generate_table(model.table_name)
    end

    puts "#{created_tables} tabelas criadas"
  end

  # DatabaseUpdater.copy('facieg')
  def self.copy(*attr)
    new(*attr).copy
  end

  def copy
    timer = {}

    unless @model_list
      @model_list = models
    end

    @model_list.each do |model|
      timer[model] = Time.current

      group = nil
      models_group.each do |g, mods|
        if mods.include?(model)
          group = g
          break
        end
      end

      # Se o grupo for 'one_time', executar apenas para a facieg
      if group != :one_time || @database == 'facieg'
        Transmitter.start(model, group, @database, initial_id: @initial_id)
      end

      timer[model] = TimeDifference.between(
        timer[model],
        Time.current
      ).in_minutes
    end

    timer.each do |model, time|
      puts "#{model}: #{time} min"
    end

    puts "TOTAL: #{timer.values.sum} min"
  end

  # DatabaseUpdater.copy_n_to_n
  def self.copy_n_to_n(*attr)
    new(*attr).copy_n_to_n
  end

  def copy_n_to_n
    models = [DistributorStockOperation, ProductModelColor]

    models.each do |model|
      Transmitter.n_to_n(model)
    end
  end

  # DatabaseUpdater.models_group
  def self.models_group(*attr)
    new(*attr).models_group
  end

  def models_group
    {
      one_time: [
        Country, State, City, Manager, Operator, ProductFabricator,
        Tariff, StockOperation, RequestType, Color, ProductLevel,
        ProcessType, ProcessStep, ProcessStepResponsible,
        BillAdditionType, BillDiscountType, AssociateCancel, AssociateUserLine, Block,
        ChipMaintenanceType, ChipMaintenance, DistributorTarget, LineCancellation,
        LineCancellationItem, NegotiationInternet, NegotiationProduct, NegotiationService,
        NumberShift, OperationControl, OperationControlService, PackagePrice,
        PlanShift, ProcessStepAction, ProductMatrix, RemoteRequest, Role, SellInternetItem,
        SellPlanItem, SellPlanItemService, ServiceOperation, ServiceOperationItem,
        ServiceTariff, Sms, StockAdjust, StockAdjustEntry, StockAdjustOutput,
        StockMovement, StockMovementItem, ReservedProduct, ReservedProductItem,
        TariffMasterPrice, TariffOperator, TariffOperatorPrice,
        Tour, TourAssociate, TourStep, TransferTitle, TransferTitleItem,
        ProcessManager, Archive, ProcessFlow, StockProductChosen, StockProductChosenItem, ImportCall
      ],

      checking: [
        Partner, Group, User, Address, OperatorAccount, ProductModel, TicketContactType, TicketType, 
        TicketSubType
      ],

      force_copy: [
        Brand, Distributor, Domain, MasterOperatorContract, MasterManagerContract,
        MasterDistributorContract, CommercialTable, Plan, PlanTariff,
        FacilityPackage, Number, Request, RequestItem, Service, ExportBill,
        InternetPlan, Invoice, InvoiceItem, StockProduct, BillPeriod, Associate,
        AssociateLine, AssociateLinePlan, AssociateLineService, ComodatoMovement,
        Comodato, AssociateBill, LineBill, Bill, ServiceBill, Repayment,
        FranchiseMovement, DistributorConfiguration, BillAddition, BillAdditionItem,
        BillDiscount, BillDiscountItem, AssociateUser, LineGroup,
        Ticket, TicketFlow, Comment, LineConsumption, GroupAssociateBill,
        Call, Negotiation, Sell, Contact
      ]
    }
  end

  private

  def models
    [
      Country, State, City, Brand, Distributor, Partner, Manager, Domain, Group,
      User, Operator, Associate, ProductFabricator, ProductModel, Tariff,
      CommercialTable, OperatorAccount, Number, MasterOperatorContract,
      MasterManagerContract, MasterDistributorContract, RequestType, StockOperation,
      Request, Plan, Service, FacilityPackage, Color, ProductLevel, LineGroup, InternetPlan,
      Negotiation, Sell, AssociateLine, StockProduct, ComodatoMovement, Comodato, AssociateLinePlan,
      AssociateLineService, ProcessType, ProcessStep, ProcessStepResponsible, ExportBill, BillPeriod,
      GroupAssociateBill, AssociateBill, LineBill, AssociateUser, FranchiseMovement, 
      DistributorConfiguration, TicketContactType, BillAdditionType, BillDiscountType, Bill, 
      BillAddition, BillAdditionItem, BillDiscount, BillDiscountItem, ServiceBill, AssociateCancel,
      AssociateUserLine, Block, ChipMaintenanceType, ChipMaintenance, Contact, DistributorTarget,
      Invoice, InvoiceItem, LineCancellation, LineCancellationItem, NegotiationInternet,
      NegotiationProduct, NegotiationService, NumberShift, OperationControl, OperationControlService,
      PackagePrice, PlanShift, PlanShiftItem, PlanTariff, ProcessStepAction,
      ProductMatrix, RemoteRequest, Repayment, RequestItem, Role, SellInternetItem,
      SellPlanItem, SellPlanItemService, ServiceOperation, ServiceOperationItem,
      ServiceTariff, Sms, StockAdjust, StockAdjustEntry, StockAdjustOutput,
      StockMovement, StockMovementItem, ReservedProduct, ReservedProductItem,
      TariffMasterPrice, TariffOperator, TariffOperatorPrice, TicketType,
      TicketSubType, Ticket, Tour, TourAssociate, TourStep, TransferTitle,
      TransferTitleItem, Address, ProcessManager, Archive, ProcessFlow,
      StockProductChosen, StockProductChosenItem, TicketFlow, Comment,
      LineConsumption, ImportCall #, Call
    ]
  end

  def generate_table(table_name)
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE TABLE #{table_name}
      (
        id serial NOT NULL,
        old_id integer NOT NULL,
        new_id integer NOT NULL,
        database varchar(255) NOT NULL,
        CONSTRAINT #{table_name}_pkey PRIMARY KEY (id)
      )
      WITH (
        OIDS=FALSE
      );
      ALTER TABLE #{table_name}
        OWNER TO postgres;

      CREATE INDEX index_#{table_name}_old_id
        ON #{table_name}
        USING btree
        (old_id);

      CREATE INDEX index_#{table_name}_new_id
        ON #{table_name}
        USING btree
        (new_id);

      CREATE INDEX index_#{table_name}_database
        ON #{table_name}
        USING btree
        (database);
    SQL
  end
end
