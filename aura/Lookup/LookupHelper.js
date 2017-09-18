({
    searchHelper : function(component,event,getInputkeyWord) {
        
        var action;
        var listRecords = component.get("v.listOfSearchRecordsRecent");
        var type = component.get("v.objectType");
        
        if (getInputkeyWord.length < 3 && type.toLowerCase() != 'contact') {
            
            component.set("v.listOfSearchRecords", null);
            var tmp = new Array();
            var i;
            if (listRecords.length > 0) {
                for ( i = 0; i < listRecords.length; i++) {
                    
                    if (type.toLowerCase() == 'contact') {
                        if ((listRecords[i].Account.Name && listRecords[i].Account.Name.toLowerCase().startsWith(getInputkeyWord.toLowerCase()) ) || 
                            (listRecords[i].FirstName && listRecords[i].FirstName.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) || 
                            (listRecords[i].LastName && listRecords[i].LastName.toLowerCase().startsWith(getInputkeyWord.toLowerCase()))) {
                            
                            tmp.push(listRecords[i]);
                        }
                    } else if (type.toLowerCase() == 'user') {
                        if ((listRecords[i].Name && listRecords[i].Name.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) || 
                            (listRecords[i].FirstName && listRecords[i].FirstName.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) || 
                            (listRecords[i].LastName && listRecords[i].LastName.toLowerCase().startsWith(getInputkeyWord.toLowerCase()))) {
                            
                            tmp.push(listRecords[i]);
                        }
                    } else if (type.toLowerCase() == 'lead') {
                        if ((listRecords[i].Title && listRecords[i].Title.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) || 
                            (listRecords[i].FirstName && listRecords[i].FirstName.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) || 
                            (listRecords[i].LastName && listRecords[i].LastName.toLowerCase().startsWith(getInputkeyWord.toLowerCase()))) {
                            
                            tmp.push(listRecords[i]);
                        }
                    } else if (type.toLowerCase() == 'case') {
                        if ((listRecords[i].CaseNumber && listRecords[i].CaseNumber.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) || 
                            (listRecords[i].Subject && listRecords[i].Subject.toLowerCase().startsWith(getInputkeyWord.toLowerCase()))) {
                            
                            tmp.push(listRecords[i]);
                        }
                    } else if (type.toLowerCase() == 'contract') {
                        if ((listRecords[i].ContractNumber && listRecords[i].ContractNumber.toLowerCase().startsWith(getInputkeyWord.toLowerCase()) ) || 
                            (listRecords[i].Account.Name && listRecords[i].Account.Name.toLowerCase().startsWith(getInputkeyWord.toLowerCase()))) {
                            
                            tmp.push(listRecords[i]);
                        }
                    } else if (type.toLowerCase() == 'order') {
                        
                        if ((listRecords[i].OrderNumber && listRecords[i].OrderNumber.toLowerCase().startsWith(getInputkeyWord.toLowerCase()) ) || 
                            (listRecords[i].Account.Name && listRecords[i].Account.Name.toLowerCase().startsWith(getInputkeyWord.toLowerCase()))) {
                            
                            tmp.push(listRecords[i]);
                        }
                    }  else if (type.toLowerCase() == 'orderitem') {
                        if (listRecords[i].OrderItemNumber.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) {
                            
                            tmp.push(listRecords[i]);
                        }
                    } else {
                        if (listRecords[i].Name.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) {
                            tmp.push(listRecords[i]);
                        }
                    }
                    
                }
                
                component.set("v.listOfSearchRecords", tmp);
                    $A.createComponent("c:CustomLookupResultWrapper", {
                        "sObjectType": component.get("v.objectType"),
                        "iconPath": component.get("v.objectIconPath"),
                        "iconColor": component.get("v.objectIconColor"),
                        "objectPluralLabel": component.get("v.objectPluralLabel"),
                        "listOfSearchRecords": component.get("v.listOfSearchRecords"),
                        "keyWord": getInputkeyWord
                    },
                                       function(newList, status, errorMessage) {
                                           var container = component.find('lookupResultsContainer');
                                           container.set("v.body", '');
                                           var body = container.get("v.body");
                                           body.push(newList);
                                           container.set("v.body", body);
                                       });
            }
            
        } else {
            
            component.set("v.listOfSearchRecords", null);
            
            action = component.get("c.obtainObjectList");
            action.setParams({
                'searchKeyWord' : getInputkeyWord,
                'objectType'    : component.get("v.objectType")
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.listOfSearchRecords", storeResponse);
                    $A.createComponent("c:CustomLookupResultWrapper", {
                        "sObjectType": component.get("v.objectType"),
                        "iconPath": component.get("v.objectIconPath"),
                        "iconColor": component.get("v.objectIconColor"),
                        "objectPluralLabel": component.get("v.objectPluralLabel"),
                        "listOfSearchRecords": storeResponse,
                        "keyWord": getInputkeyWord
                    },
                                       function(newList, status, errorMessage) {
                                           var container = component.find('lookupResultsContainer');
                                           container.set("v.body", '');
                                           var body = container.get("v.body");
                                           body.push(newList);
                                           container.set("v.body", body);
                                       });
                    
                }
                
            });
            
            $A.enqueueAction(action);
        }
        
    },
    
    
    showRecentViewesHlp : function(component, event, helper) {
        var sObjectType = component.get("v.objectType");
        var isShows = component.get("v.showFiveRecent");
        if (isShows && sObjectType.toLowerCase() != 'orderitem') {
            var action = component.get("c.showRecentViewed");
            action.setParams({
                'objectType' : sObjectType
            });
            var forOpen = component.find("searchRes");
            action.setCallback(this, function(response) {
                var state = response.getState();
                var storeResponse = response.getReturnValue();
                
                if (state === "SUCCESS" && storeResponse != null && storeResponse && storeResponse.length > 0) {
                    
                    $A.util.addClass(forOpen, 'slds-is-open');
                    $A.util.removeClass(forOpen, 'slds-is-close');
                     
                    component.set("v.listOfSearchRecordsRecent", storeResponse);

                    $A.createComponent("c:CustomLookupResultWrapper", {
                        "sObjectType": component.get("v.objectType"),
                        "iconPath": component.get("v.objectIconPath"),
                        "iconColor": component.get("v.objectIconColor"),
                        "objectPluralLabel": component.get("v.objectPluralLabel"),
                        "listOfSearchRecords": storeResponse,
                        "keyWord": ''
                    },
                                       function(newList, status, errorMessage) {
                                           var container = component.find('lookupResultsContainer');
                                           container.set("v.body", '');
                                           var body = container.get("v.body");
                                           body.push(newList);
                                           container.set("v.body", body);
                                       });
                    
                }
            });
            $A.enqueueAction(action);
        }
    },
})
