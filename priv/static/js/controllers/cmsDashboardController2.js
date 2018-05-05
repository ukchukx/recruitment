
    ///////////// THIS IS THE INDEXPAGE CONTROLLER///////
    ///// THIS CONTROLS EVERY ACTIVITY ON THE INDEX PAGE
    /////////////////////////
  module.controller('adminDashboardController', ['$scope','$http','infogathering','user_session', function($scope, $http, datagrab, user_session) {

    $scope.dirlocation=datagrab.dirlocation;
    $scope.currentPage = 1;
    $scope.pageSize = 30;
    user_session.user_session_details.then(function(response){
    $scope.user_session = response;
    });

    ////// WATCH THE SESSION SCOPE ////
    $scope.$watch('user_session', function() {
    if($scope.user_session){

    }
    });

    //////////FETCH ALL RELATED TABLES
   $http.get("http://"+datagrab.dirlocation+"api/get_all_related_tables")
   .then(function(response) {
   $scope.hstatus = angular.fromJson(response.data.health_status);
   $scope.mstatus = angular.fromJson(response.data.marital_status);
   $scope.states = angular.fromJson(response.data.states);
   $scope.religions = angular.fromJson(response.data.religions);
   $scope.ethnic_group = angular.fromJson(response.data.ethnic_group);
   $scope.risks = angular.fromJson(response.data.risk);
   $scope.sentenced = angular.fromJson(response.data.sentenced);
   $scope.sentence_type = angular.fromJson(response.data.sentence_type);
   $scope.appeal_data = angular.fromJson(response.data.appeal_data);
   $scope.reason_for_release = angular.fromJson(response.data.reason_for_release);
   $scope.prisons = angular.fromJson(response.data.prisons);
   //alert(JSON.stringify($scope.prisons));
   },function errorCallback(response) {
   return response.status;
   });

   $scope.activate_deactivate_prison = function(prison_id, type){
  //////////ACTIVATE PRISON ID
  if(type=='activate'){
   $http.get("http://"+datagrab.dirlocation+"api/activate_prison?prison_id="+prison_id)
   .then(function(response) {
    $('.activate'+prison_id).hide();
    $('.deactivate'+prison_id).show();
   },function errorCallback(response) {
   return response.status;
   });
 }

   if(type=='deactivate'){
    $http.get("http://"+datagrab.dirlocation+"api/deactivate_prison?prison_id="+prison_id)
    .then(function(response) {
     $scope.prison.active='0';
     $('.deactivate'+prison_id).hide();
     $('.activate'+prison_id).show();
    },function errorCallback(response) {
    return response.status;
    });
  }

   }






    }]);
