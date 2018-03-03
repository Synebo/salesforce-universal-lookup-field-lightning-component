global class LookupResponse {
    
    @AuraEnabled
    global Boolean isSuccess        { get; set; }
    @AuraEnabled
    global String  shortErrorDescr  { get; set; }
    @AuraEnabled
    global String  detailErrorDescr { get; set; }
    @AuraEnabled
    global Object  respBody 	    { get; set; }
    @AuraEnabled
    global String  respType 	    { get; set; }
    
    global LookupResponse(Object respBody) {
        this.isSuccess = true;
        this.respBody = respBody;
        this.respType = 'success';
    }
    
    global LookupResponse(String respType, String shortErrorDescr, String detailErrorDescr) {
        this.respType = respType;
        this.isSuccess = false;
        this.shortErrorDescr = shortErrorDescr;
        this.detailErrorDescr = detailErrorDescr;
    }
}