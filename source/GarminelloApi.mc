using Toybox.Application as App;
using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.UserProfile as Profile;

class GarminelloApi {

    hidden var api_url;
    hidden var app;

    function initialize(url) {
        app = App.getApp();
        api_url = url;
    }

    function getConfig(callback) {
        var p = Profile.getProfile();
        return get(
            "/api/config",
            {
                "watch" => app.getProperty("watch_id"),
                "activityClass" => p.activityClass,
                "birthYear" => p.birthYear,
                "gender" => p.gender,
                "height" => p.height,
                "restingHeartRate" => p.restingHeartRate,
                "runningStepLength" => p.runningStepLength,
                "sleepTime" => p.sleepTime,
                "wakeTime" => p.wakeTime,
                "walkingStepLength" => p.walkingStepLength,
                "weight" => p.weight
            }, callback
        );
    }

    // Get all boards
    function getBoards(callback) {
        return get(
            "/api/boards",
            {
                "watch" => app.getProperty("watch_id")
            }, callback
        );
    }

    // Get all lists of a baord
    function getBoard(board_id, callback) {
        return get(
            "/api/board_lists",
            {
                "watch" => app.getProperty("watch_id"),
                "board_id" => board_id
            }, callback
        );
    }

    function get(url, options, callback) {
        var watch_id = app.getProperty("watch_id");
        if (watch_id != null) {
            Comm.makeJsonRequest(
                api_url + url,
                options,
                {
                    "Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
                },
                callback
            );
        } else {
            callback.invoke(Ui.loadResource(Rez.Strings.register_watch_error), null);
        }
        return true;
    }
}
