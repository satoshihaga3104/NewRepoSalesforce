public without sharing abstract class AWSClient {

	protected AWSAccessSettings aas {get; set;}
	private static Integer calloutMilliSeconds = 0;
	private static Integer timeLeft = 120000;

	protected void setDefaultSettings(){
		this.aas = new AWSAccessSettings();
		this.aas.accessKeyId = AWS__c.getOrgDefaults().AccessKeyId__c;
		this.aas.region = AWS__c.getOrgDefaults().Region__c;
		this.aas.secretAccessKey = AWS__c.getOrgDefaults().SecretAccessKey__c;
	}

	protected virtual HTTPRequest createHttpRequest(String requestBody, String apiName){

		Datetime dt = Datetime.now();
		this.aas.today = dt.formatGmt('yyyyMMdd');
		this.aas.now = this.aas.today + 'T' + dt.formatGmt('HHmmss') + 'Z';
		this.aas.host = this.aas.serviceName.toLowerCase() + '.' + this.aas.region + '.amazonaws.com';
		this.aas.signedHeaders = 'host;x-amz-date;x-amz-target';
		this.aas.xAmzTarget = this.aas.serviceName + '_' + this.aas.apiVersion + '.' + apiName;

		this.aas.log();

		// Credential
		String credential = this.aas.accessKeyId + '/' + this.aas.today + '/' + this.aas.region + '/' + this.aas.serviceName.toLowerCase() + '/aws4_request';
		// sign
		String sign = V4.signature(this.aas, requestBody);

	    HttpRequest req = new HttpRequest();

	    req.setHeader('Authorization',V4.SIGNATURE_ALGORITHM + ' Credential=' + credential + ',SignedHeaders=' + this.aas.signedHeaders + ',Signature=' + sign);
	    req.setHeader('host', this.aas.host);
	    req.setHeader('x-amz-date', this.aas.now);
	    req.setHeader('x-amz-target', this.aas.xAmzTarget);
	    req.setHeader('content-type', 'application/x-amz-json-1.0');

	    req.setMethod(this.aas.method);
	    req.setEndpoint('https://' + this.aas.serviceName.toLowerCase() + '.' + this.aas.region + '.amazonaws.com/');
	    req.setBody(requestBody);

	    return req;
	}

	protected virtual  AWSAccessResult send(HTTPRequest req){

		// Check governor limit
		this.checkLimit();

		AWSAccessResult result = new AWSAccessResult();

		// 1 second margin
		req.setTimeout(timeLeft - 1000);

	    Http http = new Http();

    	Long start = Datetime.now().getTime();
    	result.res = http.send(req);
		calloutMilliSeconds += Integer.valueOf(Datetime.now().getTime() - start);

		System.debug(LoggingLevel.DEBUG, '---- elapsed time:' + calloutMilliSeconds + ' milli seconds');

		timeLeft -= calloutMilliSeconds;
		System.debug(LoggingLevel.DEBUG, '---- time left:' + timeLeft + ' milli seconds');

		return result;
	}

	protected virtual void checkLimit(){
		System.debug(LoggingLevel.DEBUG, '---- callout count:' + Limits.getCallouts());

		if(Limits.getLimitCallouts() == Limits.getCallouts()){
			throw new AWSException('Reached the maximum number of HTTP callout');
		}
	}
}