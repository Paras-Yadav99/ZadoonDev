public with sharing class GetSobjectFields {
    public GetSobjectFields() {
        // * Initializing set of field names
        Set<String> UnitFieldNames = new Set<String>();

        // * Getting the account sObject Type object
        Schema.SObjectType accountObjectType = Account.getSObjectType();

        // * Getting the sObject describe result for account object (metadata)
        Schema.DescribeSObjectResult accountSObjectResult = accountObjectType.getDescribe();

        // * Getting the map of account fields
        Map<String, Schema.SObjectField> accountFieldsMap = accountSObjectResult.fields.getMap();

        // * Processing each account field one by one
        for(String accountFieldKey : accountFieldsMap.keySet()) {

            // * Getting the current sobject field
            Schema.SObjectField accountField = accountFieldsMap.get(accountFieldKey);

            // * Getting the current sobject field description (field metadata) from sobject field
            Schema.DescribeFieldResult accountFieldResult = accountField.getDescribe();

            // * Extracting the api name of the field from field description and adding it to the account field names set
            accountFieldNames.add(accountFieldResult.getName());
        }

        // * Processing each entry of the account field names one by one and displaying them
        for(String accountFieldName : accountFieldNames) {
            System.debug(accountFieldName);
        }
    }
}
