package haxegithub;

import haxe.Http;
import haxe.Json;
import haxe.io.Path;
import haxe.io.BytesOutput;
import haxe.io.Bytes;

using StringTools;

class GithubAPI {
	/**
	 * is the Github API Link
	 */
	public static final apiUrl:String = 'https://api.github.com/';

	/**
	 * is used for tasks that need Authorization
	 */
	public var token:Null<String> = null;

	/**
	 * The Request Value
	 */
	public var data:String = "";

	/**
	 * The Request Bytes Value
	 */
	public var bytes:Null<Bytes> = null;

	/**
	 * The Last Error
	 */
	public var last_error:Null<String> = null;

	/**
	 * Status
	 */
	public var status:Null<Int> = null;

	/**
	 * The Request Value Parsed in JSON
	 */
	public var json:Dynamic = null;

	/**
	 * used to define a specific content type for the Github API
	 */
	public var content_type(default, set):String = "application/json";

	private function set_content_type(value:String):String {
		return content_type = (!value.startsWith('application/') ? 'application/' : '') + value;
	}

	public function new(?token:String):Void {
		this.token = token;
	}

	/**
	 * Request to Github API
	 * @param url 
	 * @param post 
	 * @param data 
	 * @param method 
	 */
	public function request(url:String, post:Bool = false, data:Null<Any> = null, method:String = 'GET'):Void {
		var api = new Http(Path.join([apiUrl, url]));
		api.setHeader("User-Agent", "request");
		if (token != null)
			api.setHeader("Authorization", "token " + token);
		api.setHeader("Content-Type", content_type);
		if (data != null)
			api.setPostData(Json.stringify(data));
		var output = new BytesOutput();

		api.onError = onError;
		api.onStatus = onStatus;

		api.customRequest(post, output, null, method.toUpperCase());

		var response = output.getBytes();

		bytes = response;
		data = response.toString();
		try {
			json = Json.parse(data);
		} catch (e) {}
	}

	/**
	 * This function will be executed when the Github API fails
	 * @param e 
	 */
	public dynamic function onError(e:String) {
		last_error = e;
		trace(last_error);
	}

	/**
	 * This function is executed when the Github API is requested
	 * @param s 
	 */
	public dynamic function onStatus(s:Int)
		status = s;
}
