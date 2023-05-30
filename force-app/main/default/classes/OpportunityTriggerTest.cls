@istest
public class OpportunityTriggerTest {
    @isTest  public static void OpportunityTriggerHandlerTest() {
        list<Account> lstAccount = testDataFactory.noOfAccountToInsert(1,'TestKizzy');
        insert lstAccount;
        list<Equipment__c> lstEquipment=  testDataFactory.noOfEquipment(1);
        insert lstEquipment;
        list<Product2> lstProduct = testDataFactory.noOfUnitsToCreate(1, lstEquipment[0].id);
        insert lstProduct;
        Pricebook2 standardPricebook = new Pricebook2(
                                                        Id = Test.getStandardPricebookId(),
                                                        IsActive = true
                                                    );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
    
        list<Opportunity> lstOpportunity = testDataFactory.createOpportunity(1, lstAccount[0].id, lstProduct[0].id);
        
        test.startTest();
        insert lstOpportunity;
        //update lstOpportunityUpdate;
        test.stopTest();
    }
    @isTest  public static void OpportunityTriggerHandlerTestonUpdate() {
        list<Account> lstAccount = testDataFactory.noOfAccountToInsert(1,'TestKizzy');
        insert lstAccount;
        list<Equipment__c> lstEquipment=  testDataFactory.noOfEquipment(1);
        insert lstEquipment;
        list<Product2> lstProduct = testDataFactory.noOfUnitsToCreate(1, lstEquipment[0].id);
        insert lstProduct;
        Pricebook2 standardPricebook = new Pricebook2(
                                                        Id = Test.getStandardPricebookId(),
                                                        IsActive = true
                                                    );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        list<Opportunity> lstOpportunityUpdate = testDataFactory.createOpportunity(1, lstAccount[0].id, lstProduct[0].id);
        insert lstOpportunityUpdate;
        
        for(Opportunity eachOpportunity : lstOpportunityUpdate){
            eachOpportunity.Financials_complete__c = true;
        }
        try{
           // update lstOpportunityUpdate;
        }catch(exception ex){
            Boolean expectedExceptionThrown =  ex.getMessage().contains('You can not mark the checkbox Financials Complete') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        /*
        test.startTest();
        
        update lstOpportunityUpdate;
        test.stopTest();*/
    }
     /*@isTest  public static void OpportunityTriggerHandlerAfterUpdate() {
        list<Account> lstAccount = TestDataFactory.noOfAccountToInsert(2,'company');
        insert lstAccount;
        list<Equipment__c> lstEquipment= TestDataFactory.noOfEquipment(1);
        insert lstEquipment;
        list<Product2> lstUnit = TestDataFactory.noOfUnitsToCreate2(1 ,lstEquipment[0].id , lstAccount[0].id);
        insert lstUnit;
        list<Opportunity> lstOpportunity = TestDataFactory.createOpportunity(1, lstAccount[0].id, '');
        string procurementOpp = System.Label.Opp_Rec_type_Dev_Name_procurement_opp;
            RecordType procurementOppRecordType = [SELECT Id FROM RecordType where DeveloperName =: procurementOpp LIMIT 1 ];
        lstOpportunity[0].RecordTypeId =procurementOppRecordType.id; 
        insert lstOpportunity; 
         Pricebook2 standardPricebook = new Pricebook2(
                                                        Id = Test.getStandardPricebookId(),
                                                        IsActive = true
                                                    );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
         for(Opportunity eachOpportunity : lstOpportunity){
              eachOpportunity.Product__c = lstUnit[0].id;
         }
         system.debug('lstOpportunity'+lstOpportunity);
         test.startTest();
         
         update lstOpportunity;
         test.stopTest();
         
     }*/
    
}