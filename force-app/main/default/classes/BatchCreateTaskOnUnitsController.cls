// handler class  for BatchCreateTaskonUnits 


public class BatchCreateTaskOnUnitsController {
    
    // controller methode for batch execution 
    public static void handleExecution(list<Product2>lstUnits){
        system.debug(lstUnits);
        
        // Null check for List of Units
        if(lstUnits!=null && !lstUnits.isEmpty()){
            system.debug('Enterd into Condition');
            list<Task>lstTasks = new list<Task>();
            
            // get id of user To Whom task need to be Assign
            Id assignToId = getAssigntoUserId();
            
            System.debug('ready to exicute loop ');
            for(Product2 eachUnit : lstUnits){
                system.debug('Unit Name :'+ eachUnit.Name);
                
             //check for Owned Units.
                if(eachUnit.Inventory_Status__c=='Owned'){
                    if(eachUnit.FB_Marketplace_Live_Link__c == Null || 
                        eachUnit.Mascus_Live_Link__c == Null ||
                        eachUnit.LinkedIn_Post_Link__c == Null ||
                        eachUnit.MyLittleSalesman_Live_Link__c == Null || 
                        eachUnit.Machinio_Live_Link__c == Null || 
                        eachUnit.Mascus_Live_Link__c == Null ||
                        eachUnit.Craigslist_Back_End_Link__c == Null ||
                        eachUnit.Equipment_Trader_Live_Link__c == Null || 
                        eachUnit.RitchieList_Live_Link__c == Null || 
                        eachUnit.MT_Back_End_Link__c == Null ||
                        eachUnit.Rock_Dirt_Live_Link__c == Null ||
                        eachUnit.FB_Post_Link__c == Null||
                        eachUnit.Craigslist_Live_Listing__c == Null||
                        eachUnit.Mailchimp_Link__c == Null){
                        //(String.isBlank(eachUnit.Mailchimp_Link__c)&&(checkProcurementOpportunityStage(eachUnit.Opportunities__r))||
                        //String.isNotBlank(eachUnit.Mailchimp_Link__c)&&(!checkProcurementOpportunityStage(eachUnit.Opportunities__r)))){
                                                            
                   //Description for the task in responce to owned units                                            
                   string Description = getDiscriptionFroOwnedUnits(eachUnit);
                    system.debug(Description);
                                                               
                   // create task for the unit           
                   if(string.isNotBlank(assignToId) && string.isNotBlank(eachUnit.Unit_Owner__c)){                                 
                lstTasks.add(createTasks('These URL fields are Empty',
                                            eachUnit.Id, 
                                            assignToId, 
                                            eachUnit.Unit_Owner__c,
                                            Description));
                                                           }
                                                        }
            }
                                            
                // check for Unowned Units
                else if(eachUnit.Inventory_Status__c!='Owned'){
                    if((eachUnit.Override_Post_Override_DNP_anywhere__c ==false &&(
                        (String.isNotBlank(eachUnit.Craigslist_Live_Listing__c)&& eachUnit.Marketed_On_Craigslist__c==false)||
                        (String.isNotBlank(eachUnit.LinkedIn_Post_Link__c)&& eachUnit.Marketed_On_LinkedIn__c==false)||
                        (String.isNotBlank(eachUnit.FB_Post_Link__c)&& eachUnit.Marketed_On_FB_Marketplace__c==false)||
                        (String.isNotBlank(eachUnit.FB_Marketplace_Live_Link__c)&& eachUnit.Marketed_On_FB_Marketplace__c==false)||
                        (String.isNotBlank(eachUnit.MyLittleSalesman_Live_Link__c)&& eachUnit.Marketed_On_MyLittleSalesman__c==false)||
                        (String.isNotBlank(eachUnit.Machinio_Live_Link__c)&& eachUnit.Marketed_On_Machinio__c==false)||
                        (String.isNotBlank(eachUnit.Mascus_Live_Link__c)&& eachUnit.Marketed_On_Mascus__c==false)||
                        (String.isNotBlank(eachUnit.Craigslist_Back_End_Link__c)&& eachUnit.Marketed_On_Craigslist__c==false)||
                        (String.isNotBlank(eachUnit.Equipment_Trader_Live_Link__c)&& eachUnit.Marketed_On_Mascus__c==false)||
                        (String.isNotBlank(eachUnit.RitchieList_Live_Link__c)&& eachUnit.Marketed_On_Mascus__c==false)||
                        (String.isNotBlank(eachUnit.Rock_Dirt_Live_Link__c)&& eachUnit.Marketed_On_Mascus__c==false)||
                        

                        (String.isBlank(eachUnit.Craigslist_Live_Listing__c)&& eachUnit.Marketed_On_Craigslist__c==True)||
                        (String.isBlank(eachUnit.LinkedIn_Post_Link__c)&& eachUnit.Marketed_On_LinkedIn__c==True)||
                        (String.isBlank(eachUnit.FB_Post_Link__c)&& eachUnit.Marketed_On_FB_Marketplace__c==True)||
                        (String.isBlank(eachUnit.FB_Marketplace_Live_Link__c)&& eachUnit.Marketed_On_FB_Marketplace__c==True)||
                        (String.isBlank(eachUnit.Craigslist_Back_End_Link__c)&& eachUnit.Marketed_On_Craigslist__c==True)||
                        (String.isBlank(eachUnit.MyLittleSalesman_Live_Link__c)&& eachUnit.Marketed_On_MyLittleSalesman__c==True)||
                        (String.isBlank(eachUnit.Machinio_Live_Link__c)&& eachUnit.Marketed_On_Machinio__c==True)||
                        (String.isBlank(eachUnit.Mascus_Live_Link__c)&& eachUnit.Marketed_On_Mascus__c==True)||
                        (String.isBlank(eachUnit.Equipment_Trader_Live_Link__c)&& eachUnit.Marketed_On_Mascus__c==True)||
                        (String.isBlank(eachUnit.RitchieList_Live_Link__c)&& eachUnit.Marketed_On_Mascus__c==True)||
                        (String.isBlank(eachUnit.Rock_Dirt_Live_Link__c)&& eachUnit.Marketed_On_Mascus__c==True)||
                        //Check Mailchimp_Link__c Link with Procurement Opportunity Stage Name
                        ((String.isBlank(eachUnit.Mailchimp_Link__c)&&(checkProcurementOpportunityStage(eachUnit.Opportunities__r)))||
                        (String.isNotBlank(eachUnit.Mailchimp_Link__c)&&(!checkProcurementOpportunityStage(eachUnit.Opportunities__r))))))||

                    ((eachUnit.Override_Post_Override_DNP_anywhere__c ==true) && (

                    (String.isBlank(eachUnit.Craigslist_Live_Listing__c)&& eachUnit.Override_Post_Craigslist__c==True)||
                    (String.isBlank(eachUnit.LinkedIn_Post_Link__c)&& eachUnit.Override_Post_LinkedIn__c==True)||
                    (String.isBlank(eachUnit.FB_Post_Link__c)&& eachUnit.Override_Post_FB_Marketplace__c==True)||
                    (String.isBlank(eachUnit.FB_Marketplace_Live_Link__c)&& eachUnit.Override_Post_FB_Marketplace__c==True)||
                    (String.isBlank(eachUnit.Craigslist_Back_End_Link__c)&& eachUnit.Override_Post_Craigslist__c==True)||
                    (String.isBlank(eachUnit.MyLittleSalesman_Live_Link__c)&& eachUnit.Override_Post_MyLittleSalesman__c==True)||
                    (String.isBlank(eachUnit.Machinio_Live_Link__c)&& eachUnit.Override_Post_Machinio__c==True)||
                    (String.isBlank(eachUnit.Mascus_Live_Link__c)&& eachUnit.Override_Post_Mascus__c==True)||
                    (String.isBlank(eachUnit.Equipment_Trader_Live_Link__c)&& eachUnit.Override_Post_Mascus__c==True)||
                    (String.isBlank(eachUnit.RitchieList_Live_Link__c)&& eachUnit.Override_Post_Mascus__c==True)||
                    (String.isBlank(eachUnit.Rock_Dirt_Live_Link__c)&& eachUnit.Override_Post_Mascus__c==True)||

                    (String.isNotBlank(eachUnit.Craigslist_Live_Listing__c)&& eachUnit.Override_Post_Craigslist__c==false)||
                    (String.isNotBlank(eachUnit.LinkedIn_Post_Link__c)&& eachUnit.Override_Post_LinkedIn__c==false)||
                    (String.isNotBlank(eachUnit.FB_Post_Link__c)&& eachUnit.Override_Post_FB_Marketplace__c==false)||
                    (String.isNotBlank(eachUnit.FB_Marketplace_Live_Link__c)&& eachUnit.Override_Post_FB_Marketplace__c==false)||
                    (String.isNotBlank(eachUnit.Craigslist_Back_End_Link__c)&& eachUnit.Override_Post_Craigslist__c==false)||
                    (String.isNotBlank(eachUnit.MyLittleSalesman_Live_Link__c)&& eachUnit.Override_Post_MyLittleSalesman__c==false)||
                    (String.isNotBlank(eachUnit.Machinio_Live_Link__c)&& eachUnit.Override_Post_Machinio__c==false)||
                    (String.isNotBlank(eachUnit.Mascus_Live_Link__c)&& eachUnit.Override_Post_Mascus__c==false)||
                    (String.isNotBlank(eachUnit.Equipment_Trader_Live_Link__c)&& eachUnit.Override_Post_Mascus__c==false)||
                    (String.isNotBlank(eachUnit.RitchieList_Live_Link__c)&& eachUnit.Override_Post_Mascus__c==false)||
                    (String.isNotBlank(eachUnit.Rock_Dirt_Live_Link__c)&& eachUnit.Override_Post_Mascus__c==false))))

                {
                
                string Description = getDiscriptionFroUnOwnedUnits(eachUnit);
                system.debug(Description);
                if(string.isNotBlank(assignToId) && string.isNotBlank(eachUnit.Unit_Owner__c)){
                lstTasks.add(createTasks('Check if there is any check box Unchecked or Url is Empty',
                                            eachUnit.Id, 
                                            assignToId, 
                                            eachUnit.Unit_Owner__c,
                                            Description));
                                                           }
                                                        }
                }
                                            
            }
            if(lstTasks!=null && !lstTasks.isEmpty()){
                
                // insert list of tasks
                system.debug('lstTasks:'+lstTasks);
                insert lstTasks; 
            }
        }
    }
    
    
    // Method to create task 
    private static task createTasks(string subject, 
                                    id recId, 
                                    id assignTo, 
                                    id recOwnerId, 
                                    string description){
                                        
                                        Task newTask = new Task();
                                        newTask.subject = subject;
                                        newTask.whatId = recId;
                                        //newTask.whoId= recOwnerId;
                                        newTask.ownerId = assignTo;
                                        newTask.status = 'In progress';
                                        newTask.Priority = 'Normal';
                                        newTask.Description = description;
                                        
                                        return newTask;
                                    }
    
    
    //Method to generate the discription for Owned Units
    private static string getDiscriptionFroOwnedUnits(Product2 unitRec){
        string Description='Fill the URL Fields :';
        system.debug('GetDescripion is exicuetd');
        
        Description = '\n'+getDiscriptionForUrl(unitRec.FB_Marketplace_Live_Link__c,'FB Marketplace Live Link')+
            getDiscriptionForUrl(unitRec.RentalYard_Link__c,'RentalYard Link')+
            getDiscriptionForUrl(unitRec.LinkedIn_Post_Link__c,'LinkedIn Post Link')+
            getDiscriptionForUrl(unitRec.FB_Post_Link__c,'FB Post Link')+
            getDiscriptionForUrl(unitRec.MT_Back_End_Link__c,'MT Back End Link')+
            getDiscriptionForUrl(unitRec.Rock_Dirt_Live_Link__c,'Rock & Dirt Live Link')+
            getDiscriptionForUrl(unitRec.RitchieList_Live_Link__c,'RitchieList Live Link')+
            getDiscriptionForUrl(unitRec.Equipment_Trader_Live_Link__c,'Equipment Trader Live Link')+
            getDiscriptionForUrl(unitRec.Craigslist_Back_End_Link__c,'Craigslist Back End Link')+
            getDiscriptionForUrl(unitRec.Craigslist_Live_Listing__c,'Craigslist Live Listing')+
            getDiscriptionForUrl(unitRec.Mascus_Live_Link__c,'Mascus Live Link')+
            getDiscriptionForUrl(unitRec.Machinio_Live_Link__c,'Machinio Live Link')+
            getDiscriptionForUrl(unitRec.MyLittleSalesman_Live_Link__c,'MyLittleSalesman Live Link');
            if(checkProcurementOpportunityStage(unitRec.Opportunities__r)){
                Description +='\n'+ getDiscriptionForUrl(unitRec.Mailchimp_Link__c,'Mailchimp Link');
            }
       
        return Description;
    }


