({    
    doInit: function(component) {
        var typeSObject = component.get("v.objectResType");
	var fullName = '';
        var lowerCaseFullName = '';
        var additionalInfo = '';
        var lowerCaseAdditionalInfo = '';
        var lowerCaseMach = '';
        var matchPart = '';
        

        if (typeSObject.toLowerCase() == 'case') {
            fullName = component.get("v.lookUpItem.CaseNumber");
            matchPart = component.get("v.matchString");
        } else if (typeSObject.toLowerCase() == 'contract') {
            fullName = component.get("v.lookUpItem.ContractNumber");
            matchPart = component.get("v.matchString");
        } else if (typeSObject.toLowerCase() == 'order') {
            fullName = component.get("v.lookUpItem.OrderNumber");
            matchPart = component.get("v.matchString");
        } else if (typeSObject.toLowerCase() == 'orderitem') {
            fullName = component.get("v.lookUpItem.OrderItemNumber");
            matchPart = component.get("v.matchString");
        } else {
            fullName = component.get("v.lookUpItem.Name");
            matchPart = component.get("v.matchString");
        }
        
        if ( (typeSObject.toLowerCase() == 'contact' || typeSObject.toLowerCase() == 'order' || typeSObject.toLowerCase() == 'contract') && component.get("v.lookUpItem.Account.Name") != null && component.get("v.lookUpItem.Account.Name") != '')
            component.set("v.additionalInfo", component.get("v.lookUpItem.Account.Name"));
        
        if (typeSObject.toLowerCase() == 'lead' && component.get("v.lookUpItem.Title") != null && component.get("v.lookUpItem.Title") != '')
            component.set("v.additionalInfo", component.get("v.lookUpItem.Title"));
        
        if (typeSObject.toLowerCase() == 'case' && component.get("v.lookUpItem.Subject") != null && component.get("v.lookUpItem.Subject") != '')
            component.set("v.additionalInfo", component.get("v.lookUpItem.Subject"));
        
        if (typeSObject.toLowerCase() == 'product2' && component.get("v.lookUpItem.ProductCode") != null && component.get("v.lookUpItem.ProductCode") != '')
            component.set("v.additionalInfo", component.get("v.lookUpItem.ProductCode"));
        
        if (fullName) {
            lowerCaseMach = matchPart.toLowerCase();
            lowerCaseFullName = fullName.toLowerCase();
            additionalInfo = component.get("v.additionalInfo");
			lowerCaseAdditionalInfo = additionalInfo.toLowerCase();            
            
            if ((lowerCaseFullName.indexOf(lowerCaseMach) == 0 || (lowerCaseFullName.indexOf(lowerCaseMach) > 0 && lowerCaseFullName[lowerCaseFullName.indexOf(lowerCaseMach)-1] == ' ')) && lowerCaseMach && lowerCaseMach != '') {
                component.set("v.matchResultBold", fullName.substring(lowerCaseFullName.indexOf(lowerCaseMach), lowerCaseFullName.indexOf(lowerCaseMach)+matchPart.length));
                component.set("v.matchResultSimple", fullName.substring(0, lowerCaseFullName.indexOf(lowerCaseMach)));
                component.set("v.matchResultSimple_2", fullName.substring(((lowerCaseFullName.indexOf(lowerCaseMach)) + matchPart.length), fullName.length));
            } else {
                component.set("v.matchResultSimple", fullName);
            }
            
            if (lowerCaseAdditionalInfo.indexOf(lowerCaseMach) == 0 && lowerCaseMach && lowerCaseMach != '') {
                component.set("v.matchResultAdditionalBold", additionalInfo.substring(0, matchPart.length));
                component.set("v.matchResultAdditionalSimple", additionalInfo.substring(matchPart.length, additionalInfo.length));
            } else {
				component.set("v.matchResultAdditionalSimple", additionalInfo);                
            }
            
        }
    },
    
    selectLookUpItem : function(component, event, helper){      
        
        var titleStr = "";
        var objType = component.get("v.objectResType");
        
        var getSelectItem = component.get("v.lookUpItem");
        var compEvent = component.getEvent("eSelectSObjectEvent");
          
        if (objType.toLowerCase() == 'case') {
            titleStr = getSelectItem.CaseNumber;
        } else if (objType.toLowerCase() == 'contract') {
            titleStr = getSelectItem.ContractNumber;
        } else if (objType.toLowerCase() == 'order') {
            titleStr = getSelectItem.OrderNumber;
        } else if (objType.toLowerCase() == 'orderitem') {
            titleStr = getSelectItem.OrderItemNumber;
        } else {
            titleStr = getSelectItem.Name;
        }
        
        compEvent.setParams({"selectedSObject" : getSelectItem });  
        compEvent.setParams({"pathToIcon" : component.get("v.iconPath") });  
        compEvent.setParams({"colorIcon" : component.get("v.iconColor") });
        compEvent.setParams({"titleName" : titleStr});
        compEvent.fire();
        
    }
})
