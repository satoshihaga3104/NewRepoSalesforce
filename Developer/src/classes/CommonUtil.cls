/*
@Name            : CommonUtil
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Utility Class
@version         : 07/01/2013 First Creation
*/
public class CommonUtil {

	/** Converting Method */
	public static Map<String,String> convertEmailtoMap(String strEmail){
		// 本文を属性別に分解する
		// 開始文字列、終了文字列にはさまれた文字列を切り出す
		// セパレータ":"で分解しリスト化
		List<String> fieldList = strEmail.split(':',0);  
			
		// 属性名、属性値のMap化
		Map<String,String> fieldMap = new Map<String,String>();
		// 分解リストループ
		for(String field : fieldList){
			// "="で分割すると2つになる場合
			if (field.split('=',0).size() == 2){
				// 最初の要素をキー
				// 2番目の要素を値として格納
				fieldMap.put(field.split('=',0)[0],field.split('=',0)[1]);  
			}
		}

		//返却
		return fieldMap;

	}

}