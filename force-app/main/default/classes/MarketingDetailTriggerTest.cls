@isTest
public class MarketingDetailTriggerTest {
    @isTest public static void MarketingDetailTriggerBeforeUpdateTest (){
        list<Account> lstAccount = TestDataFactory.noOfAccountToInsert(2,'company');
        insert lstAccount;
        list<Equipment__c> lstEquipment= TestDataFactory.noOfEquipment(1);
        insert lstEquipment;
        list<Product2> lstUnit = TestDataFactory.noOfUnitsToCreate2(1 ,lstEquipment[0].id , lstAccount[0].id);
        insert lstUnit;
        list<Marketing_Detail__c> lstMarketingDetail = [SELECT Id, Marketed_On_Construction_Equip_Guide__c, Marketed_On_Craigslist__c, 
                                                        Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, Marketed_On_Fleet_Up_Marketplace__c, 
                                                        Marketed_On_GearFlow__c, Marketed_On_Instagram__c, Marketed_On_LinkedIn__c, 
                                                        Marketed_On_Machinio__c, Marketed_On_Mascus__c, Marketed_on_MT_Crane_Truck__c, 
                                                        Marketed_On_MyLittleSalesman__c, Marketed_On_Terrapoint__c, Marketed_On_TradeMachines__c, 
                                                        Marketed_On_Used_Equip_Guide__c, Marketed_On_Zonapesada__c, Do_not_market_anywhere__c,
                                                        Account__c
                                                        FROM Marketing_Detail__c WHERE Account__c IN :lstAccount];
        for(Marketing_Detail__c eachMarketingDetail : lstMarketingDetail){
            eachMarketingDetail.Marketed_On_Construction_Equip_Guide__c= false;
            eachMarketingDetail.Marketed_On_FB_Marketplace__c = true;
        }
        test.startTest();
        update lstMarketingDetail;
        test.stopTest();
    }
    @isTest public static void MarketingDetailTriggerBeforeUpdateTest1 (){
        list<Account> lstAccount = TestDataFactory.noOfAccountToInsert(2,'company');
        insert lstAccount;
        list<Equipment__c> lstEquipment= TestDataFactory.noOfEquipment(1);
        insert lstEquipment;
        list<Product2> lstUnit = TestDataFactory.noOfUnitsToCreate2(1 ,lstEquipment[0].id , lstAccount[0].id);
        insert lstUnit;
        Pricebook2 standardPricebook = new Pricebook2(
                                                        Id = Test.getStandardPricebookId(),
                                                        IsActive = true
                                                    );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        list<Opportunity> lstOpportunity = TestDataFactory.createOpportunity(1, lstAccount[0].id, lstUnit[0].id);
        string procurementOpp = System.Label.Opp_Rec_type_Dev_Name_procurement_opp;
            RecordType procurementOppRecordType = [SELECT Id FROM RecordType where DeveloperName =: procurementOpp LIMIT 1 ];
        lstOpportunity[0].RecordTypeId =procurementOppRecordType.id; 
        insert lstOpportunity;
        system.debug('lstOpportunity'+lstOpportunity);
        list<Marketing_Detail__c> lstMarketingDetail = [SELECT Id, Marketed_On_Construction_Equip_Guide__c, Marketed_On_Craigslist__c, 
                                                        Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, Marketed_On_Fleet_Up_Marketplace__c, 
                                                        Marketed_On_GearFlow__c, Marketed_On_Instagram__c, Marketed_On_LinkedIn__c, 
                                                        Marketed_On_Machinio__c, Marketed_On_Mascus__c, Marketed_on_MT_Crane_Truck__c, 
                                                        Marketed_On_MyLittleSalesman__c, Marketed_On_Terrapoint__c, Marketed_On_TradeMachines__c, 
                                                        Marketed_On_Used_Equip_Guide__c, Marketed_On_Zonapesada__c, Do_not_market_anywhere__c,
                                                        Opportunity__c
                                                        FROM Marketing_Detail__c WHERE Opportunity__c IN :lstOpportunity];
        system.debug('lstMarketingDetail:'+lstMarketingDetail);
        for(Marketing_Detail__c eachMarketingDetail : lstMarketingDetail){
            eachMarketingDetail.Marketed_On_Construction_Equip_Guide__c= false;
            eachMarketingDetail.Marketed_On_FB_Marketplace__c = true;
        }
        system.debug('lstMarketingDetail:::'+lstMarketingDetail);
        test.startTest();
        update lstMarketingDetail;
        test.stopTest();
    }
}