global class LookupFieldController {
    
    // Title        : obtainObjectList
    // Input params : searchKeyWord - String key for search, objectType - type of Lookup
    // Return value : List<SObject>
    // Description  : Method for obtaining records
    @AuraEnabled
    global static List<SObject> obtainObjectList(String searchKeyWord, String objectType) {
        
        List<SObject> obtainList = new List < SObject > ();
        String query = gererateQuery(objectType, searchKeyWord, false);
        
        //System.debug(query);
        
        obtainList = DataBase.query(query);
        
        return obtainList;
    }
    
    // Title        : obtainObjectById
    // Input params : searchById - Id for search, objectType - type of Lookup
    // Return value : SObject
    // Description  : Method for obtaining records
    @AuraEnabled
    global static SObject obtainObjectById(String searchById, String objectType) {
        
        List<SObject> obtainList = new List < SObject > ();
        String query = 'SELECT Id, Name FROM ' + objectType + ' WHERE Id = \'' + searchById + '\' LIMIT 1';
        
        //System.debug(query);
        
        obtainList = DataBase.query(query);
        
        if (!obtainList.isEmpty()) {
            return obtainList[0];
        }
        return null;
    }
    
    // Title        : getInfo
    // Input params : objectType - type of Lookup
    // Return value : InfoWrapper
    // Description  : Method for obtaining info about sObject (color, icon etc.)    
    @AuraEnabled
    global static InfoWrapper getInfo(String objectType) {
        
        InfoWrapper info = new InfoWrapper();
        Map<String, String> classicIconToLighting = new Map<String, String>();
        
        classicIconToLighting.put('plane32.png',         'custom20');
        classicIconToLighting.put('books32.png',         'custom55');
        classicIconToLighting.put('can32.png',           'custom59');
        classicIconToLighting.put('circle32.png',        'custom12');
        classicIconToLighting.put('dice32.png',          'custom66');
        classicIconToLighting.put('hammer32.png',        'custom44');
        classicIconToLighting.put('hotairBalloon32.png', 'custom74');
        classicIconToLighting.put('padlock32.png',       'custom77');
        classicIconToLighting.put('pda32.png',           'custom29');
        classicIconToLighting.put('redcross32.png',      'custom86');
        classicIconToLighting.put('shoppingCart32.png',  'custom93');
        classicIconToLighting.put('telescope32.png',     'custom39');
        classicIconToLighting.put('tvWidescreen32.png',  'custom100');
        classicIconToLighting.put('alarmClock32.png',    'custom25');
        classicIconToLighting.put('bottle32.png',        'custom56');
        classicIconToLighting.put('car32.png',           'custom31');
        classicIconToLighting.put('compass32.png',       'custom64');
        classicIconToLighting.put('factory32.png',       'custom32');
        classicIconToLighting.put('hands32.png',         'custom14');
        classicIconToLighting.put('insect32.png',        'custom34');
        classicIconToLighting.put('mail32.png',          'custom23');
        classicIconToLighting.put('pencil32.png',        'custom83');
        classicIconToLighting.put('sack32.png',          'custom17');
        classicIconToLighting.put('square32.png',        'custom7');
        classicIconToLighting.put('thermometer32.png',   'custom97');
        classicIconToLighting.put('umbrella32.png',      'custom60');
        classicIconToLighting.put('apple32.png',         'custom51');
        classicIconToLighting.put('box32.png',           'custom13');
        classicIconToLighting.put('castle32.png',        'custom61');
        classicIconToLighting.put('computer32.png',      'custom21');
        classicIconToLighting.put('fan32.png',           'custom2');
        classicIconToLighting.put('handsaw32.png',       'custom70');
        classicIconToLighting.put('ipPhone32.png',       'custom75');
        classicIconToLighting.put('map32.png',           'custom78');
        classicIconToLighting.put('people32.png',        'custom15');
        classicIconToLighting.put('safe32.png',          'custom87');
        classicIconToLighting.put('cash32.png',          'custom41');
        classicIconToLighting.put('ticket32.png',        'custom45');
        classicIconToLighting.put('whistle32.png',       'custom82');
        classicIconToLighting.put('balls32.png',         'custom52');
        classicIconToLighting.put('bridge32.png',        'custom37');
        classicIconToLighting.put('cd32.png',            'custom49');
        classicIconToLighting.put('creditCard32.png',    'custom40');
        classicIconToLighting.put('flag32.png',          'custom26');
        classicIconToLighting.put('headset32.png',       'custom71');
        classicIconToLighting.put('jewel32.png',         'custom43');
        classicIconToLighting.put('measuringTape32.png', 'custom79');
        classicIconToLighting.put('phone32.png',         'custom22');
        classicIconToLighting.put('sailboat32.png',      'custom88');
        classicIconToLighting.put('star32.png',          'custom11');
        classicIconToLighting.put('train32.png',         'custom36');
        classicIconToLighting.put('wrench32.png',        'custom19');
        classicIconToLighting.put('bank32.png',          'custom16');
        classicIconToLighting.put('building32.png',      'custom24');
        classicIconToLighting.put('cellPhone32.png',     'custom28');
        classicIconToLighting.put('tvCTR32.png',         'custom99');
        classicIconToLighting.put('form32.png',          'custom18');
        classicIconToLighting.put('heart32.png',         'custom1');
        classicIconToLighting.put('keys32.png',          'custom76');
        classicIconToLighting.put('microphone32.png',    'custom35');
        classicIconToLighting.put('stamp32.png',         'custom46');
        classicIconToLighting.put('saxophone32.png',     'custom89');
        classicIconToLighting.put('stethoscope32.png',   'custom94');
        classicIconToLighting.put('chest32.png',         'custom42');
        classicIconToLighting.put('bell32.png',          'custom53');
        classicIconToLighting.put('buildingBlock32.png', 'custom57');
        classicIconToLighting.put('chalkboard32.png',    'custom18');
        classicIconToLighting.put('cup32.png',           'custom65');
        classicIconToLighting.put('gears32.png',         'custom67');
        classicIconToLighting.put('helicopter32.png',    'custom72');
        classicIconToLighting.put('laptop32.png',        'custom27');
        classicIconToLighting.put('moon32.png',          'custom10');
        classicIconToLighting.put('presenter32.png',     'custom84');
        classicIconToLighting.put('scales32.png',        'custom90');
        classicIconToLighting.put('stopwatch32.png',     'custom95');
        classicIconToLighting.put('triangle32.png',      'custom6');
        classicIconToLighting.put('bigtop32.png',        'custom50');
        classicIconToLighting.put('boat32.png',          'custom54');
        classicIconToLighting.put('caduceus32.png',      'custom58');
        classicIconToLighting.put('camera32.png',        'custom38');
        classicIconToLighting.put('knight32.png',        'custom47');
        classicIconToLighting.put('chip32.png',          'custom63');
        classicIconToLighting.put('desk32.png',          'custom33');
        classicIconToLighting.put('diamond32.png',       'custom8');
        classicIconToLighting.put('globe32.png',         'custom68');
        classicIconToLighting.put('guitar32.png',        'custom69');
        classicIconToLighting.put('hexagon32.png',       'custom4');
        classicIconToLighting.put('highwaySign32.png',   'custom73');
        classicIconToLighting.put('leaf32.png',          'custom5');
        classicIconToLighting.put('lightning32.png',     'custom9');
        classicIconToLighting.put('motorcycle32.png',    'custom80');
        classicIconToLighting.put('musicalNote32.png',   'custom81');
        classicIconToLighting.put('radarDish32.png',     'custom30');
        classicIconToLighting.put('realEstateSign32.png', 'custom85');
        classicIconToLighting.put('shield32.png',        'custom91');
        classicIconToLighting.put('ship32.png',          'custom92');
        classicIconToLighting.put('streetSign32.png',    'custom96');
        classicIconToLighting.put('sun32.png',           'custom3');
        classicIconToLighting.put('trophy32.png',        'custom48');
        classicIconToLighting.put('truck32.png',         'custom98');
        classicIconToLighting.put('plane32.png',         'custom20');

           
        try {
            
            SObjectType sObjectTypeItem = Schema.getGlobalDescribe().get(objectType);
            Schema.DescribeSObjectResult objectDescribeResult =  sObjectTypeItem.getDescribe();
            
            info.objectLabel = objectDescribeResult.getLabel();
            info.objectPluralLabel = objectDescribeResult.getLabelPlural();
            info.iconPath = '';
            
            if (info.objectPluralLabel == 'Users') {
                info.iconPath = '/assets/icons/standard/user';
                info.iconColor = '67cbe4';
            } else {
            
                for (DescribeTabSetResult tsr : Schema.describeTabs()) {
                    for (DescribeTabResult tr : tsr.getTabs()) {
                        
                        if (tr.getLabel() == info.objectPluralLabel) {
                            List<Schema.DescribeIconResult> iconDesc = tr.getIcons();
                            
                            if (!tr.isCustom()) {
                                if (objectType.toLowerCase() == 'product2') {
                                    info.iconPath = '/assets/icons/standard/product'; 
                                } else if (objectType.toLowerCase() == 'order' || objectType.toLowerCase() == 'orderitem') {
                                    info.iconPath = '/assets/icons/standard/orders'; 
                                } else {
                                    info.iconPath = '/assets/icons/standard/'+ objectType.toLowerCase(); 
                                }
                            } else {
                                info.iconPath = '/assets/icons/custom/' + classicIconToLighting.get(iconDesc[0].getUrl().substringAfterLast('/'));
                            }
                            
                            List<Schema.DescribeColorResult> colorDesc = tr.getColors();
                            
                            info.iconColor = colorDesc[0].getColor();
                            break;
                        }
                    }
                }
                
                //if (searchById != null || searchById != '') {
                  //  info.objRecord = obtainObjectById(searchById, objectType); 
                //}
            }
        } catch (Exception ex) {
            System.debug('Exception! Error: ' + ex.getMessage() + '. Line: ' + ex.getLineNumber());
        }
        
        return info;
    }
    
    // Title        : showRecentViewed
    // Input params : objectType - type of Lookup
    // Return value : List<SObject> 
    // Description  : Method for obtaining 5 Lastviewed records 
    @AuraEnabled
    global static List<SObject> showRecentViewed(String objectType) {
        
        List<SObject> recentRecordsList = new List<SObject>();
        
        String query = gererateQuery(objectType, '', true);
        recentRecordsList = DataBase.query(query);
        System.debug(query);
        
        return recentRecordsList;
    }
    
    
    // Title        : gererateQuery
    // Input params : objectType - type of Lookup, searchKeyWord - String key for search, isLastViewed - is it for lastViewed
    // Return value : List<SObject> 
    // Description  : Method for obtaining 5 Lastviewed records 
    public static String gererateQuery(String objectType, String searchKeyWord, Boolean isLastViewed) {
        
        String query = '';
        String searchKey = '';
        
        if (objectType.toLowerCase() == 'case' && Schema.sObjectType.Case.fields.Id.isAccessible() && Schema.sObjectType.Case.fields.CaseNumber.isAccessible() && Schema.sObjectType.Case.fields.Subject.isAccessible()) {
            query = 'SELECT Id, CaseNumber, Subject ';
        } else if (objectType.toLowerCase() == 'contract' && Schema.sObjectType.Contract.fields.Id.isAccessible() && Schema.sObjectType.Contract.fields.ContractNumber.isAccessible()) {
            query = 'SELECT Id, ContractNumber ';
        } else if (objectType.toLowerCase() == 'order' && Schema.sObjectType.Order.fields.Id.isAccessible() && Schema.sObjectType.Order.fields.OrderNumber.isAccessible()) {
            query = 'SELECT Id, OrderNumber ';
        } else if (objectType.toLowerCase() == 'orderitem' && Schema.sObjectType.Orderitem.fields.Id.isAccessible() && Schema.sObjectType.Orderitem.fields.OrderItemNumber.isAccessible()) {
            query = 'SELECT Id, OrderItemNumber ';
        } else {
            query = 'SELECT Id, Name ';
        }
        
        if ((objectType.toLowerCase() == 'contact' && Schema.sObjectType.Contact.fields.FirstName.isAccessible() && Schema.sObjectType.Contact.fields.LastName.isAccessible()) || 
            (objectType.toLowerCase() == 'user') && Schema.sObjectType.User.fields.FirstName.isAccessible() && Schema.sObjectType.User.fields.LastName.isAccessible()) {
            query += ', FirstName, LastName ';
        }
        
        if ((objectType.toLowerCase() == 'contact' && Schema.sObjectType.Contact.fields.AccountId.isAccessible()) || (objectType.toLowerCase() == 'order' && Schema.sObjectType.Order.fields.AccountId.isAccessible()) || (objectType.toLowerCase() == 'contract' && Schema.sObjectType.Contract.fields.AccountId.isAccessible())) {
            query += ', Account.Name ';
        }
        
        if (objectType.toLowerCase() == 'lead' && Schema.sObjectType.Lead.fields.FirstName.isAccessible() && Schema.sObjectType.Lead.fields.LastName.isAccessible() && Schema.sObjectType.Lead.fields.Title.isAccessible()) {
            query += ', FirstName, LastName, Title ';
        }
        if (objectType.toLowerCase() == 'product2' && Schema.sObjectType.Product2.fields.ProductCode.isAccessible()) {
            query += ', ProductCode ';
        }
        
        query += ' FROM ' + objectType;
        
        if (searchKeyWord != null && searchKeyWord != '') {
            searchKey = searchKeyWord + '%';
            
            if (objectType.toLowerCase() == 'case') {
                query += ' WHERE CaseNumber Like \'' + searchKey + '\' OR Subject Like \'' + searchKey + '\'';
            } else if (objectType.toLowerCase() == 'user') {
                query += ' WHERE Name Like \'' + searchKey + '\' OR FirstName Like \'' + searchKey + '\' OR LastName Like \'' + searchKey + '\'';
            } else if (objectType.toLowerCase() == 'contact') {
                query += ' WHERE Name Like \'' + searchKey + '\' OR Account.Name Like \'' + searchKey + '\' OR FirstName Like\'' + searchKey + '\' OR LastName Like\'' + searchKey + '\'';
            } else if (objectType.toLowerCase() == 'lead') {
                query += ' WHERE Name Like \'' + searchKey + '\' OR Title Like \'' + searchKey + '\' OR FirstName Like\'' + searchKey + '\' OR LastName Like\'' + searchKey + '\''; 
            } else if (objectType.toLowerCase() == 'product2') {
                query += ' WHERE Name Like \'' + searchKey + '\' OR ProductCode Like \'' + searchKey + '\'';
            } else if (objectType.toLowerCase() == 'contract') {
                query += ' WHERE ContractNumber Like \'' + searchKey + '\' OR Account.Name Like \'' + searchKey + '\'';
            } else if (objectType.toLowerCase() == 'order') {
                query += ' WHERE OrderNumber Like \'' + searchKey + '\' OR Account.Name Like \'' + searchKey + '\'';
            } else if (objectType.toLowerCase() == 'orderitem') {
                query += ' WHERE OrderItemNumber Like \'' + searchKey + '\'';
            } else {
                query += ' WHERE Name Like \'' + searchKey + '\'';
            }
        }
        
        if (isLastViewed) {
            query += ' WHERE LastViewedDate != null ORDER BY LastViewedDate DESC ';
            query += ' LIMIT 5';
        }
        
        return query;
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
        global SObject objRecord { get; set; }
        
    }

}
