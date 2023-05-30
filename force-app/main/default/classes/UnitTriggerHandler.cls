public class UnitTriggerHandler {
    
    
    
    public static void beforeInsert(
        List<Product2> units
    ){
        PopulateVagueCityHelper helper = new PopulateVagueCityHelper();
        for(Product2 unit : units){
            unit.MT_Vague_Display_Location_Name__c = helper.getCity(unit);
        }
    }
    /*public static void afterInsert(
List<Product2> units,
Map<Id, Product2> oldUnitMap){
List<Pricebook2> pbList = new List<Pricebook2>();
pbList = [select Id from Pricebook2 where IsStandard = TRUE LIMIT 1];
system.debug('pbList :  '+pbList);
if(pbList.size() > 0) {
List<PricebookEntry> pbEntry = new List <PricebookEntry>();
for (Product2 newProduct: units) {
PricebookEntry z = new PricebookEntry(Pricebook2Id=pbList[0].Id,Product2Id=newProduct.Id, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
pbEntry.add(z);
}
if(pbEntry.size() > 0 && !test.isRunningTest()) {
insert pbEntry;
}
}
}*/
    
    public static void afterUpdate(
        List<Product2> units,
        Map<Id, Product2> oldUnitMap){
            
            List<Id> filteredUnitsIds = new List<Id>();
            //List<Id> filteredUnitsIdsForInsert = new List<Id>();
            
            List<Integer> deleteListingIds = new List<Integer>();
            for(Product2 unit : units){
                Product2 oldUnit = oldUnitMap.get(unit.Id);
                if((hasFieldChanged(unit, oldUnit, 'Year__c') || 
                    hasFieldChanged(unit, oldUnit, 'Manufacturer__c') ||
                    hasFieldChanged(unit, oldUnit, 'Model__c') || 
                    hasFieldChanged(unit, oldUnit, 'Category__c') || 
                    hasFieldChanged(unit, oldUnit, 'Old_SF_Unit_Details__c') || 
                    hasFieldChanged(unit, oldUnit, 'Number_of_Images_in_Google_Drive__c') || 
                    hasFieldChanged(unit, oldUnit, 'Number_of_Videos_in_Google_Drive__c') || 
                    hasFieldChanged(unit, oldUnit, 'Starting_Advertised_Retail_Price__c') || 
                    //hasFieldChanged(unit, oldUnit, 'MT_Live_Advertised__c') || 
                    hasFieldChanged(unit, oldUnit, 'MT_Vague_Display_Location_Name__c') || 
                    hasFieldChanged(unit, oldUnit, 'MT_Location_Vague_Postal_Code__c') || 
                    //hasFieldChanged(unit, oldUnit, 'Google_Drive_LInk__c') || 
                    //hasFieldChanged(unit, oldUnit, 'Google_Drive_Videos_Link__c')// || 
                    hasFieldChanged(unit, oldUnit, 'Storage_State__c'))
                  ){
                      filteredUnitsIds.add(unit.Id);
                  } 
                
                if(hasFieldChanged(unit, oldUnit, 'IsActive')){
                    if(unit.IsActive == false){
                        deleteListingIds.add(Integer.valueOf(unit.MLS_Number__c));
                    } else{
                        //Id batchJobId = Database.executeBatch(new MLSCalloutBatch(), 1);
                    }
                } 
                
                /*if(hasFieldChanged(unit, oldUnit, 'My_Little_Salesman_Listing__c')){
if(unit.My_Little_Salesman_Listing__c == 'Do not Advertise'){
deleteListingIds.add(Integer.valueOf(unit.MLS_Number__c));
} else if(unit.My_Little_Salesman_Listing__c == 'Advertise') {
filteredUnitsIdsForInsert.add(unit.Id);
}
}*/
            }
            
            /*if(filteredUnitsIdsForInsert.size()> 0){
// MLSCalloutUpdateBatch obj = new MLSCalloutUpdateBatch(filteredUnitsIdsForInsert);
Id batchJobId = Database.executeBatch(new MLSCalloutBatch(), 1);
}*/
            
            if(filteredUnitsIds.size()> 0){
                // MLSCalloutUpdateBatch obj = new MLSCalloutUpdateBatch(filteredUnitsIds);
                // Id batchJobId = Database.executeBatch(obj, 1);
            }
            
            if(deleteListingIds.size()> 0){
                // MLSCalloutDeleteBatch obj = new MLSCalloutDeleteBatch(deleteListingIds);
                // Id batchJobId = Database.executeBatch(obj, 1);
            }
            
        }
    
    public static void beforeUpdate(
        List<Product2> units,
        Map<Id, Product2> oldUnitMap){
            PopulateVagueCityHelper helper = new PopulateVagueCityHelper();
            
            for(Product2 unit : units){
                Product2 oldUnit = oldUnitMap.get(unit.Id);
                if(hasFieldChanged(unit, oldUnit, 'Storage_City__c') || 
                   hasFieldChanged(unit, oldUnit, 'Inventory_Status__c'))
                {
                    unit.MT_Vague_Display_Location_Name__c = helper.getCity(unit);
                }
            }
        }
    
    private static Boolean hasFieldChanged(
        Product2 newUnit, Product2 oldUnit, String fieldName
    ){
        return hasValueChanged(
            newUnit.get(fieldName),
            oldUnit.get(fieldName)
        );
    }
    
    private static Boolean hasValueChanged(Object newValue, Object oldValue){
        return newValue != oldValue;
    }
    
    public static void handleAfterInsert(
        List<Product2> triggerNew
    ){
        set<Id> setOfAccountId = new set<Id>();
        set<Id> setOfProduct2Id = new set<Id>();
        list<Marketing_Detail__c> lstMarketingDetail;
        list<Marketing_Detail__c> lstMarketingDetailToInsert = new list<Marketing_Detail__c>();
        map<Id,Marketing_Detail__c>mapOfAccountIdVsMarketingDetail = new map<Id,Marketing_Detail__c>();
        list<Product2> lstProduct2 ;
        
        
        if(triggerNew!= null && !triggerNew.isEmpty()){
            for (Product2 eachProduct2 : triggerNew){
                if(string.isNotBlank(eachProduct2.Account__c)){
                    setOfAccountId.add(eachProduct2.Account__c);
                }
                
                setOfProduct2Id.add(eachProduct2.id);
                
                /*if(string.isNotBlank(eachProduct2.Unit_Owner__c)){
if(!mapOfUserIdVsLstUnit.keySet().contains(eachProduct2.Unit_Owner__c)){
mapOfUserIdVsLstUnit.put(eachProduct2.Unit_Owner__c,new list<Product2>());
mapOfUserIdVsLstUnit.get(eachProduct2.Unit_Owner__c).add(eachProduct2);
}
mapOfUserIdVsLstUnit.get(eachProduct2.Unit_Owner__c).add(eachProduct2);
}*/
                //setOfProduct2Id.add(eachProduct2.id);
            }
        }
        
        if(setOfAccountId!=null && !setOfAccountId.isEmpty()){
            lstMarketingDetail = [SELECT Id, Marketed_On_Construction_Equip_Guide__c, Marketed_On_Craigslist__c, 
                                  Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, 
                                  Marketed_On_Fleet_Up_Marketplace__c, Marketed_On_GearFlow__c, 
                                  Marketed_On_Instagram__c, Marketed_On_LinkedIn__c, Marketed_On_Machinio__c, 
                                  Marketed_On_Mascus__c, Marketed_on_MT_Crane_Truck__c, 
                                  Marketed_On_MyLittleSalesman__c, Marketed_On_Terrapoint__c, 
                                  Marketed_On_TradeMachines__c, Marketed_On_Used_Equip_Guide__c, 
                                  Marketed_On_Zonapesada__c, Do_not_market_anywhere__c, 
                                  Account__c, Opportunity__c, Updated_From__c,
                                  Unit__c, IsDeleted 
                                  FROM Marketing_Detail__c WHERE Account__c IN : setOfAccountId];  
        }
        if(lstMarketingDetail!=null && !lstMarketingDetail.isEmpty()){
            for(Marketing_Detail__c eachMarketingDetail : lstMarketingDetail){
                mapOfAccountIdVsMarketingDetail.put(eachMarketingDetail.Account__c,eachMarketingDetail);
            }
        }
        if(triggerNew!= null && !triggerNew.isEmpty()){
            for (Product2 eachProduct2 : triggerNew){
                if(string.isNotBlank(eachProduct2.Account__c) && mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c)!=null){
                    Marketing_Detail__c newMarketingDetail = new Marketing_Detail__c();
                    newMarketingDetail.Marketed_On_Construction_Equip_Guide__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Construction_Equip_Guide__c;
                    newMarketingDetail.Marketed_On_Craigslist__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Craigslist__c ;
                    newMarketingDetail.Marketed_On_Facebook__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Facebook__c ;
                    newMarketingDetail.Marketed_On_FB_Marketplace__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_FB_Marketplace__c;
                    newMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Fleet_Up_Marketplace__c;
                    newMarketingDetail.Marketed_On_GearFlow__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_GearFlow__c;
                    newMarketingDetail.Marketed_On_Instagram__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Instagram__c;
                    newMarketingDetail.Marketed_On_LinkedIn__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_LinkedIn__c;
                    newMarketingDetail.Marketed_On_Machinio__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Machinio__c;
                    newMarketingDetail.Marketed_On_Mascus__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Mascus__c;
                    newMarketingDetail.Marketed_on_MT_Crane_Truck__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_on_MT_Crane_Truck__c;
                    newMarketingDetail.Marketed_On_MyLittleSalesman__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_MyLittleSalesman__c;
                    newMarketingDetail.Marketed_On_Terrapoint__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Terrapoint__c ;
                    newMarketingDetail.Marketed_On_TradeMachines__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_TradeMachines__c;
                    newMarketingDetail.Marketed_On_Used_Equip_Guide__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Used_Equip_Guide__c;
                    newMarketingDetail.Marketed_On_Zonapesada__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Zonapesada__c;
                    newMarketingDetail.Do_not_market_anywhere__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Do_not_market_anywhere__c;
                    newMarketingDetail.Updated_From__c = 'Account';
                    newMarketingDetail.Unit__c = eachProduct2.id;
                    lstMarketingDetailToInsert.add(newMarketingDetail);
                }
            }
            if(lstMarketingDetailToInsert!=null && !lstMarketingDetailToInsert.isEmpty()){
                insert lstMarketingDetailToInsert;
            }
        }
    }
    
    public static void handleAfterUpdate(
        List<Product2> triggerNew,
        Map<Id, Product2> oldProduct2Map)
    {	
        
        list<Marketing_Detail__c> lstMarketingDetail;
        list<Marketing_Detail__c> lstMarketingDetailToInsert = new list<Marketing_Detail__c>();
        map<Id,Marketing_Detail__c>mapOfAccountIdVsMarketingDetail = new map<Id,Marketing_Detail__c>();
        map<Id,Marketing_Detail__c>mapOfUnitIdVsMarketingDetail = new map<Id,Marketing_Detail__c>();
        set<Id> setOfAccountId = new set<Id>();
        
        if(triggerNew!=null && !triggerNew.isEmpty()){
            for(Product2 eachProduct2 : triggerNew){
                if(eachProduct2.Account__c != oldProduct2Map.get(eachProduct2.id).Account__c 
                   && string.isNotBlank(eachProduct2.Account__c)
                  ){
                      setOfAccountId.add(eachProduct2.Account__c);
                  }
                
            }
        }
        system.debug('setOfAccountId:'+setOfAccountId);
        if(setOfAccountId!=null && !setOfAccountId.isEmpty()){
            lstMarketingDetail = [SELECT Id, Marketed_On_Construction_Equip_Guide__c, Marketed_On_Craigslist__c, 
                                  Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, 
                                  Marketed_On_Fleet_Up_Marketplace__c, Marketed_On_GearFlow__c, 
                                  Marketed_On_Instagram__c, Marketed_On_LinkedIn__c, Marketed_On_Machinio__c, 
                                  Marketed_On_Mascus__c, Marketed_on_MT_Crane_Truck__c, 
                                  Marketed_On_MyLittleSalesman__c, Marketed_On_Terrapoint__c, 
                                  Marketed_On_TradeMachines__c, Marketed_On_Used_Equip_Guide__c, 
                                  Marketed_On_Zonapesada__c, Do_not_market_anywhere__c, 
                                  Account__c, Opportunity__c, Updated_From__c,
                                  Unit__c, IsDeleted 
                                  FROM Marketing_Detail__c 
                                  WHERE Account__c IN : setOfAccountId 
                                  OR Unit__c IN : triggerNew];  
        }
        system.debug('lstMarketingDetail:'+lstMarketingDetail);
        if(lstMarketingDetail!=null && !lstMarketingDetail.isEmpty()){
            for(Marketing_Detail__c eachMarketingDetail : lstMarketingDetail){
                if(string.isNotBlank(eachMarketingDetail.Account__c)){
                    mapOfAccountIdVsMarketingDetail.put(eachMarketingDetail.Account__c,eachMarketingDetail);
                }else if(string.isNotBlank(eachMarketingDetail.Unit__c)){
                    mapOfUnitIdVsMarketingDetail.put(eachMarketingDetail.Unit__c,eachMarketingDetail);
                }
                
            }
        }
        
        
        if(triggerNew!=null && !triggerNew.isEmpty()){
            for(Product2 eachProduct2 : triggerNew){
                if(eachProduct2.Account__c != oldProduct2Map.get(eachProduct2.id).Account__c 
                   && string.isNotBlank(eachProduct2.Account__c)){
                       if( mapOfUnitIdVsMarketingDetail.get(eachProduct2.id)!= null){
                           if(mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Updated_From__c == 'Account' && 
                              mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c)!=null){
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Construction_Equip_Guide__c =mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Construction_Equip_Guide__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Craigslist__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Craigslist__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Facebook__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Facebook__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_FB_Marketplace__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_FB_Marketplace__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Fleet_Up_Marketplace__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Fleet_Up_Marketplace__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_GearFlow__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_GearFlow__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Instagram__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Instagram__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_LinkedIn__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_LinkedIn__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Machinio__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Machinio__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Mascus__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Mascus__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_on_MT_Crane_Truck__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_on_MT_Crane_Truck__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_MyLittleSalesman__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_MyLittleSalesman__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Terrapoint__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Terrapoint__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_TradeMachines__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_TradeMachines__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Used_Equip_Guide__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Used_Equip_Guide__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Marketed_On_Zonapesada__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Zonapesada__c;
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Do_not_market_anywhere__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Do_not_market_anywhere__c;   
                                  mapOfUnitIdVsMarketingDetail.get(eachProduct2.id).Account__c =  mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Account__c;
                              }
                       }else if(mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c)!=null){
                           Marketing_Detail__c newMarketingDetail = new Marketing_Detail__c();
                           newMarketingDetail.Marketed_On_Construction_Equip_Guide__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Construction_Equip_Guide__c;
                           newMarketingDetail.Marketed_On_Craigslist__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Craigslist__c ;
                           newMarketingDetail.Marketed_On_Facebook__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Facebook__c ;
                           newMarketingDetail.Marketed_On_FB_Marketplace__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_FB_Marketplace__c;
                           newMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Fleet_Up_Marketplace__c;
                           newMarketingDetail.Marketed_On_GearFlow__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_GearFlow__c;
                           newMarketingDetail.Marketed_On_Instagram__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Instagram__c;
                           newMarketingDetail.Marketed_On_LinkedIn__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_LinkedIn__c;
                           newMarketingDetail.Marketed_On_Machinio__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Machinio__c;
                           newMarketingDetail.Marketed_On_Mascus__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Mascus__c;
                           newMarketingDetail.Marketed_on_MT_Crane_Truck__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_on_MT_Crane_Truck__c;
                           newMarketingDetail.Marketed_On_MyLittleSalesman__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_MyLittleSalesman__c;
                           newMarketingDetail.Marketed_On_Terrapoint__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Terrapoint__c ;
                           newMarketingDetail.Marketed_On_TradeMachines__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_TradeMachines__c;
                           newMarketingDetail.Marketed_On_Used_Equip_Guide__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Used_Equip_Guide__c;
                           newMarketingDetail.Marketed_On_Zonapesada__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Marketed_On_Zonapesada__c;
                           newMarketingDetail.Do_not_market_anywhere__c = mapOfAccountIdVsMarketingDetail.get(eachProduct2.Account__c).Do_not_market_anywhere__c;
                           newMarketingDetail.Updated_From__c = 'Account';
                           newMarketingDetail.Unit__c = eachProduct2.id;
                           lstMarketingDetailToInsert.add(newMarketingDetail);  	    
                       }
                   }
            }
            if(lstMarketingDetailToInsert!=null && !lstMarketingDetailToInsert.isempty()){
                insert lstMarketingDetailToInsert;
            }
            if(mapOfUnitIdVsMarketingDetail.Values()!=null && !mapOfUnitIdVsMarketingDetail.Values().isEmpty()){
                update mapOfUnitIdVsMarketingDetail.Values();
            }
        }     
    }
    private static void monthlyGoalForUserAfterInsert(set<Id> setOfProduct2Id){
        string currentMonth = System.now().format( 'MMMM' );
        integer currentYear = Date.Today().Year();
        list<Monthly_Goal_For_User__c>lstMonthlyGoalForUser;
        map<id,list<Product2>> mapOfUserIdVsLstUnit = new map<id,list<Product2>>();
        map<id,list<Product2>> mapOfUserIdVsLstOfOwnedUnit = new map<id,list<Product2>>();
        map<id,list<Product2>> mapOfUserIdVsLstOfBrokeredUnit = new map<id,list<Product2>>();
        list<Product2> lstProduct2Inserted ;
        if(setOfProduct2Id!=null && !setOfProduct2Id.isEmpty()){
            lstProduct2Inserted = [SELECT Id, Account__c, Account__r.Name,
                                   Potential_Gross_Profit__c,Inventory_Status__c,Zadoon_s_Final_Purchase_Price__c,Unit_Owner__c
                                   FROM Product2 Where id IN : setOfProduct2Id ];
        }
        if(lstProduct2Inserted!=null && !lstProduct2Inserted.isEmpty()){
            for(Product2 eachProduct2 : lstProduct2Inserted ){
                if(string.isNotBlank(eachProduct2.Unit_Owner__c)){
                    if(!mapOfUserIdVsLstUnit.keySet().contains(eachProduct2.Unit_Owner__c)){
                        mapOfUserIdVsLstUnit.put(eachProduct2.Unit_Owner__c,new list<Product2>());
                        mapOfUserIdVsLstUnit.get(eachProduct2.Unit_Owner__c).add(eachProduct2);
                    }else{
                        mapOfUserIdVsLstUnit.get(eachProduct2.Unit_Owner__c).add(eachProduct2);
                    }
                    
                }
                if(string.isNotBlank(eachProduct2.Inventory_Status__c) &&
                   string.isNotBlank(eachProduct2.Account__c)){
                       if(eachProduct2.Inventory_Status__c == 'Owned' && 
                          eachProduct2.Account__r.Name =='Zadoon, LLC'){
                              if(!mapOfUserIdVsLstOfOwnedUnit.containsKey(eachProduct2.Unit_Owner__c)){
                                  mapOfUserIdVsLstOfOwnedUnit.put(eachProduct2.Unit_Owner__c,new list<Product2>());
                                  mapOfUserIdVsLstOfOwnedUnit.get(eachProduct2.Unit_Owner__c).add(eachProduct2);
                              }else{
                                  mapOfUserIdVsLstOfOwnedUnit.get(eachProduct2.Unit_Owner__c).add(eachProduct2);
                              }
                              
                          }else{
                              if(!mapOfUserIdVsLstOfBrokeredUnit.containsKey(eachProduct2.Unit_Owner__c)){
                                  mapOfUserIdVsLstOfBrokeredUnit.put(eachProduct2.Unit_Owner__c,new list<Product2>());
                                  mapOfUserIdVsLstOfBrokeredUnit.get(eachProduct2.Unit_Owner__c).add(eachProduct2);
                              }else{
                                  mapOfUserIdVsLstOfBrokeredUnit.get(eachProduct2.Unit_Owner__c).add(eachProduct2);
                              }
                          }
                   }
            }
        }
        if(mapOfUserIdVsLstUnit.keySet()!=null && !mapOfUserIdVsLstUnit.keySet().isEmpty()){
            lstMonthlyGoalForUser = [SELECT Id, User__c, Units_Purchased__c, Units_Owned_turn_rate__c, Units_Brokered__c, Units_Added__c, 
                                     Total_Units_Purchared_or_Brokered__c, Total_Actual_Gross_Profit_Procured__c, 
                                     Realized_Gross_Profit_Owned_Units__c,Realized_Gross_Profit_Brokered_Units__c, 
                                     Potential_Gross_Profit_Owned_Units__c ,Year__c,Month__c
                                     FROM Monthly_Goal_For_User__c 
                                     WHERE Month__c =: currentMonth AND Year__c =: currentYear
                                     AND User__c IN : mapOfUserIdVsLstUnit.keySet()  ];
        }
        if(lstMonthlyGoalForUser!=null && !lstMonthlyGoalForUser.isEmpty()){
            for(Monthly_Goal_For_User__c eachMonthlyGoalForUser : lstMonthlyGoalForUser){
                
                if(mapOfUserIdVsLstUnit.containsKey(eachMonthlyGoalForUser.User__c)&&
                   mapOfUserIdVsLstUnit.get(eachMonthlyGoalForUser.User__c)!=null &&
                   !mapOfUserIdVsLstUnit.get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                       eachMonthlyGoalForUser.Units_Added__c  += mapOfUserIdVsLstUnit.get(eachMonthlyGoalForUser.User__c).size();
                   }
                if(mapOfUserIdVsLstOfBrokeredUnit.containsKey(eachMonthlyGoalForUser.User__c)&&
                   mapOfUserIdVsLstOfBrokeredUnit.get(eachMonthlyGoalForUser.User__c)!=null &&
                   !mapOfUserIdVsLstOfBrokeredUnit.get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                       eachMonthlyGoalForUser.Units_Brokered__c  += mapOfUserIdVsLstOfBrokeredUnit.get(eachMonthlyGoalForUser.User__c).size();
                   }
                if(mapOfUserIdVsLstOfOwnedUnit.containsKey(eachMonthlyGoalForUser.User__c)&&
                   mapOfUserIdVsLstOfOwnedUnit.get(eachMonthlyGoalForUser.User__c)!=null &&
                   !mapOfUserIdVsLstOfOwnedUnit.get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                       eachMonthlyGoalForUser.Units_Purchased__c  += mapOfUserIdVsLstOfOwnedUnit.get(eachMonthlyGoalForUser.User__c).size();
                       decimal totalPotentialGrossProfit = 0 ;
                       for(Product2 eachProduct2 : mapOfUserIdVsLstOfOwnedUnit.get(eachMonthlyGoalForUser.User__c)){
                           if(eachProduct2.Potential_Gross_Profit__c !=null){
                               totalPotentialGrossProfit += eachProduct2.Potential_Gross_Profit__c;
                           }
                       }
                       eachMonthlyGoalForUser.Potential_Gross_Profit_Owned_Units__c += totalPotentialGrossProfit;
                   }
                
                
            }
        }
        if(lstMonthlyGoalForUser!=null && !lstMonthlyGoalForUser.isEmpty()){
            update lstMonthlyGoalForUser;
        }
    }
    //For Reporting
    /*public static void handleAfterInsert1(
List<Product2> triggerNew
){
if(triggerNew!=null && !triggerNew.isEmpty()){
for(){

}
}   
}*/
    
    // Method to handle After Update for Monthly Update
    public static void handleUnitAfterUpdate(List<Product2> triggerNew,Map<Id, Product2> oldProduct2Map,Map<Id, Product2> newProduct2Map){
        
        System.debug('After Update is called Successfully..................... ');
        set<String>setMonthName = new set<String>();
        set<integer>setYearNum = new set<Integer>();
        set<Id> setOfProduct2Id = new set<Id>();
        set<Id> setOfUserId = new set<Id>();
        string currentMonth = System.now().format( 'MMMM' );
        integer currentYear = Date.Today().Year();
        list<Monthly_Goal_For_User__c>lstMonthlyGoalForUser;
        map<id,Monthly_Goal_For_User__c> mapIdMonthlyGoalForUserToUpdate = new map<id,Monthly_Goal_For_User__c> ();
        //map<id,list<Product2>> mapOfUserIdVsLstUnit = new map<id,list<Product2>>();
        //map<id,list<Product2>> mapOfUserIdVsLstOfOwnedUnit = new map<id,list<Product2>>();
        //map<id,list<Product2>> mapOfUserIdVsLstOfBrokeredUnit = new map<id,list<Product2>>();
        
        //Year based MAP DATA Map<Integer,
        Map<Integer,Map<String,list<Monthly_Goal_For_User__c>>> mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate = new Map<Integer,Map<String,list<Monthly_Goal_For_User__c>>>();
        
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsAdded = new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsRemoved = new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsOwnedAdded= new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsOwnedRemoved= new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsBrockeredAdded= new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsBrockeredRemoved= new Map<Integer,Map<String,map<id,list<Product2>>>>();
        //
        list<Product2> lstProduct2Updated = new list<Product2>();
        
        //Add ids to sets
        if(triggerNew!=null && !triggerNew.isEmpty()){
            for(Product2 eachProduct2 : triggerNew){
                setOfProduct2Id.add(eachProduct2.id);
                setOfUserId.add(eachProduct2.Unit_Owner__c);
                setOfUserId.add(oldProduct2Map.get(eachProduct2.Id).Unit_Owner__c);
                setMonthName.add((eachProduct2.CreatedDate).format( 'MMMM' ));
                setYearNum.add((eachProduct2.CreatedDate).Year());
            }
        }
        if(setOfProduct2Id!=null && !setOfProduct2Id.isEmpty()){
            lstProduct2Updated = [SELECT Id, Account__c, Account__r.Name,CreatedDate,
                                  Potential_Gross_Profit__c,Inventory_Status__c,Zadoon_s_Final_Purchase_Price__c,Unit_Owner__c,
                                  (SELECT Id,Name FROM Opportunities__r)
                                  FROM Product2 Where id IN : setOfProduct2Id ];
        }
        System.debug('lstProduct2Updated : : :'+lstProduct2Updated);
        if(setOfUserId!=null && !setOfUserId.isEmpty()){
            lstMonthlyGoalForUser = [SELECT Id, User__c, Units_Purchased__c, Units_Owned_turn_rate__c, Units_Brokered__c, Units_Added__c, 
                                     Total_Units_Purchared_or_Brokered__c, Total_Actual_Gross_Profit_Procured__c, 
                                     Realized_Gross_Profit_Owned_Units__c,Realized_Gross_Profit_Brokered_Units__c, 
                                     Potential_Gross_Profit_Owned_Units__c ,Year__c,Month__c
                                     FROM Monthly_Goal_For_User__c 
                                     WHERE Month__c IN: setMonthName AND Year__c IN: setYearNum
                                     AND User__c IN : setOfUserId  ];
            System.debug('lstMonthlyGoalForUser : ::'+lstMonthlyGoalForUser);
        }
        
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                Map<String,list<Monthly_Goal_For_User__c>> mapMonthUserIdLstGoalForUserToUpdate = new Map<String,list<Monthly_Goal_For_User__c>>();
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        if(lstMonthlyGoalForUser!=null && !lstMonthlyGoalForUser.isEmpty()){
                            for(Monthly_Goal_For_User__c eachMonthlyGoalForUser : lstMonthlyGoalForUser ){
                                if(eachMonthlyGoalForUser.Month__c == Month){
                                    if(!mapMonthUserIdLstGoalForUserToUpdate.containsKey(eachMonthlyGoalForUser.Month__c)){
                                        mapMonthUserIdLstGoalForUserToUpdate.put(eachMonthlyGoalForUser.Month__c,new list<Monthly_Goal_For_User__c>());
                                    }
                                    mapMonthUserIdLstGoalForUserToUpdate.get(eachMonthlyGoalForUser.Month__c).add(eachMonthlyGoalForUser);
                                }
                            }
                        }
                    }
                }
                mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.put(Year,mapMonthUserIdLstGoalForUserToUpdate);
            }
        }
        //Fill Data
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsAdded = new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsRemoved = new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsOwnedAdded= new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsOwnedRemoved= new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsBrockeredAdded= new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsBrockeredRemoved= new Map<String,map<id,list<Product2>>>();
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        
                        Map<id,list<Product2>> mapUserIdLstUnitsAdded = new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsRemoved = new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsOwnedAdded= new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsOwnedRemoved= new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsBrockeredAdded= new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsBrockeredRemoved= new Map<id,list<Product2>>();
                        
                        if(lstProduct2Updated!=null && !lstProduct2Updated.isEmpty()){
                            for(Product2 eachProduct2 : lstProduct2Updated ){
                                if(Month ==eachProduct2.CreatedDate.format( 'MMMM' )){
                                    if(string.isNotBlank(eachProduct2.Unit_Owner__c)){
                                        //if Unit Owner is Changed
                                        if(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c != newProduct2Map.get(eachproduct2.Id).Unit_Owner__c){
                                            if(!mapUserIdLstUnitsAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                mapUserIdLstUnitsAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                
                                            }
                                            if(!mapUserIdLstUnitsRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                mapUserIdLstUnitsRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                
                                            }
                                            mapUserIdLstUnitsRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                            mapUserIdLstUnitsAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                            
                                            if(string.isNotBlank(eachProduct2.Inventory_Status__c)){
                                                //if Invetory Status is Changed
                                                if(oldProduct2Map.get(eachproduct2.Id).Inventory_Status__c != newProduct2Map.get(eachproduct2.Id).Inventory_Status__c){
                                                    if(newProduct2Map.get(eachproduct2.Id).Inventory_Status__c == 'Owned' && eachProduct2.Account__r.Name =='Zadoon, LLC'  && string.isNotBlank(eachProduct2.Account__c)){
                                                        //If Status is changed to Owned
                                                        if(!mapUserIdLstUnitsOwnedAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                            mapUserIdLstUnitsOwnedAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                        }
                                                        if(!mapUserIdLstUnitsBrockeredRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                            mapUserIdLstUnitsBrockeredRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                        }
                                                        mapUserIdLstUnitsBrockeredRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                        mapUserIdLstUnitsOwnedAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                        
                                                    }else if(newProduct2Map.get(eachproduct2.Id).Inventory_Status__c != 'Owned'){
                                                        //If Status is changed owned to not Owned
                                                        if(!mapUserIdLstUnitsBrockeredAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                            mapUserIdLstUnitsBrockeredAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                        }
                                                        if(!mapUserIdLstUnitsOwnedRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                            mapUserIdLstUnitsOwnedRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                        }
                                                        mapUserIdLstUnitsOwnedRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                        mapUserIdLstUnitsBrockeredAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                    }
                                                    ////////////////////////////////////////////
                                                }else if(oldProduct2Map.get(eachproduct2.Id).Inventory_Status__c == newProduct2Map.get(eachproduct2.Id).Inventory_Status__c && newProduct2Map.get(eachproduct2.Id).Inventory_Status__c == 'Owned'){
                                                    
                                                    if(!mapUserIdLstUnitsOwnedAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                        mapUserIdLstUnitsOwnedAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                        
                                                    }
                                                    if(!mapUserIdLstUnitsOwnedRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                        mapUserIdLstUnitsOwnedRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                        
                                                    }
                                                    mapUserIdLstUnitsOwnedRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                    mapUserIdLstUnitsOwnedAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                    
                                                }else{
                                                    if(!mapUserIdLstUnitsBrockeredAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                        mapUserIdLstUnitsBrockeredAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                        
                                                    }
                                                    if(!mapUserIdLstUnitsBrockeredRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                        mapUserIdLstUnitsBrockeredRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                        
                                                    }
                                                    mapUserIdLstUnitsBrockeredRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                    mapUserIdLstUnitsBrockeredAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                }
                                            }	
                                        }
                                        if(oldProduct2Map.get(eachproduct2.Id).Inventory_Status__c != newProduct2Map.get(eachproduct2.Id).Inventory_Status__c){
                                            if(newProduct2Map.get(eachproduct2.Id).Inventory_Status__c == 'Owned' && eachProduct2.Account__r.Name =='Zadoon, LLC'){
                                                //If Status is changed to Owned
                                                if(!mapUserIdLstUnitsOwnedAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                    mapUserIdLstUnitsOwnedAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                }
                                                if(!mapUserIdLstUnitsBrockeredRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                    mapUserIdLstUnitsBrockeredRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                }
                                                mapUserIdLstUnitsBrockeredRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                mapUserIdLstUnitsOwnedAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                
                                            }else if(newProduct2Map.get(eachproduct2.Id).Inventory_Status__c != 'Owned' ){ //&& eachProduct2.Account__r.Name =='Zadoon, LLC'
                                                //If Status is changed owned to not Owned
                                                if(!mapUserIdLstUnitsBrockeredAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                    mapUserIdLstUnitsBrockeredAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                }
                                                if(!mapUserIdLstUnitsOwnedRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                    mapUserIdLstUnitsOwnedRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                }
                                                mapUserIdLstUnitsOwnedRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                mapUserIdLstUnitsBrockeredAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                            }
                                        }
                                    }
                                    //fill Monthly Data into MAPS
                                    //string Product2Month = eachProduct2.CreatedDate.format( 'MMMM' );
                                    //integer product2Year = eachProduct2.CreatedDate.Year();
                                    mapMonthUserIdLstUnitsAdded.put(Month,mapUserIdLstUnitsAdded);
                                    mapMonthUserIdLstUnitsRemoved.put(Month,mapUserIdLstUnitsRemoved);
                                    mapMonthUserIdLstUnitsOwnedAdded.put(Month,mapUserIdLstUnitsOwnedAdded);
                                    mapMonthUserIdLstUnitsOwnedRemoved.put(Month,mapUserIdLstUnitsOwnedRemoved);
                                    mapMonthUserIdLstUnitsBrockeredAdded.put(Month,mapUserIdLstUnitsBrockeredAdded);
                                    mapMonthUserIdLstUnitsBrockeredRemoved.put(Month,mapUserIdLstUnitsBrockeredRemoved);
                                }
                            }
                        }
                        //YearMonths
                        ////fill Monthly Data into MAPS
                        //string Product2Month = eachProduct2.CreatedDate.format( 'MMMM' );
                        //integer product2Year = eachProduct2.CreatedDate.Year();
                        mapYearMonthsUserIdLstUnitsAdded.put(Year,mapMonthUserIdLstUnitsAdded);
                        mapYearMonthsUserIdLstUnitsRemoved.put(Year,mapMonthUserIdLstUnitsRemoved);
                        mapYearMonthsUserIdLstUnitsOwnedAdded.put(Year,mapMonthUserIdLstUnitsOwnedAdded);
                        mapYearMonthsUserIdLstUnitsOwnedRemoved.put(Year,mapMonthUserIdLstUnitsOwnedRemoved);
                        mapYearMonthsUserIdLstUnitsBrockeredAdded.put(Year,mapMonthUserIdLstUnitsBrockeredAdded);
                        mapYearMonthsUserIdLstUnitsBrockeredRemoved.put(Year,mapMonthUserIdLstUnitsBrockeredRemoved);
                    }
                }
            }
        }
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        if(mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month)!=null && !mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month).isEmpty()){
                            for(Monthly_Goal_For_User__c eachMonthlyGoalForUser : mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month)){
                                
                                if(mapYearMonthsUserIdLstUnitsAdded.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Added__c  += mapYearMonthsUserIdLstUnitsAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                   }
                                if(mapYearMonthsUserIdLstUnitsRemoved.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Added__c  -= mapYearMonthsUserIdLstUnitsRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                   }
                                if(mapYearMonthsUserIdLstUnitsBrockeredAdded.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsBrockeredAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsBrockeredAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Brokered__c  += mapYearMonthsUserIdLstUnitsBrockeredAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                   }
                                if(mapYearMonthsUserIdLstUnitsBrockeredRemoved.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsBrockeredRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsBrockeredRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Brokered__c  -= mapYearMonthsUserIdLstUnitsBrockeredRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                   }
                                if(mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Purchased__c  += mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                       decimal totalPotentialGrossProfit = 0 ;
                                       for(Product2 eachProduct2 : mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)){
                                           if(eachProduct2.Potential_Gross_Profit__c !=null){
                                               totalPotentialGrossProfit += eachProduct2.Potential_Gross_Profit__c;
                                           }
                                       }
                                       eachMonthlyGoalForUser.Potential_Gross_Profit_Owned_Units__c += totalPotentialGrossProfit;
                                   }
                                if(mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Purchased__c  -= mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                       decimal totalPotentialGrossProfit = 0 ;
                                       for(Product2 eachProduct2 : mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)){
                                           if(eachProduct2.Potential_Gross_Profit__c !=null){
                                               totalPotentialGrossProfit -= eachProduct2.Potential_Gross_Profit__c;
                                           }
                                       }
                                       eachMonthlyGoalForUser.Potential_Gross_Profit_Owned_Units__c += totalPotentialGrossProfit;
                                   }
                                //Put eachMonthlyGoalForUser to map to update
                                mapIdMonthlyGoalForUserToUpdate.put(eachMonthlyGoalForUser.id,eachMonthlyGoalForUser);
                                
                            }
                        }
                    }
                }
            }
        }
        //update MonthlyGoalForUser
        if(mapIdMonthlyGoalForUserToUpdate.values()!=null && !mapIdMonthlyGoalForUserToUpdate.values().isEmpty()){
            update mapIdMonthlyGoalForUserToUpdate.values();
            System.debug('After Update Valuse : : :'+mapIdMonthlyGoalForUserToUpdate.values());
        }
    }
    
    //This method is used to handle before Delete
    public static void handleBeforeDelete(list<Product2>TriggerOld , map<id,Product2>oldProduct2Map){
        set<String>setMonthName = new set<String>();
        set<integer>setYearNum = new set<Integer>();
        set<Id> setOfProduct2Id = new set<Id>();
        set<Id> setOfUserId = new set<Id>();
        list<Product2>lstProduct2Deleted = new list<Product2>();
        list<Monthly_Goal_For_User__c>lstMonthlyGoalForUser;
        map<id,Monthly_Goal_For_User__c> mapIdMonthlyGoalForUserToUpdate = new map<id,Monthly_Goal_For_User__c> ();
        Map<Integer,Map<String,list<Monthly_Goal_For_User__c>>> mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate = new Map<Integer,Map<String,list<Monthly_Goal_For_User__c>>>();
        
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsRemoved = new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsOwnedRemoved= new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsBrockeredRemoved= new Map<Integer,Map<String,map<id,list<Product2>>>>();
        
        
        if(TriggerOld!=null && !TriggerOld.isEmpty()){
            for(Product2 eachProduct2 : TriggerOld){
                setOfProduct2Id.add(eachProduct2.id);
                setOfUserId.add(eachProduct2.Unit_Owner__c);
                setMonthName.add((eachProduct2.CreatedDate).format( 'MMMM' ));
                setYearNum.add((eachProduct2.CreatedDate).Year());
            }
        }
        
        if(lstProduct2Deleted!=null && !lstProduct2Deleted.isEmpty()){
            lstProduct2Deleted = [SELECT Id, Account__c, Account__r.Name,CreatedDate,
                                  Potential_Gross_Profit__c,Inventory_Status__c,Zadoon_s_Final_Purchase_Price__c,Unit_Owner__c,
                                  (SELECT Id,Name FROM Opportunities__r)
                                  FROM Product2 Where id IN : setOfProduct2Id ];
        }
        if(setOfUserId!=null && !setOfUserId.isEmpty()){
            lstMonthlyGoalForUser = [SELECT Id, User__c, Units_Purchased__c, Units_Owned_turn_rate__c, Units_Brokered__c, Units_Added__c, 
                                     Total_Units_Purchared_or_Brokered__c, Total_Actual_Gross_Profit_Procured__c, 
                                     Realized_Gross_Profit_Owned_Units__c,Realized_Gross_Profit_Brokered_Units__c, 
                                     Potential_Gross_Profit_Owned_Units__c ,Year__c,Month__c
                                     FROM Monthly_Goal_For_User__c 
                                     WHERE Month__c IN: setMonthName AND Year__c IN: setYearNum
                                     AND User__c IN : setOfUserId  ];
            System.debug('lstMonthlyGoalForUser : ::'+lstMonthlyGoalForUser);
        }
        
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                Map<String,list<Monthly_Goal_For_User__c>> mapMonthUserIdLstGoalForUserToUpdate = new Map<String,list<Monthly_Goal_For_User__c>>();
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        if(lstMonthlyGoalForUser!=null && !lstMonthlyGoalForUser.isEmpty()){
                            for(Monthly_Goal_For_User__c eachMonthlyGoalForUser : lstMonthlyGoalForUser ){
                                if(eachMonthlyGoalForUser.Month__c == Month){
                                    if(!mapMonthUserIdLstGoalForUserToUpdate.containsKey(eachMonthlyGoalForUser.Month__c)){
                                        mapMonthUserIdLstGoalForUserToUpdate.put(eachMonthlyGoalForUser.Month__c,new list<Monthly_Goal_For_User__c>());
                                    }
                                    mapMonthUserIdLstGoalForUserToUpdate.get(eachMonthlyGoalForUser.Month__c).add(eachMonthlyGoalForUser);
                                }
                            }
                        }
                    }
                }
                mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.put(Year,mapMonthUserIdLstGoalForUserToUpdate);
            }
        }
        //
        //
        //
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsRemoved = new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsOwnedRemoved= new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsBrockeredRemoved= new Map<String,map<id,list<Product2>>>();
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        
                        Map<id,list<Product2>> mapUserIdLstUnitsRemoved = new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsOwnedRemoved= new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsBrockeredRemoved= new Map<id,list<Product2>>();
                        
                        if(lstProduct2Deleted!=null && !lstProduct2Deleted.isEmpty()){
                            for(Product2 eachProduct2 : lstProduct2Deleted ){
                                if(Month ==eachProduct2.CreatedDate.format( 'MMMM' )){
                                    if(string.isNotBlank(eachProduct2.Unit_Owner__c)){
                                        //if Unit Owner is Changed
                                        if(!mapUserIdLstUnitsRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                            mapUserIdLstUnitsRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                            
                                        }
                                        mapUserIdLstUnitsRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                        
                                        if(string.isNotBlank(eachProduct2.Inventory_Status__c) && string.isNotBlank(eachProduct2.Account__c)){
                                            //if Invetory Status is Changed
                                            if(oldProduct2Map.get(eachproduct2.Id).Inventory_Status__c == 'Owned' && eachProduct2.Account__r.Name =='Zadoon, LLC'){
                                                //If Status is changed to Owned
                                                if(!mapUserIdLstUnitsBrockeredRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                    mapUserIdLstUnitsBrockeredRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                }
                                                mapUserIdLstUnitsBrockeredRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                
                                                
                                            }else{
                                                if(!mapUserIdLstUnitsBrockeredRemoved.containsKey(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                    mapUserIdLstUnitsBrockeredRemoved.put(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                    
                                                }
                                                mapUserIdLstUnitsBrockeredRemoved.get(oldProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                            }
                                        }	
                                    }
                                }
                                //fill Monthly Data into MAPS
                                //string Product2Month = eachProduct2.CreatedDate.format( 'MMMM' );
                                //integer product2Year = eachProduct2.CreatedDate.Year();
                                mapMonthUserIdLstUnitsRemoved.put(Month,mapUserIdLstUnitsRemoved);
                                mapMonthUserIdLstUnitsOwnedRemoved.put(Month,mapUserIdLstUnitsOwnedRemoved);
                                mapMonthUserIdLstUnitsBrockeredRemoved.put(Month,mapUserIdLstUnitsBrockeredRemoved);
                            }
                        }
                    
                    //YearMonths
                    ////fill Monthly Data into MAPS
                    //string Product2Month = eachProduct2.CreatedDate.format( 'MMMM' );
                    //integer product2Year = eachProduct2.CreatedDate.Year();
                    mapYearMonthsUserIdLstUnitsRemoved.put(Year,mapMonthUserIdLstUnitsRemoved);
                    mapYearMonthsUserIdLstUnitsOwnedRemoved.put(Year,mapMonthUserIdLstUnitsOwnedRemoved);
                    mapYearMonthsUserIdLstUnitsBrockeredRemoved.put(Year,mapMonthUserIdLstUnitsBrockeredRemoved);
                    }
                }
            }
        }
        /////////
        //
        //
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        if(mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month)!=null && !mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month).isEmpty()){
                            for(Monthly_Goal_For_User__c eachMonthlyGoalForUser : mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month)){
                                
                                if(mapYearMonthsUserIdLstUnitsRemoved.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Added__c  -= mapYearMonthsUserIdLstUnitsRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                   }
                                
                                if(mapYearMonthsUserIdLstUnitsBrockeredRemoved.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsBrockeredRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsBrockeredRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Brokered__c  -= mapYearMonthsUserIdLstUnitsBrockeredRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                   }
                                
                                if(mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Purchased__c  -= mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                       decimal totalPotentialGrossProfit = 0 ;
                                       for(Product2 eachProduct2 : mapYearMonthsUserIdLstUnitsOwnedRemoved.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)){
                                           if(eachProduct2.Potential_Gross_Profit__c !=null){
                                               totalPotentialGrossProfit -= eachProduct2.Potential_Gross_Profit__c;
                                           }
                                       }
                                       eachMonthlyGoalForUser.Potential_Gross_Profit_Owned_Units__c += totalPotentialGrossProfit;
                                   }
                                //Put eachMonthlyGoalForUser to map to update
                                mapIdMonthlyGoalForUserToUpdate.put(eachMonthlyGoalForUser.id,eachMonthlyGoalForUser);
                                
                            }
                        }
                    }
                }
            }
        }
        //update MonthlyGoalForUser
        if(mapIdMonthlyGoalForUserToUpdate.values()!=null && !mapIdMonthlyGoalForUserToUpdate.values().isEmpty()){
            update mapIdMonthlyGoalForUserToUpdate.values();
        }
    }
    
    
    /*
* 
To handle After Undelete
* 
*/
    public static void handleAfterUndelete(List<Product2> triggerNew,Map<Id, Product2> newProduct2Map){
        set<String>setMonthName = new set<String>();
        set<integer>setYearNum = new set<Integer>();
        set<Id> setOfProduct2Id = new set<Id>();
        set<Id> setOfUserId = new set<Id>();
        string currentMonth = System.now().format( 'MMMM' );
        integer currentYear = Date.Today().Year();
        list<Monthly_Goal_For_User__c>lstMonthlyGoalForUser;
        map<id,Monthly_Goal_For_User__c> mapIdMonthlyGoalForUserToUpdate = new map<id,Monthly_Goal_For_User__c> ();
        //map<id,list<Product2>> mapOfUserIdVsLstUnit = new map<id,list<Product2>>();
        //map<id,list<Product2>> mapOfUserIdVsLstOfOwnedUnit = new map<id,list<Product2>>();
        //map<id,list<Product2>> mapOfUserIdVsLstOfBrokeredUnit = new map<id,list<Product2>>();
        
        //Year based MAP DATA Map<Integer,
        Map<Integer,Map<String,list<Monthly_Goal_For_User__c>>> mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate = new Map<Integer,Map<String,list<Monthly_Goal_For_User__c>>>();
        
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsAdded = new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsOwnedAdded= new Map<Integer,Map<String,map<id,list<Product2>>>>();
        Map<Integer,Map<String,map<id,list<Product2>>>> mapYearMonthsUserIdLstUnitsBrockeredAdded= new Map<Integer,Map<String,map<id,list<Product2>>>>();
        //
        list<Product2> lstProduct2Updated = new list<Product2>();
        
        //Add ids to sets
        if(triggerNew!=null && !triggerNew.isEmpty()){
            for(Product2 eachProduct2 : triggerNew){
                setOfProduct2Id.add(eachProduct2.id);
                setOfUserId.add(eachProduct2.Unit_Owner__c);
                setMonthName.add((eachProduct2.CreatedDate).format( 'MMMM' ));
                setYearNum.add((eachProduct2.CreatedDate).Year());
            }
        }
        if(setOfProduct2Id!=null && !setOfProduct2Id.isEmpty()){
            lstProduct2Updated = [SELECT Id, Account__c, Account__r.Name,CreatedDate,
                                  Potential_Gross_Profit__c,Inventory_Status__c,Zadoon_s_Final_Purchase_Price__c,Unit_Owner__c,
                                  (SELECT Id,Name FROM Opportunities__r)
                                  FROM Product2 Where id IN : setOfProduct2Id ];
        }
        if(setOfUserId!=null && !setOfUserId.isEmpty()){
            lstMonthlyGoalForUser = [SELECT Id, User__c, Units_Purchased__c, Units_Owned_turn_rate__c, Units_Brokered__c, Units_Added__c, 
                                     Total_Units_Purchared_or_Brokered__c, Total_Actual_Gross_Profit_Procured__c, 
                                     Realized_Gross_Profit_Owned_Units__c,Realized_Gross_Profit_Brokered_Units__c, 
                                     Potential_Gross_Profit_Owned_Units__c ,Year__c,Month__c
                                     FROM Monthly_Goal_For_User__c 
                                     WHERE Month__c IN: setMonthName AND Year__c IN: setYearNum
                                     AND User__c IN : setOfUserId  ];
            System.debug('lstMonthlyGoalForUser : ::'+lstMonthlyGoalForUser);
        }
        
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                Map<String,list<Monthly_Goal_For_User__c>> mapMonthUserIdLstGoalForUserToUpdate = new Map<String,list<Monthly_Goal_For_User__c>>();
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        if(lstMonthlyGoalForUser!=null && !lstMonthlyGoalForUser.isEmpty()){
                            for(Monthly_Goal_For_User__c eachMonthlyGoalForUser : lstMonthlyGoalForUser ){
                                if(eachMonthlyGoalForUser.Month__c == Month){
                                    if(!mapMonthUserIdLstGoalForUserToUpdate.containsKey(eachMonthlyGoalForUser.Month__c)){
                                        mapMonthUserIdLstGoalForUserToUpdate.put(eachMonthlyGoalForUser.Month__c,new list<Monthly_Goal_For_User__c>());
                                    }
                                    mapMonthUserIdLstGoalForUserToUpdate.get(eachMonthlyGoalForUser.Month__c).add(eachMonthlyGoalForUser);
                                }
                            }
                        }
                    }
                }
                mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.put(Year,mapMonthUserIdLstGoalForUserToUpdate);
            }
        }
        ///
        //
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsAdded = new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsOwnedAdded= new Map<String,map<id,list<Product2>>>();
                Map<String,map<id,list<Product2>>> mapMonthUserIdLstUnitsBrockeredAdded= new Map<String,map<id,list<Product2>>>();
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        
                        Map<id,list<Product2>> mapUserIdLstUnitsAdded = new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsOwnedAdded= new Map<id,list<Product2>>();
                        Map<id,list<Product2>> mapUserIdLstUnitsBrockeredAdded= new Map<id,list<Product2>>();
                        
                        if(lstProduct2Updated!=null && !lstProduct2Updated.isEmpty()){
                            for(Product2 eachProduct2 : lstProduct2Updated ){
                                if(Month ==eachProduct2.CreatedDate.format( 'MMMM' )){
                                    if(string.isNotBlank(eachProduct2.Unit_Owner__c)){
                                        //if Unit Owner is Changed
                                        if(!mapUserIdLstUnitsAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                            mapUserIdLstUnitsAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                            
                                        }
                                        mapUserIdLstUnitsAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                        
                                        if(string.isNotBlank(eachProduct2.Inventory_Status__c) && string.isNotBlank(eachProduct2.Account__c)){
                                            //if Invetory Status is Changed
                                            if(newProduct2Map.get(eachproduct2.Id).Inventory_Status__c == 'Owned' && eachProduct2.Account__r.Name =='Zadoon, LLC'){
                                                //If Status is changed to Owned
                                                if(!mapUserIdLstUnitsOwnedAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                    mapUserIdLstUnitsOwnedAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                }
                                                mapUserIdLstUnitsOwnedAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                                
                                            }else{
                                                if(!mapUserIdLstUnitsBrockeredAdded.containsKey(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c)){
                                                    mapUserIdLstUnitsBrockeredAdded.put(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c,new list<Product2>());
                                                    
                                                }
                                                mapUserIdLstUnitsBrockeredAdded.get(newProduct2Map.get(eachproduct2.Id).Unit_Owner__c).add(eachProduct2);
                                            }
                                        }	
                                    }
                                    
                                }
                                //fill Monthly Data into MAPS
                                //string Product2Month = eachProduct2.CreatedDate.format( 'MMMM' );
                                //integer product2Year = eachProduct2.CreatedDate.Year();
                                mapMonthUserIdLstUnitsAdded.put(Month,mapUserIdLstUnitsAdded);
                                mapMonthUserIdLstUnitsOwnedAdded.put(Month,mapUserIdLstUnitsOwnedAdded);
                                mapMonthUserIdLstUnitsBrockeredAdded.put(Month,mapUserIdLstUnitsBrockeredAdded);
                                
                            }
                        }
                        //YearMonths
                        ////fill Monthly Data into MAPS
                        //string Product2Month = eachProduct2.CreatedDate.format( 'MMMM' );
                        //integer product2Year = eachProduct2.CreatedDate.Year();
                        mapYearMonthsUserIdLstUnitsAdded.put(Year,mapMonthUserIdLstUnitsAdded);
                        mapYearMonthsUserIdLstUnitsOwnedAdded.put(Year,mapMonthUserIdLstUnitsOwnedAdded);
                        mapYearMonthsUserIdLstUnitsBrockeredAdded.put(Year,mapMonthUserIdLstUnitsBrockeredAdded);
                    }
                }
            }
        }
        //
        //update the Data
        if(setYearNum!=null && !setYearNum.isEmpty()){
            for(integer Year : setYearNum){
                if(setMonthName!=null && !setMonthName.isEmpty()){
                    for(String Month : setMonthName){
                        if(mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month)!=null && !mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month).isEmpty()){
                            for(Monthly_Goal_For_User__c eachMonthlyGoalForUser : mapYearMonthsmapUserIdMonthlyGoalForUserToUpdate.get(Year).get(Month)){
                                
                                if(mapYearMonthsUserIdLstUnitsAdded.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Added__c  += mapYearMonthsUserIdLstUnitsAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                   }
                                
                                if(mapYearMonthsUserIdLstUnitsBrockeredAdded.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsBrockeredAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsBrockeredAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Brokered__c  += mapYearMonthsUserIdLstUnitsBrockeredAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                   }
                                
                                if(mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).containsKey(eachMonthlyGoalForUser.User__c)&&
                                   mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)!=null &&
                                   !mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).isEmpty() ){
                                       eachMonthlyGoalForUser.Units_Purchased__c  += mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c).size();
                                       decimal totalPotentialGrossProfit = 0 ;
                                       for(Product2 eachProduct2 : mapYearMonthsUserIdLstUnitsOwnedAdded.get(Year).get(Month).get(eachMonthlyGoalForUser.User__c)){
                                           if(eachProduct2.Potential_Gross_Profit__c !=null){
                                               totalPotentialGrossProfit += eachProduct2.Potential_Gross_Profit__c;
                                           }
                                       }
                                       eachMonthlyGoalForUser.Potential_Gross_Profit_Owned_Units__c += totalPotentialGrossProfit;
                                   }
                                
                                //Put eachMonthlyGoalForUser to map to update
                                mapIdMonthlyGoalForUserToUpdate.put(eachMonthlyGoalForUser.id,eachMonthlyGoalForUser);
                                
                            }
                        }
                    }
                }
            }
        }
        //
        //update MonthlyGoalForUser
        if(mapIdMonthlyGoalForUserToUpdate.values()!=null && !mapIdMonthlyGoalForUserToUpdate.values().isEmpty()){
            update mapIdMonthlyGoalForUserToUpdate.values();
        }
    }
}






