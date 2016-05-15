using Toybox.Application as App;
using Toybox.Communications as Comm;

enum
{
	WATCH_ID = 1
}

class GarminelloApi {

	hidden var api_url;
	hidden var watch_id;

    function initialize(url) {
		watch_id = App.getApp().getProperty(WATCH_ID);
		if (watch_id == null) {
			watch_id = "ABCD1234";
			App.getApp().setProperty(WATCH_ID, watch_id);
		}
		api_url = url;
    }

	// Get all boards
    function getBoards(callback) {
        Comm.makeJsonRequest(
			api_url + "/api/boards",
			{
				"watch" => watch_id
			},
			{
				"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
			},
			callback
		);
    }

	// Get all lists of a baord
    function getBoard(board_id, callback) {
        Comm.makeJsonRequest(
			api_url + "/api/board_lists",
			{
				"watch" => watch_id,
				"board_id" => board_id
			},
			{
				"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
			},
			callback
		);
    }
}
