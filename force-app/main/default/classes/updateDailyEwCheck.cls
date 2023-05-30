global class updateDailyEwCheck Implements Schedulable {

    global void execute(SchedulableContext sc) {
    
  
        /* find active units with no Fair Market Value and unflagged no market value available */
        List<Product2> ZIDs = [Select 
                ID
             From
                 Product2
             WHERE 
                 
                 IsActive = TRUE 
                 
                 AND  EW_Date_of_Last_Price_Analysis__c < LAST_N_DAYS:90
                
                  
             ];
             
        for(Product2 prod : ZIDs )
        {
            prod.Update_EW_Prices__c = TRUE;
        }
        update ZIDs;

    }

    public updateDailyEwCheck() {
         /* nothing here */
    }

}