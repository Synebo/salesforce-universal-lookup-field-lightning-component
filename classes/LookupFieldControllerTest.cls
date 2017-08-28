@isTest
public class LookupFieldControllerTest {
	
    @isTest
    public static void test() {
        LookupFieldController.getInfo('Account');
		LookupFieldController.getInfo('User');        
        LookupFieldController.gererateQuery('case', 'test', false);
        LookupFieldController.gererateQuery('contact', 'test', false);
        LookupFieldController.gererateQuery('lead', 'test', false);
        LookupFieldController.gererateQuery('contract', 'test', false);
        LookupFieldController.gererateQuery('order', 'test', false);
        LookupFieldController.gererateQuery('product2', 'test', false);
        LookupFieldController.gererateQuery('orderItem', 'test', false);
        
        String expected = 'SELECT Id, CaseNumber, Subject  FROM case WHERE LastViewedDate != null ORDER BY LastViewedDate DESC  LIMIT 5';
        String testQuery = LookupFieldController.gererateQuery('case', '', true);
        System.assertEquals(expected, testQuery);
    }
    
}