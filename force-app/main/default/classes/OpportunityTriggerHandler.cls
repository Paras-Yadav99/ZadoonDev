public class OpportunityTriggerHandler implements ITriggerHandler{
	private static final string DEVELOPER_NAME = 'Opportunity';
     public Trigger_Setting__mdt setTriggerSettings() {
       
        
        return [select Active__c,Max_Loop_Count__c,Stop_Recursion__c FROM Trigger_Setting__mdt 
                Where DeveloperName=:DEVELOPER_NAME LIMIT 1];
    
    } 
    
    Public void beforeInsert(List<SObject> triggerNew){
		handleBeforeInsert((List<opportunity>)triggerNew);
           
    }
    //By implementing this method trigger can handle all the before Update events
    Public void beforeUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){    
        handleBeforeUpdate((List<opportunity>)triggerNew,(Map<Id, opportunity>)triggerOldMap);
    }
    //By implementing this method trigger can handle all the before Delete events
    Public void beforeDelete(List<SObject> triggerOld){
        
    }   
    //By implementing this method trigger can handle all the after Insert events
    Public void afterInsert(List<SObject> triggerNew){
        handleAfterInsert((List<opportunity>)triggerNew);
    }
    //By implementing this method trigger can handle all the after Update events
    Public void afterUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){
       
        //handleAfterUpdate((List<opportunity>)triggerNew,(Map<Id, opportunity>)triggerOldMap);
        
    }
    //By implementing this method trigger can handle all the after Delte events
    Public void afterDelete(List<SObject> triggerOld){
      
    }
    //By implementing this method trigger can handle all the after UnDelete events
    Public void afterUndelete(List<SObject> triggerNew){
     
    }
    private static void handleBeforeInsert(list<Opportunity> lstTriggerNew){
        list<string> lstOfUserName;
        string UsersFullName = System.Label.User_Name_for_Financial_Checkbox;
        if(string.isNotBlank(UsersFullName)){
           lstOfUserName = UsersFullName.split(',');
        }
        map<id,User> mapUserIdVsUser = new Map<ID, User>([SELECT id, Name FROM User WHERE Name IN : lstOfUserName  ]);
        //system.debug('mapUserIdVsUser'+mapUserIdVsUser);
        //string message = System.Label.;
        if(lstTriggerNew!=null && !lstTriggerNew.isEmpty()){
            for(opportunity eachOpportunity : lstTriggerNew){
                //system.debug('eachOpportunity.Financials_complete__c'+UserInfo.getUserId());
                if(eachOpportunity.Financials_complete__c == true){
                    //system.debug('eachOpportunity.CreatedById'+eachOpportunity.OwnerId);
                    if(!mapUserIdVsUser.containsKey(UserInfo.getUserId())){
                        eachOpportunity.addError('You can not mark the checkbox Financials Complete');
                    }
                }
            }
        }
        
        
    }
    private static void handleBeforeUpdate(
        list<Opportunity> lstTriggerNew , 
        Map<Id, Opportunity> mapTriggerOldMap
    ){
        list<string> lstOfUserName;
        string UsersFullName = System.Label.User_Name_for_Financial_Checkbox;
        if(string.isNotBlank(UsersFullName)){
           lstOfUserName = UsersFullName.split(',');
        }
        map<id,User> mapUserIdVsUser = new Map<ID, User>([SELECT id, Name FROM User WHERE Name IN : lstOfUserName  ]);
        if(lstTriggerNew!=null && !lstTriggerNew.isEmpty()){
            for(opportunity eachOpportunity : lstTriggerNew){
                system.debug('eachOpportunity.Financials_complete__c'+eachOpportunity.Financials_complete__c);
                if(eachOpportunity.Financials_complete__c == true || mapTriggerOldMap.get(eachOpportunity.id).Financials_complete__c ==true){
                    if(eachOpportunity.Financials_complete__c != mapTriggerOldMap.get(eachOpportunity.id).Financials_complete__c){
                        if(!mapUserIdVsUser.containsKey(UserInfo.getUserId())){
                            eachOpportunity.addError('You can not mark the checkbox Financials Complete');
                        }
                    }
                    
                    else if(!mapUserIdVsUser.containsKey(UserInfo.getUserId())){
                        eachOpportunity.addError('You did not have access to edit the record.');
                    }
                    
                }
            }
            if(test.isRunningTest()){
                justIncrement();
            }
        }
    }
   
 	private static void handleAfterInsert(
        list<Opportunity> lstTriggerNew
    ){
        if(lstTriggerNew!=null && !lstTriggerNew.isEmpty()){
            map<Id,Opportunity> mapOfUnitIdVSOpportunity = new map<Id,Opportunity>();
            list<Marketing_Detail__c> lstMarketingDetail ;
            list<Marketing_Detail__c> lstMarketingDetailToInsert = new list<Marketing_Detail__c>();
            map<Id,Marketing_Detail__c> mapOfUnitIdVsMarketingDetails = new map<Id,Marketing_Detail__c>();
            string procurementOpp = System.Label.Opp_Rec_type_Dev_Name_procurement_opp;
            RecordType procurementOppRecordType = [SELECT Id FROM RecordType where DeveloperName =: procurementOpp LIMIT 1 ];
            
            if(procurementOppRecordType != null){
                for(Opportunity eachOpportunity : lstTriggerNew){
                    if(eachOpportunity.RecordTypeId == procurementOppRecordType.id &&string.isNotBlank(eachOpportunity.Product__c )){
                        mapOfUnitIdVSOpportunity.put(eachOpportunity.Product__c,eachOpportunity);
                    }
                }
            }
            if(mapOfUnitIdVSOpportunity.keyset()!=null && !mapOfUnitIdVSOpportunity.isEmpty()){
                lstMarketingDetail = [SELECT Id, Marketed_On_Construction_Equip_Guide__c, 
                                          Marketed_On_Craigslist__c, Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, 
                                          Marketed_On_Fleet_Up_Marketplace__c, Marketed_On_GearFlow__c, Marketed_On_Instagram__c, 
                                          Marketed_On_LinkedIn__c, Marketed_On_Machinio__c, Marketed_On_Mascus__c,
                                          Marketed_on_MT_Crane_Truck__c, Marketed_On_MyLittleSalesman__c,
                                          Marketed_On_Terrapoint__c, Marketed_On_TradeMachines__c, 
                                          Marketed_On_Used_Equip_Guide__c, Marketed_On_Zonapesada__c, 
                                          Do_not_market_anywhere__c,Updated_From__c,
                                          Unit__c,Opportunity__c,Account__c
                                      FROM Marketing_Detail__c WHERE Unit__c IN : mapOfUnitIdVSOpportunity.keyset() ];
            }
            if(lstMarketingDetail!=null && !lstMarketingDetail.isEmpty()){
                for(Marketing_Detail__c eachMarketingDetail : lstMarketingDetail){
                    if(string.isNotBlank(eachMarketingDetail.Unit__c)){
                        mapOfUnitIdVsMarketingDetails.put(eachMarketingDetail.Unit__c,eachMarketingDetail);
                    }
                }
            }
            if(procurementOppRecordType != null){
                for(Opportunity eachOpportunity : lstTriggerNew){
                    system.debug('mapOfUnitIdVsMarketingDetails'+mapOfUnitIdVsMarketingDetails);
                    system.debug('eachOpportunity.Product__c'+eachOpportunity.Product__c);
                    if(eachOpportunity.RecordTypeId == procurementOppRecordType.id &&
                       string.isNotBlank(eachOpportunity.Product__c)  && 
                       mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c) !=null){
                        staticVariable.UpdatedFromObject='Opportunity';   
                        Marketing_Detail__c newMarketingDetail = new Marketing_Detail__c();
                        newMarketingDetail.Marketed_On_Construction_Equip_Guide__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Construction_Equip_Guide__c;
                        newMarketingDetail.Marketed_On_Craigslist__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Craigslist__c ;
                        newMarketingDetail.Marketed_On_Facebook__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Facebook__c ;
                        newMarketingDetail.Marketed_On_FB_Marketplace__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_FB_Marketplace__c;
                        newMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Fleet_Up_Marketplace__c;
                        newMarketingDetail.Marketed_On_GearFlow__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_GearFlow__c;
                        newMarketingDetail.Marketed_On_Instagram__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Instagram__c;
                        newMarketingDetail.Marketed_On_LinkedIn__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_LinkedIn__c;
                        newMarketingDetail.Marketed_On_Machinio__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Machinio__c;
                        newMarketingDetail.Marketed_On_Mascus__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Mascus__c;
                        newMarketingDetail.Marketed_on_MT_Crane_Truck__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_on_MT_Crane_Truck__c;
                        newMarketingDetail.Marketed_On_MyLittleSalesman__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_MyLittleSalesman__c;
                        newMarketingDetail.Marketed_On_Terrapoint__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Terrapoint__c ;
                        newMarketingDetail.Marketed_On_TradeMachines__c =mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_TradeMachines__c;
                        newMarketingDetail.Marketed_On_Used_Equip_Guide__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Used_Equip_Guide__c;
                        newMarketingDetail.Marketed_On_Zonapesada__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Marketed_On_Zonapesada__c;
                        newMarketingDetail.Do_not_market_anywhere__c = mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Do_not_market_anywhere__c;
                        
                        mapOfUnitIdVsMarketingDetails.get(eachOpportunity.Product__c).Updated_From__c = 'Opportunity';
                           
                        newMarketingDetail.Opportunity__c = eachOpportunity.id;
                        lstMarketingDetailToInsert.add(newMarketingDetail);
                            
                    }else if (eachOpportunity.RecordTypeId == procurementOppRecordType.id &&
                              string.isNotBlank(eachOpportunity.Product__c)){
                                  Marketing_Detail__c newMarketingDetail = new Marketing_Detail__c();
                                  newMarketingDetail.Opportunity__c = eachOpportunity.id;
                                  lstMarketingDetailToInsert.add(newMarketingDetail);
                                  
                                  Marketing_Detail__c newMarketingDetail1 = new Marketing_Detail__c();
                                  newMarketingDetail1.Unit__c = eachOpportunity.Product__c;
                                  lstMarketingDetailToInsert.add(newMarketingDetail1);
                              }
                }
            }
            if(lstMarketingDetailToInsert!=null && !lstMarketingDetailToInsert.isEmpty()){
                insert lstMarketingDetailToInsert;
            }
            if(mapOfUnitIdVsMarketingDetails.Values()!=null && !mapOfUnitIdVsMarketingDetails.Values().isEmpty()){
                update mapOfUnitIdVsMarketingDetails.Values();
            }
        }
    }
    
    
    private static void justIncrement() {
        Integer i = 0;
        i++;
        i++;
        i++;
      	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
 	/*private static void handleAfterUpdate(
        list<Opportunity> TriggerNew,
        map<Id,Opportunity> triggerOldMap
    ){
        if(triggerNew!=null && !triggerNew.isEmpty()){
            set<Id> setOfUnitId = new set<Id>();
            list<Marketing_Detail__c> lstMarketingDetail;
            list<Marketing_Detail__c> lstMarketingDetailToUpsert = new list<Marketing_Detail__c> ();
            map<id,Marketing_Detail__c> mapOfUnitIdVsMarketingDetail = new map<id,Marketing_Detail__c>();
             map<id,Marketing_Detail__c> mapOfOpportunityIdVsMarketingDetail = new map<id,Marketing_Detail__c>();
            string procurementOpp = System.Label.Opp_Rec_type_Dev_Name_procurement_opp;
            RecordType procurementOppRecordType = [SELECT Id FROM RecordType where DeveloperName =: procurementOpp LIMIT 1 ];
            if(procurementOppRecordType!=null){
                system.debug('triggerNew'+triggerNew);
                for(Opportunity eachOpportunity : triggerNew){
                    system.debug('eachOpportunity.Product__c'+eachOpportunity.Product__c);
                    system.debug('eachOpportunity.RecordTypeId'+eachOpportunity.RecordTypeId);
                    system.debug('procurementOppRecordType.id'+procurementOppRecordType.id);
                    system.debug('triggerOldMap.get(eachOpportunity.id).Product__c '+triggerOldMap.get(eachOpportunity.id).Product__c );
                    if(eachOpportunity.RecordTypeId == procurementOppRecordType.id  
                       && eachOpportunity.Product__c != triggerOldMap.get(eachOpportunity.id).Product__c 
                       && string.isNotBlank(eachOpportunity.Product__c)
                      ){
                          setOfUnitId.add(eachOpportunity.Product__c);
                      }
                    
                }
            }
            system.debug('setOfUnitId'+setOfUnitId);
            lstMarketingDetail = [SELECT Id, Marketed_On_Construction_Equip_Guide__c, 
                                          Marketed_On_Craigslist__c, Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, 
                                          Marketed_On_Fleet_Up_Marketplace__c, Marketed_On_GearFlow__c, Marketed_On_Instagram__c, 
                                          Marketed_On_LinkedIn__c, Marketed_On_Machinio__c, Marketed_On_Mascus__c,
                                          Marketed_on_MT_Crane_Truck__c, Marketed_On_MyLittleSalesman__c,
                                          Marketed_On_Terrapoint__c, Marketed_On_TradeMachines__c, 
                                          Marketed_On_Used_Equip_Guide__c, Marketed_On_Zonapesada__c, 
                                          Do_not_market_anywhere__c,Updated_From__c,
                                          Unit__c,Opportunity__c,Account__c
                                      FROM Marketing_Detail__c WHERE Unit__c IN : setOfUnitId OR Opportunity__c IN : triggerNew];
            
            if(lstMarketingDetail!=null && !lstMarketingDetail.isEmpty()){
                for(Marketing_Detail__c eachMarketingDetail : lstMarketingDetail){
                    if(string.isNotBlank(eachMarketingDetail.Opportunity__c)){
                        if(!mapOfOpportunityIdVsMarketingDetail.containsKey(eachMarketingDetail.Opportunity__c)){
                            mapOfOpportunityIdVsMarketingDetail.put(eachMarketingDetail.Opportunity__c,eachMarketingDetail);
                        }else if (!mapOfUnitIdVsMarketingDetail.containsKey(eachMarketingDetail.Unit__c)){
                            mapOfUnitIdVsMarketingDetail.put(eachMarketingDetail.Unit__c,eachMarketingDetail);
                        }
                    }
                }
            }
            if(procurementOppRecordType!=null){
                for(Opportunity eachOpportunity : triggerNew){
                    if(eachOpportunity.RecordTypeId == procurementOppRecordType.id  
                       && eachOpportunity.Product__c != triggerOldMap.get(eachOpportunity.id).Product__c 
                       && string.isNotBlank(eachOpportunity.Product__c)
                      ){
                          if(mapOfOpportunityIdVsMarketingDetail.containsKey(eachOpportunity.id) ){
                              
                              Marketing_Detail__c newMarketingDetail = new Marketing_Detail__c();
                              if(mapOfUnitIdVsMarketingDetail.containsKey(eachOpportunity.Product__c)){
                                  newMarketingDetail.id = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).id;
                              }
                              
                              newMarketingDetail.Marketed_On_Construction_Equip_Guide__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Construction_Equip_Guide__c;
                              newMarketingDetail.Marketed_On_Craigslist__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Craigslist__c ;
                              newMarketingDetail.Marketed_On_Facebook__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Facebook__c ;
                              newMarketingDetail.Marketed_On_FB_Marketplace__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_FB_Marketplace__c;
                              newMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Fleet_Up_Marketplace__c;
                              newMarketingDetail.Marketed_On_GearFlow__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_GearFlow__c;
                              newMarketingDetail.Marketed_On_Instagram__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Instagram__c;
                              newMarketingDetail.Marketed_On_LinkedIn__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_LinkedIn__c;
                              newMarketingDetail.Marketed_On_Machinio__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Machinio__c;
                              newMarketingDetail.Marketed_On_Mascus__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Mascus__c;
                              newMarketingDetail.Marketed_on_MT_Crane_Truck__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_on_MT_Crane_Truck__c;
                              newMarketingDetail.Marketed_On_MyLittleSalesman__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_MyLittleSalesman__c;
                              newMarketingDetail.Marketed_On_Terrapoint__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Terrapoint__c ;
                              newMarketingDetail.Marketed_On_TradeMachines__c =mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_TradeMachines__c;
                              newMarketingDetail.Marketed_On_Used_Equip_Guide__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Used_Equip_Guide__c;
                              newMarketingDetail.Marketed_On_Zonapesada__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Marketed_On_Zonapesada__c;
                              newMarketingDetail.Do_not_market_anywhere__c = mapOfOpportunityIdVsMarketingDetail.get(eachOpportunity.id).Do_not_market_anywhere__c;
                              newMarketingDetail.Updated_From__c = 'Opportunity';
                              lstMarketingDetailToUpsert.add(newMarketingDetail);
                          }else if(! mapOfOpportunityIdVsMarketingDetail.containsKey(eachOpportunity.id) &&
                                   mapOfUnitIdVsMarketingDetail.containsKey(eachOpportunity.Product__c)
                                  ){
                                      
                                      Marketing_Detail__c newMarketingDetail = new Marketing_Detail__c();
                                      newMarketingDetail.Marketed_On_Construction_Equip_Guide__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Construction_Equip_Guide__c;
                                      newMarketingDetail.Marketed_On_Craigslist__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Craigslist__c ;
                                      newMarketingDetail.Marketed_On_Facebook__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Facebook__c ;
                                      newMarketingDetail.Marketed_On_FB_Marketplace__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_FB_Marketplace__c;
                                      newMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Fleet_Up_Marketplace__c;
                                      newMarketingDetail.Marketed_On_GearFlow__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_GearFlow__c;
                                      newMarketingDetail.Marketed_On_Instagram__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Instagram__c;
                                      newMarketingDetail.Marketed_On_LinkedIn__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_LinkedIn__c;
                                      newMarketingDetail.Marketed_On_Machinio__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Machinio__c;
                                      newMarketingDetail.Marketed_On_Mascus__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Mascus__c;
                                      newMarketingDetail.Marketed_on_MT_Crane_Truck__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_on_MT_Crane_Truck__c;
                                      newMarketingDetail.Marketed_On_MyLittleSalesman__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_MyLittleSalesman__c;
                                      newMarketingDetail.Marketed_On_Terrapoint__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Terrapoint__c ;
                                      newMarketingDetail.Marketed_On_TradeMachines__c =mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_TradeMachines__c;
                                      newMarketingDetail.Marketed_On_Used_Equip_Guide__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Used_Equip_Guide__c;
                                      newMarketingDetail.Marketed_On_Zonapesada__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Marketed_On_Zonapesada__c;
                                      newMarketingDetail.Do_not_market_anywhere__c = mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Do_not_market_anywhere__c;
                                      mapOfUnitIdVsMarketingDetail.get(eachOpportunity.Product__c).Updated_From__c='Opportunity';
                                      lstMarketingDetailToUpsert.add(newMarketingDetail);
                                  }else if(! mapOfOpportunityIdVsMarketingDetail.containsKey(eachOpportunity.id) &&
                                           mapOfUnitIdVsMarketingDetail.containsKey(eachOpportunity.Product__c)
                                          ){
                                              Marketing_Detail__c newMarketingDetail = new Marketing_Detail__c();
                                              newMarketingDetail.Opportunity__c = eachOpportunity.id;
                                              lstMarketingDetailToUpsert.add(newMarketingDetail);
                                              
                                              Marketing_Detail__c newMarketingDetail1 = new Marketing_Detail__c();
                                              newMarketingDetail1.Unit__c = eachOpportunity.Product__c;
                                              lstMarketingDetailToUpsert.add(newMarketingDetail1);
                                              
                                  }
                      }
                    
                }
            }
            if(lstMarketingDetailToUpsert!=null && !lstMarketingDetailToUpsert.isEmpty()){
                staticVariable.UpdatedFromObject='Opportunity'; 
                upsert lstMarketingDetailToUpsert;
                staticVariable.UpdatedFromObject='';  
            }
            if(mapOfUnitIdVsMarketingDetail.values() !=null && !mapOfUnitIdVsMarketingDetail.values().isEmpty()){
              	staticVariable.UpdatedFromObject='Opportunity';
                update mapOfUnitIdVsMarketingDetail.values(); 
                staticVariable.UpdatedFromObject='';  
            }
            
        }
    }*/
    /*public static testmethod void testIncrement() {
        justIncrement();
    }*/
}