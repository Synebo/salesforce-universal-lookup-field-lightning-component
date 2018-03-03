({
    searchHelper : function(cmp, event, getInputkeyWord) {
        
        var action;
        var listRecords = cmp.get("v.listOfSearchRecordsRecent");
        var type = cmp.get("v.objectType");
        var additional = cmp.get("v.additionalField");
        var mainField = cmp.get("v.mainField");
        
        if (getInputkeyWord.length < 3 && type && type.toLowerCase() != 'contact') {
            
            cmp.set("v.listOfSearchRecords", null);
            var tmp = new Array();
            var i;
            
            if (listRecords.length > 0) {
                for ( i = 0; i < listRecords.length; i++) {
                    
                    if (listRecords[i][mainField] && listRecords[i][mainField] && getInputkeyWord && listRecords[i][additional] ||
                        listRecords[i][additional]) {
                        tmp.push(listRecords[i]);
                    }                    
                }
                
                cmp.set("v.listOfSearchRecords", tmp);
                
                $A.createComponent("c:CustomLookupResultWrapper", {
                    "sObjectType"		  : cmp.get("v.objectType"),
                    "iconPath"			  : cmp.get("v.objectIconPath"),
                    "iconColor"			  : cmp.get("v.objectIconColor"),
                    "objectPluralLabel"   : cmp.get("v.pluralLabel"),
                    "listOfSearchRecords" : cmp.get("v.listOfSearchRecords"),
                    "keyWord"             : getInputkeyWord,
                    "main"                : mainField,
                    "additional"          : cmp.get("v.additionalFieldValue")
                },
                                   function(newList, status, errorMessage) {
                                       var container = cmp.find('lookupResultsContainer');
                                       container.set("v.body", '');
                                       var body = container.get("v.body");
                                       body.push(newList);
                                       container.set("v.body", body);
                                   });
            }
            
        } else {
            
            cmp.set("v.listOfSearchRecords", null);
            
            action = cmp.get("c.obtainRecordsList");
            
            action.setParams({
                'searchKeyWord'   : getInputkeyWord,
                'sObjectType'      : cmp.get("v.objectType"),
                'additionalField' : additional,
                'queryCondition' : cmp.get("v.queryCondition")
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var storeResponse = response.getReturnValue();
                if (state === "SUCCESS" && storeResponse.isSuccess) {
                    
                    
                    cmp.set("v.listOfSearchRecords", storeResponse);
                    $A.createComponent("c:CustomLookupResultWrapper", {
                        "sObjectType"		  : cmp.get("v.objectType"),
                        "iconPath"			  : cmp.get("v.objectIconPath"),
                        "iconColor"			  : cmp.get("v.objectIconColor"),
                        "objectPluralLabel"   : cmp.get("v.pluralLabel"),
                        "listOfSearchRecords" : storeResponse.respBody,
                        "keyWord"             : getInputkeyWord,
                        "main"                : mainField,
                        "additional"          : cmp.get("v.additionalFieldValue")
                    },
                                       function(newList, status, errorMessage) {
                                           var container = cmp.find('lookupResultsContainer');
                                           container.set("v.body", '');
                                           var body = container.get("v.body");
                                           body.push(newList);
                                           container.set("v.body", body);
                                       });
                    
                } else if (state === "SUCCESS" && !storeResponse.isSuccess){
                    this.errorCatched(cmp, storeResponse.shortErrorDescr, storeResponse.detailErrorDescr);
                }
                
            });
            
            $A.enqueueAction(action);
        }
    },
        
    showRecentViewesHlp : function(cmp, event, helper) {
        
        var additional = cmp.get("v.additionalField");
        var mainField = cmp.get("v.mainField");
        var sObjectType = cmp.get("v.objectType");
        var isShows = cmp.get("v.showFiveRecent");
        
        if (isShows && sObjectType && sObjectType.toLowerCase() != 'orderitem') {
            var action = cmp.get("c.obtainFiveRecentRecords");
            action.setParams({
                'sObjectType'     : sObjectType,
                'additionalField' : cmp.get("v.additionalField"),
                'queryCondition' : cmp.get("v.queryCondition")
            });
            var forOpen = cmp.find("searchRes");
            action.setCallback(this, function(response) {
                var state = response.getState();
                var storeResponse = response.getReturnValue();
                
                if (state === "SUCCESS" && storeResponse != null && storeResponse.isSuccess && storeResponse && storeResponse.respBody.length > 0) {
                    
                    $A.util.addClass(forOpen, 'slds-is-open');
                    $A.util.removeClass(forOpen, 'slds-is-close');
                     
                    cmp.set("v.listOfSearchRecordsRecent", storeResponse);
					
                    $A.createComponent("c:CustomLookupResultWrapper", {
                        "sObjectType"		  : cmp.get("v.objectType"),
                        "iconPath"			  : cmp.get("v.objectIconPath"),
                        "iconColor"			  : cmp.get("v.objectIconColor"),
                        "objectPluralLabel"   : cmp.get("v.pluralLabel"),
                        "listOfSearchRecords" : storeResponse.respBody,
                        "main"                : mainField,
                        "additional"          : cmp.get("v.additionalFieldValue")
                    },
                                       function(newList, status, errorMessage) {
                                           var container = cmp.find('lookupResultsContainer');
                                           container.set("v.body", '');
                                           var body = container.get("v.body");
                                           body.push(newList);
                                           container.set("v.body", body);
                                       });
                    
                } else if (state === "SUCCESS" && storeResponse != null && !storeResponse.isSuccess) {
                   this.errorCatched(cmp, storeResponse.shortErrorDescr, storeResponse.detailErrorDescr);
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    showExceptionToast : function(cmp, evt) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            message: 'This is a required message',
            messageTemplate: 'Record {0} created! See it {1}!',
            messageTemplateData: [
                'Salesforce', {
                    url: 'http://www.salesforce.com/',
                    label: 'here',
                }
            ]
        });
        toastEvent.fire();
    },
    
    onChangeEventFire: function(cmp) {
        var newVal = cmp.get("v.selectedRecordId");
        var oldVal = cmp.get("v.prevSelectedRecordId");
        
        if (newVal && oldVal && newVal != oldVal) {
            var onChangeEv = cmp.getEvent("onchange");
            onChangeEv.setParams({"cmpId": cmp.getLocalId()});
            onChangeEv.setParams({"oldValue": cmp.get("v.prevSelectedRecordId")});
            onChangeEv.fire(); 
        }
    },
    
    onFocusEventFire: function(cmp) {
        var onFocusEv = cmp.getEvent("onfocus");
        onFocusEv.setParams({"cmpId": cmp.getLocalId()});
        onFocusEv.fire();
    },
    
    onBlurEventFire: function(cmp) {
        var onBlurEv = cmp.getEvent("onblur");
        onBlurEv.setParams({"cmpId": cmp.getLocalId()});
        onBlurEv.fire();
    },
    
    changeLookupValue: function(cmp, evt) {
        
        var lookupId = cmp.get("v.setTo");
        
        if (lookupId && lookupId != null && lookupId != "") {
        
            var action1 = cmp.get("c.obtainRecordById");
            
            action1.setParams({
                'searchById'    : lookupId,
                'objectType'    : cmp.get("v.objectType"),
                'queryCondition' : cmp.get("v.queryCondition")
            });
            
            action1.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    
                    if (storeResponse && storeResponse != null && storeResponse.isSuccess) {
                        cmp.set("v.searchIsActive", false );
                        cmp.set("v.selectedRecord", storeResponse.respBody);
                        cmp.set("v.selectedRecordId", storeResponse.respBody.Id);
                        cmp.set("v.selectedRecordTitle", storeResponse.respBody[cmp.get("v.mainField")]);
                        this.onChangeEventFire(cmp);
                        
                        var forclose = cmp.find("lookup-pill");
                        $A.util.addClass(forclose, 'slds-show');
                        $A.util.removeClass(forclose, 'slds-hide');
                        
                        var lookUpTarget = cmp.find("lookupField");
                        $A.util.addClass(lookUpTarget, 'slds-hide');
                        $A.util.removeClass(lookUpTarget, 'slds-show'); 
                        
                        var forclose = cmp.find("searchRes");
                        $A.util.addClass(forclose, 'slds-is-close');
                        $A.util.removeClass(forclose, 'slds-is-open');
                    } else if (storeResponse && storeResponse != null && !storeResponse.isSuccess && storeResponse.respType == 'warning') {
                        this.warningCatched(cmp, storeResponse.shortErrorDescr, storeResponse.detailErrorDescr);
                    } else if (storeResponse && storeResponse != null && !storeResponse.isSuccess && storeResponse.respType == 'error') {
                        this.errorCatched(cmp, storeResponse.shortErrorDescr, storeResponse.detailErrorDescr);
                    }
                }
            });
            $A.enqueueAction(action1);
        } else if (lookupId == null){
            this.clearHelper(cmp, evt);
        }
    },
    
    clearHelper : function(cmp, evt) {
        cmp.set("v.searchIsActive", true );  
        
        var pillTarget = cmp.find("lookup-pill");
        var lookUpTarget = cmp.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        cmp.set("v.prevSelectedRecord", cmp.get("v.selectedRecord")); 
        
        cmp.set("v.selectedRecord", null); 
        cmp.set("v.selectedRecordId", null); 
        cmp.set("v.searchKeyWord", null);
        cmp.set("v.listOfSearchRecords", null );
        
        this.onChangeEventFire(cmp);
    },
    
    errorCatched : function(cmp, shortError, detailError) {
        cmp.set("v.searchKeyWord", "#ERROR");
        cmp.set("v.readOnly", "#ERROR");
        
        console.log('[l_lookup] Exception from Lookup component');
        console.log('[l_lookup] Short description: ' + shortError);
        console.log('[l_lookup] Full description: ' + detailError);
    },
    
    warningCatched : function(cmp, shortError, detailError) {
        console.log('[l_lookup] Exception from Lookup component');
        console.log('[l_lookup] Short description: ' + shortError);
        console.log('[l_lookup] Full description: ' + detailError);
    }

})