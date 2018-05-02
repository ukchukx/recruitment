
    ///////////// THIS IS THE INDEXPAGE CONTROLLER///////
    ///// THIS CONTROLS EVERY ACTIVITY ON THE INDEX PAGE
    /////////////////////////
  module.controller('recruitRegistrationController', ['$scope','$http','infogathering','user_session', function($scope, $http, datagrab, user_session) {
    $scope.dirlocation=datagrab.dirlocation;
    $scope.currentPage = 1;
    $scope.pageSize = 10;

    //////////FETCH ALL RELATED TABLES
   $http.get(datagrab.completeUrlLocation+"recruit_api/get_all_related_tables")
   .then(function(response) {
    $scope.degrees = angular.fromJson(response.data.type_of_degree); 
    $scope.classifications = angular.fromJson(response.data.classifications);
    $scope.countries = angular.fromJson(response.data.countries);
   },function errorCallback(response) {
   return response.status;
   });

      
    $scope.get_qualifications = function(id){
    //////////FETCH RESULTS
   $http.get(datagrab.completeUrlLocation+"recruit_api/get_qualifications?id="+id)
   .then(function(response) {
    $scope.edu_qualifications = angular.fromJson(response.data.qualifications);
    $scope.pro_qualifications = angular.fromJson(response.data.professionals); 
   },function errorCallback(response) {
   return response.status;
   });
   
    }
    
    $scope.get_applicants_other_details = function(id){
    //////////FETCH APPLICANTS OTHER DETAILS 
    if(id){
   $http.get(datagrab.completeUrlLocation+"hr_api/get_applicants_other_details?id="+id)
   .then(function(response) {
   $('.loader').hide(); 
   $scope.applicants_educational_details = angular.fromJson(response.data.educational_qualifications);
   $scope.applicants_professional_details = angular.fromJson(response.data.professional_qualifications); 
   $scope.attachments = angular.fromJson(response.data.attachments); 
   $scope.work_experience  = angular.fromJson(response.data.work_experience);
   },function errorCallback(response) {
   return response.status;
   });

   }    
  }
  
    $scope.calculate_age = function (value){
      //alert(value);
    var myDate=value.split('/');
    //var myDate=myDate.split("/");
  
    var newDate=myDate[1]+'/'+myDate[0]+'/'+myDate[2];///MM/DD/YY
    var dobTime = Math.round(new Date(newDate).getTime()/1000);
    var today = Math.round(new Date().getTime()/1000);
    var deduct = Math.round((today-dobTime)/86400);
    var age = Math.round(deduct/365);
    //$scope.age = age; 
      
    $('#age').val(age);  
    }

    $scope.get_positions = function(user_id){
    //////////FETCH RESULTS
   $http.get(datagrab.completeUrlLocation+"recruit_api/get_positions?id="+user_id)
   .then(function(response) {
    $scope.positions = angular.fromJson(response.data.positions);
    $scope.sub_positions = angular.fromJson(response.data.sub_positions); 
    $scope.user_details = angular.fromJson(response.data.user_details);
   },function errorCallback(response) {
   return response.status;
   });
   
    }

    
    $scope.delete_result = function (id,user_id,table){
    var conf = confirm("Do you want to delete this record?");
    if(conf==true){
    //////////DELETE RESULT
   $http.get(datagrab.completeUrlLocation+"recruit_api/delete_result?id="+id+"&user_id="+user_id+"&table="+table)
   .then(function(response) {
    if(response.data==''){
    window.location.reload();    
    }   
   },function errorCallback(response) {
   return response.status;
   });
        
    }    
    }
      

    $scope.add_educational_qualification = function(){
    $('#edu_qualification_Window_Modal').appendTo("body").modal('show');    
    }

    $scope.preview_details = function(index){
    $('.loader').show();  
    $scope.get_applicants_other_details(index);
    $http.get(datagrab.completeUrlLocation+"recruit_api/get_applicant_details?id="+index)
   .then(function(response) {
    $('.loader').hide();
    $scope.user_details=response.data;
    //alert(JSON.stringify($scope.user_details))
   },function errorCallback(response) {
   return response.status;
   });
        
    $('#preview_Window_Modal').appendTo("body").modal('show');    
    }

    $scope.add_professional_qualification = function(){
    $('#pro_qualification_Window_Modal').appendTo("body").modal('show');    
    }
    



    }]);
