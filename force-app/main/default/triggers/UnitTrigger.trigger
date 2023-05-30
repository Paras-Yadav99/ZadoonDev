trigger UnitTrigger on Product2 (before insert, after insert, after update, before update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            UnitTriggerHandler.handleAfterInsert(Trigger.new);
            //Id batchJobId = Database.executeBatch(new MLSCalloutBatch(), 1);
        }else if(Trigger.isUpdate){
            UnitTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
            UnitTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
            UnitTriggerHandler.handleUnitAfterUpdate(Trigger.new, Trigger.oldMap,Trigger.newMap);
        } 
    }else if(Trigger.isBefore){
        if(Trigger.isUpdate){
            UnitTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        } else if(Trigger.isInsert){
            UnitTriggerHandler.beforeInsert(Trigger.new);
        }
    }
    
}

/*trigger UnitTrigger on Product2 (before insert, after insert, after update, before update) {
    
    List<Customization_Settings__mdt> TriggerMdt = [SELECT Id,DeveloperName,Active_Trigger__c from Customization_Settings__mdt
                                                     WHERE DeveloperName ='Product_After_Insert_Trigger'];

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            
            UnitTriggerHandler.afterInsert(Trigger.new, Trigger.oldMap);
            Id batchJobId = Database.executeBatch(new MLSCalloutBatch(), 1);
            if(TriggerMdt != null && TriggerMdt.size()>0 && TriggerMdt.get(0).Active_Trigger__c ){
                if ( UtilityClass.runOnce ) {
                    //if(trigger.isAfter && ( trigger.isInsert || trigger.isUpdate)) {
                        ProductTriggerHelper.createMatchingIronDemandUnits(trigger.new, trigger.oldMap, trigger.isUpdate, trigger.isInsert);
                        UtilityClass.runOnce = false;
                    //}
                }
            }

        }else if(Trigger.isUpdate){
            UnitTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
            if(TriggerMdt != null && TriggerMdt.size()>0 && TriggerMdt.get(0).Active_Trigger__c ){
                if ( UtilityClass.runOnce ) {
                    //if(trigger.isAfter && ( trigger.isInsert || trigger.isUpdate)) {
                        ProductTriggerHelper.createMatchingIronDemandUnits(trigger.new, trigger.oldMap, trigger.isUpdate, trigger.isInsert);
                        UtilityClass.runOnce = false;
                    //}
                }
            }
        }
    }else if(Trigger.isBefore){
        if(Trigger.isUpdate){
            
            UnitTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);

            if(TriggerMdt != null && TriggerMdt.size()>0 && TriggerMdt.get(0).Active_Trigger__c ){
               
                //if(trigger.isAfter && ( trigger.isInsert || trigger.isUpdate)) {
                    ProductTriggerHelper.populateEquipmentModel( trigger.new );
                //}
                
            }

        } else if(Trigger.isInsert){
            UnitTriggerHandler.beforeInsert(Trigger.new);
            if(TriggerMdt != null && TriggerMdt.size()>0 && TriggerMdt.get(0).Active_Trigger__c ){
               
                //if(trigger.isAfter && ( trigger.isInsert || trigger.isUpdate)) {
                    ProductTriggerHelper.populateEquipmentModel( trigger.new );
                //}
                
            }
        }
    }
    
}
*/