class DatabaseUpdater
  def initialize(database = 'facieg')
    @database = database
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

    models.each do |model|
      puts "#{model}"

      timer[model] = Time.current

      group = models_group.key(model)

      Transmitter.start(model, group, @database)

      timer[model] = TimeDifference.between(
        timer[model],
        Time.current
      ).in_minutes
    end

    timer.each do |model, time|
      puts "#{model}: #{time} min"
    end

    puts timer

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
        Country, State, City, Manager, Operator, ProductFabricator, ProductModel,
        Tariff, StockOperation, RequestType, Color, ProductLevel, Negotiation, Sell,
        ProcessType, ProcessStep, ProcessStepResponsible, TicketContactType,
        BillAdditionType, BillDiscountType, AssociateCancel, AssociateUserLine, Block,
        ChipMaintenanceType, ChipMaintenance, Contact, DistributorTarget, LineCancellation,
        LineCancellationItem, NegotiationInternet, NegotiationProduct, NegotiationService,
        NumberShift, OperationControl, OperationControlService, PackagePrice, Permit,
        PlanShift, ProcessStepAction, ProductMatrix, RemoteRequest, Role, SellInternetItem,
        SellPlanItem, SellPlanItemService, ServiceOperation, ServiceOperationItem,
        ServiceTariff, Sms, StockAdjust, StockAdjustEntry, StockAdjustOutput,
        StockMovement, StockMovementItem, ReservedProduct, ReservedProductItem,
        TariffMasterPrice, TariffOperator, TariffOperatorPrice, TicketType,
        TicketSubType, Tour, TourAssociate, TourStep, TransferTitle, TransferTitleItem,
        ProcessManager, Archive, ProcessFlow, StockProductChosen, StockProductChosenItem
      ],

      checking: [
        Partner, Group, User, Address
      ],

      force_copy: [
        Brand, Distributor, Domain, MasterOperatorContract, MasterManagerContract,
        MasterDistributorContract, CommercialTable, Plan, PlanTariff, DistributorPlan,
        FacilityPackage, OperatorAccount, Number, Request, RequestItem, Service,
        InternetPlan, Invoice, InvoiceItem, StockProduct, BillPeriod, Associate,
        AssociateLine, AssociateLinePlan, AssociateLineService, ComodatoMovement,
        Comodato, AssociateBill, LineBill, Bill, ServiceBill, Repayment,
        FranchiseMovement, DistributorConfiguration, BillAddition, BillAdditionItem,
        BillDiscount, BillDiscountItem, AssociateUser, LineGroup, DistributorInternetPlan,
        DistributorService, Ticket, TicketFlow, Comment, LineConsumption,
        ImportCall, Call
      ]
    }
  end

  private

  def models
    [
      Country, State, City, Brand, Distributor, Partner, Manager, Domain, Group,
      User, Operator, Associate, ProductFabricator, ProductModel, Tariff,
      CommercialTable, Plan, OperatorAccount, Number, MasterOperatorContract,
      MasterManagerContract, MasterDistributorContract, RequestType, StockOperation,
      Request, Service, Color, ProductLevel, LineGroup, InternetPlan, Negotiation,
      Sell, AssociateLine, StockProduct, ComodatoMovement, Comodato, ProcessType,
      ProcessStep, ProcessStepResponsible, BillPeriod, AssociateBill, LineBill,
      AssociateUser, FranchiseMovement, DistributorConfiguration, TicketContactType,
      BillAdditionType, BillDiscountType, AssociateLinePlan, Bill, FacilityPackage,
      BillAddition, BillAdditionItem, BillDiscount, BillDiscountItem,
      AssociateLineService, ServiceBill, AssociateCancel, AssociateUserLine, Block,
      ChipMaintenanceType, ChipMaintenance, Contact, DistributorInternetPlan,
      DistributorPlan, DistributorService, DistributorTarget, Invoice, InvoiceItem,
      LineCancellation, LineCancellationItem, NegotiationInternet, NegotiationProduct,
      NegotiationService, NumberShift, OperationControl, OperationControlService,
      PackagePrice, Permit, PlanShift, PlanShiftItem, PlanTariff, ProcessStepAction,
      ProductMatrix, RemoteRequest, Repayment, RequestItem, Role, SellInternetItem,
      SellPlanItem, SellPlanItemService, ServiceOperation, ServiceOperationItem,
      ServiceTariff, Sms, StockAdjust, StockAdjustEntry, StockAdjustOutput,
      StockMovement, StockMovementItem, ReservedProduct, ReservedProductItem,
      TariffMasterPrice, TariffOperator, TariffOperatorPrice, TicketType,
      TicketSubType, Ticket, Tour, TourAssociate, TourStep, TransferTitle,
      TransferTitleItem, Address, ProcessManager, Archive, ProcessFlow,
      StockProductChosen, StockProductChosenItem, TicketFlow, LineConsumption,
      ImportCall, Call, Comment
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
