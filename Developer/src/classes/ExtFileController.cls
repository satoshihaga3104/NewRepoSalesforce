public with sharing class ExtFileController {

  public String strQuestion {get; set;}

  public String getStrAnswer() {
  	
  	if('あけまして'.equals(strQuestion)){
  		return 'おめでとう';
  	}else if('ありがとう'.equals(strQuestion)){
  		return 'どういたしまして';
  	}else{
  		return 'おっしゃっている意味がわかりません';
  	}
  	
  	return 'おっしゃっている意味がわかりません';
  }


}