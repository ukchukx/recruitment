
    ///////////// THIS IS THE INDEXPAGE CONTROLLER///////
    ///// THIS CONTROLS EVERY ACTIVITY ON THE INDEX PAGE
    /////////////////////////
  module.controller('hrApplicantsController', ['$scope','$http','infogathering','user_session', function($scope, $http, datagrab, user_session) {
      
    $scope.completeUrlLocation=datagrab.completeUrlLocation;
    $scope.currentPage = 1;
    $scope.pageSize = 50;
    $('.loader').show();
    $scope.edu_details = '';

    $scope.get_applicants = function(type,category,state,age,search_name){
    //////////FETCH ALL APPLICANTS
   $http.get(datagrab.completeUrlLocation+"hr_api/get_all_"+type+'?category='+category+'&&state='+state+'&&age='+age+'&&search_name='+search_name)
   .then(function(response) {
   $scope.applicants = response.data; 
   //alert(JSON.stringify($scope.applicants));
   },function errorCallback(response) {
   return response.status;
   });
   }


   $scope.get_search_result_applicants = function(type,category,state,age,edu_qualification,edu_start_year,edu_end_year,edu_classification){
    //////////FETCH ALL APPLICANTS
   $http.get(datagrab.completeUrlLocation+"hr_api/get_all_"+type+'?category='+category+'&&state='+state+'&&age='+age+'&&edu_qualification='+edu_qualification+'&&edu_start_year='+edu_start_year+'&&edu_end_year='+edu_end_year+'&&edu_classification='+edu_classification)
   .then(function(response) {
    //alert(response.data);
   $scope.applicants = response.data; 
   //alert(JSON.stringify($scope.applicants));
   },function errorCallback(response) {
   return response.status;
   });
   }

   $scope.print = function(type,category,state,age,edu_qualification,edu_start_year,edu_end_year,edu_classification){
  window.open(datagrab.completeUrlLocation+'hr/print_result?type='+type+'&&category='+category+'&&state='+state+'&&age='+age+'&&edu_qualification='+edu_qualification+'&&edu_start_year='+edu_start_year+'&&edu_end_year='+edu_end_year+'&&edu_classification='+edu_classification,'Print Result', 'width=700,height=900');
   }

   $scope.get_all_states = function(category){
    //////////FETCH ALL RELATED TABLES  
   $http.get(datagrab.completeUrlLocation+"hr_api/get_all_states")
   .then(function(response) {
   $scope.states = response.data; 
   },function errorCallback(response) {
   return response.status;
   });
   }

   $scope.confirm = function(check){
   var checkbox =  document.getElementById('checkbox_'+check);
   var checkbox_alt = document.getElementById('checkbox_alt_'+check);
   var splitvalue = checkbox.value.split('@');

   if(checkbox.checked == false){
   checkbox_alt.checked = true;  
    /*
   $http.get(datagrab.completeUrlLocation+"hr_api/update_approved_list?recruit_id="+splitvalue[0]+'&&value=0')
   .then(function(response) {
   $scope.applicants = response.data; 
   },function errorCallback(response) {
   return response.status;
   });
*/
  }

  if(checkbox.checked == true){
  checkbox_alt.checked = false;   

  }


   }

   $scope.search = function(category,state,age,search_name){
      //////////FETCH ALL COMPLETED APPLICANTS
   $http.get(datagrab.completeUrlLocation+"hr_api/get_all_"+category+'?category='+category+'&&state='+state)
   .then(function(response) {
   $scope.applicants = response.data; 
   },function errorCallback(response) {
   return response.status;
   });

   }

   $scope.compare = function(prop, val){
    newVal = val.split('@');
    return function(item){
      if(newVal[0]=='>'){
      return item[prop] > newVal[1];
      }else{
      return item[prop] <= newVal[1];
      }
    }
}

    $scope.get_positions = function(){
    //////////FETCH RESULTS
   $http.get(datagrab.completeUrlLocation+"recruit_api/get_positions?id=")
   .then(function(response) {
    $scope.positions = angular.fromJson(response.data.positions);
    $scope.sub_positions = angular.fromJson(response.data.sub_positions); 
   // $scope.user_details = angular.fromJson(response.data.user_details);
   },function errorCallback(response) {
   return response.status;
   });
   
    }

    $scope.get_all_related_tables = function(){
    //////////FETCH RESULTS
   $http.get(datagrab.completeUrlLocation+"recruit_api/get_all_related_tables")
   .then(function(response) {
    $scope.type_of_degree = angular.fromJson(response.data.type_of_degree);
    $scope.classifications = angular.fromJson(response.data.classifications); 
   },function errorCallback(response) {
   return response.status;
   });
   
    }



  $scope.open_edu = function(name,details){
  $scope.edu_details = details;
  $scope.applicant_name=name;
  $('#edu_qualification_Window_Modal_'+$scope.edu_details[0].recruit_id).appendTo("body").modal('show');
  }



  $scope.pro_cert = function(name,details){
  $scope.pro_cert_details = details;
  $scope.applicant_name=name;
  $('#pro_certification_Window_Modal_'+$scope.pro_cert_details[0].recruit_id).appendTo("body").modal('show');
  }

 
  $scope.work_exp = function(name,details){
  $scope.work_exp_details = details;
  $scope.applicant_name=name;
  $('#work_experience_Window_Modal_'+$scope.work_exp_details[0].recruit_id).appendTo("body").modal('show');
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
    




    }]);
