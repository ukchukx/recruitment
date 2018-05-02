//// INFORMATION GATHERING ////
    module.factory('infogathering', ['$http','$cookies', function($http, $cookies) {
    var siteUrl = window.location.pathname;
    var webUrl= siteUrl.split("/");
    //splice the url to fit in both on localhost and onine server
    var i = webUrl.indexOf('nps_biometric');
    webUrl.splice(i, 1);

    //var dirlocation = window.location.hostname+'/nps/';
    var dirlocation = window.location.hostname+'/';
    //var completeUrlLocation = 'https://'+window.location.hostname+'/';
    var completeUrlLocation = 'http://'+window.location.hostname+'/nps/';
    //var current_user = $('#current_user_value').val();
    return {dirlocation: dirlocation, urlSplit:webUrl, completeUrlLocation:completeUrlLocation}

    }])


      ///// SERVICE FOR SESSION INFO GATHERING/////
    module.factory('user_session', ['$http','infogathering', function($http, datagrab) {
    //////////FETCH CURRENT USER
    //var user_session = $http.get("http://"+datagrab.dirlocation+"api/get_session")
    //var user_session = $http.get("https://"+datagrab.dirlocation+"api/get_session")
    var user_session = $http.get(datagrab.completeUrlLocation+"api/get_session")
    .then(function(response) {
    var user_session = response.data;
    //var user_counter = angular.fromJson(response.data.counter);   
    return response.data;
    },function errorCallback(response) {
    return response.status;
    });


    return {user_session_details:user_session};


    }])


module.filter('HTML2TXT', function($sce){
    return function(msg) { 
        var RexStr = /\<|\>|\"|\'|\&/g;
        msg = (msg + '').replace(RexStr,
            function(MatchStr){
                switch(MatchStr){
                    case "<":
                        return "&lt;";
                        break;
                    case ">":
                        return "&gt;";
                        break;
                    case "\"":
                        return "&quot;";
                        break;
                    case "'":
                        return "&#39;";
                        break;
                    case "&":
                        return "&amp;";
                        break;
                    default :
                        break;
                }
            }
        )
        return $sce.trustAsHtml(msg);
    }
});

