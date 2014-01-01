/*
@Name            : CommonConstants
@Author          : Satoshi Haga
@Description     : Constans Class
@version         : First Create 2013/12/11 Satoshi Haga
*/
public class CommonConstants {


	/** Upper limit count */
	public static String UPPER_LIMIT_COUNT = '20';

	/** Error Message when user doesn't have district-code on friend-search page */
	public static String ERROR_NO_DISTRICT = '地域コードが設定されていないので、検索できません';

	/** Success Message on FriendSearch page */
	public static String SUCCESS_SUBMIT_FRIEND_REQUEST = '友達リクエストが送信されました！！';

	/** Success Message  */
	public static String SUCCESS_GENERAL = '処理は正常に終了しました！！';


	/** Descripriton of transaction */
	public static String NORMAL_PURCHASE = '通常取引';
	public static String SPECIAL_PURCHASE = 'キャンペーン取引';
	public static String INITIAL_COST = '初回会員費用';

	/** Initial Cost */
	public static Decimal PRICE_INITIAL_COST = 5000;

	/** Success Message on Finishing Transaction */
	public static String SUCCESS_SUBMIT_FIHISH_TRANSACTION = '商品購入が終了しました';

	/** URL of ApprovalRequest */
	public static String URL_APPROVAL_REQUEST = '/apex/ApprovalRequest';

	/** URL of MainView */
	public static String URL_MAIN_VIEW = '/apex/MainView';

	/** URL of GoodsSearch */
	public static String URL_GOODS_SEARCH = '/apex/GoodsSearch';

	/** URL of FriendsSearch */
	public static String URL_FRIENDS_SEARCH = '/apex/FriendSearch';

	/** URL of Inquiry */
	public static String URL_INQUIRY = '/apex/MyProfilePage';

	/** URL of MyProfile */
	public static String URL_MY_PROFLE = '/apex/MyProfilePage';

}