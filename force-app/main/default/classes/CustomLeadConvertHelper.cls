public with sharing class CustomLeadConvertHelper {
    public static AuraResponse CustomLeadConvertHelper(set<lead>lstLead) {






        Database.LeadConvert lc = new Database.LeadConvert();

        lc.setLeadId(leadObj.Id);
        lc.setAccountId(contMap.get(leadObj.Email).AccountId);
        lc.setContactId(contMap.get(leadObj.Email).Id);
        lc.setDoNotCreateOpportunity(true);
    }
}