
    ///////////// THIS IS THE INDEXPAGE CONTROLLER///////
    ///// THIS CONTROLS EVERY ACTIVITY ON THE INDEX PAGE
    /////////////////////////
  module.controller('cmsGalleryController', ['$scope','$sce','$http','infogathering','user_session', function($scope, $sce, $http, datagrab, user_session) {
    $('.loader').show();  
    $scope.dirlocation=datagrab.dirlocation;
    $scope.currentPage = 1;
    $scope.pageSize = 30;
   
      $scope.initialise_all_gallery = function(){
    //////////FETCH ALL RELATED TABLES
   $http.get("http://"+datagrab.dirlocation+"api/get_all_gallery")
   .then(function(response) {
    $('.loader').hide();   
   $scope.gallery = response.data;
       //alert(JSON.stringify($scope.gallery));
   },function errorCallback(response) {
   return response.status;
   });
    }

   $scope.delete_image = function(details){
    
    var conf = confirm("Do you want to delete this image "+details.galleryTitle);
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

   $scope.Set_upload_img = function (index){
   var src = document.getElementById("src");
    var target = document.getElementById("target");

    var fr=new FileReader();
    // when image is loaded, set the src of the image where you want to display it
    fr.onload = function(e) { target.src = this.result; };
    //src.addEventListener("change",function() {
    // fill fr with image data
    fr.readAsDataURL(src.files[0]);
    //});
    $('#targetwrap').show();
    //$('.buttonshow1').show();

    }
   
   
    }]);
