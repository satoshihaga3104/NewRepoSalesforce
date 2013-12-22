public without sharing class AWSAccessSettings {
	public String accessKeyId {get;set;}
	public String host {get;set;}
	public String now {get;set;}
	public String region {get;set;}
	public Integer requestTimeout {get;set;}
	public String secretAccessKey {get;set;}
	public String serviceName {get;set;}
	public String signedHeaders {get;set;}
	public String today {get;set;}
	public String xAmzTarget {get;set;}
	public String apiVersion {get;set;}
	public String method {get;set;}

	public void log(){
		System.debug(LoggingLevel.DEBUG, '---- accessKeyId:' + this.accessKeyId);
		System.debug(LoggingLevel.DEBUG, '---- host:' + this.host);
		System.debug(LoggingLevel.DEBUG, '---- now:' + this.now);
		System.debug(LoggingLevel.DEBUG, '---- region:' + this.region);
		System.debug(LoggingLevel.DEBUG, '---- requestTimeout:' + this.requestTimeout);
		System.debug(LoggingLevel.DEBUG, '---- secretAccessKey:' + this.secretAccessKey);
		System.debug(LoggingLevel.DEBUG, '---- serviceName:' + this.serviceName);
		System.debug(LoggingLevel.DEBUG, '---- signedHeaders:' + this.signedHeaders);
		System.debug(LoggingLevel.DEBUG, '---- today:' + this.today);
		System.debug(LoggingLevel.DEBUG, '---- xAmzTarget:' + this.xAmzTarget);
		System.debug(LoggingLevel.DEBUG, '---- apiVersion:' + this.apiVersion);
		System.debug(LoggingLevel.DEBUG, '---- method:' + this.method);
   	}
}