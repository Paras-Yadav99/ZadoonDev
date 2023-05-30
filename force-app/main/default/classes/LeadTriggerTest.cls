@isTest
public class LeadTriggerTest {
    @isTest
    public static void testMethodForInsert(){
        list<Equipment__c> lstToAdd = TestDataFactory.noOfEquipment(1);
        insert lstToAdd;
        
        list<Product2> lstOfProductToAdd = TestDaTaFactory.noOfUnitsToCreate(1,lstToAdd[0].id);
        insert lstOfProductToAdd;

        Contact con = TestDaTaFactory.createContact(True);

        Lead lead = new Lead();
        lead.MobilePhone = '123';
        lead.Email = 'test@gmail.com';
        lead.LastName = 'Test';
        lead.Company = 'Test';
        lead.Unit__c = lstOfProductToAdd[0].Id;
        lead.Contact__c = con.Id;
        
        Test.startTest();
        insert lead;
        Test.stopTest();

        Iron_Demand__c ironDemand = [SELECT Id FROM Iron_Demand__c limit 1];
        System.assert(ironDemand != null);
    }

    @isTest
    public static void testMethodForUpdate(){
        list<Equipment__c> lstToAdd = TestDataFactory.noOfEquipment(1);
        insert lstToAdd;
        
        list<Product2> lstOfProductToAdd = TestDaTaFactory.noOfUnitsToCreate(1,lstToAdd[0].id);
        insert lstOfProductToAdd;

        Contact con = TestDaTaFactory.createContact(True);

        Lead lead = new Lead();
        lead.MobilePhone = '123';
        lead.Email = 'test@gmail.com';
        lead.LastName = 'Test';
        lead.Company = 'Test';
        lead.Contact__c = con.Id;
        insert lead;

        List<Iron_Demand__c> ironDemands = [SELECT Id FROM Iron_Demand__c limit 1];
        System.assert(ironDemands.size() == 0);
        
        Test.startTest();
        lead.Unit__c = lstOfProductToAdd[0].Id;
        update lead;
        Test.stopTest();

        ironDemands = [SELECT Id FROM Iron_Demand__c limit 1];
        System.assert(ironDemands != null);
    }
    @isTest
    public static void testMethodForNoOfActiveLead(){
    	list<Lead> lstDomesticLead= testDataFactory.noOfLeadToInsert(1,'');
        insert lstDomesticLead;
        for(lead eachLead : lstDomesticLead){
            eachLead.Status='Working';
        }
        Test.startTest();
        update lstDomesticLead; 
        delete lstDomesticLead;
        undelete lstDomesticLead;
        Test.stopTest();
           
    }
    @isTest
    public static void testMethodForNoOfActiveLeadAfterDelete(){
    	list<Lead> lstDomesticLead= testDataFactory.noOfLeadToInsert(1,'+15437');
        insert lstDomesticLead;
        
        Test.startTest();
        
        delete lstDomesticLead;
        
        Test.stopTest();
           
    }
    @isTest
    public static void testMethodForNoOfActiveLeadAfterUnDelete(){
    	list<Lead> lstDomesticLead= testDataFactory.noOfLeadToInsert(1,'+15437');
        insert lstDomesticLead;
        delete lstDomesticLead;
        Test.startTest();
        
        Undelete lstDomesticLead;
        
        Test.stopTest();
           
    }
    @isTest
    public static void testTriggerDispatcher(){
        TriggerDispatcher.LoopCount obj = new TriggerDispatcher.LoopCount();
        Integer max = obj.getMax();
        Integer count = obj.getCount();
    }
    @isTest
    public static void testMethodBeforeInsertRoundRobin(){
        list<Lead> lstDomesticLead= testDataFactory.noOfLeadToInsert(1,'+15437');
        list<Lead> lstLeadToInert= testDataFactory.noOfLeadToInsertForRoundRobin(1,'456261','test1@gmail.com','Kizzy123');
        list<Lead> lstLeadToInert2= testDataFactory.noOfLeadToInsertForRoundRobin(1,'45626','test13@gmail.com','Kizzy123');
        list<Lead> lstLeadToInert1= testDataFactory.noOfLeadToInsertForRoundRobin(1,'3484','test12@gmail.com','test');
        
        list<Lead> lstInternationalLead= testDataFactory.noOfLeadToInsert(1,'456261');
        list<Sales_Team__c> lstDomesticSalesTeam = testDataFactory.SalesTeamToInsert(1,'Domestic');
        insert lstDomesticSalesTeam;
        list<Sales_Team__c> lstInternationalSalesTeam = testDataFactory.SalesTeamToInsert(1,'International');
        insert lstInternationalSalesTeam;
        list<Team_Member__c> lstDomesticTeamMember = testDataFactory.TeamMemberToInsert(1,lstDomesticSalesTeam[0].id);
        insert lstDomesticTeamMember;
        
        list<Team_Member__c> lstInternationalTeamMember = testDataFactory.TeamMemberToInsert(1,lstInternationalSalesTeam[0].id);
        insert lstInternationalTeamMember;
        Test.startTest();
        insert lstDomesticLead;
        insert lstInternationalLead;
       // insert lstLeadToInert;
        //insert lstLeadToInert1;
        //insert lstLeadToInert2;
        Test.stopTest();

       
    }
    @isTest
    public static void testMethodBeforeInsertRoundRobin1(){
        //list<Lead> lstDomesticLead= testDataFactory.noOfLeadToInsert(1,'+15437');
        list<Lead> lstLeadToInert= testDataFactory.noOfLeadToInsertForRoundRobin(1,'456261','test1@gmail.com','Kizzy123');
        insert lstLeadToInert;
        list<Lead> lstLeadToInert2= testDataFactory.noOfLeadToInsertForRoundRobin(1,'45626','test13@gmail.com','Kizzy123');
        list<Lead> lstLeadToInert1= testDataFactory.noOfLeadToInsertForRoundRobin(1,'3484','test1@gmail.com','test');
        list<Lead> lstLeadToInert3= testDataFactory.noOfLeadToInsertForRoundRobin(1,'456261','test113@gmail.com','Kizzy1123');
        
        //list<Lead> lstInternationalLead= testDataFactory.noOfLeadToInsert(1,'456261');
        list<Sales_Team__c> lstDomesticSalesTeam = testDataFactory.SalesTeamToInsert(1,'Domestic');
        insert lstDomesticSalesTeam;
        list<Sales_Team__c> lstInternationalSalesTeam = testDataFactory.SalesTeamToInsert(1,'International');
        insert lstInternationalSalesTeam;
        list<Team_Member__c> lstDomesticTeamMember = testDataFactory.TeamMemberToInsert(1,lstDomesticSalesTeam[0].id);
        insert lstDomesticTeamMember;
        
        list<Team_Member__c> lstInternationalTeamMember = testDataFactory.TeamMemberToInsert(1,lstInternationalSalesTeam[0].id);
        insert lstInternationalTeamMember;
        Test.startTest();
        //insert lstDomesticLead;
        //insert lstInternationalLead;
        
        //insert lstLeadToInert1;
        insert lstLeadToInert2;
        insert lstLeadToInert3;
        Test.stopTest();

       
    }
    @isTest
    public static void testMethodBeforeUpdateRoundRobin(){
        list<Lead> lstDomesticLead= testDataFactory.noOfLeadToInsert(1,'+15437');
        insert lstDomesticLead;
        list<Lead> lstInternationalLead= testDataFactory.noOfLeadToInsert(1,'456261');
        insert lstInternationalLead;
        
        list<Sales_Team__c> lstDomesticSalesTeam = testDataFactory.SalesTeamToInsert(1,'DOMESTIC');
        insert lstDomesticSalesTeam;
        list<Sales_Team__c> lstInternationalSalesTeam = testDataFactory.SalesTeamToInsert(1,'INTERNATIONAL');
        insert lstInternationalSalesTeam;
        list<Team_Member__c> lstDomesticTeamMember = testDataFactory.TeamMemberToInsert(1,lstDomesticSalesTeam[0].id);
        insert lstDomesticTeamMember;
        
        list<Team_Member__c> lstInternationalTeamMember = testDataFactory.TeamMemberToInsert(1,lstInternationalSalesTeam[0].id);
        insert lstInternationalTeamMember;
        
        for(lead eachLead : lstDomesticLead){
            eachLead.Region__c = 'INTERNATIONAL';
        }
        for(lead eachLead : lstInternationalLead){
            eachLead.Region__c = 'DOMESTIC';
        }
        Test.startTest();
        update lstDomesticLead;
        Test.stopTest();

       
    }
}