    // Method to generate the Discription for the Unowned units    
    private static string getDiscriptionFroUnOwnedUnits(Product2 UnitRec){

         system.debug('GetDescripion is exicuetd');

         
        string Description =' ';
        string description3 =' ';
        
        string Description1 = 'Checked Checkboxes with Empty URL : '+'\n'+
                checkUrlOrCheckBoxes(UnitRec.Craigslist_Live_Listing__c,'Craigslist Live Listing', 
                                    UnitRec.Marketed_On_Craigslist__c,'Marketed On - Craigslist')+
                checkUrlOrCheckBoxes(UnitRec.Machinio_Live_Link__c,'Machinio Live Link',
                                    UnitRec.Marketed_On_Machinio__c,'Marketed On - Machinio')+
                checkUrlOrCheckBoxes(UnitRec.Mascus_Live_Link__c,'Mascus Live Link',
                                    UnitRec.Marketed_On_Mascus__c,'Marketed On - Mascus')+
                checkUrlOrCheckBoxes(UnitRec.MyLittleSalesman_Live_Link__c,'MyLittleSalesman Live Link',
                                    UnitRec.Marketed_On_MyLittleSalesman__c,'Marketed On - MyLittleSalesman')+
                checkUrlOrCheckBoxes(UnitRec.LinkedIn_Post_Link__c,'LinkedIn Post Link', 
                                    UnitRec.Marketed_On_LinkedIn__c,'Marketed On - LinkedIn')+
                checkUrlOrCheckBoxes(UnitRec.FB_Post_Link__c,'FB Post Link',
                                    UnitRec.Marketed_On_FB_Marketplace__c,'FB Marketplace - Live Link')+
                checkUrlOrCheckBoxes(UnitRec.FB_Marketplace_Live_Link__c,'FB Marketplace - Live Link', 
                                    UnitRec.Marketed_On_FB_Marketplace__c,'Marketed On - FB Marketplace')+
                checkUrlOrCheckBoxes(UnitRec.Rock_Dirt_Live_Link__c,'Rock & Dirt Live Link',
                                    UnitRec.Marketed_On_Mascus__c,'Marketed On - Mascus')+
                checkUrlOrCheckBoxes(UnitRec.RitchieList_Live_Link__c,'RitchieList Live Link',
                                    UnitRec.Marketed_On_Mascus__c,'Marketed On - Mascus')+
                checkUrlOrCheckBoxes(UnitRec.Equipment_Trader_Live_Link__c,'Equipment Trader Live Link',
                                    UnitRec.Marketed_On_Mascus__c,'Marketed On - Mascus')+
                checkUrlOrCheckBoxes(UnitRec.MT_Back_End_Link__c,'MT Back-End Link',
                                    UnitRec.Marketed_on_MT_incl_Crane_Trk__c,'Marketed on - MT + Crane/Truck')+
                checkUrlOrCheckBoxes(UnitRec.Craigslist_Back_End_Link__c,'Craigslist Back-End Link',
                                    UnitRec.Marketed_On_Craigslist__c,'Marketed On - Craigslist')+'\n';

            if(unitRec.Override_Post_Override_DNP_anywhere__c ==true){
                Description1 += 
                                    //Override CheckBoxes start here.. 
                checkUrlOrCheckBoxes(UnitRec.Craigslist_Live_Listing__c,'Craigslist Live Listing', 
                                    UnitRec.Override_Post_Craigslist__c,'Override & Post - Craigslist')+
                checkUrlOrCheckBoxes(UnitRec.Machinio_Live_Link__c,'Machinio Live Link',
                                    UnitRec.Override_Post_Machinio__c,'Override & Post - Machinio')+
                checkUrlOrCheckBoxes(UnitRec.Mascus_Live_Link__c,'Mascus Live Link', 
                                    UnitRec.Override_Post_Mascus__c,'Override & Post -Mascus')+
                checkUrlOrCheckBoxes(UnitRec.MyLittleSalesman_Live_Link__c,'MyLittleSalesman Live Link',
                                    UnitRec.Override_Post_MyLittleSalesman__c,'Override & Post - MyLittleSalesman')+
                checkUrlOrCheckBoxes(UnitRec.LinkedIn_Post_Link__c,'LinkedIn Post Link', 
                                    UnitRec.Override_Post_LinkedIn__c,'Override & Post - LinkedIn')+
                checkUrlOrCheckBoxes(UnitRec.FB_Post_Link__c,'FB Post Link',
                                    UnitRec.Override_Post_FB_Marketplace__c,'Override & Post - FB Marketplace')+
                checkUrlOrCheckBoxes(UnitRec.FB_Marketplace_Live_Link__c,'FB Marketplace - Live Link',
                                    UnitRec.Override_Post_FB_Marketplace__c,'Override & Post - FB Marketplace')+
                checkUrlOrCheckBoxes(UnitRec.Rock_Dirt_Live_Link__c,'Rock & Dirt Live Link',
                                    UnitRec.Override_Post_Mascus__c,'Override & Post - Mascus')+
                checkUrlOrCheckBoxes(UnitRec.RitchieList_Live_Link__c,'RitchieList Live Link',
                                    UnitRec.Override_Post_Mascus__c,'Override & Post - Mascus')+
                checkUrlOrCheckBoxes(UnitRec.Equipment_Trader_Live_Link__c,'Equipment Trader Live Link',
                                    UnitRec.Override_Post_Mascus__c,'Override & Post - Mascus')+
                checkUrlOrCheckBoxes(UnitRec.MT_Back_End_Link__c,'MT Back-End Link',
                                    UnitRec.Override_Post_MT_Crane_Truck__c,'Override & Post - MT + Crane/Truck')+
                checkUrlOrCheckBoxes(UnitRec.Craigslist_Back_End_Link__c,'Craigslist Back-End Link',
                                    UnitRec.Override_Post_Craigslist__c,'Override & Post - Craigslist')+'\n';
            }

            string Description2='URLs Without having checkBoxes Checked : ';
            if( unitRec.Override_Post_Override_DNP_anywhere__c ==false){
            // check for URls and Check Boxes
                Description2 += '\n'+
                checkCheckBoxesAndUrl(UnitRec.Craigslist_Live_Listing__c,'Craigslist Live Listing', 
                                    UnitRec.Marketed_On_Craigslist__c,'Marketed On - Craigslist')+
                checkCheckBoxesAndUrl(UnitRec.Machinio_Live_Link__c,'Machinio Live Link',
                                    UnitRec.Marketed_On_Machinio__c,'Marketed On - Machinio')+
                checkCheckBoxesAndUrl(UnitRec.Mascus_Live_Link__c,'Mascus Live Link', 
                                    UnitRec.Marketed_On_Mascus__c,'Marketed On - Mascus')+
                checkCheckBoxesAndUrl(UnitRec.MyLittleSalesman_Live_Link__c,'MyLittleSalesman Live Link',
                                    UnitRec.Marketed_On_MyLittleSalesman__c,'Marketed On - MyLittleSalesman')+
                checkCheckBoxesAndUrl(UnitRec.LinkedIn_Post_Link__c,'LinkedIn Post Link', 
                                    UnitRec.Marketed_On_LinkedIn__c,'Marketed On - LinkedIn')+
                checkCheckBoxesAndUrl(UnitRec.FB_Post_Link__c,'FB Post Link',
                                    UnitRec.Marketed_On_FB_Marketplace__c,'Marketed On - FB Marketplace')+
                checkCheckBoxesAndUrl(UnitRec.FB_Marketplace_Live_Link__c,'FB Marketplace - Live Link',
                                    UnitRec.Marketed_On_FB_Marketplace__c,'Marketed On - FB Marketplace')+
                checkCheckBoxesAndUrl(UnitRec.Rock_Dirt_Live_Link__c,'Rock & Dirt Live Link',
                                    UnitRec.Marketed_On_Mascus__c,'Marketed On - Mascus')+
                checkCheckBoxesAndUrl(UnitRec.RitchieList_Live_Link__c,'RitchieList Live Link',
                                    UnitRec.Marketed_On_Mascus__c,'Marketed On - Mascus')+
                checkCheckBoxesAndUrl(UnitRec.Equipment_Trader_Live_Link__c,'Equipment Trader Live Link',
                                    UnitRec.Marketed_On_Mascus__c,'Marketed On - Mascus')+
                checkCheckBoxesAndUrl(UnitRec.MT_Back_End_Link__c,'MT Back-End Link',
                                    UnitRec.Marketed_on_MT_incl_Crane_Trk__c,'Marketed on - MT + Crane/Truck')+
                checkCheckBoxesAndUrl(UnitRec.Craigslist_Back_End_Link__c,'Craigslist Back-End Link',
                                    UnitRec.Marketed_On_Craigslist__c,'Marketed On - Craigslist')+'\n'; 
            }

            if( unitRec.Override_Post_Override_DNP_anywhere__c ==true){
                Description2 = 
                              
                                    //Override CheckBoxes start here.. 
                checkCheckBoxesAndUrl(UnitRec.Craigslist_Live_Listing__c,'Craigslist Live Listing', 
                                    UnitRec.Override_Post_Craigslist__c,'Override & Post - Craigslist')+
                checkCheckBoxesAndUrl(UnitRec.Machinio_Live_Link__c,'Machinio Live Link',
                                    UnitRec.Override_Post_Machinio__c,'Override & Post - Machinio')+
                checkCheckBoxesAndUrl(UnitRec.Mascus_Live_Link__c,'Mascus Live Link', 
                                    UnitRec.Override_Post_Mascus__c,'Override & Post -Mascus')+
                checkCheckBoxesAndUrl(UnitRec.MyLittleSalesman_Live_Link__c,'MyLittleSalesman Live Link',
                                    UnitRec.Override_Post_MyLittleSalesman__c,'Override & Post - MyLittleSalesman')+
                checkCheckBoxesAndUrl(UnitRec.LinkedIn_Post_Link__c,'LinkedIn Post Link', 
                                    UnitRec.Override_Post_LinkedIn__c,'Override & Post - LinkedIn')+
                checkCheckBoxesAndUrl(UnitRec.FB_Post_Link__c,'FB Post Link',
                                    UnitRec.Override_Post_FB_Marketplace__c,'Override & Post - FB Marketplace')+
                checkCheckBoxesAndUrl(UnitRec.FB_Marketplace_Live_Link__c,'FB Marketplace - Live Link',
                                    UnitRec.Override_Post_FB_Marketplace__c,'Override & Post - FB Marketplace')+
                checkCheckBoxesAndUrl(UnitRec.Rock_Dirt_Live_Link__c,'Rock & Dirt Live Link',
                                    UnitRec.Override_Post_Mascus__c,'Override & Post - Mascus')+
                checkCheckBoxesAndUrl(UnitRec.RitchieList_Live_Link__c,'RitchieList Live Link',
                                    UnitRec.Override_Post_Mascus__c,'Override & Post - Mascus')+
                checkCheckBoxesAndUrl(UnitRec.Equipment_Trader_Live_Link__c,'Equipment Trader Live Link',
                                    UnitRec.Override_Post_Mascus__c,'Override & Post - Mascus')+
                checkCheckBoxesAndUrl(UnitRec.MT_Back_End_Link__c,'MT Back-End Link',
                                    UnitRec.Override_Post_MT_Crane_Truck__c,'Override & Post - MT + Crane/Truck')+
                checkCheckBoxesAndUrl(UnitRec.Craigslist_Back_End_Link__c,'Craigslist Back-End Link',
                                    UnitRec.Override_Post_Craigslist__c,'Override & Post - Craigslist')+'\n';
            }

        if(checkProcurementOpportunityStage(unitRec.Opportunities__r) && String.isBlank(UnitRec.Mailchimp_Link__c)){
            description3 ='Unit have Procurement Opportunity with satgeName :Proactve Brokerage Satge but link  :Mailchimp Link is Empty on unit';
        }else if(String.isNotBlank(unitRec.Mailchimp_Link__c)&&(!checkProcurementOpportunityStage(unitRec.Opportunities__r))){
            description3 ='Unit do not have any Procurement Opportunity with satgeName :Proactve Brokerage Satge but link  :Mailchimp Link has values on unit';

        } 

        // description for Unowned Units 
        Description = Description1 + Description2 + description3;

        
        return Description;
    }
    
