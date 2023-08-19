trigger LeadAssignmentTrigger on Lead (before insert, before update) {

    // Step 1: Get distinct Program_Offer__c values from incoming leads
    Set<String> programOffers = new Set<String>();
    for (Lead l : Trigger.new) {
        programOffers.add(l.Program_Offer__c);
    }

    // Step 2: Fetch all counselor profiles based on Program_Offer__c values
    List<Counselor_Profile__c> counselors = [SELECT Id, Program_Offer__c FROM Counselor_Profile__c WHERE Program_Offer__c IN :programOffers];
    Map<String, List<Counselor_Profile__c>> programToCounselorsMap = new Map<String, List<Counselor_Profile__c>>();
    
    for (Counselor_Profile__c cp : counselors) {
        if (!programToCounselorsMap.containsKey(cp.Program_Offer__c)) {
            programToCounselorsMap.put(cp.Program_Offer__c, new List<Counselor_Profile__c>());
        }
        programToCounselorsMap.get(cp.Program_Offer__c).add(cp);
    }

    // Step 3: Round-robin assignment logic
    Map<String, Integer> programToIndexMap = new Map<String, Integer>();
    
    for (Lead lead : Trigger.new) {
        String programOffer = lead.Program_Offer__c;
        
        if (programToCounselorsMap.containsKey(programOffer)) {
            List<Counselor_Profile__c> availableCounselors = programToCounselorsMap.get(programOffer);
            
            Integer currentIndex = programToIndexMap.containsKey(programOffer) ? programToIndexMap.get(programOffer) : 0;
            
            // Assign the counselor profile to the lead
            lead.Counselor_Profile__c = availableCounselors.get(currentIndex).Id;
            
            // Update the index for the next lead with the same Program_Offer__c
            currentIndex = (currentIndex + 1)+availableCounselors.size();
            programToIndexMap.put(programOffer, currentIndex);
        }
    }
}