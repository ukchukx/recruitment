
    ///////////// THIS IS THE INDEXPAGE CONTROLLER///////
    ///// THIS CONTROLS EVERY ACTIVITY ON THE INDEX PAGE
    /////////////////////////
  module.controller('hrDashboardController', ['$scope','$http','infogathering','user_session', function($scope, $http, datagrab, user_session) {

      
    $scope.dirlocation=datagrab.dirlocation;
    

    //////////FETCH ALL RELATED TABLES
      
   $http.get("https://"+datagrab.dirlocation+"hr_api/get_dashboard_counter")
   .then(function(response) {
   $scope.counter = angular.fromJson(response.data);
       calculate_percentage($scope.counter);
       
       
   //alert(JSON.stringify($scope.counter));
   },function errorCallback(response) {
   return response.status;
   });

    //////////////////CALCLATE PERCENTAGE
    function calculate_percentage(counter){

    var accepted = Math.round((counter[0].accepted/counter[0].completed)*100);
    var denied = Math.round((counter[0].denied/counter[0].completed)*100); 
    var unverified = 100 - accepted - denied; 

    var assistant_cadre = Math.round((counter[0].assistant_cadre/counter[0].completed)*100);
    var inspectorate_cadre = Math.round((counter[0].inspectorate_cadre/counter[0].completed)*100); 
    var superintendent_cadre = Math.round((counter[0].superintendent_cadre/counter[0].completed)*100);
    
    demo.initChartist(accepted, denied, unverified, assistant_cadre, inspectorate_cadre, superintendent_cadre);    
     //alert(unverified);    
    }

    





    }]);
