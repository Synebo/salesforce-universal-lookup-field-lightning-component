public class QueryService {
    
    // 
    // Title        : obtaineNameByType
    // Input params : String sObjectType - type of SObject in Lookup
    // Return value : String
    // Description  : Method for obtaining correct "Name" field
    // 
    public static String obtaineNameByType(String sObjectType) {
        
        String nameOrNumber = '';
        
        if (sObjectType.toLowerCase() == 'case') {
            nameOrNumber = 'CaseNumber';
        } else if (sObjectType.toLowerCase() == 'contract') {
            nameOrNumber = 'ContractNumber';
        } else if (sObjectType.toLowerCase() == 'order') {
            nameOrNumber = 'OrderNumber';
        } else if (sObjectType.toLowerCase() == 'orderitem') {
            nameOrNumber = 'OrderItemNumber';
        } else if (sObjectType.toLowerCase() == 'task') {
            nameOrNumber = 'Subject';
        } else if (sObjectType.toLowerCase() == 'quotelineitem') {
            nameOrNumber = 'LineNumber';
        } else {
            nameOrNumber = 'Name';
        }
        
        return nameOrNumber;
    }
    
    private static Set<String> obtainFieldSet(String sObjectType, String additionalField) {
        
        Set<String> additionalFieldSet = new Set<String>();
        Set<String> fieldSet = new Set<String>();
        
        fieldSet.add('Id');
        fieldSet.add(obtaineNameByType(sObjectType));
        
        String addFieldToDisplay = obtainStandardAdditionalFieldToDisplay(sObjectType, additionalField);
        if (addFieldToDisplay != null && addFieldToDisplay != '')
            fieldSet.add(addFieldToDisplay);
        if (additionalField != null && additionalField != '') {
            fieldSet.add(additionalField);
        } else {
            
            additionalFieldSet = obtainStandardAdditionalFieldSet(sObjectType);
            if (!additionalFieldSet.isEmpty()) {
                fieldSet.addAll(additionalFieldSet);
            }
        }
        
        return fieldSet;
    }
    
    public static String obtainStandardAdditionalFieldToDisplay(String sObjectType, String additionalSearchField) {
        String fieldToDisplay = '';
        String additionalNameField = '';
        
        if (additionalSearchField == null || additionalSearchField == '') {
            if (sObjectType.toLowerCase() == 'case' || sObjectType.toLowerCase() == 'task') {
                fieldToDisplay = 'Subject';
            } else if (sObjectType.toLowerCase() == 'contact' || sObjectType.toLowerCase() == 'order' || sObjectType.toLowerCase() == 'contract') {
                fieldToDisplay = 'Account.Name';
            } else if (sObjectType.toLowerCase() == 'lead') {
                fieldToDisplay = 'Title';
            } else if (sObjectType.toLowerCase() == 'product2') {
                fieldToDisplay = 'ProductCode';
            }
        } else {
            Schema.DescribeFieldResult dr = LookupFieldService.obtainFieldType(sObjectType, additionalSearchField);
            String additionalFieldType = String.valueOf(dr.getType()).toLowerCase();
            if (additionalFieldType != 'reference') {
                fieldToDisplay = additionalSearchField;
            } else if (additionalFieldType == 'reference' && additionalSearchField.endsWith('Id')) {
                additionalNameField = obtaineNameByType(String.valueOf(dr.getReferenceTo()[0]));
                fieldToDisplay = additionalSearchField.replace('Id', '') + '.' + additionalNameField;
            } else if (additionalFieldType == 'reference' && additionalSearchField.endsWith('__c')) {
                additionalNameField = obtaineNameByType(String.valueOf(dr.getReferenceTo()[0]));
                fieldToDisplay = additionalSearchField.substring(0, additionalSearchField.length()-3) + '__r' + '.' + additionalNameField;
            }
        }
        return fieldToDisplay;
    }
    
    public static Set<String> obtainStandardAdditionalFieldSet(String sObjectType) {
        
        Set<String> additionalFieldSet = new Set<String>();
        
        if (sObjectType.toLowerCase() == 'case') {
            additionalFieldSet.add('Subject');
        } else if (sObjectType.toLowerCase() == 'contact' || sObjectType.toLowerCase() == 'user' ) {
            additionalFieldSet.addAll(new Set<String>{'FirstName', 'LastName'});	
        } else if (sObjectType.toLowerCase() == 'contact' || sObjectType.toLowerCase() == 'order' || sObjectType.toLowerCase() == 'contract') {
            additionalFieldSet.add('Account.Name');
        } else if (sObjectType.toLowerCase() == 'lead') {
            additionalFieldSet.addAll(new Set<String>{'FirstName', 'LastName', 'Title'});
        } else if (sObjectType.toLowerCase() == 'product2') {
            additionalFieldSet.add('ProductCode');
        }   
        
        return additionalFieldSet;
    }
    
    public static String obtaineClause(String sObjectType, String searchKeyWord, Set<String> fieldSet, String additionalSearchField) {
        
        String clause = '', 
               searchKey = '',
               searchKey1 = '',
               additionalFieldType = '';
        String additionalNameField = '';
        Schema.DescribeFieldResult dr;
        
        if (searchKeyWord != null && searchKeyWord != '' && !fieldSet.isEmpty()) {
            
            searchKey = searchKeyWord + '%';
            searchKey1 =  '% ' + searchKeyWord + '%';
            System.debug(fieldSet);
            for (String field_i : fieldSet) {
                
                if (!field_i.contains('.') && field_i.toLowerCase() != 'id') {
                    dr = LookupFieldService.obtainFieldType(sObjectType, field_i);
                } else {
                    dr = LookupFieldService.obtainFieldType(sObjectType, additionalSearchField);
                }
                System.debug(field_i);
                if (dr != null && dr.getType() != null) {
                    additionalFieldType = String.valueOf(dr.getType()).toLowerCase();
                    
                    if (field_i.toLowerCase() != 'id') {
                        if (additionalFieldType != 'reference' && LookupFieldService.VALID_ADDITIONAL_TYPE_SET.contains(additionalFieldType)) {
                            clause += ' OR ' + field_i + ' Like \'' + searchKey + '\' ' 
                                    + ' OR ' + field_i + ' LIKE \'' + searchKey1 + '\' ';
                        } else if (additionalFieldType == 'reference' && field_i.toLowerCase().endsWith('id') && LookupFieldService.VALID_ADDITIONAL_TYPE_SET.contains(additionalFieldType)) {
                            additionalNameField = obtaineNameByType(String.valueOf(dr.getReferenceTo()[0]));
                            clause += ' OR ' + field_i.toLowerCase().replace('id', '') + '.' + additionalNameField +' Like \'' + searchKey + '\'';
                        } else if (additionalFieldType == 'reference' && field_i.toLowerCase().endsWith('__c') && LookupFieldService.VALID_ADDITIONAL_TYPE_SET.contains(additionalFieldType)) {
                            additionalNameField = obtaineNameByType(String.valueOf(dr.getReferenceTo()[0]));
                            clause += ' OR ' + field_i.toLowerCase().substring(0, field_i.toLowerCase().length()-3) + '__r'  + '.' + additionalNameField +' Like \'' + searchKey + '\'';
                        }
                    }
                }
            } 
        }
        
        clause = clause.removeStart(' OR');
        
        return clause;
    }
    
    // MAIN 1
    public static String generateQuery(String sObjectType, String searchKeyWord, String additionalSearchField, Boolean isLastViewed, String queryCondition) {
     	
        String query = '',
               clause = '';
        Set<String> fieldSet = new Set<String>();
        List<String> fieldList = new List<String>();
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        fieldSet = obtainFieldSet(sObjectType, additionalSearchField);
		fieldList.addAll(fieldSet);
        
        clause = obtaineClause(sObjectType, searchKeyWord, fieldSet, additionalSearchField);
        
        if (!fieldList.isEmpty() && schemaType.getDescribe().isAccessible()) {
            query = ' SELECT ' + String.join(fieldList, ',')
                  + ' FROM '   + sObjectType;
            
            if (!isLastViewed) {
                
                if (clause != null && clause != '') {
                    query += ' WHERE ('  + clause + ')';
                }
                if (queryCondition != null && queryCondition != '') {
					   query += (query.contains('WHERE')) ? ' AND (' + queryCondition + ') ' : ' WHERE ' + queryCondition;
                }
                
            } else {
                query += ' WHERE (LastViewedDate != null) ';
                if (queryCondition != null && queryCondition != '') {
                    query += ' AND (' + queryCondition + ') ';
                }
                query += ' ORDER BY LastViewedDate DESC ';
                query += ' LIMIT 5';
            }
        }
        
        return query;
    }
    
}