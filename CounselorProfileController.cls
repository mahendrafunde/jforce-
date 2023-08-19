public class CounselorProfileController {
    private final Counselor_Profile__c profile;

    public CounselorProfileController(ApexPages.StandardController stdController) {
        this.profile = (Counselor_Profile__c)stdController.getRecord();
    }

    public PageReference save() {
        // Add any custom save logic or validations if required
        insert profile;
        return new PageReference('/' + profile.Id);
    }
}