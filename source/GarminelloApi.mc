using Toybox.Application.Storage as Storage;
using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.UserProfile as Profile;
using Toybox.System as Sys;
using Toybox.PersistedContent as PersistedContent;
using Toybox.Lang as Lang;

class ApiCall {
    hidden var actualCallback;

    function initialize(callback) {
        actualCallback = callback;
    }

    function onReceive(status as Lang.Number, data as Null or Lang.Dictionary or Lang.String or PersistedContent.Iterator) as Void {
        Sys.println("ApiCall:onReceive: " + status + ": " + data);
        // alternative status (straight from the garminello server) may be embedded in the return JSON dictionary
        if (data instanceof Dictionary and data["status"] != null) {
            status = data["status"];
            data = data["error"];
        }
        if (status == 456) {
            data = Ui.loadResource(Rez.Strings.register_watch_error);
        } else if (status == 0 or status == -300) {
            data = Ui.loadResource(Rez.Strings.connection_error);
        } else if (status < 0) {
            data = Ui.loadResource(Rez.Strings.generic_api_error) + " (" + status.toString() + ")";
        }
        actualCallback.invoke(status, data);
    }
}

class GarminelloApi {

    hidden var api_url;

    function initialize(url) {
        api_url = url;
    }

    function registerWatch(callback) {
        var p = Profile.getProfile();
        var settings = Sys.getDeviceSettings();
        return post(
            "/api/watch/register",
            {
                "activation_code" => Storage.getValue("activation_code"),
                "type" => settings.partNumber,
                "screen_width" => settings.screenWidth,
                "screen_height" => settings.screenHeight,
                "screen_shape" => settings.screenShape,
                "profile" => {
                    "activityClass" => p.activityClass,
                    "birthYear" => p.birthYear,
                    "gender" => p.gender,
                    "height" => p.height,
                    "restingHeartRate" => p.restingHeartRate,
                    "runningStepLength" => p.runningStepLength,
                    "walkingStepLength" => p.walkingStepLength,
                    "weight" => p.weight
                }
             }, callback
        );
    }

    function getConfig(callback) {
        return get(
            "/api/watch/config/" + Storage.getValue("watch_id"),
            {},
            callback
        );
    }

    // Get all boards
    function getBoards(callback) {
        return get(
            "/api/watch/boards/" + Storage.getValue("watch_id"),
            {},
            callback
        );
    }

    // Get all lists of a baord
    function getBoard(board_id, callback) {
        return get(
            "/api/watch/board_lists/" + Storage.getValue("watch_id") + "/" + board_id,
            {},
            callback
        );
    }

    function get_or_post(http_method, url, parameters, callback) {
        var call = new ApiCall(callback);
        parameters["v"] = VERSION;
        Comm.makeJsonRequest(
            api_url + url,
            parameters,
            {
                :headers => {
                    "Content-Type" => Comm.REQUEST_CONTENT_TYPE_JSON
                },
                :method => http_method
            },
            call.method(:onReceive)
        );
        return true;
    }

    function get(url, parameters, callback) {
        return get_or_post(Comm.HTTP_REQUEST_METHOD_GET, url, parameters, callback);
    }

    function post(url, parameters, callback) {
        return get_or_post(Comm.HTTP_REQUEST_METHOD_POST, url, parameters, callback);
    }
}