    // Method to check Url related to CheckBox
    private static string  checkUrlOrCheckBoxes(string Url, string UrlLabel, boolean CheckBox , string CheckBoxLabel){
        string DescriptionMsg= ' ';
        If(String.isBlank(Url)&& CheckBox== true){
            // Check Url and CheckBoxes is there any  Empty URL having true CheckBox
            DescriptionMsg='Url Field : '+UrlLabel+' is empty but Check-box : '+CheckBoxLabel +' is Checked.'+'\n';
        }
        return DescriptionMsg;
    } 
    
    // Method to check CheckBox related to Url
    private static string checkCheckBoxesAndUrl(string Url, string UrlLabel, boolean CheckBox , string CheckBoxLabel){
        string DescriptionMsg= ' ';
        // Check Url and CheckBoxes is there any URL having false CheckBox
         if(String.isNotBlank(Url)&& CheckBox==false){
             DescriptionMsg='Url Field : '+UrlLabel+' have URL but Check-box : '+CheckBoxLabel +' is Unchecked.'+'\n';
        }
        return DescriptionMsg;
    }
    
    
    // Method to check URLs for Owned Units
    private static string getDiscriptionForUrl(string urlField ,string LabelName ){
        system.debug('Check Url ');
        string FieldLabel; 
        // If Url field is Null or don't have Url 
        if(urlField== null){
            FieldLabel = LabelName+'\n';
        }else{
            FieldLabel=' ';
        } 
        return FieldLabel;
    } 
    
    // get Assign to id based on label user name 
    private static id getAssigntoUserId(){
        // VA is custom label having User Name as Value
        string customLabelValue = System.Label.VA;
        user assignToUser = [SELECT Id
                             FROM User
                             WHERE Name =:customLabelValue LIMIT 1];
        system.debug(assignToUser.Id);
        // Returning User Id
        return assignToUser.Id;
        
    }
     
   
    // get Opportunity Stage Name based on label  
    private static boolean checkProcurementOpportunityStage(list<Opportunity> lstOpportunity){
        boolean isOppStageProactiveBrokerage = false;

        if(lstOpportunity!=null && !lstOpportunity.isEmpty()){
            for(Opportunity eachOpportunity : lstOpportunity){
                //label is used here to validate the opp stage name .
                if(eachOpportunity.StageName==System.Label.opportunity_Stage_ProactiveBrokerage){
                    isOppStageProactiveBrokerage = true;
                }
            }
        }
        return isOppStageProactiveBrokerage;
    }

    
}