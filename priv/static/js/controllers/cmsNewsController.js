
    ///////////// THIS IS THE INDEXPAGE CONTROLLER///////
    ///// THIS CONTROLS EVERY ACTIVITY ON THE INDEX PAGE
    /////////////////////////
  module.controller('cmsNewsController', ['$scope','$sce','$http','infogathering','user_session', function($scope, $sce, $http, datagrab, user_session) {

    $scope.dirlocation=datagrab.dirlocation;
    $scope.currentPage = 1;
    $scope.pageSize = 30;
    user_session.user_session_details.then(function(response){
    $scope.user_session = response;
    });

    $scope.initialise_all_news = function(){
    //////////FETCH ALL RELATED TABLES
   $http.get("http://"+datagrab.dirlocation+"api/get_all_news")
   .then(function(response) {
   $scope.news = response.data;
   //alert(JSON.stringify($scope.news));
   },function errorCallback(response) {
   return response.status;
   });
    }
    //$('.loading').show();
 
   $scope.createNews = function(index){
   
   }
   
   $scope.sanitize = function(details){
    return details ? String(details).replace(/<[^>]+>/gm, '') : '';   
   }

   $scope.setFeaturedImage = function (index){
   var src = document.getElementById("src");
    var target = document.getElementById("target");

    var fr=new FileReader();
    // when image is loaded, set the src of the image where you want to display it
    fr.onload = function(e) { target.src = this.result; };
    //src.addEventListener("change",function() {
    // fill fr with image data
    fr.readAsDataURL(src.files[0]);
    //});
    $('#target').show();
    //$('.buttonshow1').show();

    }

    $scope.deleteNews = function(index){
    var conf = confirm("Do you want to delete this news?");
    if(conf==true){
    window.location.href = "http://"+$scope.dirlocation+"cms/news?delete="+index  
    }
    } 

    }]);
