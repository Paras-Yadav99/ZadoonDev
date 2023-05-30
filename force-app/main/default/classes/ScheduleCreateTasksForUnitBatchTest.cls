@isTest
public class ScheduleCreateTasksForUnitBatchTest {
    @isTest
    public static void testScheduler(){
        String CRON_EXP = '0 0 22 * * ? *';

        list<Equipment__c> lstToAdd = TestDataFactory.noOfEquipment(1);
        insert lstToAdd;
        
        list<Product2> lstOfProductToAdd = TestDaTaFactory.noOfUnitsToCreate(1,lstToAdd[0].id);
        insert lstOfProductToAdd;
        
        list<Product2> lstOfProductToAdd2 = TestDaTaFactory.noOfUnitsToCreate2(1,lstToAdd[0].id);
        insert lstOfProductToAdd2;

        list<Product2> lstOfProductToAdd3 = TestDaTaFactory.noOfUnitsToCreate2(1,lstToAdd[0].id);
        lstOfProductToAdd3[0].Inventory_Status__c = 'Owned';
        lstOfProductToAdd3[0].CL_Post_Date__c = System.today().addDays(-30);
        insert lstOfProductToAdd3;
     
        test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new ScheduleCreateTasksForUnitBatch()
            );
        test.stopTest();
        
        System.assert(String.isNotBlank(jobId));
    }
}