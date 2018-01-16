@isTest
public class LookupFieldControllerTest {
    
    @isTest
    public static void testController() {
        LookupFieldController.getInfo('Account');
        LookupFieldController.getInfo('User');        
        LookupFieldController.generateQuery('case', 'test', false, '');
        LookupFieldController.generateQuery('contact', 'test', false, '');
        LookupFieldController.generateQuery('lead', 'test', false, '');
        LookupFieldController.generateQuery('contract', 'test', false, '');
        LookupFieldController.generateQuery('order', 'test', false, '');
        LookupFieldController.generateQuery('product2', 'test', false, '');
        LookupFieldController.generateQuery('orderItem', 'test', false, '');
        LookupFieldController.generateQuery('user', 'test', false, '');
        
        LookupFieldController.showRecentViewed('contact');
        LookupFieldController.obtainObjectById('', 'contact');
        try {
            LookupFieldController.obtainObjectList('test', 'contact', 'Description=null');
        } catch(Exception e) {
            system.debug(e);
        }

        String expected = 'SELECT Id,Name,FirstName,LastName,Account.Name FROM contact  WHERE (Name Like \'test%\' OR Account.Name Like \'test%\' OR FirstName Like\'test%\' OR LastName Like\'test%\') AND (Description=null)';
        String testQuery = LookupFieldController.generateQuery('contact', 'test', false, 'Description=null');
        System.assertEquals(expected, testQuery);
        
        expected = 'SELECT Id,CaseNumber,Subject FROM case  WHERE LastViewedDate != null ORDER BY LastViewedDate DESC  LIMIT 5';
        testQuery = LookupFieldController.generateQuery('case', '', true, '');
        System.assertEquals(expected, testQuery);
    }
    
}
