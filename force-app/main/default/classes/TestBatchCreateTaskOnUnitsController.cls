// test Class for Batch Creat
@isTest
public class TestBatchCreateTaskOnUnitsController {
    public static Account NewAccount = new Account();
    public static Contact NewContact = new Contact();
    public static Equipment__c NewEquipment = new Equipment__c();
    @isTest
    public static void testOwnedUnits(){
        
        NewAccount.Name = 'Test Account';
        insert NewAccount;
        
        Account NewAccount1 = new Account();
        NewAccount1.Name='TestAccount1';
        NewAccount1.Do_not_market_Facebook__c=true;
        insert NewAccount1;
        
        NewContact.LastName='Test Conatact';
        NewContact.AccountID = NewAccount.Id;
        insert NewContact;
        
        NewEquipment.Name = 'Test Equipment';
        NewEquipment.Manufacturer__c = 'Stellar';
        NewEquipment.Base_New__c = '50';
        NewEquipment.MT_Inventory_Type__c = 'Agricultural_Equipment';
        NewEquipment.On_Off_Highway__c='On Highway';
        insert NewEquipment;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User newUser = new user();
        newUser.LastName = 'Test Code';
        newUser.Email = 'test@test.com';
        newUser.Alias = 'Tcode';
        newUser.Username = 'test2022dee@test.com';
        newUser.CommunityNickname = 'test12';
        newUser.LocaleSidKey = 'en_US';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.ProfileID = pf.id;
        newUser.LanguageLocaleKey = 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        insert newUser;
        
        list<product2>lstUnits = new list<product2>();
        Product2 NewProduct = New Product2();
        NewProduct.IsActive = true;
        NewProduct.Name = 'Test Product';
        NewProduct.Account__c=NewAccount.Id;
        //NewProduct.Primary_Contact__c=NewContact.Id;
        NewProduct.equipment__c=NewEquipment.Id;
        NewProduct.Inventory_Status__c='Owned';
        NewProduct.Unit_Owner__c=newUser.Id;
        NewProduct.Sourced_From_Link__c = 'Null link1' ;
        NewProduct.FB_Marketplace_Live_Link__c = 'link2' ; 
        NewProduct.RentalYard_Link__c = 'TestLink3'; 
        NewProduct.Mailchimp_Link__c = 'NullLink4'; 
        lstUnits.add(NewProduct);
        
        Product2 NewProduct1 = New Product2();
        NewProduct1.IsActive = true;
        NewProduct1.Name = 'Test Product';
        NewProduct1.Account__c=NewAccount.Id;
        //NewProduct1.Primary_Contact__c=NewContact.Id;
        NewProduct1.equipment__c=NewEquipment.Id;
        NewProduct1.Unit_Owner__c=newUser.Id;
        NewProduct1.Inventory_Status__c='Owned';
        lstUnits.add(NewProduct1);
        
        Product2 NewProduct2 = New Product2();
        NewProduct2.IsActive = true;
        NewProduct2.Name = 'Test Product';
        NewProduct2.Account__c=NewAccount.Id;
        //NewProduct2.Primary_Contact__c=NewContact.Id;
        NewProduct2.equipment__c=NewEquipment.Id;
        NewProduct2.Unit_Owner__c=newUser.Id;
        NewProduct2.Inventory_Status__c='Brokerage';
        lstUnits.add(NewProduct2);
        
        Product2 NewProduct3 = New Product2();
        NewProduct3.IsActive = true;
        NewProduct3.Name = 'Test Product';
        NewProduct3.Account__c=NewAccount1.Id;
        //NewProduct3.Primary_Contact__c=NewContact.Id;
        NewProduct3.Unit_Owner__c=newUser.Id;
        NewProduct3.equipment__c=NewEquipment.Id;
        NewProduct3.Inventory_Status__c='Brokerage';
        NewProduct3.Override_Post_Override_DNP_anywhere__c = true;
       // NewProduct3.Sourced_From_Link__c = 'Null link1' ;
       // NewProduct3.FB_Marketplace_Live_Link__c = 'link2' ; 
        NewProduct3.Rock_Dirt_Live_Link__c = 'TestLink3';
        //NewProduct3.Craigslist_Live_Listing__c = 'DemoLink'; 
        lstUnits.add(NewProduct3);
        
        Product2 NewProduct4 = New Product2();
        NewProduct4.Name = 'Test Product';
        
        NewProduct4.Account__c=NewAccount.Id;
        NewProduct4.Unit_Owner__c=newUser.Id;
        //NewProduct4.Primary_Contact__c=NewContact.Id;
        NewProduct4.equipment__c=NewEquipment.Id;
        NewProduct4.Inventory_Status__c='Brokerage';
        NewProduct4.Sourced_From_Link__c = 'Null link1' ;
        NewProduct4.FB_Marketplace_Live_Link__c = 'link2' ; 
        NewProduct4.RentalYard_Link__c = 'TestLink3'; 
        NewProduct4.Mailchimp_Link__c = 'NullLink4'; 
        NewProduct4.Craigslist_Live_Listing__c = Null; 
        lstUnits.add(NewProduct4);
        
        insert lstUnits;
        Id proRecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Procurement Opportunity').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'mickle';
        opp1.AccountId = NewAccount.Id;
        opp1.Product__c = NewProduct3.Id;
        opp1.StageName = 'Proactive Brokerage';
        opp1.RecordTypeId = proRecordTypeIdOpportunity;
        opp1.CloseDate = Date.newInstance(2022, 12, 20);
        insert opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'mickle';
        opp2.AccountId = NewAccount.Id;
        opp2.Product__c = NewProduct1.Id;
        opp2.StageName = 'Proactive Brokerage';
        opp2.RecordTypeId = proRecordTypeIdOpportunity;
        opp2.CloseDate = Date.newInstance(2022, 12, 20);
        insert opp2;
        
        BatchCreateTaskonUnits batchInstance= new BatchCreateTaskonUnits();
        System.Test.startTest();
        id BatchId = DataBase.executeBatch(batchInstance, 200);
       // BatchCreateTaskOnUnitsController.handleExecution(lstUnits);
        System.Test.stopTest();
  
    }
     @isTest
    public static void testSchedulableContext(){
        System.Test.startTest();
        ScheduleBatchCreateTaskOnUnitsClass instScheduleClass = new ScheduleBatchCreateTaskOnUnitsClass();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Territory Check', sch, instScheduleClass); 
        System.Test.stopTest();
    }
}