@isTest
public class CreateTasksForUnitBatchTest {
    @isTest public static void testCreateTasksForUnitBatch(){
        list<Equipment__c> lstToAdd = TestDataFactory.noOfEquipment(1);
        insert lstToAdd;
        
        list<Product2> lstOfProductToAdd = TestDaTaFactory.noOfUnitsToCreate(1,lstToAdd[0].id);
        insert lstOfProductToAdd;
        
        list<Product2> lstOfProductToAdd2 = TestDaTaFactory.noOfUnitsToCreate2(1,lstToAdd[0].id);
        insert lstOfProductToAdd2;
     
        test.startTest();
        CreateTasksForUnitBatch newUnit = new CreateTasksForUnitBatch();
        database.executebatch(newUnit);
        test.stopTest();    
    }   
    
    @isTest public static void testCreateTasksForUnitBatch_CL(){
        list<Equipment__c> lstToAdd = TestDataFactory.noOfEquipment(1);
        insert lstToAdd;
        
        list<Product2> lstOfProductToAdd = TestDaTaFactory.noOfUnitsToCreate2(1,lstToAdd[0].id);
        lstOfProductToAdd[0].Inventory_Status__c = 'Owned';
        lstOfProductToAdd[0].CL_Post_Date__c = System.today().addDays(-30);
        insert lstOfProductToAdd;
     
        test.startTest();
        CreateTasksForUnitBatch_CL newUnit = new CreateTasksForUnitBatch_CL();
        database.executebatch(newUnit);
        test.stopTest();    

        Task tsk = [SELECT Id, Subject FROM Task LIMIT 1];
        System.assert(tsk != null);
        System.assertEquals(CreateTasksForUnitBatchHelper.clAgeTaskSubj, tsk.Subject);
    } 
}