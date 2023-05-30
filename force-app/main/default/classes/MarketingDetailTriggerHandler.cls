public class MarketingDetailTriggerHandler implements ITriggerHandler{
	private static final string DEVELOPER_NAME = 'MarketingDetail';
     public Trigger_Setting__mdt setTriggerSettings() {
       
        
        return [select Active__c,Max_Loop_Count__c,Stop_Recursion__c FROM Trigger_Setting__mdt 
                Where DeveloperName=:DEVELOPER_NAME LIMIT 1];
    
    } 
    
    Public void beforeInsert(List<SObject> triggerNew){
		//handleBeforeInsert((List<opportunity>)triggerNew);
           
    }
    //By implementing this method trigger can handle all the before Update events
    Public void beforeUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){    
        handleBeforeUpdate((List<Marketing_Detail__c>) triggerNew, (Map<Id, Marketing_Detail__c>) triggerOldMap);
        //handleBeforeUpdate((List<opportunity>)triggerNew,(Map<Id, opportunity>)triggerOldMap);
    }
    //By implementing this method trigger can handle all the before Delete events
    Public void beforeDelete(List<SObject> triggerOld){
        
    }   
    //By implementing this method trigger can handle all the after Insert events
    Public void afterInsert(List<SObject> triggerNew){
        
    }
    //By implementing this method trigger can handle all the after Update events
    Public void afterUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){
       //handleAfterUpdate((List<Marketing_Detail__c>) triggerNew, (Map<Id, Marketing_Detail__c>) triggerOldMap);
	}
    //By implementing this method trigger can handle all the after Delte events
    Public void afterDelete(List<SObject> triggerOld){
      
    }
    //By implementing this method trigger can handle all the after UnDelete events
    Public void afterUndelete(List<SObject> triggerNew){
     
    }
    private static void handleBeforeUpdate(
        List<Marketing_Detail__c> triggerNew, 
        Map<Id, Marketing_Detail__c> triggerOldMap
    ){
        if(triggerNew!=null && !triggerNew.isEmpty()){
            
         	map<Id,list<Marketing_Detail__c>>mapOfAccountIdVsLstMarketingDetail = new map<Id,list<Marketing_Detail__c>>();
            map<Id,list<Marketing_Detail__c>>mapOfUnitIdVsLstMarketingDetail = new map<Id,list<Marketing_Detail__c>>();
            map<Id,Id> mapOfOpportunityIdVsUnitId = new map<Id,Id>();
            list<Marketing_Detail__c> lstMarketingDetailToUpdate = new list<Marketing_Detail__c>();
            list<Marketing_Detail__c> lstMarketingDetailOnOpportunity;
            //set<Id> setOfOpportunityProductId = new set<Id>();
            set<Id> setOfAccountId = new set<Id>();
            set<Id> setOfOpportunityId = new set<Id>();
            set<Id> setOfUnitId = new set<Id>();
            list<Product2> lstUnit ;
            list<Product2> lstOpportunityUnit ;
            list<Opportunity> lstOpportunity ;
            for(Marketing_Detail__c eachMarketingDetail : triggerNew){
                if(string.isNotBlank(eachMarketingDetail.Account__c) 
                   && string.isBlank(eachMarketingDetail.Updated_From__c)){
                 	setOfAccountId.add(eachMarketingDetail.Account__c);   
                    
                }else if(string.isNotBlank(eachMarketingDetail.Opportunity__c)
                         && string.isBlank(eachMarketingDetail.Updated_From__c)){
                    setOfOpportunityId.add(eachMarketingDetail.Opportunity__c);
                    
                }else if(string.isNotBlank(eachMarketingDetail.Unit__c)
                        && string.isNotBlank(eachMarketingDetail.Updated_From__c)){
                    setOfUnitId.add(eachMarketingDetail.Unit__c);
                    
                }
            }
            system.debug('setOfAccountId::'+setOfAccountId);
            system.debug('setOfOpportunityId::'+setOfOpportunityId);
            system.debug('setOfUnitId::'+setOfUnitId);
            if(setOfAccountId!= null && !setOfAccountId.isEmpty()){
                lstUnit = [SELECT Id,Account__c,
                               (SELECT Id, Marketed_On_Construction_Equip_Guide__c, 
                                Marketed_On_Craigslist__c, Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, 
                                Marketed_On_Fleet_Up_Marketplace__c, Marketed_On_GearFlow__c, Marketed_On_Instagram__c, 
                                Marketed_On_LinkedIn__c, Marketed_On_Machinio__c, Marketed_On_Mascus__c,
                                Marketed_on_MT_Crane_Truck__c, Marketed_On_MyLittleSalesman__c,
                                Marketed_On_Terrapoint__c, Marketed_On_TradeMachines__c, 
                                Marketed_On_Used_Equip_Guide__c, Marketed_On_Zonapesada__c, 
                                Do_not_market_anywhere__c,
                                Unit__c,Opportunity__c,Account__c,Updated_From__c
                                FROM Marketing_Details__r WHERE Updated_From__c ='Account' AND id != : triggerNew ) 
                           FROM Product2 
                           WHERE Account__c IN : setOfAccountId];
            }
            system.debug('lstUnit'+lstUnit);
            //system.debug('lstUnit'+lstUnit.size());
            if(lstUnit!=null && !lstUnit.isEmpty()){
                for(Product2 eachUnit : lstUnit){
                    system.debug('eachUnit.Marketing_Details__r:'+eachUnit.Marketing_Details__r);
                    system.debug('eachUnit.Marketing_Details__r:::'+eachUnit.Marketing_Details__r.size());
                    if(eachUnit.Marketing_Details__r!=null && !eachUnit.Marketing_Details__r.isEmpty()){
                        for(Marketing_Detail__c eachMarketingDetail : eachUnit.Marketing_Details__r){
                        	if(!mapOfAccountIdVsLstMarketingDetail.containsKey(eachUnit.Account__c)){
                        		mapOfAccountIdVsLstMarketingDetail.put(eachUnit.Account__c,new list<Marketing_Detail__c>());
                                mapOfAccountIdVsLstMarketingDetail.get(eachUnit.Account__c).add(eachMarketingDetail);
                            }else{
                                mapOfAccountIdVsLstMarketingDetail.get(eachUnit.Account__c).add(eachMarketingDetail);
                            }
                        }
                    }
                    
                    
                }
            }
            system.debug('mapOfAccountIdVsLstMarketingDetail::'+mapOfAccountIdVsLstMarketingDetail);
            if(setOfOpportunityId!= null && !setOfOpportunityId.isEmpty()){
                lstOpportunity = [SELECT Id, AccountId,Product__c, Amount 
                                  FROM Opportunity 
                                  WHERE Id IN : setOfOpportunityId 
                                  AND Product__c!=null];
            }
            if(lstOpportunity!=null && !lstOpportunity.isEmpty()){
                for(Opportunity eachOpportunity : lstOpportunity){
                    mapOfOpportunityIdVsUnitId.put(eachOpportunity.id,eachOpportunity.Product__c);
                    //setOfOpportunityProductId.add(eachOpportunity.Product__c);
                }
                
            }
            if(mapOfOpportunityIdVsUnitId.values()!=null && !mapOfOpportunityIdVsUnitId.values().isEmpty()){
                lstOpportunityUnit = [SELECT Id,Account__c,
                                       (SELECT Id, Marketed_On_Construction_Equip_Guide__c, 
                                        Marketed_On_Craigslist__c, Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, 
                                        Marketed_On_Fleet_Up_Marketplace__c, Marketed_On_GearFlow__c, Marketed_On_Instagram__c, 
                                        Marketed_On_LinkedIn__c, Marketed_On_Machinio__c, Marketed_On_Mascus__c,
                                        Marketed_on_MT_Crane_Truck__c, Marketed_On_MyLittleSalesman__c,
                                        Marketed_On_Terrapoint__c, Marketed_On_TradeMachines__c, 
                                        Marketed_On_Used_Equip_Guide__c, Marketed_On_Zonapesada__c, 
                                        Do_not_market_anywhere__c,
                                        Unit__c,Opportunity__c,Account__c,Updated_From__c
                                        FROM Marketing_Details__r WHERE Updated_From__c ='Opportunity' ) 
                                   FROM Product2 
                                   WHERE Id IN : mapOfOpportunityIdVsUnitId.values()];
            }
            if(lstOpportunityUnit!=null && !lstOpportunityUnit.isEmpty()){
                for(Product2 eachUnit : lstOpportunityUnit){
                    if(eachUnit.Marketing_Details__r!=null && !eachUnit.Marketing_Details__r.isEmpty()){
                        for(Marketing_Detail__c eachMarketingDetail : eachUnit.Marketing_Details__r){
                        	if(!mapOfUnitIdVsLstMarketingDetail.containsKey(eachUnit.id)){
                        		mapOfUnitIdVsLstMarketingDetail.put(eachUnit.id,new list<Marketing_Detail__c>());
                                mapOfUnitIdVsLstMarketingDetail.get(eachUnit.id).add(eachMarketingDetail);
                            }else{
                                mapOfUnitIdVsLstMarketingDetail.get(eachUnit.id).add(eachMarketingDetail);
                            }
                        }
                    }
                    
                    
                }
            }
            /*list<Marketing_Detail__c>lstMarketingDetail = [SELECT Id, Marketed_On_Construction_Equip_Guide__c, 
                                                               Marketed_On_Craigslist__c, Marketed_On_Facebook__c, Marketed_On_FB_Marketplace__c, 
                                                               Marketed_On_Fleet_Up_Marketplace__c, Marketed_On_GearFlow__c, Marketed_On_Instagram__c, 
                                                               Marketed_On_LinkedIn__c, Marketed_On_Machinio__c, Marketed_On_Mascus__c,
                                                               Marketed_on_MT_Crane_Truck__c, Marketed_On_MyLittleSalesman__c,
                                                               Marketed_On_Terrapoint__c, Marketed_On_TradeMachines__c, 
                                                               Marketed_On_Used_Equip_Guide__c, Marketed_On_Zonapesada__c, 
                                                               Do_not_market_anywhere__c,
                                                               Unit__c,Opportunity__c,Account__c,Updated_From__c
                                                           FROM Marketing_Detail__c WHERE Account__c IN : setOfAccountId 
                                                           OR Opportunity__c IN : setOfOpportunityId 
                                                           OR Unit__c IN : setOfUnitId ];
            if(lstMarketingDetail!=Null && !lstMarketingDetail.isEmpty()){
                for(Marketing_Detail__c eachMarketingDetail : lstMarketingDetail){
                   mapOfAccountIdVsMarketingDetail.put(eachMarketingDetail.Account__c,eachMarketingDetail);
                }
            }*/
        
            for(Marketing_Detail__c eachMarketingDetail : triggerNew ){
                system.debug('eachMarketingDetail'+eachMarketingDetail.Unit__c);
                system.debug('eachMarketingDetail'+eachMarketingDetail.Account__c);
                system.debug('mapOfAccountIdVsLstMarketingDetail.get(eachMarketingDetail.Account__c):'+mapOfAccountIdVsLstMarketingDetail.get(eachMarketingDetail.Account__c));
                if(string.isNotBlank(eachMarketingDetail.Account__c) && 
                   string.isBlank(eachMarketingDetail.Updated_From__c )&&
                   mapOfAccountIdVsLstMarketingDetail.get(eachMarketingDetail.Account__c)!=null && 
                   !mapOfAccountIdVsLstMarketingDetail.get(eachMarketingDetail.Account__c).isempty()){
                       staticVariable.UpdatedFromObject='Account';
                       for(Marketing_Detail__c eachMarketingDetail1 : mapOfAccountIdVsLstMarketingDetail.get(eachMarketingDetail.Account__c)){
                         	eachMarketingDetail1.Marketed_On_Construction_Equip_Guide__c = eachMarketingDetail.Marketed_On_Construction_Equip_Guide__c;
                            eachMarketingDetail1.Marketed_On_Craigslist__c = eachMarketingDetail.Marketed_On_Craigslist__c ;
                            eachMarketingDetail1.Marketed_On_Facebook__c = eachMarketingDetail.Marketed_On_Facebook__c ;
                            eachMarketingDetail1.Marketed_On_FB_Marketplace__c = eachMarketingDetail.Marketed_On_FB_Marketplace__c;
                            eachMarketingDetail1.Marketed_On_Fleet_Up_Marketplace__c = eachMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c;
                            eachMarketingDetail1.Marketed_On_GearFlow__c = eachMarketingDetail.Marketed_On_GearFlow__c;
                            eachMarketingDetail1.Marketed_On_Instagram__c = eachMarketingDetail.Marketed_On_Instagram__c;
                            eachMarketingDetail1.Marketed_On_LinkedIn__c = eachMarketingDetail.Marketed_On_LinkedIn__c;
                            eachMarketingDetail1.Marketed_On_Machinio__c = eachMarketingDetail.Marketed_On_Machinio__c;
                            eachMarketingDetail1.Marketed_On_Mascus__c = eachMarketingDetail.Marketed_On_Mascus__c;
                            eachMarketingDetail1.Marketed_on_MT_Crane_Truck__c =eachMarketingDetail.Marketed_on_MT_Crane_Truck__c;
                            eachMarketingDetail1.Marketed_On_MyLittleSalesman__c = eachMarketingDetail.Marketed_On_MyLittleSalesman__c;
                            eachMarketingDetail1.Marketed_On_Terrapoint__c = eachMarketingDetail.Marketed_On_Terrapoint__c ;
                            eachMarketingDetail1.Marketed_On_TradeMachines__c =eachMarketingDetail.Marketed_On_TradeMachines__c;
                            eachMarketingDetail1.Marketed_On_Used_Equip_Guide__c = eachMarketingDetail.Marketed_On_Used_Equip_Guide__c;
                            eachMarketingDetail1.Marketed_On_Zonapesada__c = eachMarketingDetail.Marketed_On_Zonapesada__c;
                            eachMarketingDetail1.Do_not_market_anywhere__c =eachMarketingDetail.Do_not_market_anywhere__c;
                        	lstMarketingDetailToUpdate.add(eachMarketingDetail1);
                       }
                       
                   }else if(string.isNotBlank(eachMarketingDetail.Opportunity__c)&& 
                            string.isBlank(eachMarketingDetail.Updated_From__c )&&
                   mapOfOpportunityIdVsUnitId.get(eachMarketingDetail.Opportunity__c)!=null && 
                   mapOfUnitIdVsLstMarketingDetail.get(mapOfOpportunityIdVsUnitId.get(eachMarketingDetail.Opportunity__c)) !=null &&
                   !mapOfUnitIdVsLstMarketingDetail.get(mapOfOpportunityIdVsUnitId.get(eachMarketingDetail.Opportunity__c)).isempty()){
                       staticVariable.UpdatedFromObject='Opportunity';
                       for(Marketing_Detail__c eachMarketingDetail1 : mapOfUnitIdVsLstMarketingDetail.get(mapOfOpportunityIdVsUnitId.get(eachMarketingDetail.Opportunity__c))){
                         	eachMarketingDetail1.Marketed_On_Construction_Equip_Guide__c = eachMarketingDetail.Marketed_On_Construction_Equip_Guide__c;
                            eachMarketingDetail1.Marketed_On_Craigslist__c = eachMarketingDetail.Marketed_On_Craigslist__c ;
                            eachMarketingDetail1.Marketed_On_Facebook__c = eachMarketingDetail.Marketed_On_Facebook__c ;
                            eachMarketingDetail1.Marketed_On_FB_Marketplace__c = eachMarketingDetail.Marketed_On_FB_Marketplace__c;
                            eachMarketingDetail1.Marketed_On_Fleet_Up_Marketplace__c = eachMarketingDetail.Marketed_On_Fleet_Up_Marketplace__c;
                            eachMarketingDetail1.Marketed_On_GearFlow__c = eachMarketingDetail.Marketed_On_GearFlow__c;
                            eachMarketingDetail1.Marketed_On_Instagram__c = eachMarketingDetail.Marketed_On_Instagram__c;
                            eachMarketingDetail1.Marketed_On_LinkedIn__c = eachMarketingDetail.Marketed_On_LinkedIn__c;
                            eachMarketingDetail1.Marketed_On_Machinio__c = eachMarketingDetail.Marketed_On_Machinio__c;
                            eachMarketingDetail1.Marketed_On_Mascus__c = eachMarketingDetail.Marketed_On_Mascus__c;
                            eachMarketingDetail1.Marketed_on_MT_Crane_Truck__c =eachMarketingDetail.Marketed_on_MT_Crane_Truck__c;
                            eachMarketingDetail1.Marketed_On_MyLittleSalesman__c = eachMarketingDetail.Marketed_On_MyLittleSalesman__c;
                            eachMarketingDetail1.Marketed_On_Terrapoint__c = eachMarketingDetail.Marketed_On_Terrapoint__c ;
                            eachMarketingDetail1.Marketed_On_TradeMachines__c =eachMarketingDetail.Marketed_On_TradeMachines__c;
                            eachMarketingDetail1.Marketed_On_Used_Equip_Guide__c = eachMarketingDetail.Marketed_On_Used_Equip_Guide__c;
                            eachMarketingDetail1.Marketed_On_Zonapesada__c = eachMarketingDetail.Marketed_On_Zonapesada__c;
                            eachMarketingDetail1.Do_not_market_anywhere__c =eachMarketingDetail.Do_not_market_anywhere__c;
                        	lstMarketingDetailToUpdate.add(eachMarketingDetail1);
                       }
                       //eachMarketingDetail.Updated_From__c = 'Opportunity';
                       
                   }else if(string.isNotBlank(eachMarketingDetail.Unit__c)&&
                            string.isNotBlank(eachMarketingDetail.Updated_From__c )&&
                            !string.isNotBlank(staticVariable.UpdatedFromObject)){
                       staticVariable.UpdatedFromObject='Manually';         
                       eachMarketingDetail.Updated_From__c = 'Manually';
                                
                   }
            }
           /* if(mapOfAccountIdVsLstMarketingDetail.KeySet()!=null && !mapOfAccountIdVsLstMarketingDetail.KeySet().isempty()){
                for(id eachId : mapOfAccountIdVsLstMarketingDetail.KeySet()){
                    if(mapOfAccountIdVsLstMarketingDetail.get(eachId)!= null && !mapOfAccountIdVsLstMarketingDetail.get(eachId).isEmpty()){
                        system.debug('mapOfAccountIdVsLstMarketingDetail.get(eachId)'+mapOfAccountIdVsLstMarketingDetail.get(eachId));
                        lstMarketingDetailToUpdate.addAll(mapOfAccountIdVsLstMarketingDetail.get(eachId));
                    }
                }
            }
            if(mapOfUnitIdVsLstMarketingDetail.KeySet()!=null && !mapOfUnitIdVsLstMarketingDetail.KeySet().isempty()){
                for(id eachId : mapOfUnitIdVsLstMarketingDetail.KeySet()){
                    if(mapOfUnitIdVsLstMarketingDetail.get(eachId)!= null && !mapOfUnitIdVsLstMarketingDetail.get(eachId).isEmpty()){
                        system.debug('mapOfUnitIdVsLstMarketingDetail.get(eachId)'+mapOfUnitIdVsLstMarketingDetail.get(eachId));
                        lstMarketingDetailToUpdate.addAll(mapOfUnitIdVsLstMarketingDetail.get(eachId));
                    }
                }
            }*/
            if(lstMarketingDetailToUpdate!=null && !lstMarketingDetailToUpdate.isempty()){
                system.debug('lstMarketingDetailToUpdate'+lstMarketingDetailToUpdate);
                system.debug('lstMarketingDetailToUpdate'+lstMarketingDetailToUpdate.size());
                update lstMarketingDetailToUpdate;
                staticVariable.UpdatedFromObject='';
            }
        }
    }
}