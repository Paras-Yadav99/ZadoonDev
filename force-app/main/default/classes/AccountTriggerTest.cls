@istest
public class AccountTriggerTest {
    @isTest public static void handleAfterInsert(){
        list<Account> lstAccount = TestDataFactory.noOfAccountToInsert(2,'company');
        
        test.startTest();
        insert lstAccount;
        test.stopTest();
    }
}