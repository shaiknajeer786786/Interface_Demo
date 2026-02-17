public class INT_AF_AccountDetailsAction {

     public class SimpleRequest{
        @InvocableVariable(label='Search Keyword' description='Search Keyword') 
        public String inputText;
    }

    public class SimpleResponse {
        @InvocableVariable 
        public String response;
    }
    
    @InvocableMethod(label='Agentforce: Search Accounts' description='Wildcard search on Account Name and returns clickable hyperlinks')
    public static List<SimpleResponse> getAccountDetails(List<SimpleRequest> requests) {
        SimpleResponse responseWrapper = new SimpleResponse();

        if (requests.isEmpty() || String.isBlank(requests[0].inputText)) {
            responseWrapper.response = 'Please type something';
            return new List<SimpleResponse>{ responseWrapper };
        }
        User currentUser = [SELECT Id, Division__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        String formatted = '';
        try{ 
            string queryString = 'Select Id, Name FROM Account Where Account_Status__c = \'Active\' AND (';
            string searchKey = requests[0].inputText;
            if(String.isNotBlank(searchKey) && searchKey.contains(' ')){
                List<String> List_String = searchKey.split(' ');
                for(string val : List_String){
                    val = '\'%'+val+'%\'';
                    queryString += 'Name Like '+ val +' AND ';
                }
            }
            System.debug('queryString :::: '+queryString);
            queryString = queryString.removeEndIgnoreCase(' AND ');
            queryString += ') ORDER BY Name LIMIT 20';
            System.debug('queryString :::: '+queryString);
            //List<Account> Account_List = [Select Id, Name FROM Account Where Name LIKE :searchKey AND Account_Status__c = 'Active' AND Division__c = :currentUser.Division__c ORDER BY Name LIMIT 20];
            List<Account> Account_List = Database.query(queryString);
            if(!Account_List.isEmpty()){
                formatted += 'Based on your search, here are the Account(s) I found: \n';
                formatted += 'If this is not what you expected, try a more precise search term. \n';
                Integer accountIndex = 1;
                for(Account acc : Account_List){
                    formatted += '\n' + accountIndex + '. ';
                    formatted += '<a href="' + URL.getOrgDomainURL().toExternalForm() + '/lightning/r/Account/' +  acc.Id + '/view"><b>' + acc.Name + '</b></a> <i> (Click here to view this Account record)</i>\n';
                    
                    accountIndex ++;
                }
                responseWrapper.response = formatted;
            }
            return new List<SimpleResponse>{ responseWrapper };
        }
        catch(Exception exe){
            responseWrapper.response = exe.getMessage();
            return new List<SimpleResponse>{ responseWrapper };
        }
    }
    public static void method1(){
        
    }
    public static void method2(){
        
    }
    public static void method3(){
        
    }
    public static void method4(){
        
    }
    public static void method5(){
    }

    public static void method6(){
        
    }
}