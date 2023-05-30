@istest
public class UnitTriggerTest {
    @isTest public static void testUnitTriggerOnInsert (){
        list<Account> lstAccount = TestDataFactory.noOfAccountToInsert(1, 'company');
        insert lstAccount;
        list<Equipment__c> lstEquipment= TestDataFactory.noOfEquipment(1);
        insert lstEquipment;
        list<Product2> lstUnit = TestDataFactory.noOfUnitsToCreate2(1 ,lstEquipment[0].id ,lstAccount[0].id );
        test.startTest();
        insert lstUnit;
        test.stopTest();
    }
    @isTest public static void testUnitTriggerOnUpdate (){
        list<Account> lstAccount = TestDataFactory.noOfAccountToInsert(2,'company');
        insert lstAccount;
        list<Equipment__c> lstEquipment= TestDataFactory.noOfEquipment(1);
        insert lstEquipment;
        list<Product2> lstUnit = TestDataFactory.noOfUnitsToCreate2(1 ,lstEquipment[0].id , lstAccount[0].id);
        insert lstUnit;
        list<Product2> lstUnit1 = TestDataFactory.noOfUnitsToCreate2(1 ,lstEquipment[0].id , '');
        insert lstUnit1;
        list<Product2> lstUnitUpdate = new list<Product2>();
        for(Product2 eachProduct2 :lstUnit1){
            eachProduct2.Account__c = lstAccount[0].id;
            lstUnitUpdate.add(eachProduct2);
        }
        for(Product2 eachProduct2 :lstUnit){
            eachProduct2.Account__c = lstAccount[1].id;
            lstUnitUpdate.add(eachProduct2);
        }
        test.startTest();
        	update lstUnitUpdate;
        test.stopTest();
    }
}