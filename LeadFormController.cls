public class LeadFormController {
    public Lead lead { get; set; }

    public LeadFormController() {
        lead = new Lead();
    }

    public PageReference submitLead() {
        try {
            insert lead;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error inserting lead.'));
            return null;
        }
        return null;
    }
}