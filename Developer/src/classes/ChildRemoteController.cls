global with sharing class ChildRemoteController {
    @RemoteAction
    global static String sayHello(String helloTo) {
        return 'Hello ' + helloTo + ' from the Grandparent.';
    }
    
    @RemoteAction
    global static List<sObject> queryData(String query){
        return Database.query(query);
    }
}