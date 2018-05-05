
    ///////////// THIS IS THE INDEXPAGE CONTROLLER///////
    ///// THIS CONTROLS EVERY ACTIVITY ON THE INDEX PAGE
    /////////////////////////
  module.controller('cmsPrisonController', ['$scope','$sce','$http','infogathering','user_session', function($scope, $sce, $http, datagrab, user_session) {
    $('.loader').show();  
    $scope.dirlocation=datagrab.dirlocation;
    $scope.currentPage = 1;
    $scope.pageSize = 25;
   
    $scope.initialise_all_prisons = function(){
    //////////FETCH ALL PRISONS
   $http.get("http://"+datagrab.dirlocation+"api/get_all_prisons")
   .then(function(response) {
    $('.loader').hide();   
   $scope.prisons = response.data;
   // alert(JSON.stringify($scope.prisons));
   },function errorCallback(response) {
   return response.status;
   });
    }

    
    $scope.initialize_states = function(){
        //////////FETCH ALL STATES
   $http.get("http://"+datagrab.dirlocation+"api/get_all_states")
   .then(function(response) {
   $scope.states = response.data;
   //alert(JSON.stringify($scope.states));
   },function errorCallback(response) {
   return response.status;
   });  
    }
   $scope.delete_prison = function(details){
    
    var conf = confirm("Do you want to delete this Prison "+details.galleryTitle);
    if(conf==true){
    $http.get("http://"+datagrab.dirlocation+"api/delete_image?id="+details.id+"&path="+details.path+"&table=gallery")
   .then(function(response) {
   alert(response.data);
    window.location.reload();    
   },function errorCallback(response) {
   return response.status;
   });
    
    }   
       
   }


   
    }]);
