@isTest
private class MyFutureClassTest {
 
    static testMethod void myMethodTest() {
        
        Test.startTest();
        
        Account newAcct = new Account(name = 'Acme');
        insert newAcct;
        
        LocationCallouts.getLocation(newAcct.Id);
        
        Id pId = newAcct.Id;
        
        Account results = [select Id,Location__Latitude__s from Account where id = :pId];
        System.assert(results.Location__Latitude__s == null);
        
        Test.stopTest();
        
        results = [select Id,Location__Latitude__s from Account where id = :pId];
        System.assert(results.Location__Latitude__s != null);
    }
}