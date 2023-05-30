public class CreateTasksForUnitBatch_CL implements database.Batchable<sObject>{
    public database.QueryLocator start(database.BatchableContext bc){
        return Database.getQueryLocator(
            [
                SELECT ID, IsActive, Inventory_Status__c, Unit_Owner__c, CL_Post_Age__c, Unit_Confirmation_Age__c, Unit_Purchase_Age__c
                FROM Product2
                WHERE IsActive = True AND
                (
                    Inventory_Status__c = 'Owned' OR
                    Craigslist_Live_Listing__c != null
                )
                AND
                CL_Post_Age__c IN :CreateTasksForUnitBatchHelper.clAgeSet
            ]
        );
    }

    public void execute(Database.BatchableContext bc, List<Product2> scope){
        CreateTasksForUnitBatchHelper.run_cl(scope);
    }

    public void finish(Database.BatchableContext bc){
        
    }
}