/* lstProduct2  = [SELECT Id,Account__c,Account__r.Do_not_market_Craigslist__c,
Account__r.Do_not_market_Construction_Equip_Guide__c,
Account__r.Do_not_market_Facebook__c,Account__r.Do_not_market_FB_Marketplace__c,
Account__r.Do_Not_Market_Fleet_Up_Marketplace__c, Account__r.Do_not_market_GearFlow__c,
Account__r.Do_not_market_Instagram__c,Account__r.Do_not_market_LinkedIn__c,
Account__r.Do_not_market_Machinio__c,Account__r.Do_not_market_Mascus__c,
Account__r.Do_not_market_MT_incl_Crane_Truck__c,Account__r.Do_not_market_MyLittleSalesman__c,
Account__r.Do_not_market_Terrapoint__c, Account__r.Do_not_market_TradeMachines__c,
Account__r.Do_not_market_Used_Equip_Guide__c,Account__r.Do_not_market_Zonapesada__c,
Account__r.Do_not_market_anywhere__c
FROM Product2 
WHERE Id IN : setOfProduct2Id ]; */
/*
private static final string DEVELOPER_NAME = 'Unit';
public Trigger_Setting__mdt setTriggerSettings() {


return [select Active__c,Max_Loop_Count__c,Stop_Recursion__c FROM Trigger_Setting__mdt 
Where DeveloperName=:DEVELOPER_NAME LIMIT 1];

} 

Public void beforeInsert(List<SObject> triggerNew){

//handleBeforeInsert((list<Lead>)triggerNew);

}
//By implementing this method trigger can handle all the before Update events
Public void beforeUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){
// handleBeforeUpdate((list<Lead>)triggerNew,
//                  (Map<Id,Lead>)triggerOldMap);


}
//By implementing this method trigger can handle all the before Delete events
Public void beforeDelete(List<SObject> triggerOld){

}   
//By implementing this method trigger can handle all the after Insert events
Public static void afterInsert(List<SObject> triggerNew){

handleAfterInsert((list<Product2>)triggerNew);
}
//By implementing this method trigger can handle all the after Update events
Public void afterUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){
handleAfterUpdate((list<Product2>)triggerNew,
(Map<Id,Product2>)triggerOldMap);

}
//By implementing this method trigger can handle all the after Delte events
Public void afterDelete(List<SObject> triggerOld){

}
//By implementing this method trigger can handle all the after UnDelete events
Public void afterUndelete(List<SObject> triggerNew){

}

*/