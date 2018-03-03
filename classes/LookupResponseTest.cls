@isTest
public class LookupResponseTest {
    
    @isTest
    public static void test() {
        
        LookupResponse resp = new LookupResponse('', '', '');
        System.assertEquals(false, resp.isSuccess);
        
        resp = new LookupResponse(null);
        System.assertEquals(true, resp.isSuccess);
    }

}