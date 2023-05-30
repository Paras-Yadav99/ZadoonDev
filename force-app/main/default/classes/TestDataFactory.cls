@isTest
public with sharing class TestDataFactory {
    
    public static Model__c createModel( Boolean doInsert ) {
        Model__c model = new Model__c();
        model.Name = 'S650TX';
        if(doInsert) insert model;
        return model;
    }
    
    public static Account createAccount( Boolean doInsert ) {
        Account acc = new Account();
        acc.Name = 'TEST ACC.';
        if( doInsert ) insert acc;
        return acc;
    }
    
    public static Contact createContact( Boolean doInsert ) {
        Contact con = new Contact();
        con.LastName = 'Facchina';
        con.FirstName = 'Landy';
        con.Email = 'glile@midwestequipmentfunding.com';
        con.Phone = '440846-6600';
        if(doInsert) insert con;
        return con;
    }
    
    public static Opportunity createOpportunity( Boolean doInsert, Id accId, Id UnitId) {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.AccountId = accId;
        opp.CloseDate = Date.today()+30;
        opp.StageName = 'Need Analysis';
        if(string.isNotBlank(UnitId)){
            opp.Product__c = UnitId;
        }
        
        if( doInsert ) insert opp;
        return opp;
    }
    
    public static Unit_Related_Transaction__c createUnitRelated( Boolean doInsert, Id oppId, Id UnitId) {
        Unit_Related_Transaction__c unitTransaction = new Unit_Related_Transaction__c();
        unitTransaction.Opportunity__c = oppId;
        unitTransaction.Product__c = unitId;
        unitTransaction.Amount__c = 5000;
        unitTransaction.Pass_Cost_to_Client__c = false;
        unitTransaction.Upcharge_cost_to_client__c = true;
        unitTransaction.Transaction_Type__c = 'Expense';
        if( doInsert ) insert unitTransaction;
        return unitTransaction;
    }
    
    public static Equipment__c createEquipment( Boolean doInsert, Id modelId ) {
        Equipment__c equipment = new Equipment__c();
        equipment.Name = 'Caterpillar-12H';
        equipment.Model_Equipment__c = modelId;
        equipment.Manufacturer__c = 'Caterpillar';
        equipment.Category__c = 'Motor Grader';
        equipment.Base_New__c = '12';
        equipment.On_Off_Highway__c = 'Off Highway';
        equipment.MT_Inventory_Type__c = 'Trailers';
        if(doInsert) insert equipment;
        return equipment;
    }
    
    public static Product2 createUnit( Boolean doInsert, Id modelId, Id EquipId ) {
        Product2 pro = new Product2();
        pro.Name = '2500S Cone Crusher ZID-130163';
        pro.Model_Unit__c = modelId;
        pro.Equipment__c = EquipId;
        pro.Year__c = '2012';
        pro.Make__c = 'Caterpillar';
        //pro.Gross_Vehicle_Weight__c = 5000;
        pro.Hour__c = 3000;
        //pro.Product_Price_Unit__c = 250000;
        pro.Storage_State__c = 'Texas';
        pro.Starting_Advertised_Retail_Price__c = 2000;
        pro.Storage_Country__c = 'United States';
        pro.IsActive = true;
        pro.ProductCode = '	ZID-130163';
        if( doInsert ) insert pro;
        return pro;
    }
    
    public static Iron_Demand__c createIronDemand( Boolean doInsert, Id EquipId, Id ContactId ) {
        Iron_Demand__c iron = new Iron_Demand__c();
        iron.IsActive__c = true;
        iron.IronDemand_Iron__c = EquipId;
        iron.Max_Price__c = 250000;
        iron.Max_Year__c = '2012';
        iron.Max_Hours__c = 3000;
        iron.IronDemand_Contact__c = ContactId;
        if( doInsert ) insert iron;
        return iron;
    }
    
    public static Iron_Demand_Unit__c createUnits( Boolean doInsert, Id unitId, Id ironId ) {
        Iron_Demand_Unit__c unit = new Iron_Demand_Unit__c();
        unit.Unit__c = unitId;
        unit.Iron_Demand__c = ironId;
        if(doInsert) insert unit;
        return unit;
    }
    public static list<MC4SF__MC_Campaign__c> lstCampaign (integer NoOfRecords ){
        list<MC4SF__MC_Campaign__c> lstMCCampaign=new list<MC4SF__MC_Campaign__c>();
        for(integer i=0;i<=NoOfRecords;i++){
            MC4SF__MC_Campaign__c newCampaign = new MC4SF__MC_Campaign__c();
            newCampaign.Name='test'+i;
            newCampaign.MC4SF__MailChimp_ID__c='aksjgr98326508fhoy'+i;
            lstMCCampaign.add(newCampaign);
        }
        return lstMCCampaign;
    }
    public static list<MC4SF__MC_Campaign_Hourly_Stats__c> noOfMCCampaignToCreate (integer noOfRecords , string campaignId){
        list<MC4SF__MC_Campaign_Hourly_Stats__c>lstMCCampaignHour = new list<MC4SF__MC_Campaign_Hourly_Stats__c>();
        for(integer j=0;j<=noOfRecords;j++){
            
        	MC4SF__MC_Campaign_Hourly_Stats__c newMCCampaignHour = new MC4SF__MC_Campaign_Hourly_Stats__c();
        	newMCCampaignHour.MC4SF__MC_Campaign__c=campaignId;
            lstMCCampaignHour.add(newMCCampaignHour);
        }
        return lstMCCampaignHour;
    }
    
    public static list<Equipment__c> noOfEquipment (integer noOfRecord ){
        list<Equipment__c> lstEquipment= new list<Equipment__c>();
        for(integer i=0;i<=noOfRecord;i++){
            Equipment__c newEquipment = new Equipment__c();
            newEquipment.Name= 'Test'+i;
            newEquipment.Category__c = 'Backhoe';
            newEquipment.On_Off_Highway__c ='On Highway';
            newEquipment.MT_Inventory_Type__c='Other_Items';
            lstEquipment.add(newEquipment);
        }
        return lstEquipment;
    }
    
	public static list<Product2> noOfUnitsToCreate (integer noOfRecord, string equipmentId){
    	list<Product2> lstUnit = new list<Product2>();
        for(integer i=0;i<=noOfRecord;i++){
        	Product2 newUnit = new Product2();
            newUnit.equipment__c=equipmentId;
            newUnit.Name = 'test'+i;
            newUnit.Serial_Number__c = '45';
            newUnit.Year__c = '2020';
            newUnit.Make__c = '2021';
            newUnit.Hour__c = 3;
            newUnit.IsActive = true ;
           	newUnit.Purchase_Date__c= System.today().addDays(-120) ;
            newUnit.Unit_Owner__c = UserInfo.getUserId();
            newUnit.Inventory_Status__c ='Brokerage';   //Brokerage
            //newUnit.Max_of_Purchased_Created_and_LESC_date__c= System.today().addDays(-120); 30
            lstUnit.add(newUnit);
        }
        return lstUnit;    
    }
    
    public static list<Product2> noOfUnitsToCreate2 (integer noOfRecord, string equipmentId, string AccountId){
    	list<Product2> lstUnit = new list<Product2>();
        for(integer i=0;i<=noOfRecord;i++){
        	Product2 newUnit = new Product2();
            newUnit.equipment__c=equipmentId;
            newUnit.Name = 'test'+i;
            if(string.isNotBlank(AccountId)){
                newUnit.Account__c = AccountId;
            }
            
            newUnit.IsActive = true ;
           	newUnit.Purchase_Date__c= System.today().addDays(-180) ;
            newUnit.Inventory_Status__c ='Brokerage';   //Brokerage
            //newUnit.Max_of_Purchased_Created_and_LESC_date__c= System.today().addDays(-120); 30
            lstUnit.add(newUnit);
        }
        return lstUnit;    
    }
     public static list<task> taskToInsert (integer noOfTaskToInsert ){
        list<task> lstTask = new list<task>();
        for (integer i=0; i<=noOfTaskToInsert; i++){
            task newTask = new task();
            newTask.Subject = 'Call';
            newTask.OwnerId = UserInfo.getUserId();
            newTask.Status ='Completed';
            lstTask.add(newTask);
        }
        return lstTask;
    }
    /*
    public static list<Inspection_Report_Header__c> createInspectionReportHeader( integer noOfRecords , string recordType , string Type, integer orderNo) {
        list<Inspection_Report_Header__c> lstInspectionReportHeader = new list<Inspection_Report_Header__c>();
        for(integer i=0 ; i<noOfRecords;i++){
            Inspection_Report_Header__c newInspectionReportHeader = new Inspection_Report_Header__c();
            newInspectionReportHeader.Name = 'Test2';
            newInspectionReportHeader.Unit_Record_Type__c = recordType;
            newInspectionReportHeader.Order__c = orderNo;
            newInspectionReportHeader.Type__c = Type;
            lstInspectionReportHeader.add(newInspectionReportHeader);
        }
        return lstInspectionReportHeader;
    }
    public static list<Inspection_Report_Header_Line_Item__c> createInspectionReportHeaderLineItem( integer noOfRecords , id InspectionReportHeader, string fieldType, string picklistValue ) {
        list<Inspection_Report_Header_Line_Item__c> lstInspectionReportHeaderLineItem = new list<Inspection_Report_Header_Line_Item__c>();
        for(integer i=0 ; i<noOfRecords;i++){
            Inspection_Report_Header_Line_Item__c newInspectionReportHeaderLineItem = new Inspection_Report_Header_Line_Item__c();
            newInspectionReportHeaderLineItem.Name = 'Test1';
            newInspectionReportHeaderLineItem.Inspection_Report_Header__c = InspectionReportHeader;
            newInspectionReportHeaderLineItem.Field_Type__c = fieldType;
            newInspectionReportHeaderLineItem.Picklist_Values__c = picklistValue;
            lstInspectionReportHeaderLineItem.add(newInspectionReportHeaderLineItem);
        }
        return lstInspectionReportHeaderLineItem;
    }
    
    public static list<Inspection_Report__c> InspectionReportToInsert (integer noOfRecordToInsert ){
        list<Inspection_Report__c> lstInspectionReport = new list<Inspection_Report__c>();
        for (integer i=0; i<=noOfRecordToInsert; i++){
            Inspection_Report__c newInspectionReport = new Inspection_Report__c();
            
            lstInspectionReport.add(newInspectionReport);
        }
        return lstInspectionReport;
    }
    */
    public static list<Lead> noOfLeadToInsert (integer noOfRecord , string mobileNo ){
        list<Lead> lstLead= new list<Lead>();
        for(integer i=0;i<=noOfRecord;i++){
            Lead newLead = new Lead();
            newLead.MobilePhone = mobileNo;
            newLead.LeadSource ='Zadoon Machinio Leads';
            newLead.Email = 'test@gmail.com';
            newLead.LastName = 'Test';
            newLead.Company = 'Kizzy123';
            newLead.status ='New';
            lstLead.add (newLead);
        }
        return lstLead;
    }
    public static list<Lead> noOfLeadToInsertForRoundRobin (integer noOfRecord ,string MobileNo, string Email,String Company ){
        list<Lead> lstLead= new list<Lead>();
        for(integer i=0;i<=noOfRecord;i++){
            Lead newLead = new Lead();
            newLead.MobilePhone = mobileNo;
            newLead.LeadSource ='Zadoon Machinio Leads';
            newLead.Email = Email;
            newLead.LastName = 'Test';
            newLead.Company = Company;
            newLead.status ='New';
            lstLead.add (newLead);
        }
        return lstLead;
    }
    public static list<Sales_Team__c> SalesTeamToInsert (integer noOfRecord , string Region ){
        list<Sales_Team__c> lstSalesTeam= new list<Sales_Team__c>();
        for(integer i=0;i<=noOfRecord;i++){
            Sales_Team__c newSalesTeam = new Sales_Team__c();
           	newSalesTeam.Name = Region;
            newSalesTeam.Region__c = Region;
            lstSalesTeam.add (newSalesTeam);
        }
        return lstSalesTeam;
    }
    public static list<Team_Member__c> TeamMemberToInsert (integer noOfRecord , string salesTeamId ){
        list<Team_Member__c> lstTeamMember= new list<Team_Member__c>();
        for(integer i=0;i<=noOfRecord;i++){
            Team_Member__c newTeamMember = new Team_Member__c();
           	newTeamMember.Name = 'test'+i;
            newTeamMember.Sales_Team__c = salesTeamId;
            newTeamMember.User__c = UserInfo.getUserId();
            newTeamMember.Capacity__c = 5;
            newTeamMember.Active__c = true;
            lstTeamMember.add (newTeamMember);
        }
        return lstTeamMember;
    }
    public static list<Account> noOfAccountToInsert (integer noOfRecord , string company ){
        list<Account> lstAccount= new list<Account>();
        for(integer i=0;i<noOfRecord;i++){
            Account newAccount = new Account();
           	newAccount.Name = company;
            lstAccount.add (newAccount);
        }
        return lstAccount;
    }
    public static list<Contact> noOfContactToInsert (integer noOfRecord , string lastName ){
        list<Contact> lstContact= new list<Contact>();
        for(integer i=0;i<noOfRecord;i++){
            Contact newContact = new Contact();
           	newContact.lastName = lastName;
            newContact.email = 'paras.yadav@kizzyconsulting.com';
            lstContact.add (newContact);
        }
        return lstContact;
    }
    /*public static User createTestUser(Id profID, String fName, String lName) {
        UserRole newUserRole=new UserRole(Name= 'ABC'); 
		insert newUserRole; 
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
		String uniqueName=orgId+dateString+RandomId; 
        User newUser=new User(firstname = fName, 
                        lastName = lName, 
                        email = uniqueName + '@test' + orgId + '.org', 
                        Username = uniqueName + '@test' + orgId + '.org', 
                        EmailEncodingKey = 'ISO-8859-1', 
                        Alias = uniqueName.substring(18, 23), 
                        TimeZoneSidKey = 'America/Los_Angeles', 
                        LocaleSidKey = 'en_US', 
                        LanguageLocaleKey = 'en_US', 
                        ProfileId = profID, 
                        UserRoleId = newUserRole.id); 
        return newUser;

    }*/
    public static list<Opportunity> createOpportunity( integer noOfOpportunity, string accId, string UnitId) {
        list<Opportunity>lstOpportunity = new list<Opportunity>();
        Id standardPB = Test.getStandardPricebookId();
        system.debug('standardPBwgw24'+standardPB);
        for(integer i =0; i<noOfOpportunity; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test opp';
            opp.AccountId = accId;
            opp.CloseDate = Date.today()+30;
            opp.StageName = 'Need Analysis';
            if(string.isNotBlank(UnitId)){
                opp.Product__c = UnitId;
            }
			opp.Pricebook2Id = standardPB;
            lstOpportunity.add(opp);
        }
        return lstOpportunity;
        
        
    }
    public static list<Opportunity> createOpportunity1( integer noOfOpportunity, string accId, string UnitId) {
        list<Opportunity>lstOpportunity = new list<Opportunity>();
        Id standardPB = Test.getStandardPricebookId();
        system.debug('standardPBwgw24'+standardPB);
        for(integer i =0; i<noOfOpportunity; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test opp';
            opp.AccountId = accId;
            //opp.IsClosed = true;
            opp.CloseDate = Date.today()+30;
            opp.StageName = 'Need Analysis';
            if(string.isNotBlank(UnitId)){
                opp.Product__c = UnitId;
            }
			
            lstOpportunity.add(opp);
        }
        return lstOpportunity;
        
        
    }
}