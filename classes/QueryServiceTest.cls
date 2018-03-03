@isTest
public class QueryServiceTest {
    
    @isTest
    public static void test() {
        
        String caseNameField = QueryService.obtaineNameByType('case');
        System.assertEquals('CaseNumber', caseNameField);
        
        QueryService.obtainStandardAdditionalFieldToDisplay('case', 'subject');
        QueryService.obtainStandardAdditionalFieldSet('case');
        QueryService.obtainStandardAdditionalFieldSet('contact');
        QueryService.obtainStandardAdditionalFieldSet('lead');
        QueryService.obtainStandardAdditionalFieldSet('product2');
        QueryService.obtaineClause('case', 'test', new Set<String> {'caseNumber'}, '');
        
    }

}