@isTest
public class LookupFieldControllerTest {
    
    @isTest
    public static void test() {
        LookupFieldController.getInfo('Account');
	LookupFieldController.getInfo('User');        
        LookupFieldController.generateQuery('case', 'test', false);
        LookupFieldController.generateQuery('contact', 'test', false);
        LookupFieldController.generateQuery('lead', 'test', false);
        LookupFieldController.generateQuery('contract', 'test', false);
        LookupFieldController.generateQuery('order', 'test', false);
        LookupFieldController.generateQuery('product2', 'test', false);
        LookupFieldController.generateQuery('orderItem', 'test', false);
        LookupFieldController.generateQuery('user', 'test', false);
        
        LookupFieldController.showRecentViewed('contact');
        LookupFieldController.obtainObjectById('', 'contact');
        LookupFieldController.obtainObjectList('test', 'contact');
        
        String expected = 'SELECT Id,CaseNumber,Subject FROM case  WHERE LastViewedDate != null ORDER BY LastViewedDate DESC  LIMIT 5';
        String testQuery = LookupFieldController.generateQuery('case', '', true);
        System.assertEquals(expected, testQuery);
    }
    
}
