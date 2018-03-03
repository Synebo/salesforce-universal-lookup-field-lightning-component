@isTest
public class LookupFieldControllerTest {
    
    @isTest
    public static void test() {
        LookupFieldController.showRecentViewed('contact');
        
        LookupFieldController.obtainRecordsList('contact', 'test', 'email', null); 
        
        LookupFieldController.obtainFiveRecentRecords('contact', 'email', null); 
        
        LookupResponse resp = LookupFieldController.getObjectInfo(null, 'email'); 
        System.assertEquals(false, resp.isSuccess);
    }
    
}