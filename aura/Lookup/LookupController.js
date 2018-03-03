({
    doInit: function(cmp, evt, helper) {
        
        var action = cmp.get("c.getObjectInfo");
        
        action.setParams({
            'sObjectType'     : cmp.get("v.objectType"),
            'additionalField' : cmp.get("v.additionalField")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state === "SUCCESS" && storeResponse.isSuccess) {
                
                var objectInfo = storeResponse.respBody;
                if (cmp.get("v.label") == "") {
                    cmp.set("v.label", objectInfo.objectLabel);
                }
                if (cmp.get("v.pluralLabel") == "") {
                    cmp.set("v.pluralLabel", objectInfo.objectPluralLabel);
                }
                cmp.set("v.objectIconPath", objectInfo.iconPath);
                cmp.set("v.objectIconColor", objectInfo.iconColor);
                cmp.set("v.mainField", objectInfo.mainField);
                cmp.set("v.additionalFieldValue", objectInfo.additionalField);
                
            } else if (!storeResponse.isSuccess){
                helper.errorCatched(cmp, storeResponse.shortErrorDescr, storeResponse.detailErrorDescr);
            } else {
                console.log('[l_lookup] Unexpected Exception from Lookup component. Please contact to contact@synebo.io.');
            }
        });
        
        $A.enqueueAction(action);

        if (cmp.get("v.selectedRecordId") != null && cmp.get("v.selectedRecordId") != "") {
            helper.changeLookupValue(cmp, evt);
        }
    },
    
    undoObject : function(cmp, event, helper) {
        
        var prevSelectedId = cmp.get("v.prevSelectedRecordId");
        
        cmp.set("v.searchKeyWord", "");

        if (prevSelectedId && prevSelectedId.length > 0) {
            
            cmp.set("v.searchIsActive", false);
            
            cmp.set("v.selectedRecord", cmp.get("v.prevSelectedRecord")); 
            cmp.set("v.selectedRecordId", cmp.get("v.prevSelectedRecordId"));
            
            var forclose = cmp.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var lookUpTarget = cmp.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show'); 
            
        }
        
        var forclose = cmp.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        helper.onChangeEventFire(cmp);
    },
    
    keyPressController : function(cmp, event, helper) {
        
        var getInputkeyWord = cmp.get("v.searchKeyWord");
        
        if (cmp.get("v.prevSelectedRecordId") != null || cmp.get("v.prevSelectedRecordId") != '')
            cmp.set("v.searchIsActive", true );  
        if( getInputkeyWord.length > 0 ){
            var forOpen = cmp.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(cmp,event,getInputkeyWord);
        } else {  
            helper.showRecentViewesHlp(cmp, event, helper);         
            var forclose = cmp.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    clear :function(cmp, evt, helper){
        helper.clearHelper(cmp, evt);
    },
    
    handleComponentEvent : function(cmp, event, helper) {
        
        var selectedItemFromEvent = event.getParam("selectedSObject");
        cmp.set("v.searchIsActive", false ); 
        
        cmp.set("v.selectedRecord" , selectedItemFromEvent); 
        cmp.set("v.selectedRecordId" , selectedItemFromEvent.Id); 
        cmp.set("v.selectedRecordTitle", event.getParam("titleName"))
        cmp.set("v.objectIconPath", event.getParam("pathToIcon")); 
        cmp.set("v.objectIconColor", event.getParam("colorIcon"));
        cmp.set("v.searchKeyWord", "");
        
        var forclose = cmp.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = cmp.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = cmp.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
        helper.onChangeEventFire(cmp);
    },
    
    showRecentViewes : function(cmp, event, helper) {
        helper.onFocusEventFire(cmp);
        helper.showRecentViewesHlp(cmp, event, helper);      
    },
    
    hideRecentList : function(cmp, event, helper) {
        var forOpen = cmp.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-close');
        $A.util.removeClass(forOpen, 'slds-is-open'); 
    },
    
    onBlur : function(cmp, event, helper) {
        helper.onBlurEventFire(cmp);
    },
    
    handlePreviousValue : function(cmp, evt) {
        cmp.set("v.prevSelectedRecordId", evt.getParam("oldValue"));
    },
    
    fireChanging : function(cmp, evt, helper) {
        
        if (!cmp.get("v.readOnly")) {
            var newLookupId = cmp.get("v.setTo");
            if (newLookupId == null || newLookupId && newLookupId.length == 15 || newLookupId && newLookupId.length == 18 ) {
                helper.changeLookupValue(cmp, evt);
            } else {
                console.log('[l_lookup] Invalid Id to set. Please check it.');
            }
        } else {
            console.log('[l_lookup] Component is in read only mode.');
        }
    }
})