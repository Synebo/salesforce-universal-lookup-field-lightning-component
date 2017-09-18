({
    doInit: function(component) {
        
        var action = component.get("c.getInfo");
        
        action.setParams({
            'objectType'    : component.get("v.objectType")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (component.get("v.label") == "") {
                    component.set("v.label", storeResponse.objectLabel);
                }
                component.set("v.objectPluralLabel", storeResponse.objectPluralLabel);
                component.set("v.objectIconPath", storeResponse.iconPath);
                component.set("v.objectIconColor", storeResponse.iconColor);
            }
        });
        
        $A.enqueueAction(action);

        if (component.get("v.selectedRecordId") != null && component.get("v.selectedRecordId") != "") {
            
            var action1 = component.get("c.obtainObjectById");
            
            action1.setParams({
                'searchById'    : component.get("v.selectedRecordId"),
                'objectType'    : component.get("v.objectType")
            });
            
            action1.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    
                    if (storeResponse && storeResponse != null) {
                        component.set("v.selectedRecord", storeResponse);
                        component.set("v.selectedRecordTitle", storeResponse.Name);
                        
                        var forclose = component.find("lookup-pill");
                        $A.util.addClass(forclose, 'slds-show');
                        $A.util.removeClass(forclose, 'slds-hide');
                        
                        var lookUpTarget = component.find("lookupField");
                        $A.util.addClass(lookUpTarget, 'slds-hide');
                        $A.util.removeClass(lookUpTarget, 'slds-show'); 
                        
                        var forclose = component.find("searchRes");
                        $A.util.addClass(forclose, 'slds-is-close');
                        $A.util.removeClass(forclose, 'slds-is-open');
                    }
                    
                }
            });
            
            $A.enqueueAction(action1);
            
            
        }
        
    },
    
    undoObject : function(component, event, helper) {
        
        var prevSelectedId = component.get("v.prevSelectedRecordId");
        
        component.set("v.searchKeyWord", "");

        if (prevSelectedId && prevSelectedId.length > 0) {
            
            component.set("v.searchIsActive", false);
            
            component.set("v.selectedRecord", component.get("v.prevSelectedRecord")); 
            component.set("v.selectedRecordId", component.get("v.prevSelectedRecordId"));
            
            
            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show'); 
            
        }
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        
    },
    
    keyPressController : function(component, event, helper) {
        
         
        var getInputkeyWord = component.get("v.searchKeyWord");
        
        if (component.get("v.prevSelectedRecordId") != null || component.get("v.prevSelectedRecordId") != '')
            component.set("v.searchIsActive", true );  
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            helper.showRecentViewesHlp(component, event, helper);         
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
    
    clear :function(component,event,heplper){
        component.set("v.searchIsActive", true );  
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.prevSelectedRecord", component.get("v.selectedRecord")); 
        component.set("v.prevSelectedRecordId", component.get("v.selectedRecordId")); 
        
        component.set("v.selectedRecord", null); 
        component.set("v.selectedRecordId", null); 
        
        component.set("v.searchKeyWord", null);
        component.set("v.listOfSearchRecords", null );
    },
    
    handleComponentEvent : function(component, event, helper) {
        
        var selectedItemFromEvent = event.getParam("selectedSObject");
        component.set("v.searchIsActive", false ); 
        
        component.set("v.selectedRecord" , selectedItemFromEvent); 
        component.set("v.selectedRecordId" , selectedItemFromEvent.Id); 
        component.set("v.selectedRecordTitle", event.getParam("titleName"))
        component.set("v.objectIconPath", event.getParam("pathToIcon")); 
        component.set("v.objectIconColor", event.getParam("colorIcon"));
        component.set("v.searchKeyWord", "");
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
    },
    
    showRecentViewes : function(component, event, helper) {
        helper.showRecentViewesHlp(component, event, helper);      
    },
    
    hideRecentList : function(component, event, helper) {
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-close');
        $A.util.removeClass(forOpen, 'slds-is-open'); 
    }
    
})
