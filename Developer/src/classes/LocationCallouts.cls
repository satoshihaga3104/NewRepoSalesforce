public class LocationCallouts {
 
     @future (callout=true)
      static public void getLocation(id accountId){
      	
      	system.debug('★★★LocationCallouts★★★　check 1 time=' + datetime.now().format('yyyy/MM/dd hh:mm:ss'));
      	
      	
        // gather account info
        Account a = [SELECT BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE id =: accountId];
 
        // create an address string
        String address = '';
        if (a.BillingStreet != null)
            address += a.BillingStreet +', ';
        if (a.BillingCity != null)
            address += a.BillingCity +', ';
        if (a.BillingState != null)
            address += a.BillingState +' ';
        if (a.BillingPostalCode != null)
            address += a.BillingPostalCode +', ';
        if (a.BillingCountry != null)
            address += a.BillingCountry;
 
        address = EncodingUtil.urlEncode(address, 'UTF-8');
 
        // build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String strAddress = '日本,東京都八王子市北野町16-15';
        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + strAddress + '&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);
 
        try{
            // callout
            HttpResponse res = h.send(req);
 
            // parse coordinates from response
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                       parser.nextToken(); // object start
                       while (parser.nextToken() != JSONToken.END_OBJECT){
                           String txt = parser.getText();
                           parser.nextToken();
                           if (txt == 'lat')
                               lat = parser.getDoubleValue();
                           else if (txt == 'lng')
                               lon = parser.getDoubleValue();
                       }
 
                }
            }
 
            // update coordinates if we get back
            if (lat != null){
                a.Location__Latitude__s = lat;
                a.Location__Longitude__s = lon;

                a.AnnualRevenue = a.AnnualRevenue == null ? 1 : a.AnnualRevenue + 1; 
                
                update a;
            }
 
        } catch (Exception e) {
        }
    }
    
}