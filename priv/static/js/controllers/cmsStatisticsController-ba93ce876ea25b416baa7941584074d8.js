
    ///////////// THIS IS THE INDEXPAGE CONTROLLER///////
    ///// THIS CONTROLS EVERY ACTIVITY ON THE INDEX PAGE
    /////////////////////////
  module.controller('cmsStatisticsController', ['$scope','$sce','$http','infogathering','user_session', function($scope, $sce, $http, datagrab, user_session) {
    //$('.loader').show();

    $scope.dirlocation=datagrab.dirlocation;
    $scope.currentPage = 1;
    $scope.pageSize = 25;


    $scope.calculate = function(){
    //alert('reach here');  
    }

   
    }]);
