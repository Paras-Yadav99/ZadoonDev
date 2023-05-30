public class LeadTriggerHandler implements ITriggerHandler{
    private static final string DEVELOPER_NAME = 'lead';
     public Trigger_Setting__mdt setTriggerSettings() {
       
        
        return [select Active__c,Max_Loop_Count__c,Stop_Recursion__c FROM Trigger_Setting__mdt 
                Where DeveloperName=:DEVELOPER_NAME LIMIT 1];
    
    } 
    
    Public void beforeInsert(List<SObject> triggerNew){
        
            handleBeforeInsert((list<Lead>)triggerNew);
           
    }
    //By implementing this method trigger can handle all the before Update events
    Public void beforeUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){
       handleBeforeUpdate((list<Lead>)triggerNew,
                          (Map<Id,Lead>)triggerOldMap);
        
        
    }
    //By implementing this method trigger can handle all the before Delete events
    Public void beforeDelete(List<SObject> triggerOld){
        
    }   
    //By implementing this method trigger can handle all the after Insert events
    Public void afterInsert(List<SObject> triggerNew){
        HandleIronDemandOnInsert((list<Lead>)triggerNew);
        //It will calulate the no of lead under that unit.
        CalculateNoOfLeads(triggerNew);
    }
    //By implementing this method trigger can handle all the after Update events
    Public void afterUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap){
        HandleIronDemandCreationOnUpdate((list<Lead>)triggerNew,
                                        	(Map<Id,Lead>)triggerOldMap);
        
        handleNoOfActiveLeadOnUpdate((list<Lead>)triggerNew,
                                    (Map<Id,Lead>)triggerOldMap);
        
        
    }
    //By implementing this method trigger can handle all the after Delte events
    Public void afterDelete(List<SObject> triggerOld){
        CalculateNoOfLeads(triggerOld);
    }
    //By implementing this method trigger can handle all the after UnDelete events
    Public void afterUndelete(List<SObject> triggerNew){
        //It will calulate the no of lead under that unit.
        CalculateNoOfLeads(triggerNew);
    }
    //If international leads are misrouted to a domestic rep, 
    //we should have a trigger by which they can put the list into the international round-robin 
    /*private static void handleRoundRobinBeforeUpdate(
    	List<lead> triggerNew, 
        Map<Id, lead> triggerOldMap
    ){
        for(Lead eachLead : triggerNew){
            
        }
    }*/
    private static void CalculateNoOfLeads(
        List<Lead> leads
    ){
        set<id> setOfUnitId = new set<id>();
        if(leads!=null && !leads.isEmpty()){
            for(lead eachLead : leads){
                if(string.isNotBlank( eachLead.Unit__c)){
                    setOfUnitId.add(eachLead.Unit__c);
                }
            }
        }
        if(setOfUnitId!=null && !setOfUnitId.isEmpty()){
            list<Product2>lstUnit = [SELECT id, name, 
                                        Number_of_Active_leads__c, 
                                        (SELECT id,Name FROM Leads__r WHERE Status!='Unqualified' AND IsConverted !=True) 
                                        FROM Product2 
                                        WHERE id IN :setOfUnitId];
            
            
            if(lstUnit != null && !lstUnit.isempty()){
                for(Product2 eachUnit : lstUnit){
                    eachUnit.Number_of_Active_leads__c = eachUnit.Leads__r.size();
                }
            }
            if(lstUnit != null && lstUnit.size()>0){    
                update lstUnit;
                
            }
        }
    }
    private static void HandleIronDemandOnInsert(
        List<Lead> leads
    ){
        set<Id>setOfLeadId = new set<Id>();
        set<Id>setOfContactId = new set<Id>();
        set<Id> setOfEquipmemtId = new set<Id>();
        List<Lead> filteredLeads = new List<Lead>();
        //Map<string,Lead> mapOfStringVsLead = new map<string,Lead>(); 
        map<string, Iron_Demand__c> mapOfStringVsIronDemand = new map<string,Iron_Demand__c>();
        for(Lead ld : leads){
            if(ld.Contact__c != null && ld.Unit__c != null){
                //filteredLeads.add(ld);
                setOfContactId.add(ld.Contact__c);
                setOfLeadId.add(ld.id);
                
            }
        }
        
        list<Lead> lstLead = [SELECT id,
                              Contact__c,
                              Unit__c, 
                              unit__r.equipment__c FROM
                               lead WHERE 
                              id IN :setOfLeadId ];
        
        if(lstLead!=null && !lstLead.isEmpty()){
            for(lead eachLead :lstLead ){
                
                setOfEquipmemtId.add(eachLead.unit__r.equipment__c);
            }
        }
        
        list<Iron_Demand__c> lstIronDemand = [SELECT Id,
                                              IronDemand_Contact__c,
                                              IronDemand_Iron__c 
                                              FROM Iron_Demand__c 
                                              WHERE IronDemand_Contact__c IN : setOfContactId 
                                              AND IronDemand_Iron__c IN :setOfEquipmemtId];
        
        if(lstIronDemand!=null && !lstIronDemand.isEmpty()){
            for(Iron_Demand__c eachIronDemand : lstIronDemand){
                string IronDemandcontactIdEquipmentID;
                IronDemandcontactIdEquipmentID = String.valueOf(eachIronDemand.IronDemand_Contact__c) + String.valueOf(eachIronDemand.IronDemand_Iron__c);
                
                mapOfStringVsIronDemand.put(IronDemandcontactIdEquipmentID,eachIronDemand);
            }
            
        }
        
        if(lstLead!=null && !lstLead.isEmpty()){
            for(lead eachLead : lstLead){
                string contactIdEquipmentID;
                contactIdEquipmentID = String.valueOf(eachLead.Contact__c) + String.valueOf(eachLead.unit__r.equipment__c);
                
                if(!mapOfStringVsIronDemand.containsKey(contactIdEquipmentID)){
                    filteredLeads.add(eachLead);
                }
            }
        }
        
        if(filteredLeads.size()> 0){
            createIronDemandsFromLeads(filteredLeads);
        }
    }
    /*private static void HandleIronDemandOnInsert(
        List<Lead> leads
    ){
        List<Lead> filteredLeads = new List<Lead>();
        for(Lead ld : leads){
            if(ld.Contact__c != null && ld.Unit__c != null){
                filteredLeads.add(ld);
            }
        }
        if(filteredLeads.size()> 0){
            createIronDemandsFromLeads(filteredLeads);
        }
    }*/
    public static void HandleIronDemandCreationOnUpdate(
        List<Lead> leads,
        Map<Id, Lead> oldLeadMap){
        set<Id>setOfLeadId = new set<Id>();
        set<Id>setOfContactId = new set<Id>();
        set<Id> setOfEquipmemtId = new set<Id>();
        set<Id> setOfUnitId = new set<Id>();
        List<Lead> filteredLeads = new List<Lead>();
        map<string, Iron_Demand__c> mapOfStringVsIronDemand = new map<string,Iron_Demand__c>();
        for(Lead ld : leads){
            if(ld.Contact__c != null && ld.Unit__c != null){
                Lead oldLead = oldLeadMap.get(ld.Id);
                if((hasContactChanged(ld, oldLead) || 
                    hasUnitChanged(ld, oldLead))){
                    setOfContactId.add(ld.Contact__c);
                	setOfLeadId.add(ld.id);
                    
                    //filteredLeads.add(ld);
                }
            }
        }
        list<Lead> lstLead = [SELECT id,
                              Contact__c,
                              Unit__c, 
                              unit__r.equipment__c FROM
                               lead WHERE 
                              id IN :setOfLeadId ];
        
        if(lstLead!=null && !lstLead.isEmpty()){
            for(lead eachLead :lstLead ){
                
                setOfEquipmemtId.add(eachLead.unit__r.equipment__c);
            }
        }
        if((setOfContactId!=null && !setOfContactId.isEmpty())&& 
           ((setOfEquipmemtId!=null && !setOfEquipmemtId.isEmpty()))){
               list<Iron_Demand__c> lstIronDemand = [SELECT Id,
                                                  IronDemand_Contact__c,
                                                  IronDemand_Iron__c 
                                                  FROM Iron_Demand__c 
                                                  WHERE IronDemand_Contact__c IN : setOfContactId 
                                                  AND IronDemand_Iron__c IN :setOfEquipmemtId];
            
            if(lstIronDemand!=null && !lstIronDemand.isEmpty()){
                for(Iron_Demand__c eachIronDemand : lstIronDemand){
                    string IronDemandcontactIdEquipmentID;
                    IronDemandcontactIdEquipmentID = String.valueOf(eachIronDemand.IronDemand_Contact__c) + String.valueOf(eachIronDemand.IronDemand_Iron__c);
                    
                    mapOfStringVsIronDemand.put(IronDemandcontactIdEquipmentID,eachIronDemand);
                }
                
            }
        }
        if(lstLead!=null && !lstLead.isEmpty()){
            for(lead eachLead : lstLead){
                string contactIdEquipmentID;
                contactIdEquipmentID = String.valueOf(eachLead.Contact__c) + String.valueOf(eachLead.unit__r.equipment__c);
                
                if(!mapOfStringVsIronDemand.containsKey(contactIdEquipmentID)){
                    filteredLeads.add(eachLead);
                }
            }
        }
        
        if(filteredLeads.size()> 0){
            createIronDemandsFromLeads(filteredLeads);
        }
            
    }

    private static void createIronDemandsFromLeads(
        List<Lead> leads
    ){
        List<Iron_Demand__c> ironDemandsToInsert = new List<Iron_Demand__c>();
        Map<Id, Product2> leadIdToUnitMap = new Map<Id, Product2>();
        Set<Id> unitIds = new Set<Id>();
        for(Lead lead : leads){
            unitIds.add(lead.Unit__c);
        }
        Map<Id, Product2> unitMap = new Map<Id, Product2>([SELECT Id, Equipment__c FROM Product2 WHERE Id IN :unitIds]);
        
        for(Lead lead : leads){
            if(unitMap.get(lead.Unit__c) != null){
                leadIdToUnitMap.put(lead.Id, unitMap.get(lead.Unit__c));
            }
        }
        for(Lead lead : leads){
            Iron_Demand__c ironDemand = new Iron_Demand__c();
            ironDemand.IronDemand_Contact__c = lead.Contact__c;
            if(leadIdToUnitMap.get(lead.Id) != null && leadIdToUnitMap.get(lead.Id).Equipment__c != null){
                ironDemand.IronDemand_Iron__c = leadIdToUnitMap.get(lead.Id).Equipment__c;
                ironDemandsToInsert.add(ironDemand);
            }
        }
		
        if(ironDemandsToInsert.size() > 0){
            Database.insert(ironDemandsToInsert);
        }
    }

    private static Boolean hasContactChanged(
        Lead newLead, Lead oldLead
    ){
        return hasValueChanged(
            newLead.Contact__c,
            oldLead.Contact__c
        );
    }
    private static Boolean hasRegionChanged(
        Lead newLead, Lead oldLead
    ){
        return hasValueChanged(
            newLead.Region__c,
            oldLead.Region__c
        );
    }
    private static Boolean hasMobileNumberChanged(
        Lead newLead, Lead oldLead
    ){
        return hasValueChanged(
            newLead.MobilePhone,
            oldLead.MobilePhone
        );
    }
    private static Boolean hasOwnerChanged(
        Lead newLead, Lead oldLead
    ){
        return hasValueChanged(
            newLead.OwnerId,
            oldLead.OwnerId
        );
    }
	
    private static Boolean hasUnitChanged(
        Lead newLead, Lead oldLead
    ){
        return hasValueChanged(
            newLead.Unit__c,
            oldLead.Unit__c
        );
    }
	private static Boolean hasStatusChanged(
    Lead newLead, Lead oldLead
    ){
       	return hasValueChanged(
            newLead.status,
            oldLead.status
        ); 
    }
    private static Boolean hasValueChanged(Object newValue, Object oldValue){
        return newValue != oldValue;
    }
    
    
    private static void handleBeforeInsert(List<Lead> triggerNew){
        set<String> setOfLeadSource = new set<String>();
        string leadSourceValues = System.Label.Lead_Source_For_Round_Robin;
        if(string.isNotBlank(leadSourceValues)){
			list<String> lstString = leadSourceValues.split(',');
            
            setOfLeadSource.addAll(lstString);            
        }
        if(triggerNew!=null && !triggerNew.isEmpty() ){
            list<Lead> lstLead = new list<Lead>();
            set<string> setOfEmailId = new set<string>();
            set<string> setOfMobilePhone = new set<string>();
            set<String> setOfCompanyName = new set<String>();
            list<Opportunity> lstOpportunity = new list<Opportunity>();
            set<Id> setOfOwnerId =new set<Id> ();
            list<Team_Member__c> lstActiveTeamMember;
            map<id,Team_Member__c>mapOfActiveUserVsTeamMember = new map<id,Team_Member__c>();
            map<string,Team_Member__c>mapOfActiveUserRegionVsTeamMember = new map<string,Team_Member__c>();
            //list<Team_Member__c> lstTeamMemberAssignToSameUser;
            //map<id,Team_Member__c>mapOfUserVsTeamMember = new map<id,Team_Member__c>();
            list<lead>lstLeadFromSystem = new list<lead>();
            map<String,list<Lead>> mapOfEmailVsLeads = new map<String,list<Lead>>();
            map<String,list<Lead>> mapOfCompanyVsLeads = new map<String,list<Lead>>();
            map<String,list<Opportunity>> mapOfCompanyVsOpportunity = new map<String,list<Opportunity>>();
            map<String,list<Lead>> mapOfMobilePhoneVsLeads = new map<String,list<Lead>>();
            list<Lead> lstLeadAssignToSameUser = new list<Lead>();
            list<account> lstAccount = new list<Account>();
            for(lead eachLead : triggerNew){
                if(setOfLeadSource.contains(eachLead.LeadSource)){    
                	if(string.isNotBlank(eachLead.MobilePhone)){
                        setOfMobilePhone.add(eachLead.MobilePhone);
                    }
                    if(string.isNotBlank(eachLead.Email)){
                        setOfEmailId.add(eachLead.Email);
                    }
                    if(string.isNotBlank(eachLead.Company)){
                        setOfCompanyName.add(eachLead.Company);
                    }
                }
            }
            lstActiveTeamMember = [SELECT Id,
                                           Capacity__c,
                                           Counter__c,
                                           User__c,
                                   		   Active__c,
                                           Sales_Team__r.Region__c,
                                           Sales_Team__c FROM 
                                           Team_Member__c WHERE 
                                  			Active__c=true];
            if(lstActiveTeamMember!=null && !lstActiveTeamMember.isEmpty()){
                for(Team_Member__c eachTeamMember :lstActiveTeamMember){
                    string userRegion= eachTeamMember.User__c + eachTeamMember.Sales_Team__r.Region__c;
                    mapOfActiveUserRegionVsTeamMember.put(userRegion,eachTeamMember);
                   	mapOfActiveUserVsTeamMember.put(eachTeamMember.User__c,eachTeamMember);
                }
            }
            
            if(((setOfMobilePhone!=null && 
                	!setOfMobilePhone.isEmpty()) || 
               (setOfEmailId !=null && 
               		!setOfEmailId.isEmpty()) || 
               (setOfCompanyName!=null && 
               		!setOfCompanyName.isEmpty())
              )&& (mapOfActiveUserVsTeamMember.Keyset()!=null &&
                  !mapOfActiveUserVsTeamMember.Keyset().isEmpty())  ){
					lstLeadFromSystem = [SELECT id,
                                           MobilePhone,
                                           Email,
                                           OwnerId,
                                           Status,
                                           Company,
                                           Region__c FROM 
                                           lead WHERE isConverted = false AND 
                                           Status!='Qualified' AND	
                                           OwnerId IN : mapOfActiveUserVsTeamMember.Keyset() AND
                                           (MobilePhone IN :setOfMobilePhone OR 
                                           Email IN : setOfEmailId OR 
                                           Company IN : setOfCompanyName)
                                           Order by LastModifiedDate desc ];   
                  
              }
            
            if(setOfCompanyName!=null && !setOfCompanyName.isEmpty()){
                lstAccount = [SELECT id, 
                                      Name,
                                      (SELECT Id,OwnerId, Name ,RecordTypeId
                                               FROM Opportunities 
                                               WHERE 
                                       		   (RecordTypeId =: getRecordTypeId(System.Label.Opp_Rec_Type_Broker_Sell) OR
                                                RecordTypeId =: getRecordTypeId(System.Label.Opp_Rec_Type_Inventory_Sell)) AND 
                                       			OwnerId IN : mapOfActiveUserVsTeamMember.Keyset()
                                               Order by LastModifiedDate asc) FROM 
                                      Account WHERE 
                                      Name IN : setOfCompanyName 
                                      Order by LastModifiedDate desc];  
            }
            
            if(lstAccount!=null && !lstAccount.isEmpty()){
                for(account eachAccount :lstAccount){
                    
                    if(eachAccount.Opportunities!=null && !eachAccount.Opportunities.isEmpty()){
                        for(Opportunity eachOpportunity : eachAccount.Opportunities ){
                            setOfOwnerId.add(eachOpportunity.OwnerId);
                            if(!mapOfCompanyVsOpportunity.containsKey(eachAccount.Name)){
                                mapOfCompanyVsOpportunity.put(eachAccount.Name,new list<Opportunity>());
                                mapOfCompanyVsOpportunity.get(eachAccount.Name).add(eachOpportunity);
                            }else 
                                mapOfCompanyVsOpportunity.get(eachAccount.Name).add(eachOpportunity);
                            }
                    }
                }
            }
           
            if(lstLeadFromSystem!=null && ! lstLeadFromSystem.isEmpty()){
                for(lead eachLead : lstLeadFromSystem){
                    setOfOwnerId.add(eachLead.OwnerId);
                    
                    if(string.isNotBlank(eachLead.MobilePhone)){
                        if(!mapOfMobilePhoneVsLeads.containsKey(eachLead.MobilePhone)){
                            mapOfMobilePhoneVsLeads.put(eachLead.MobilePhone,new list<Lead>());
                            mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone).add(eachLead);
                        }else 
                            mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone).add(eachLead);
                    }
                    
                    if(string.isNotBlank(eachLead.Email)){
                        if(!mapOfEmailVsLeads.containsKey(eachLead.Email)){
                            mapOfEmailVsLeads.put(eachLead.Email,new list<Lead>());
                            mapOfEmailVsLeads.get(eachLead.Email).add(eachLead);
                        }else 
                            mapOfEmailVsLeads.get(eachLead.Email).add(eachLead);
                    }
                    if(string.isNotBlank(eachLead.Company)){
                        if(!mapOfCompanyVsLeads.containsKey(eachLead.Company)){
                            mapOfCompanyVsLeads.put(eachLead.Company,new list<Lead>());
                            mapOfCompanyVsLeads.get(eachLead.Company).add(eachLead);
                        }else 
                            mapOfCompanyVsLeads.get(eachLead.Company).add(eachLead);
                    }
                }
            }
           
            /*
            if(setOfOwnerId!=null && !setOfOwnerId.isEmpty()){
                lstTeamMemberAssignToSameUser = [SELECT Id,
                                                 Capacity__c,
                                                 Counter__c,
                                                 User__c,
                                                 Sales_Team__r.Region__c,
                                                 Sales_Team__c FROM 
                                                 Team_Member__c WHERE
                                                 User__c IN : setOfOwnerId];
            
                
                if(lstTeamMemberAssignToSameUser!=null && !lstTeamMemberAssignToSameUser.isEmpty()){
                    for(Team_Member__c eachTeamMember :lstTeamMemberAssignToSameUser){
                        mapOfUserVsTeamMember.put(eachTeamMember.User__c,eachTeamMember);
                    }
                }
            }*/
            for(lead eachLead : triggerNew){
                if(setOfLeadSource.contains(eachLead.LeadSource)&& 
                   eachLead.Region__c != 'Manual'){    
                	      
                    if(!((mapOfEmailVsLeads.get(eachLead.Email)!=null && !mapOfEmailVsLeads.get(eachLead.Email).isEmpty()) || 
                         (mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)!= null && !mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone).isEmpty()) ||
                         (mapOfCompanyVsLeads.get(eachLead.Company)!=null && !mapOfCompanyVsLeads.get(eachLead.Company).isEmpty()) || 
                        (mapOfCompanyVsOpportunity.get(eachLead.Company)!=null && !mapOfCompanyVsOpportunity.get(eachLead.Company).isEmpty()))
                         
                      ){
                        if(eachLead.LeadSource == 'Call Back'){
                            eachLead.Region__c = 'Domestic';
                            lstLead.add(eachLead);
                        }else if (string.isNotBlank(eachLead.MobilePhone) 
                           && string.isBlank(eachLead.Region__c) 
                           
                           ){
                           
                            if((eachLead.MobilePhone).startsWith('+1') ){
                                eachLead.Region__c = 'Domestic';//DOMESTIC
                                
                            }else {
                                eachLead.Region__c = 'International';//INTERNATIONAL
                            }
                            lstLead.add(eachLead);        
                        }else if(string.isNotBlank(eachLead.Region__c)
                                && string.isBlank(eachLead.MobilePhone)){
                            lstLead.add(eachLead);
                                    
                        }else if(string.isBlank(eachLead.Region__c) 
                                    && string.isBlank(eachLead.MobilePhone)
                                ){
                                    eachLead.Region__c = 'DOMESTIC';
                                    lstLead.add(eachLead);
                                }
                    /*else {
                        eachLead.Region__c = 'Not Lead';//Not Lead
                    }*/
                      }else{
                          lstLeadAssignToSameUser.add(eachLead);
                      }
                }
            }
           
            if(lstLead!=null && !lstLead.isEmpty()){
                
                list<Team_Member__c> lstTeamMember = RoundRobinHandler.RoundRobin(lstLead,
                                                                               'Sales_Team__r',
                                                                               'Team_Member__c',
                                                                               'Region__c',
                                                                               'OwnerId',
                                                                               'User__c');
               
                if(lstTeamMember!=null && !lstTeamMember.isEmpty()){
                    update lstTeamMember;
                }
            }
            
            if(lstLeadAssignToSameUser!=null && !lstLeadAssignToSameUser.isEmpty()){
                
                list<Team_Member__c>lstTeamMemberToUpdate =leadTriggerHandler.assignLeadToPreviousUser(
                                                                           	lstLeadAssignToSameUser,
                                                                            mapOfEmailVsLeads,
                                                                            mapOfMobilePhoneVsLeads,
                    														mapOfCompanyVsLeads,
                                                                            mapOfActiveUserVsTeamMember,
                    														mapOfCompanyVsOpportunity
                															);
                
                if(lstTeamMemberToUpdate!=null && !lstTeamMemberToUpdate.isEmpty()){
                    update lstTeamMemberToUpdate;
                }
            }
            
        }
    }
    
    private static void handleBeforeUpdate(
                                            List<Lead> leads,
                                            Map<Id, Lead> oldLeadMap){
        string leadSourceValues = System.Label.Lead_Source_For_Round_Robin;
        set<String> setOfLeadSource = new set<String>();
        
		if(string.isNotBlank(leadSourceValues)){
		
            list<String> lstString = leadSourceValues.split(',');
            
            setOfLeadSource.addAll(lstString);            
        }
                                                
        List<Lead> lstLeadForRoundRobin = new List<Lead>();
        set<Id> setOfOwnerId = new set<Id>();
        set<String> setOfRegion = new set<string>();
        map<String,list<lead>> mapOfOwnerAndRegionVsLead = new map<String,list<lead>>();
        //set<string> setOfMobilePhone = new set<string>();
        //map<String,list<Lead>> mapOfMobilePhoneVsLeads = new map<String,list<Lead>>();
        //map<String,list<Lead>> mapOfCompanyVsLeads = new map<String,list<Lead>>();                                        
        list<Team_Member__c> lstTeamMemberAssignToSameUser;
        //map<id,Team_Member__c>mapOfUserVsTeamMember = new map<id,Team_Member__c>(); 
		//map<String,list<Lead>> mapOfEmailVsLeads = new map<String,list<Lead>>();                                                
		//list<Lead> lstPreviousLead = new list<Lead>(); 
        list<lead>lstLeadToChangeOwner = new list<Lead>();                                        
        /*for(Lead eachLead : leads){
           	Lead oldLead = oldLeadMap.get(eachLead.Id);
            if(hasMobileNumberChanged(eachLead, oldLead)&& 
           		string.isNotBlank(eachLead.MobilePhone)&& 
              	eachLead.Region__c !='Manual' && 
              	setOfLeadSource.contains(eachLead.LeadSource)
              ){
               	setOfMobilePhone.add(eachLead.MobilePhone);
              }
        }   */                                  
        /*if(setOfMobilePhone!=null && !setOfMobilePhone.isempty()){
          	lstPreviousLead = [SELECT id,
                               MobilePhone,
                               Email,
                               OwnerId,
                               Region__c FROM 
                               lead WHERE 
                               MobilePhone IN :setOfMobilePhone 
                               Order by LastModifiedDate desc ];                                         
        }  */
		/*if(lstPreviousLead!=null && ! lstPreviousLead.isEmpty()){
            for(lead eachLead : lstPreviousLead){
                setOfOwnerId.add(eachLead.OwnerId);
                
                if(string.isNotBlank(eachLead.MobilePhone)){
                    if(!mapOfMobilePhoneVsLeads.containsKey(eachLead.MobilePhone)){
                        mapOfMobilePhoneVsLeads.put(eachLead.MobilePhone,new list<Lead>());
                    }else 
                        mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone).add(eachLead);
                }
            }
        }*/
        /*    if(setOfOwnerId!=null && !setOfOwnerId.isEmpty()){
                lstTeamMemberAssignToSameUser = [SELECT Id,
                                                 Capacity__c,
                                                 Counter__c,
                                                 User__c,
                                                 Sales_Team__r.Region__c,
                                                 Sales_Team__c FROM 
                                                 Team_Member__c WHERE
                                                 User__c IN : setOfOwnerId];
                
                if(lstTeamMemberAssignToSameUser!=null && !lstTeamMemberAssignToSameUser.isEmpty()){
                    for(Team_Member__c eachTeamMember :lstTeamMemberAssignToSameUser){
                        mapOfUserVsTeamMember.put(eachTeamMember.User__c,eachTeamMember);
                    }
                }
            }*/                                              
       	for(Lead eachLead : leads){
            if(eachLead.Region__c !='Manual' && 
               setOfLeadSource.contains(eachLead.LeadSource)){
                Lead oldLead = oldLeadMap.get(eachLead.Id);
                if(hasRegionChanged(eachLead, oldLead)&& 
                        string.isNotBlank(eachLead.Region__c)
                ){
                    lstLeadForRoundRobin.add(eachLead);
                } /*else if(hasMobileNumberChanged(eachLead, oldLead) && 
                   string.isNotBlank(eachLead.MobilePhone)
                  ){
                      if(!(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)!= null
                           && !mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone).isEmpty())
                           ){
                               if((eachLead.MobilePhone).startsWith('+1') ){
                                   eachLead.Region__c = 'Domestic';//DOMESTIC
                                   
                               }else {
                                   eachLead.Region__c = 'International';//INTERNATIONAL
                               }
                               
                               lstLeadForRoundRobin.add(eachLead);
                           }else{
                               lstLeadToChangeOwner.add(eachLead);
                           }
                      
                
                  }*/
                
            }
        }
       
        list<Team_Member__c> lstTeamMember = RoundRobinHandler.RoundRobin(lstLeadForRoundRobin,
																				   'Sales_Team__r',
                                                                                   'Team_Member__c',
                                                                                   'Region__c',
                                                                                   'OwnerId',
                                                                                   'User__c'); 
        if(lstTeamMember!=null && !lstTeamMember.isEmpty()){
 
            update lstTeamMember;
        }
                                                
        
        /*if(lstLeadToChangeOwner!=null && !lstLeadToChangeOwner.isEmpty()){
            list<Team_Member__c>lstTeamMemberToUpdate =leadTriggerHandler.assignLeadToPreviousUser(
                                                                                                    lstLeadToChangeOwner,
                                                                                                    mapOfEmailVsLeads,
                                                                                                    mapOfMobilePhoneVsLeads,
                                                                                                    mapOfCompanyVsLeads,
                                                                                                    mapOfUserVsTeamMember);
           
            if(lstTeamMemberToUpdate!=null && !lstTeamMemberToUpdate.isEmpty()){
                update lstTeamMemberToUpdate;
            }
        } */   
        for(Lead eachLead : leads){
        	Lead oldLead = oldLeadMap.get(eachLead.Id);
            string ownerAndRegion;
            if(hasOwnerChanged(eachLead, oldLead) && hasRegionChanged(eachLead, oldLead)&& string.isNotBlank(eachLead.Region__c)){
                setOfOwnerId.add(oldLead.OwnerId);
                setOfRegion.add(oldLead.Region__c);
                ownerAndRegion = oldLead.OwnerId + oldLead.Region__c;
                
                if(!mapOfOwnerAndRegionVsLead.containsKey(ownerAndRegion)){
                    mapOfOwnerAndRegionVsLead.put(ownerAndRegion, new list<Lead>());
                    mapOfOwnerAndRegionVsLead.get(ownerAndRegion).add(eachLead);
                }
                mapOfOwnerAndRegionVsLead.get(ownerAndRegion).add(eachLead);
            }
        }                                  
        list<Team_Member__c> lstMemberToUpdate = new list<Team_Member__c>();  
        if((setOfRegion!=null && !setOfRegion.isEmpty()) && 
            (setOfOwnerId!=null && !setOfOwnerId.isEmpty())){
            list<Team_Member__c> lstMember = [SELECT counter__c, 
                                          		user__c,
                                          		Sales_Team__r.Region__c
                                          		FROM Team_Member__c 
                                          		WHERE Sales_Team__r.Region__c IN :setOfRegion 
                                          		AND user__c IN : setOfOwnerId];
    
            if(lstMember!=null && !lstMember.isEmpty()){
                for(Team_Member__c eachTeamMember : lstMember){
                    string ownerAndRegion;
                    ownerAndRegion = eachTeamMember.user__c + eachTeamMember.Sales_Team__r.Region__c;
                    if(mapOfOwnerAndRegionVsLead.get(ownerAndRegion)!=null && !mapOfOwnerAndRegionVsLead.get(ownerAndRegion).isEmpty()){
                        eachTeamMember.Counter__c =  eachTeamMember.Counter__c - mapOfOwnerAndRegionVsLead.get(ownerAndRegion).size();
                        if(eachTeamMember.Counter__c < 0){
                            eachTeamMember.Counter__c = 0;
                        }
                        lstMemberToUpdate.add(eachTeamMember);
                    }
                }
            }
            if(lstMemberToUpdate!=null && !lstMemberToUpdate.isEmpty()){
                update lstMemberToUpdate;                                          
            }
        }                                      
                                                
    }
    private static void handleNoOfActiveLeadOnUpdate(
                                            List<Lead> leads,
                                            Map<Id, Lead> oldLeadMap){
        if(leads!=null&& !leads.isEmpty()){
           
            set<Lead> setOfLead = new set<Lead>();
            for(Lead newLead : leads){
                Lead oldLead = oldLeadMap.get(newLead.Id);
                if((hasUnitChanged(newLead, oldLead) || hasStatusChanged(newLead, oldLead) )){
                    setOfLead.add(newLead);
                    setOfLead.add(oldLead);
                    
                }
            }
        
        
            if(setOfLead!=null && !setOfLead.isempty()){
                list<Lead> lstLead = new list<Lead>();
                lstLead.addAll(setOfLead);
                //It will update the no of lead under that unit.
            CalculateNoOfLeads(lstLead);
            }                                       
        }                                    
    }
    private static list<Team_Member__c> assignLeadToPreviousUser (list<Lead> lstLeadAssignToSameUser,
    													   map<String,list<Lead>> mapOfEmailVsLeads,
                                                           map<String,list<Lead>> mapOfMobilePhoneVsLeads,
                                                           map<String,list<Lead>> mapOfCompanyVsLeads,       
                                                           map<id,Team_Member__c>mapOfUserVsTeamMember,
                                                           map<String,list<opportunity>> mapOfCompanyVsOpportunity){
        list<Team_Member__c>lstTeamMemberToUpdate = new list<Team_Member__c>();
       	map<Id,Integer> mapOfUserIdVsNoOfReords = new map <Id,Integer>();
		if(lstLeadAssignToSameUser!=null && !lstLeadAssignToSameUser.isEmpty()){
         	for(lead eachLead : lstLeadAssignToSameUser){
                    
             	if(mapOfEmailVsLeads.get(eachLead.Email)!=null && 
                  !mapOfEmailVsLeads.get(eachLead.Email).isEmpty()){
                  	if( mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId)!=null ){
						eachLead.OwnerId = mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId;
                        //Team_Member__c newTeamMember = new Team_Member__c();
                        //newTeamMember.id = mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).id;
                        /*if(!mapOfUserIdVsNoOfReords.containsKey(mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).id)){
                            mapOfUserIdVsNoOfReords.put(mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).id, 1);
                        }
                		integer test =mapOfUserIdVsNoOfReords.get(mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).id);
                        */
                        if(mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).Counter__c 
                                    < 
                           mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).Capacity__c ){
                           		mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).Counter__c +=1;
                        }else{
                            mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).Counter__c=1;
                        }
                           //newTeamMember.Counter__c = mapOfUserVsTeamMember.get(mapOfEmailVsLeads.get(eachLead.Email)[0].OwnerId).Counter__c;
                        
                           //lstTeamMemberToUpdate.add(newTeamMember);
                    }
                  }else if(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)!=null &&
                            !mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone).isEmpty()
                            ){
                                
                        if(mapOfUserVsTeamMember.get(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId)!=null){
                            eachLead.OwnerId = mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId;
                            
                             	eachLead.Region__c = mapOfUserVsTeamMember.get(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId).Sales_Team__r.Region__c;   
                            
                        
                            //Team_Member__c newTeamMember = new Team_Member__c();
                            //newTeamMember.id =mapOfUserVsTeamMember.get(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId).id;
                            if(mapOfUserVsTeamMember.get(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId).Counter__c 
                               < 
                               mapOfUserVsTeamMember.get(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId).Capacity__c ){
                                   
                                mapOfUserVsTeamMember.get(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId).Counter__c +=1;
                            }else{
                                mapOfUserVsTeamMember.get(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId).Counter__c=1;
                            }
                            //newTeamMember.Counter__c = mapOfUserVsTeamMember.get(mapOfMobilePhoneVsLeads.get(eachLead.MobilePhone)[0].OwnerId).Counter__c;
                            //lstTeamMemberToUpdate.add(newTeamMember);
                        }
                   }else if(mapOfCompanyVsLeads.get(eachLead.Company)!=null &&
                            !mapOfCompanyVsLeads.get(eachLead.Company).isEmpty()
                    ){
                        if(mapOfUserVsTeamMember.get(mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId)!=null){
                            eachLead.OwnerId = mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId;
                            
                                    eachLead.Region__c = mapOfUserVsTeamMember.get(mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId).Sales_Team__r.Region__c;   
                            
                        
                            //Team_Member__c newTeamMember = new Team_Member__c();
                            //newTeamMember.id =mapOfUserVsTeamMember.get(mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId).id;
                            
                            if(mapOfUserVsTeamMember.get(mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId).Counter__c 
                                < 
                                mapOfUserVsTeamMember.get(mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId).Capacity__c ){
                                    
                                mapOfUserVsTeamMember.get(mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId).Counter__c +=1;
                            }else{
                                mapOfUserVsTeamMember.get(mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId).Counter__c=1;
                            }
                            //newTeamMember.Counter__c = mapOfUserVsTeamMember.get(mapOfCompanyVsLeads.get(eachLead.Company)[0].OwnerId).Counter__c;
                            //lstTeamMemberToUpdate.add(newTeamMember);
                        }
                    }else if(mapOfCompanyVsOpportunity.get(eachLead.Company)!=null &&
                            !mapOfCompanyVsOpportunity.get(eachLead.Company).isEmpty()
                    ){  
                        if(mapOfUserVsTeamMember.get(mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId)!=null){
                            eachLead.OwnerId = mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId;
                            
                                    //eachLead.Region__c = mapOfUserVsTeamMember.get(mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId).Sales_Team__r.Region__c;   
                            
                        
                            //Team_Member__c newTeamMember = new Team_Member__c();
                            //newTeamMember.id =mapOfUserVsTeamMember.get(mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId).id;
                            
                            if(mapOfUserVsTeamMember.get(mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId).Counter__c 
                                < 
                                mapOfUserVsTeamMember.get(mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId).Capacity__c ){
                                    
                                mapOfUserVsTeamMember.get(mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId).Counter__c +=1;
                            }else{
                                mapOfUserVsTeamMember.get(mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId).Counter__c=1;
                            }
                            //newTeamMember.Counter__c = mapOfUserVsTeamMember.get(mapOfCompanyVsOpportunity.get(eachLead.Company)[0].OwnerId).Counter__c;
                            //lstTeamMemberToUpdate.add(newTeamMember);
                        }
                    }
            }
            }
           
    	return mapOfUserVsTeamMember.values();
    }
    // get RecordType id based on label Record Type Name 
    private static id getRecordTypeId(string labelValue){
        // To query RecordType Id
        RecordType CurrentRecordType = [SELECT Id
                                        FROM RecordType
                                        WHERE DeveloperName =:labelValue LIMIT 1];
        system.debug(CurrentRecordType.Id);
        return CurrentRecordType.Id;
        
    }
}