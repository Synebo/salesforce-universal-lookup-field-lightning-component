({    
    doInit: function(cmp) {
        
        var main = cmp.get("v.main");
        var additional = cmp.get("v.additional");
        var item = cmp.get("v.lookUpItem");
        var mainValue = item[main];
        var additionalValue = '';
        
        if (additional && item[additional] && !(additional.indexOf('.') > -1)) {
            additionalValue = item[additional];
        } else if (additional && additional.indexOf('.') > -1) {
            var additionalTmpArr = additional.split('.');
            if (additionalTmpArr && additionalTmpArr.length == 2 && additionalTmpArr[0] && additionalTmpArr[1] && item[additionalTmpArr[0].trim()] && item[additionalTmpArr[0].trim()][additionalTmpArr[1].trim()]) {
                additionalValue = item[additionalTmpArr[0].trim()][additionalTmpArr[1].trim()];
            }
        }
        
        var fullName = '';
        var lowerCaseFullName = '';
        var lowerCaseAdditionalInfo = '';
        var lowerCaseMach = '';
        var matchPart = '';
        
        matchPart = cmp.get("v.matchString");
		var matchResult = '';
        
        if (additionalValue && String(additionalValue).length > 0)
            cmp.set("v.matchResultAdditional", additionalValue);
        cmp.set("v.matchResult", mainValue);
                
        if (mainValue) {
            lowerCaseMach = matchPart.toLowerCase();
            lowerCaseFullName = mainValue.toLowerCase();
            lowerCaseAdditionalInfo = String(additionalValue).toLowerCase();            
            
            var startMatchIndex = lowerCaseFullName.indexOf(lowerCaseMach);
            if (startMatchIndex != -1) {
                
                var matchResultPart = mainValue.substring(startMatchIndex, startMatchIndex + lowerCaseMach.length);
                var matchResultPartBold = '<b>' + matchResultPart + '</b>';
                cmp.set("v.matchResult", mainValue.replace(matchResultPart, matchResultPartBold));
            }
            
            var startMatchIndexAdditional = lowerCaseAdditionalInfo.indexOf(lowerCaseMach);
            if (startMatchIndexAdditional != -1 && additionalValue && lowerCaseMach) {
                
                var matchResultPart1 = additionalValue.substring(startMatchIndexAdditional, startMatchIndexAdditional+lowerCaseMach.length);
                var matchResultPartBold1 = '<b>' + matchResultPart1 + '</b>';
                if (matchResultPart1)
                    cmp.set("v.matchResultAdditional", additionalValue.replace(matchResultPart1, matchResultPartBold1));
            }
        }
    },
    
   
    selectLookUpItem : function(cmp, event, helper){      
        
        var titleStr = "";
        var getSelectItem = cmp.get("v.lookUpItem");
        var compEvent = cmp.getEvent("eSelectSObjectEvent");
        titleStr = getSelectItem[cmp.get("v.main")];
        
        compEvent.setParams({"selectedSObject" : getSelectItem });  
        compEvent.setParams({"pathToIcon" : cmp.get("v.iconPath") });  
        compEvent.setParams({"colorIcon" : cmp.get("v.iconColor") });
        compEvent.setParams({"titleName" : titleStr});
        compEvent.fire();
        
    }
})