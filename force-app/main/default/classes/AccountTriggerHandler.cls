public class AccountTriggerHandler implements ITriggerHandler{
    private static final string DEVELOPER_NAME = 'Account';
    public Trigger_Setting__mdt setTriggerSettings() {
        
        
        return [select Active__c,Max_Loop_Count__c,Stop_Recursion__c FROM Trigger_Setting__mdt 
                Where DeveloperName=:DEVELOPER_NAME LIMIT 1];
        
    } 
    
    Public void beforeInsert(List<SObject> triggerNew){
        //handleBeforeInsert((List<opportunity>)triggerNew);
        
    }
    //By implementing this method trigger can handle all the before Update events
    Public void beforeUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){    
        //handleBeforeUpdate((List<opportunity>)triggerNew,(Map<Id, opportunity>)triggerOldMap);
    }
    //By implementing this method trigger can handle all the before Delete events
    Public void beforeDelete(List<SObject> triggerOld){
        
    }   
    //By implementing this method trigger can handle all the after Insert events
    Public void afterInsert(List<SObject> triggerNew){
        handleAfterInsert((List<Account>) triggerNew);
    }
    //By implementing this method trigger can handle all the after Update events
    Public void afterUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){
        //handleAfterUpdate((List<Account>) triggerNew, (Map<Id, Account>) triggerOldMap);
    }
    //By implementing this method trigger can handle all the after Delte events
    Public void afterDelete(List<SObject> triggerOld){
        
    }
    //By implementing this method trigger can handle all the after UnDelete events
    Public void afterUndelete(List<SObject> triggerNew){
        
    }
    public static void handleAfterInsert(
        list<Account> lstTriggerNew 
    ){
        //list<Client_Type_For_Marketing_Checkbox__mdt> lstClientType = [SELECT Id, Client_Type__c, DeveloperName FROM Client_Type_For_Marketing_Checkbox__mdt];
        list<Fields_For_Marketing_Checkbox__mdt> lstofFields = [SELECT Id, Client_Type_For_Marketing_Checkbox__c,
                                                                    Client_Type_For_Marketing_Checkbox__r.Client_Type__c, 
                                                                    Checkbox_field_API_Name__c, Checked__c, DeveloperName 
                                                                FROM Fields_For_Marketing_Checkbox__mdt];
        system.debug('lstofFields'+lstofFields.size());
        map<String,list<String>>mapOfClientTypeVsListOfField = new map<String,list<String>>();
        if(lstofFields!=null && !lstofFields.isempty()){
            for(Fields_For_Marketing_Checkbox__mdt eachfield : lstofFields){
                if(!mapOfClientTypeVsListOfField.containskey(eachfield.Client_Type_For_Marketing_Checkbox__r.Client_Type__c)){
                    mapOfClientTypeVsListOfField.put(eachfield.Client_Type_For_Marketing_Checkbox__r.Client_Type__c,new list<String>());
                    mapOfClientTypeVsListOfField.get(eachfield.Client_Type_For_Marketing_Checkbox__r.Client_Type__c).add(eachfield.Checkbox_field_API_Name__c);
                }else{
                    mapOfClientTypeVsListOfField.get(eachfield.Client_Type_For_Marketing_Checkbox__r.Client_Type__c).add(eachfield.Checkbox_field_API_Name__c);
                }
            }
        }
        system.debug('mapOfClientTypeVsListOfField'+mapOfClientTypeVsListOfField);
        list<Marketing_Detail__c> lstMarketingDetail = new list<Marketing_Detail__c>();
        if(lstTriggerNew!=null && !lstTriggerNew.isEmpty()){
            for(Account eachAccount : lstTriggerNew){
                if(mapOfClientTypeVsListOfField.get(eachAccount.Client_Type__c)!=null && 
                  !mapOfClientTypeVsListOfField.get(eachAccount.Client_Type__c).isEmpty()){
                      system.debug('mapOfClientTypeVsListOfField::'+mapOfClientTypeVsListOfField.get(eachAccount.Client_Type__c));
                      Marketing_Detail__c eachMarketingDetail = new Marketing_Detail__c();
                      eachMarketingDetail.Account__c = eachAccount.id;
                      for(string eachString : mapOfClientTypeVsListOfField.get(eachAccount.Client_Type__c)){
                          eachMarketingDetail.put(eachString,True);
                      }
                      lstMarketingDetail.add(eachMarketingDetail);
                  }
                      /*
                      //Marketing_Detail__c eachMarketingDetail = new Marketing_Detail__c();
                      eachMarketingDetail.Do_not_market_anywhere__c = false;
                      eachMarketingDetail.Marketed_On_Construction_Equip_Guide__c = True;
                      eachMarketingDetail.Marketed_On_Craigslist__c = False;
                      eachMarketingDetail.Marketed_On_Facebook__c = True;
                      eachMarketingDetail.Marketed_On_FB_Marketplace__c = False;
                      eachMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c = True;
                      eachMarketingDetail.Marketed_On_GearFlow__c = True;
                      eachMarketingDetail.Marketed_On_Instagram__c = True;
                      eachMarketingDetail.Marketed_On_LinkedIn__c = True;
                      eachMarketingDetail.Marketed_On_Machinio__c = True;
                      eachMarketingDetail.Marketed_On_Mascus__c = True;
                      eachMarketingDetail.Marketed_on_MT_Crane_Truck__c = False;
                      eachMarketingDetail.Marketed_On_MyLittleSalesman__c = True;
                      eachMarketingDetail.Marketed_On_Terrapoint__c = True;
                      eachMarketingDetail.Marketed_On_TradeMachines__c = True;
                      eachMarketingDetail.Marketed_On_Used_Equip_Guide__c = True;
                      eachMarketingDetail.Marketed_On_Zonapesada__c = True;
                      eachMarketingDetail.Account__c = eachAccount.Id;
                      lstMarketingDetail.add(eachMarketingDetail);*/
                  /*}else if(eachAccount.Client_Type__c == 'Manufacturer Dealer' || eachAccount.Client_Type__c == 'Equipment Seller'){
                      Marketing_Detail__c eachMarketingDetail = new Marketing_Detail__c();
                      eachMarketingDetail.Do_not_market_anywhere__c = true;
                      eachMarketingDetail.Account__c = eachAccount.Id;
                      lstMarketingDetail.add(eachMarketingDetail);
                  }else{
                      Marketing_Detail__c eachMarketingDetail = new Marketing_Detail__c();
                      eachMarketingDetail.Do_not_market_anywhere__c = false;
                      eachMarketingDetail.Marketed_On_Construction_Equip_Guide__c = True;
                      eachMarketingDetail.Marketed_On_Craigslist__c = False;
                      eachMarketingDetail.Marketed_On_Facebook__c = True;
                      eachMarketingDetail.Marketed_On_FB_Marketplace__c = False;
                      eachMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c = True;
                      eachMarketingDetail.Marketed_On_GearFlow__c = True;
                      eachMarketingDetail.Marketed_On_Instagram__c = True;
                      eachMarketingDetail.Marketed_On_LinkedIn__c = True;
                      eachMarketingDetail.Marketed_On_Machinio__c = True;
                      eachMarketingDetail.Marketed_On_Mascus__c = True;
                      eachMarketingDetail.Marketed_on_MT_Crane_Truck__c = False;
                      eachMarketingDetail.Marketed_On_MyLittleSalesman__c = True;
                      eachMarketingDetail.Marketed_On_Terrapoint__c = True;
                      eachMarketingDetail.Marketed_On_TradeMachines__c = True;
                      eachMarketingDetail.Marketed_On_Used_Equip_Guide__c = True;
                      eachMarketingDetail.Marketed_On_Zonapesada__c = True;
                      eachMarketingDetail.Account__c = eachAccount.Id;
                      lstMarketingDetail.add(eachMarketingDetail);
                  }*/
            }
            if(lstMarketingDetail!=null && !lstMarketingDetail.isEmpty()){
                insert lstMarketingDetail;
            }
        }
    }
    /*private static void handleAfterUpdate(
        list<Account> lstTriggerNew , 
        Map<Id, Account> mapTriggerOldMap
    ){
        if(lstTriggerNew!=null && !lstTriggerNew.isEmpty()){
            map<Id,list<Marketing_Detail__c>>mapOfAccountIdVsLstMarketingDetail = new map<Id,list<Marketing_Detail__c>>();
            list<Marketing_Detail__c> lstMarketingDetailToUpdate = new list<Marketing_Detail__c>();
            list<Marketing_Detail__c>lstMarketingDetail = [SELECT Id, Marketed_On_Construction_Equip_Guide__c, 
                                                           Marketed_On_Craigslist__c, Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, 
                                                           Marketed_On_Fleet_Up_Marketplace__c, Marketed_On_GearFlow__c, Marketed_On_Instagram__c, 
                                                           Marketed_On_LinkedIn__c, Marketed_On_Machinio__c, Marketed_On_Mascus__c,
                                                           Marketed_on_MT_Crane_Truck__c, Marketed_On_MyLittleSalesman__c,
                                                           Marketed_On_Terrapoint__c, Marketed_On_TradeMachines__c, 
                                                           Marketed_On_Used_Equip_Guide__c, Marketed_On_Zonapesada__c, 
                                                           Do_not_market_anywhere__c,Override_and_Post__c,
                                                           Unit__c,Opportunity__c,Account__c
                                                           FROM Marketing_Detail__c WHERE Account__c IN : lstTriggerNew 
                                                           AND Opportunity__c = null 
                                                           AND Override_and_Post__c = false ];
            if(lstMarketingDetail!=Null && !lstMarketingDetail.isEmpty()){
                for(Marketing_Detail__c eachMarketingDetail : lstMarketingDetail){
                    if(!mapOfAccountIdVsLstMarketingDetail.containsKey(eachMarketingDetail.Account__c)){
                        mapOfAccountIdVsLstMarketingDetail.put(eachMarketingDetail.Account__c,new list<Marketing_Detail__c>());
                        mapOfAccountIdVsLstMarketingDetail.get(eachMarketingDetail.Account__c).add(eachMarketingDetail);                        
                    }else{
                        mapOfAccountIdVsLstMarketingDetail.get(eachMarketingDetail.Account__c).add(eachMarketingDetail); 
                    }
                    //mapOfAccountIdVsLstMarketingDetail.put(eachMarketingDetail.Account__c,);
                }
            }
            for(Account eachAccount : lstTriggerNew){
                if(mapOfAccountIdVsLstMarketingDetail.get(eachAccount.id)!=null &&
                   !mapOfAccountIdVsLstMarketingDetail.get(eachAccount.id).IsEmpty()){
                       for(Marketing_Detail__c eachMarketingDetail : mapOfAccountIdVsLstMarketingDetail.get(eachAccount.id)){
                           if(eachAccount.Do_not_market_anywhere__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_anywhere__c){
                               eachMarketingDetail.Do_not_market_anywhere__c = eachAccount.Do_not_market_anywhere__c;
                           }
                           if(eachAccount.Do_not_market_Construction_Equip_Guide__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Construction_Equip_Guide__c){
                               eachMarketingDetail.Marketed_On_Construction_Equip_Guide__c = !eachAccount.Do_not_market_Construction_Equip_Guide__c;
                           }
                           if(eachAccount.Do_not_market_Craigslist__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Craigslist__c){
                               eachMarketingDetail.Marketed_On_Craigslist__c = !eachAccount.Do_not_market_Craigslist__c;
                           }
                           if(eachAccount.Do_not_market_Facebook__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Facebook__c){
                               eachMarketingDetail.Marketed_On_Facebook__c = !eachAccount.Do_not_market_Facebook__c;
                           }
                           if(eachAccount.Do_not_market_FB_Marketplace__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_FB_Marketplace__c){
                               eachMarketingDetail.Marketed_On_FB_Marketplace__c = !eachAccount.Do_not_market_FB_Marketplace__c;
                           }
                           if(eachAccount.Do_Not_Market_Fleet_Up_Marketplace__c != mapTriggerOldMap.get(eachAccount.id).Do_Not_Market_Fleet_Up_Marketplace__c){
                               eachMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c = !eachAccount.Do_Not_Market_Fleet_Up_Marketplace__c;
                           }
                           if(eachAccount.Do_not_market_GearFlow__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_GearFlow__c){
                               eachMarketingDetail.Marketed_On_GearFlow__c = !eachAccount.Do_not_market_GearFlow__c;
                           }
                           if(eachAccount.Do_not_market_Instagram__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Instagram__c){
                               eachMarketingDetail.Marketed_On_Instagram__c = !eachAccount.Do_not_market_Instagram__c;
                           }
                           if(eachAccount.Do_not_market_LinkedIn__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_LinkedIn__c){
                               eachMarketingDetail.Marketed_On_LinkedIn__c = !eachAccount.Do_not_market_LinkedIn__c;
                           }
                           if(eachAccount.Do_not_market_Machinio__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Machinio__c){
                               eachMarketingDetail.Marketed_On_Machinio__c = !eachAccount.Do_not_market_Machinio__c;
                           }
                           if(eachAccount.Do_not_market_Mascus__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Mascus__c){
                               eachMarketingDetail.Marketed_On_Mascus__c = !eachAccount.Do_not_market_Mascus__c;
                           }
                           if(eachAccount.Do_not_market_MT_incl_Crane_Truck__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_MT_incl_Crane_Truck__c){
                               eachMarketingDetail.Marketed_on_MT_Crane_Truck__c = !eachAccount.Do_not_market_MT_incl_Crane_Truck__c;
                           }
                           if(eachAccount.Do_not_market_MyLittleSalesman__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_MyLittleSalesman__c){
                               eachMarketingDetail.Marketed_On_MyLittleSalesman__c = !eachAccount.Do_not_market_MyLittleSalesman__c;
                           }
                           if(eachAccount.Do_not_market_Terrapoint__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Terrapoint__c){
                               eachMarketingDetail.Marketed_On_Terrapoint__c = !eachAccount.Do_not_market_Terrapoint__c;
                           }
                           if(eachAccount.Do_not_market_TradeMachines__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_TradeMachines__c){
                               eachMarketingDetail.Marketed_On_TradeMachines__c = !eachAccount.Do_not_market_TradeMachines__c;
                           }
                           if(eachAccount.Do_not_market_Used_Equip_Guide__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Used_Equip_Guide__c){
                               eachMarketingDetail.Marketed_On_Used_Equip_Guide__c = !eachAccount.Do_not_market_Used_Equip_Guide__c;
                           }
                           if(eachAccount.Do_not_market_Zonapesada__c != mapTriggerOldMap.get(eachAccount.id).Do_not_market_Zonapesada__c){
                               eachMarketingDetail.Marketed_On_Zonapesada__c = !eachAccount.Do_not_market_Zonapesada__c;
                           }
                           lstMarketingDetailToUpdate.add(eachMarketingDetail);
                           
                       }
                   }
            }
            if(lstMarketingDetailToUpdate!=null && !lstMarketingDetailToUpdate.isEmpty()){
                update lstMarketingDetailToUpdate;
            }
            
        }
    }*/
    
}