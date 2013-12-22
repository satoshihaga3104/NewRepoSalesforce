@isTest
private class DynamoDBClientTest {

    static testMethod void putItem(){
        AWS__c a = new AWS__c();
        a.AccessKeyId__c = 'test';
        a.Region__c= 'test';
        a.SecretAccessKey__c= 'test';
        insert a;
        
        System.assertEquals('test', AWS__c.getOrgDefaults().SecretAccessKey__c);
    
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        DynamoDBClient cl = new DynamoDBClient();
        
        Test.startTest();
        cl.putItem('');
        Test.stopTest();
    }
}