public class CreateTasksForUnitBatchHelper {

    public static final String hardyUserName = System.Label.HardyUserName;
    public static final string HARDY_USER_ID = [SELECT Id FROM User WHERE UserName = :hardyUserName LIMIT 1]?.Id;

    public static final String shellyUserName = System.Label.ShellyUserName;
    public static final string SHELLY_USER_ID = [SELECT Id FROM User WHERE UserName = :shellyUserName LIMIT 1]?.Id;

    public static Set<Integer> unitConfirmationAgeSet = new Set<Integer>{
        120
    };
    public static Set<Integer> unitPurchaseAgeSet_priceDrop = new Set<Integer>{
        30, 60, 90, 120, 150
    };
    public static Set<Integer> unitPurchaseAgeSet_valutaion = new Set<Integer>{
        180
    };
    public static Set<Integer> clAgeSet = new Set<Integer>{
        30
    };

    public static final String priceDropTaskSubj = 'Recommend a price drop';
    public static final String valuationTaskSubj = 'Recommend a price drop or look into auction valuations';
    public static final String confirmationAgeTaskSubj = 'Confirm unit availability and see if any other machines are available for sale';
    public static final String clAgeTaskSubj = 'Renew CL listing';

    public static void run(List<Product2> units){
        List<Product2> purchaseAgeUnits_priceDrop = new List<Product2>();
        List<Product2> confirmationAgeUnits = new List<Product2>();
        List<Product2> purchaseAgeUnits_valutaion = new List<Product2>();
        List<Task> tasksToInsert = new List<Task>();

        for(Product2 unit : units){
            if(unitConfirmationAgeSet.contains(Integer.valueOf(unit.Unit_Confirmation_Age__c)) && 
                unit.Inventory_Status__c != 'Owned'
            ){
                confirmationAgeUnits.add(unit);
            }
            if(unitPurchaseAgeSet_priceDrop.contains(Integer.valueOf(unit.Unit_Purchase_Age__c)) ){
                purchaseAgeUnits_priceDrop.add(unit);
            }
            if(unitPurchaseAgeSet_valutaion.contains(Integer.valueOf(unit.Unit_Purchase_Age__c))){
                purchaseAgeUnits_valutaion.add(unit); 
            }
        }
        system.debug('confirmationAgeUnits'+confirmationAgeUnits);
        system.debug('purchaseAgeUnits'+purchaseAgeUnits_valutaion);
		system.debug('priceDrop'+purchaseAgeUnits_priceDrop);
        for(Product2 unit : purchaseAgeUnits_priceDrop){
            if(HARDY_USER_ID != null){
                tasksToInsert.add(createTaskObj(HARDY_USER_ID, priceDropTaskSubj,unit.Id));
            } else{
                tasksToInsert.add(createTaskObj(UserInfo.getUserId(), priceDropTaskSubj,unit.Id));
            }
        }
        
        for(Product2 unit : purchaseAgeUnits_valutaion){
            if(HARDY_USER_ID != null){
                tasksToInsert.add(createTaskObj(HARDY_USER_ID, valuationTaskSubj, unit.Id));
            } else{
                tasksToInsert.add(createTaskObj(UserInfo.getUserId(), valuationTaskSubj, unit.Id));
            }
        }

        for(Product2 unit : confirmationAgeUnits){
            tasksToInsert.add(createTaskObj(unit.Unit_Owner__c, confirmationAgeTaskSubj,unit.Id));
        }

        system.debug('taskToInsert'+tasksToInsert);
        if(tasksToInsert.size() > 0){
            Database.insert(tasksToInsert);
        }
    }

    public static void run_cl(List<Product2> units){
        List<Product2> clAgeUnits = new List<Product2>();
        List<Task> tasksToInsert = new List<Task>();

        for(Product2 unit : units){
            if(clAgeSet.contains(Integer.valueOf(unit.CL_Post_Age__c)) &&
                (unit.Inventory_Status__c == 'Owned' || unit.Craigslist_Live_Listing__c != null)
            ){
                clAgeUnits.add(unit); 
            }
        }
        system.debug('clAgeUnits'+clAgeUnits);

        for(Product2 unit : clAgeUnits){
            if(SHELLY_USER_ID != null){
                tasksToInsert.add(createTaskObj(SHELLY_USER_ID, clAgeTaskSubj, unit.Id));
            } else{
                tasksToInsert.add(createTaskObj(UserInfo.getUserId(), clAgeTaskSubj, unit.Id));
            }
            
        }

        system.debug('taskToInsert'+tasksToInsert);
        if(tasksToInsert.size() > 0){
            Database.insert(tasksToInsert);
        }
    }

    public static Task createTaskObj(Id owner, String subject, Id relatedObj){
        Task tsk = new Task();
        tsk.Subject = subject;
        tsk.Status = 'Open';
        tsk.WhatId = relatedObj;
        tsk.OwnerId = owner;
        tsk.Priority = 'Normal';
        tsk.ActivityDate = System.today();

        return tsk;
    }
}