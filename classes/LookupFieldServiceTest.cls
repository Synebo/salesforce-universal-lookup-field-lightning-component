@isTest
public class LookupFieldServiceTest {
    
    @isTest
    public static void test() {
        
        Schema.DescribeFieldResult dr = LookupFieldService.obtainFieldType('case', 'subject');
        String fieldType = String.valueOf(dr.getType());
        
        System.assertEquals('string', fieldType.toLowerCase());
        
        Boolean isValid = LookupFieldService.isAdditionalFieldTypeDisplayValid('case', 'subject');
        System.assertEquals(true, isValid);
    }

}