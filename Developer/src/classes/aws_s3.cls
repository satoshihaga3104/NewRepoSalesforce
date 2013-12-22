global with sharing class aws_s3 {
    private static set<string> storage_classes = new set<string>{'private','public-read','public-read-write','authenticated-read','bucket-owner-read','bucket-owner-full-control'};

    global class r {
        boolean status;
        string message;
    }

    public static aws_s3__c getConfig(){
        return aws_s3__c.getOrgDefaults();
    }
    
    @isTest
    private static void test_getConfig(){
        aws_s3__c aws_s3 = new aws_s3__c(
            reduced_redundancy__c = true,
            access_key__c = 'abc',
            secret_access_key__c = 'def',
            bucket__c = 'ghi'
        );
        upsert aws_s3;
        aws_s3 = getConfig();
        system.assertEquals(true, aws_s3.reduced_redundancy__c);
    }
    
    @remoteAction
    global static r insert_s3_object(string url){
        r r = new r();
        r.status = false;
        
        if (url == null){
            r.message = 'URL is not set.';
            return r;
        }
        
        if (url.contains('?')){
            url = url.substringBefore('?');
        }
        
        s3_object__c s3_obj = new s3_object__c(url__c = url);
        insert s3_obj;
        
        r.status = true;
        r.message = s3_obj.id;
        return r;
    }
    
    @isTest
    private static void test_insert_s3_object(){
        r r = new r();
        
        // execute without setting url
        r = insert_s3_object(null);
        system.assertEquals(false, r.status);
        system.assertEquals('URL is not set.', r.message);
        
        // execute in correct usage
        r = insert_s3_object('https://ueryhuvnuedjhfy.com');
        system.assertEquals(true, r.status);
        system.assertEquals('https://ueryhuvnuedjhfy.com', [select url__c from s3_object__c where id = :r.message].url__c);
        
        // check if query string has been removed
        r = insert_s3_object('https://duejfkdmkfjkgnn.com?parameter=ioueyroehgirh');
        system.assertEquals(true, r.status);
        system.assertEquals('https://duejfkdmkfjkgnn.com', [select url__c from s3_object__c where id = :r.message].url__c);
    }
    
    @remoteAction
    global static r get_url_for_upload(string file_name, string file_type){
        r r = new r();
        r.status = false;
        aws_s3__c s3 = aws_s3__c.getOrgDefaults();
        
        if (s3.access_key__c == null || s3.secret_access_key__c == null || s3.bucket__c == null){
            r.message = 'Custom Settings has not been configured.';
            return r;
        }
        
        if (String.isBlank(file_name)){
            r.message = 'file_name is not set.';
            return r;
        }
        
        string url;
        
        // This means that users have to start uploading in 600 seconds since they have loaded the page by default.
        integer default_expiration = 600;
        
        string http_method = 'PUT';
        string content_md5 = '';
        
        string content_type = '';
        if (String.isBlank(file_type)){
            r.message = 'file_type is not set.';
            return r;
        }
        content_type = file_type.toLowerCase();
        
        string expiration;
        if (s3.expiration__c == null){
            expiration = string.valueOf((DateTime.now().getTime() / 1000).intValue() + default_expiration);
        } else {
            expiration = string.valueOf((DateTime.now().getTime() / 1000).intValue() + s3.expiration__c.intValue());
        }
        
        string canonicalized_amz_headers = '';
        if (!String.isBlank(s3.acl__c)){
            if (storage_classes.contains(s3.acl__c.toLowerCase())){
                canonicalized_amz_headers += 'x-amz-acl:' + s3.acl__c.toLowerCase() + '\n';
            } else {
                r.message = 'ACL value is incorrect.';
                return r;
            }
        }
        if (s3.reduced_redundancy__c == true){
            canonicalized_amz_headers += 'x-amz-storage-class:REDUCED_REDUNDANCY' + '\n';
        }
        
        string canonicalized_resource;
        if (s3.folder__c == null){
            canonicalized_resource = '/' + s3.bucket__c + '/' + file_name;
        } else {
            canonicalized_resource = '/' + s3.bucket__c + '/' + s3.folder__c.removeStart('/').removeEnd('/') + '/' + file_name;
        }
        string string_to_sign = 
            http_method + '\n' +
            content_md5 + '\n' +
            content_type + '\n' + 
            expiration + '\n' + 
            canonicalized_amz_headers + canonicalized_resource;
        system.debug('string_to_sign = ' + string_to_sign);
        string signature = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Crypto.generateMac('hmacSHA1', blob.valueOf(string_to_sign), blob.valueOf(s3.secret_access_key__c))), 'UTF-8');
        string path = '/';
        if (s3.folder__c != null){
            path += s3.folder__c.removeStart('/').removeEnd('/') + '/';
        }
        url = 'https://' + s3.bucket__c + '.s3.amazonaws.com' + path + file_name + '?AWSAccessKeyId=' + s3.access_key__c + '&Signature=' + signature + '&Expires=' + expiration;
        
        r.status = true;
        r.message = url;
        return r;
    }
    
    @isTest
    private static void test_get_url_for_upload(){
        r r;
        
        // execute without configuring Custom Setting
        r = get_url_for_upload('saivnefimvkdfje', 'text/plain');
        system.assertEquals(false, r.status);
        system.assertEquals('Custom Settings has not been configured.', r.message);
        
        // configure Custom Setting
        aws_s3__c s3 = new aws_s3__c();
        s3.access_key__c = 'asdfzxcvqwerasdf';
        s3.secret_access_key__c = 'oiuylkjhrewqfdsa';
        s3.bucket__c = 'iquweytr';
        upsert s3;
        
        // execute without passing file_name
        r = get_url_for_upload(null, 'text/plain');
        system.assertEquals(false, r.status);
        system.assertEquals('file_name is not set.', r.message);
        
        // execute without passing file_type
        r = get_url_for_upload('saivnefimvkdfje', null);
        system.assertEquals(false, r.status);
        system.assertEquals('file_type is not set.', r.message);
        
        // execute properly
        r = get_url_for_upload('saivnefimvkdfje', 'text/plain');
        system.assertEquals(true, r.status);
        
        // set expiration
        s3.expiration__c = 300;
        update s3;
        r = get_url_for_upload('saivnefimvkdfje', 'text/plain');
        system.assertEquals(true, r.status);
        
        // set folder
        s3.folder__c = 'vmjdjifn';
        update s3;
        r = get_url_for_upload('saivnefimvkdfje', 'text/plain');
        system.assertEquals(true, r.status);
        
        // set reduced_redundancy
        s3.reduced_redundancy__c = true;
        update s3;
        r = get_url_for_upload('saivnefimvkdfje', 'text/plain');
        system.assertEquals(true, r.status);
        
        // set incorrect acl
        s3.acl__c = 'open';
        update s3;
        r = get_url_for_upload('saivnefimvkdfje', 'text/plain');
        system.assertEquals(false, r.status);
        system.assertEquals('ACL value is incorrect.', r.message);
        
        // set correct acl
        s3.acl__c = 'PRIVATE';
        update s3;
        r = get_url_for_upload('saivnefimvkdfje', 'text/plain');
        system.assertEquals(true, r.status);
    }
}