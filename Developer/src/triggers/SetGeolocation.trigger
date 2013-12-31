trigger SetGeolocation on Account (after insert, after update) {
	
	system.debug('★★★SetGeolocation★★★　check 0 time=' + datetime.now().format('yyyy/MM/dd hh:mm:ss'));
	
    for (Account a : trigger.new){
        if (a.Location__Latitude__s == null){
            LocationCallouts.getLocation(a.id);            
        }
        
    }         

	system.debug('★★★SetGeolocation★★★　check 2 time=' + datetime.now().format('yyyy/MM/dd hh:mm:ss'));

}