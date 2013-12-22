public without sharing class AWSAccessResult {

	public HTTPResponse res {get; set;}

	public Boolean isSuccess(){
		if(res != null && res.getStatusCode() == 200){
			return true;
		}
		return false;
	}

	public void outputResult(){

		system.debug(LoggingLevel.DEBUG, '---- response status code:'+ this.res.getStatusCode());
		system.debug(LoggingLevel.DEBUG, '---- response status:'+ this.res.getStatus());

		if(this.isSuccess()){
			System.debug(LoggingLevel.DEBUG, '---- result:OK');
		} else {
			System.debug(LoggingLevel.ERROR, '---- result:NG');
		}
		if(this.res != null){
			System.debug(LoggingLevel.DEBUG, '---- response body:' + this.res.getBody());
		}
	}
}