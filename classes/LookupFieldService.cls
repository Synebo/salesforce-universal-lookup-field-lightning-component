public class LookupFieldService {
    
    public static final Set<String> VALID_ADDITIONAL_TYPE_SET = new Set<String>{'email', 'id', 'phone', 'picklist', 'reference', 'string', 'url', 'combobox'};
    public static final Set<String> VALID_ADDITIONAL_DISPLAY_TYPE_SET = new Set<String>{'email', 'id', 'phone', 'picklist', 'reference', 'string', 'url'};
    
    public static Schema.DescribeFieldResult obtainFieldType(String sObjectName, String fieldName) {
        
        if (sObjectName == null || sObjectName == '' || fieldName == null || fieldName == '' || fieldName.contains('.')) {
            return null;
        }
        
        String fieldType = '';
        Schema.DescribeFieldResult dr;
            
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        if (gdMap != null && sObjectName != null && gdMap.get(sObjectName) != null && gdMap.get(sObjectName).getDescribe() != null) {
            Schema.Describesobjectresult dsResult = gdMap.get(sObjectName).getDescribe();
            Map<String, Schema.SObjectField> fieldMap = dsResult.fields.getMap();
            
            if (fieldMap != null && fieldMap.get(fieldName) != null && fieldMap.get(fieldName).getDescribe() != null) {
                dr = fieldMap.get(fieldName).getDescribe();
            }
        }
        return dr;
    }
    
    public static Boolean isAdditionalFieldTypeDisplayValid(String sObjectName, String fieldName) {
        
        Boolean isValid = false;
        Schema.DescribeFieldResult dr = obtainFieldType(sObjectName, fieldName);
        String fieldType = String.valueOf(dr.getType()).toLowerCase();
        
        if (fieldType != null && fieldType != '' && VALID_ADDITIONAL_DISPLAY_TYPE_SET.contains(fieldType)) {
            isValid = true;
        }
        
        return isValid;
    }
    
    

}