public class CreateTaskOnUnitController {
	public static void handleExecution(list<Opportunity>lstOpportunity){
        list<Task> lstTask = new list<Task>();
        if(lstOpportunity!=null && !lstOpportunity.isEmpty() && string.isNotBlank(CreateTaskOnUnit.UserId)){
            for(Opportunity eachopportunity : lstOpportunity){
                Task newTask = new Task();
                newTask.Subject = 'Post this unit on FB Group, add Post Date and Fb Group Post Link on Unit. ';
                newTask.OwnerId = CreateTaskOnUnit.UserId;
                newTask.WhatId = eachopportunity.Product__c;
                lstTask.add(newTask);
                
            }
            if(lstTask!=null && !lstTask.isEmpty()){
             	insert lstTask;
            }
        }
    }
}