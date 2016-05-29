using Toybox.Application as App;
using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.UserProfile as Profile;
using Toybox.System as Sys;

class ApiCall {
    hidden var actualCallback;

    function initialize(callback) {
        actualCallback = callback;
    }

    function onReceive(status, data) {
        Sys.println("ApiCall:onReceive: " + status + ": " + data);
        // alternative status (straight from the garminello server) may be embedded in the return JSON dictionary
        if (data instanceof Dictionary and data["status"] != null) {
            status = data["status"];
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
    hidden var app;

    function initialize(url) {
        app = App.getApp();
        api_url = url;
    }

    function registerWatch(callback) {
        var p = Profile.getProfile();
        return post(
            "/api/watch/register",
            {
                "activation_code" => app.getProperty("activation_code"),
                "type" => "vivoactive_hr",
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
            "/api/watch/config/" + app.getProperty("watch_id"),
            {},
            callback
        );
    }

    // Get all boards
    function getBoards(callback) {
        return get(
            "/api/watch/boards/" + app.getProperty("watch_id"),
            {},
            callback
        );
    }

    // Get all lists of a baord
    function getBoard(board_id, callback) {
        return get(
            "/api/watch/board_lists/" + app.getProperty("watch_id") + "/" + board_id,
            {},
            callback
        );
    }

    function get_or_post(http_method, url, parameters, callback) {
//        var watch_id = app.getProperty("watch_id");
//        if (watch_id != null) {
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
//        } else {
//            callback.invoke(456, Ui.loadResource(Rez.Strings.register_watch_error));
//        }
        return true;
    }

    function get(url, parameters, callback) {
        return get_or_post(Comm.HTTP_REQUEST_METHOD_GET, url, parameters, callback);
    }

    function post(url, parameters, callback) {
        return get_or_post(Comm.HTTP_REQUEST_METHOD_POST, url, parameters, callback);
    }
}
