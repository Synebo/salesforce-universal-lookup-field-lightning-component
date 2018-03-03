global with sharing class LookupFieldController {
    
    // Title        : getObjectInfo
    // Input params : sObjectType - type of Lookup, additionalField - additional field name
    // Return value : LookupResponse
    // Description  : Method for obtaining info about sObject (color, icon etc.)    
    @AuraEnabled
    global static LookupResponse getObjectInfo(String sObjectType, String additionalField) {
        try { 
            InfoWrapper info = new InfoWrapper();
            String additionalFieldType = '';
            
            // Check that it is not empty
            if (sObjectType == null || sObjectType == '') {
                return new LookupResponse('error', 'Object type is not defined.', 'Object type is not defined. Please check attribute "objectType".');
            }
            
            // Check is SObject valid and isAccessible
            SObjectType sObjectTypeItem = Schema.getGlobalDescribe().get(sObjectType);
            if (sObjectTypeItem == null) {
                return new LookupResponse('error', 'Invalid Object or you do not have permissions.', 'Invalid Object on you do not have permissions. Please check attribute "objectType" on your permissions to Object.');
            }
             
            Schema.DescribeSObjectResult objectDescribeResult =  sObjectTypeItem.getDescribe();
            if (!objectDescribeResult.isAccessible()) {
                return new LookupResponse('error', 'Invalid Object or you do not have permissions.', 'Invalid Object on you do not have permissions. Please check attribute "objectType" on your permissions to Object.');
            }
            
            if (additionalField != null && additionalField != '') {  
                
                Schema.DescribeFieldResult dr = LookupFieldService.obtainFieldType(sObjectType, additionalField);
                if (dr == null) {
                    return new LookupResponse('error', 'Additional field is invalid', 'Additional is invalid. Please check attribute additionalField. If this is correct, check its type, this should match the documentation.');
                }  
                
                additionalFieldType = String.valueOf(dr.getType()).toLowerCase();
                
                // Check is additionalField valid and accessible
                if (additionalField != null && !LookupFieldService.VALID_ADDITIONAL_DISPLAY_TYPE_SET.contains(additionalFieldType)) {
                    return new LookupResponse('error', 'Additional field is invalid', 'Additional is invalid. Please check attribute additionalField. If this is correct, check its type, this should match the documentation.');
                }  
            }
            
            info.objectLabel = objectDescribeResult.getLabel();
            info.objectPluralLabel = objectDescribeResult.getLabelPlural();
            info.iconPath = '';
            info.mainField = QueryService.obtaineNameByType(sObjectType);
            info.additionalField = (additionalField != null && additionalField != '' && additionalFieldType != 'reference') ? info.additionalField = additionalField : QueryService.obtainStandardAdditionalFieldToDisplay(sObjectType, additionalField);
            
            info.additionalField = info.additionalField;
            
            if (info.objectPluralLabel == 'Users') {
                info.iconPath = 'standard:avatar';
                info.iconColor = '67cbe4';
            } else if (info.objectPluralLabel == 'Quotes' || sObjectType == 'quotelineitem') {
                info.iconPath = 'standard:quotes';
                info.iconColor = '87c650';
            } else if (sObjectType == 'opportunitylineitem') {
                info.iconPath = 'standard:opportunity';
                info.iconColor = 'f6b95a';
            } else if (info.objectPluralLabel == 'Tasks') {
                info.iconPath = 'custom:custom18';
                info.iconColor = '67cbe4'; 
            } else if (sObjectType == 'Asset') {
                info.iconPath = 'standard:product';
                info.iconColor = '327992'; 
            } else if (sObjectType == 'PriceBook') {
                info.iconPath = 'standard:pricebook';
            } else { 
                System.debug(sObjectType);
                for (DescribeTabSetResult tsr : Schema.describeTabs()) {
                    for (DescribeTabResult tr : tsr.getTabs()) {
                        
                        if (tr.getLabel() == info.objectPluralLabel) {
                            List<Schema.DescribeIconResult> iconDesc = tr.getIcons();
                            
                            if (!tr.isCustom()) {
                                if (sObjectType.toLowerCase() == 'product2') {
                                    info.iconPath = 'standard:product';
                                } else if (sObjectType.toLowerCase() == 'order' || sObjectType.toLowerCase() == 'orderitem') {
                                    info.iconPath = 'standard:orders';
                                } else if (sObjectType.toLowerCase() == 'quote') {
                                    info.iconPath = 'standard:quotes';
                                } else if (sObjectType.toLowerCase() == 'quotelineitem') {
                                    info.iconPath = 'standard:quotes';
                                } else if (sObjectType.toLowerCase() == 'opportunitylineitem') {
                                    info.iconPath = 'standard:opportunity';
                                } else {
                                    info.iconPath = 'standard:' + sObjectType.toLowerCase();
                                }
                            } else {
                                info.iconPath = 'custom:' + IconHelper.getLightningIcon(iconDesc[0].getUrl().substringAfterLast('/'));
                            }
                            
                            List<Schema.DescribeColorResult> colorDesc = tr.getColors();
                            
                            info.iconColor = colorDesc[0].getColor();
                            break;
                        }
                    }
                }
            }
            
            return new LookupResponse(info);
            
        } catch (Exception ex) {
            System.debug('[ Exception caught ] -- ' + ex.getMessage()); 
            System.debug('[ Exception caught ] Line: ' + ex.getLineNumber());
            System.debug('[ Exception caught ] StackTrace: ' + ex.getStackTraceString());
            return new LookupResponse('error', 'Unhandled exception', ex.getMessage());
        }
    }
    
    @AuraEnabled
    global static LookupResponse obtainRecordsList(String sObjectType, String searchKeyWord, String additionalField, String queryCondition) {
     	
        if (sObjectType == null || sObjectType == '') {
            throw new LookupException('SObject type is not define.');
            return new LookupResponse('error', 'Unexpected error.', 'SObject type is not define.');
        }
        
        String query = '';
        List<Object> resultList = new List<Object>();
        List<SObject> obtainList = new List <SObject>();
        String nameField = QueryService.obtaineNameByType(sObjectType);
        
        try {
            query = QueryService.generateQuery(sObjectType, searchKeyWord, additionalField, false, queryCondition);
            System.debug(query);
            
            
            String additionalSearchFieldToDisplay = QueryService.obtainStandardAdditionalFieldToDisplay(sObjectType, additionalField);
            
            if (query != null && query != '') {
                obtainList = DataBase.query(query);
                System.debug('obtainList -- ' + obtainList);
                
                if (!obtainList.isEmpty()) {
                    for (SObject obj_i : obtainList) {
                        resultList.add( obj_i );
                    }
                }
                
                return new LookupResponse(resultList);
            }
            
        } catch(Exception ex) {
            
            if (ex.getTypeName() == 'System.QueryException' && queryCondition != null && queryCondition != '') {
                return new LookupResponse('error', 'Error in query.', 'Check value in queryCondition attribute. If you are sure that i is correct and still getting the error contact to contact@synebo.io.');
            }
            System.debug('[Exception caught] -- ' + ex.getMessage()); 
            System.debug('[Exception caught] Line: ' + ex.getLineNumber());
            System.debug('[Exception caught] StackTrace: ' + ex.getStackTraceString());
            return new LookupResponse('error', 'Unexpected error.', ex.getMessage() + '. Contact to contact@synebo.io.');
        }
        
        return null;
    }
    
    @AuraEnabled
    global static LookupResponse obtainFiveRecentRecords(String sObjectType, String additionalField, String queryCondition) {
     	
        if (sObjectType.toLowerCase() != 'opportunitylineitem') {
            String query = '';
            List<Object> resultList = new List<Object>();
            List<SObject> obtainList = new List <SObject>();
            String nameField = QueryService.obtaineNameByType(sObjectType);
            System.debug(queryCondition);
            
            try {
                query = QueryService.generateQuery(sObjectType, '', additionalField, true, queryCondition);
                System.debug('[ Search query ] -- ' + query);
                
                String additionalSearchFieldToDisplay = QueryService.obtainStandardAdditionalFieldToDisplay(sObjectType, additionalField);
                
                if (query != null && query != '') {
                    obtainList = DataBase.query(query);
                    
                    if (!obtainList.isEmpty()) {
                        for (SObject obj_i : obtainList) {
                            resultList.add( obj_i );
                        }
                        
                        return new LookupResponse(resultList);
                    }
                }
                
            } catch(Exception ex) {
                if (ex.getTypeName() == 'System.QueryException' && queryCondition != null && queryCondition != '') {
                    return new LookupResponse('error', 'Error in query.', 'Check value in queryCondition attribute. If you are sure that i is correct and still getting the error contact to contact@synebo.io.');
                }
                System.debug('[Exception caught] -- ' + ex.getMessage()); 
                System.debug('[Exception caught] Line: ' + ex.getLineNumber());
                System.debug('[Exception caught] StackTrace: ' + ex.getStackTraceString());
                return new LookupResponse('error', 'Unexpected error.', ex.getMessage() + '. Contact to contact@synebo.io.');
            }
        }
        return null; 
    }
    
    // Title        : obtainRecordById
    // Input params : searchById - Id for search, objectType - type of Lookup, queryCondition - additional conditiom
    // Return value : LookupResponse
    // Description  : Method for obtaining record by Id
    @AuraEnabled
    global static LookupResponse obtainRecordById(String searchById, String objectType, String queryCondition) {
        
        try {
            List<SObject> obtainList = new List <SObject> (); 
            SObjectType schemaType = Schema.getGlobalDescribe().get(objectType);
            Map<String, SObjectField> fieldMap = schemaType.getDescribe().fields.getMap();
            String nameField = QueryService.obtaineNameByType(objectType);
            
            String query = 'SELECT Id, ' + nameField + ' FROM ' + objectType + ' WHERE Id = \'' + searchById + '\'';
            if (queryCondition != null && queryCondition != '') {
                query += ' AND (' + queryCondition + ')';
            }
            query += ' LIMIT 1';
            
            if (fieldMap.get('Id').getDescribe().isAccessible() && fieldMap.get(nameField).getDescribe().isAccessible() && schemaType.getDescribe().isAccessible()) {
                obtainList = DataBase.query(query);
                
                if (!obtainList.isEmpty()) {
                    return new LookupResponse(obtainList[0]);
                } else if (queryCondition != null && queryCondition != ''){
                    return new LookupResponse('warning', 'Invalid value.', 'Id is invalid or do not match criteria. You use attribute queryCondition please check that record matched criterias');
                } else {
                    return new LookupResponse('warning', 'Invalid value.', 'No results');
                }
            }
        } catch(Exception ex) {
            if (ex.getTypeName() == 'System.QueryException' && queryCondition != null && queryCondition != '') {
                return new LookupResponse('error', 'Error in query.', 'Check value in queryCondition attribute. If you are sure that i is correct and still getting the error contact to contact@synebo.io.');
            }
            System.debug('[Exception caught] -- ' + ex.getMessage()); 
            System.debug('[Exception caught] Line: ' + ex.getLineNumber());
            System.debug('[Exception caught] StackTrace: ' + ex.getStackTraceString());
            return new LookupResponse('error', 'Unexpected error.', ex.getMessage() + '. Contact to contact@synebo.io.');
        }
        return null;
    }
    
    
    
    
    global class InfoWrapper {
        @AuraEnabled
        global String objectLabel { get; set; }
        @AuraEnabled
        global String objectPluralLabel { get; set; }
        @AuraEnabled
        global String iconPath { get; set; }
        @AuraEnabled
        global String iconColor { get; set; }
        @AuraEnabled
        global String mainField { get; set; }
        @AuraEnabled
        global String additionalField { get; set; }
    }
    
    
}