var console;
if (console === undefined) {
    console = {
        "log": function log(message) { },
        "dir": function dir(message) { },
        "warn": function warn(message) { }
    };
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Group: Variables.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

var m_isLogin;
var m_isLoggedIn;
var m_urlParams;
var m_transitionEvent;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Group: Initialize Methods.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

function initialize() {
    // Call to initialize variables, events, components, etc. 10/28/2015 0309 PM - josiahb
    initializeVariables();
    initializeEvents();
    initializeComponents();

    // Call to finish initialization setup. 10/28/2015 0310 PM - josiahb
    initializationComplete();
}

function initializeVariables() {
    m_transitionEvent = 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend';
}

function initializeEvents() {
    // Setup the view more/view less buttons. 10/28/2015 0310 PM - josiahb
    $('.view-more').on('click', onViewMoreClick);
    $('.view-less').on('click', onViewLessClick);
}

function initializeComponents() {
    // Initialize the date picker utilities. 10/27/2015 0446 PM - josiahb
    if ($('.date-picker-util').length > 0) {
        try {
            $('.date-picker-util').datepicker({
                "dateFormat": "yy-mm-dd",
            });
        } catch (error) {
            console.warn('There was a(n) error creating the date picker: ' + error.message);
        }
    }
}

function initializationComplete() {
    // Hide the preloader. 10/28/2015 0310 PM - josiahb
    showPreloader(false);
}

function initializeUrlParams() {
    m_urlParams = {};

    // Populate the url params object with the url parameter name values pairs. 10/28/2015 0510 PM - josiahb
    var windowLocation = window.location.href;
    if (windowLocation.match(/[^\?]+\?[^=]+=[^&#]+/) !== null) {
        var paramString = windowLocation.slice((windowLocation.lastIndexOf('?') + 1));
        var params = paramString.indexOf('&') > -1? paramString.slice('&') : [paramString];

        for (var inParams = 0; inParams < params.length; inParams++) {
            var param = params[inParams];

            m_urlParams[param.split('=')[0]] = param.split('=')[1];
        }
    }
}

function showPreloader(show) {
    // Toggle the none and delay show classes based on whether we are showing or hiding the preloader.
    // 10/28/2015 0310 PM - josiahb
    $('#preloadContainer')[show ? 'removeClass' : 'addClass']('none')[show ? 'addClass' : 'removeClass']('delay-show');
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Group: View Methods.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

function onViewMoreClick(evntClick) {
    // Get a handle to the calling button, and the div it is linked to. Add the expanded
    // class to the linked div, and set the "min-height" css property to the pixel value
    // of the scrolling height for the linked div (this is so the height can animate using
    // the css3 transition defined in the site.css file). Hide the calling button and show
    // the associated view less button. 09/24/2015 0408 PM - josiahb
    var btnViewMore = $(evntClick.currentTarget),
        divLinked = $('#' + btnViewMore.data('linked'));

    divLinked.addClass('expanded')
             .addClass('transition')
             .css({
                 "height": divLinked.get(0).scrollHeight + "px"
             })
             .on(m_transitionEvent, function heightTransitionComplete() {
                 // After the transition has finished, remove the transition class and set the
                 // height to be 100% so the height will auto-adjust. 11/16/2015 1102 AM - josiahb
                 divLinked.off(m_transitionEvent, heightTransitionComplete)
                          .removeClass('transition')
                          .css({
                              "height": "100%"
                          });
             });

    btnViewMore.addClass('none')
               .next('.view-less').removeClass('none');
}

function onViewLessClick(evntClick) {
    // Get a handle to the calling button, and the div it is linked to. Remove the
    // expanded class from the linked div, and reset the "min-height" css property
    // to the initial setting. Hide the calling button, and show the associated
    // view more button. 09/24/2015 0406 PM - josiahb
    var btnViewLess = $(evntClick.currentTarget),
        divLinked = $('#' + btnViewLess.data('linked'));

    divLinked.removeClass('expanded')
             .css({
                 "height": divLinked.get(0).scrollHeight + "px"
             });

    // Set a timeout before adding the transition class and removing the height property
    // from the style attribute so it will pull the default height from the stylesheet.
    // 11/16/2015 1100 AM - josiahb
    setTimeout(function() {
      divLinked.addClass('transition')
               .attr("style", divLinked.attr("style").replace(/height:([^;]+);/g, ''));
    }, 100);

    btnViewLess.addClass('none')
               .prev('.view-more').removeClass('none');
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Group: Angular Methods.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Main module, that contains generic functionality used throughout multiple modules.
var mainApp = angular.module('mainApp', ['ngRoute']);

/////////////////////////////////////////////////////////////////////////////////////
// Group: mainApp Controllers.
/////////////////////////////////////////////////////////////////////////////////////
mainApp.controller('MainController', ['$scope', '$sce', function ($scope, $sce) {
    m_urlParams = undefined;
    m_isLogin = window.location.hash.match(/login/) !== null;

    $scope.notLoggedIn = function () {
        // Set the hash to the login page. 10/29/2015 1155 AM - josiahb
        window.location.hash = 'login?redirect=' + window.location.hash.replace(/#|\//g, '');
    }

    $scope.$loggedIn = function (data) {
        // If the user ID was retrieved successfully, and it is valid, call to initialize the page. Otherwise call
        // the get user ID error method. 10/28/2015 0312 PM - josiahb
        if (data.d !== undefined) {
            var accountData = JSON.parse(data.d),
                userId = Number(accountData.userId) || 0;

            if (!isNaN(userId) && userId > 0) {
                // Mark the user as logged in so we don't have to make an ajax call everytime they change pages. 10/29/2015 1159 AM - josiahb
                m_isLoggedIn = true;

                initialize();

                // If on the login page, redirect the user to the home page. Otherwise call the
                // override method "loggedIn" in case the page controller has something it needs
                // to do. 11/16/2015 1134 AM - josiahb
                if (m_isLogin) {
                  window.location.hash = 'home';
                } else {
                  $scope.loggedIn(accountData);
                }
            } else {
                $scope.notLoggedIn();
            }
        } else {
            $scope.notLoggedIn();
        }
    }
    if (typeof $scope.loggedIn === 'undefined') {
      $scope.loggedIn = function(accountData) {};
    }

    // If not on the log in page, and the user isn't logged in, check to make sure the user is logged in before allowing them to access pages
    // other than the login page. 10/29/2015 1200 PM - josiahb
    if (!m_isLogin && !m_isLoggedIn) {
        // $.ajax({
        //     "contentType": "application/json; charset=utf-8",
        //     "dataType": "json",
        //     "error": $scope.notLoggedIn,
        //     "success": $scope.$loggedIn,
        //     "type": "POST",
        //     "url": "methods.aspx/GetUserId"
        // });
    } else {
        initialize();
    }

    // Method used to bind trusted HTML. 11/16/2015 0933 AM - josiahb
    $scope.renderHtml = function (scope, prop) {
        var html = scope;

        if (typeof scope === 'object' && typeof prop !== 'undefined') {
            html = scope[prop];
        }

        return $sce.trustAsHtml(html);
    };
}]);

mainApp.controller('HomeController', ['$scope', '$controller', function ($scope, $controller) {
    angular.extend(this, $controller('MainController', { $scope: $scope }));

    $scope.scheduledTrainings = [];
    $scope.requiredTrainings  = [];
    $scope.completeTrainings  = [];

    // Error/success methods to be called when the scheduled training data
    // has been returned.
    $scope.scheduledError = function (error, status, message) {
        // display warning message if there was an error retrieving the training data. 10/30/2015 0549 PM - josiahb
        console.warn('There was a(n) ' + status + ' retrieving your scheduled trainings: ' + message);
    };
    $scope.scheduledSuccess = function (data) {
        if (data.d !== undefined) {
            var trainingData = JSON.parse(data.d);

            $scope.scheduledTrainings = trainingData;
            $scope.$apply();
        }
    };

    // Error/success methods to be called when the required training data
    // has been returned.
    $scope.requiredError = function (error, status, message) {
        // display warning message if there was an error retrieving the training data. 10/30/2015 0549 PM - josiahb
        console.warn('There was a(n) ' + status + ' retrieving your required trainings: ' + message);
    };
    $scope.requiredSuccess = function (data) {
        console.log('requiredSuccess()');
        console.dir(data);

        if (data.d !== undefined) {
            var trainingData = JSON.parse(data.d);

            console.dir(trainingData);

//            $scope.requiredTrainings = trainingData;
//            $scope.$apply();
        }
    };

    // Called if/when the user is logged in. 11/16/2015 1129 AM - josiahb
    $scope.loggedIn = function() {
      // $.ajax({
      //     "contentType": "application/json; charset=utf-8",
      //     "dataType": "json",
      //     "error": $scope.scheduledError,
      //     "success": $scope.scheduledSuccess,
      //     "type": "POST",
      //     "url": "methods.aspx/GetScheduledUserTraining"
      // });
      //
      // $.ajax({
      //   "contentType": "application/json; charset=utf-8",
      //   "dataType": "json",
      //   "error": $scope.requiredError,
      //   "success": $scope.requiredSuccess,
      //   "type": "POST",
      //   "url": "methods.aspx/GetRequiredUserTrainings"
      // });
    };

    // If the user is already logged in, call the logged in method.
    // 11/16/2015 1130 AM - josiahb
    if (m_isLoggedIn) {
      $scope.loggedIn();
    }
}]);

mainApp.controller('AdminController', ['$scope', '$controller', function ($scope, $controller) {
    angular.extend(this, $controller('MainController', { $scope: $scope }));
}]);

mainApp.controller('LoginController', ['$scope', '$controller', function ($scope, $controller) {
    angular.extend(this, $controller('MainController', { $scope: $scope }));

    $scope.account = {};

    $scope.error = function (error, status, message) {
        // Display a warning if there was an error logging in with the given credentials. 10/28/2015 0333 PM - josiahb
        console.warn('There was a(n) ' + status + ' logging in: ' + message);
    };

    $scope.success = function (data) {
        if (data.d !== undefined) {
            var userData = JSON.parse(data.d),
                userId = Number(userData.userId) || 0;

            if (!isNaN(userId) && userId > 0) {
                if (m_urlParams === undefined) {
                    initializeUrlParams();

                    // Default the redirect page to the home page. 10/29/2015 1217 PM - josiahb
                    if (m_urlParams.redirect === undefined) {
                        m_urlParams.redirect = 'home';
                    }
                }

                if (!userData.passwordReset) {
                    window.location.hash = m_urlParams.redirect;
                } else {
                    window.location.hash = 'resetPassword';
                }
            }
        }
    };

    $scope.submit = function (account) {
        if (!$scope.login.$valid) {
            return;
        }

        // $.ajax({
        //     "contentType": "application/json; charset=utf-8",
        //     "data": JSON.stringify(account),
        //     "dataType": "json",
        //     "error": $scope.error,
        //     "success": $scope.success,
        //     "type": "POST",
        //     "url": "methods.aspx/Login"
        // });
    };
}]);

mainApp.controller('ResetPasswordController', ['$scope', function($scope) {
  $scope.account = {};
  $scope.passwordsMatch = true;

  $scope.error = function (error, status, message) {
      // Display a warning if there was an error resetting the users password. 11/16/2015 1147 AM - josiahb
      console.warn('There was a(n) ' + status + ' resetting your password: ' + message);

      window.location.hash = 'home';
  };

  $scope.success = function (data) {
      if (data.d !== undefined) {
          var userData = JSON.parse(data.d);

          if (!userData.success) {
            console.warn('There was an error resetting your password.');
          }

          // If the password was updated successfully, redirect the user to the marked page, or
          // to the home page by default. 11/16/2015 0508 PM - josiahb
          if (typeof m_urlParams.redirect === 'undefined') {
            window.location.hash = 'home';
          } else {
            window.location.hash = m_urlParams.redirect;
          }
      }
  };

  $scope.submit = function( account ) {
    if (!$scope.resetPassword.$valid) {
      return;
    }

    if (account.newPassword === account.verifyPassword) {
      $scope.passwordsMatch = true;

      // Call to update the users password. 11/16/2015 0507 PM - josiahb
      // $.ajax({
      //   "contentType": "application/json; charset=utf-8",
      //   "data": JSON.stringify(account),
      //   "dataType": "json",
      //   "error": $scope.error,
      //   "success": $scope.success,
      //   "type": "POST",
      //   "url": "methods.aspx/ResetPassword"
      // });
    } else {
      $scope.passwordsMatch = false;
    }
  };
}]);

mainApp.controller('RoleController', ['$scope', function ($scope) {
    $scope.roles = [];

    $scope.error = function (error, status, message) {
        // If there was an error retreiving the roles list, warn the user. 10/22/2015 0852 AM - josiahb
        console.warn('There was a(n) ' + status + ' retreiving the roles list: ' + message);
    };

    $scope.success = function (data) {
        // If correct data was returned, update the roles list in the scope to create the select list of
        // valid roles. If correct data was NOT returned, warn the user. 10/22/2015 0853 AM - josiahb
        if (data.d !== undefined) {
            var rolesData = typeof data.d === 'string' ? JSON.parse(data.d) : data.d;

            $scope.roles = rolesData;
            $scope.$apply();
        } else {
            console.warn('Incorrect data returned for RoleController, unable to build controller.');
        }
    };

    // $.ajax({
    //     "contentType": "application/json; charset=utf-8",
    //     "dataType": "json",
    //     "error": $scope.error,
    //     "success": $scope.success,
    //     "type": "POST",
    //     "url": "methods.aspx/GetRoles"
    // });
}]);

mainApp.controller('NewAccountController', ['$scope', function ($scope) {
    $scope.account = {};
    $scope.passwordsMatch = true;
    $scope.hasError = false;
    $scope.noRole = false;

    $scope.error = function (error, status, message) {
        // Display a warning if there was an error creating the user account. 10/28/2015 0323 PM - josiahb
        console.warn('There was a(n) ' + status + ' creating the user account: ' + message);

        // Mark the has error flag as true, and apply the changes to the scope. 10/28/2015 0324 PM - josiahb
        $scope.hasError = true;
        $scope.$apply();
    };

    $scope.success = function (data) {
        var hasError = false;

        // Check to see if user data was returned, and if a valid user ID was given. If user data was not returned, or the user
        // ID given is not valid set the has error flag to true. Otherwise clear the account information, and hide the new user
        // account modal. 10/28/2015 0325 PM - josiahb
        if (data.d !== undefined) {
            var userData = JSON.parse(data.d),
                userId = Number(userData.userId);

            if (isNaN(userId) || userId === 0) {
                hasError = true;
            }
            else {
                $scope.account = {};
                $('#newAccount').modal('hide');
            }
        } else {
            hasError = true;
        }

        if (hasError) {
            $scope.hasError = true;
            $scope.$apply();
        }
    };

    $scope.submit = function (account) {
        // Clear the error flags. 10/28/2015 0326 PM - josiahb
        $scope.hasError = false;
        $scope.passwordsMatch = true;
        $scope.noRole = false;

        // Check to make sure an account role has been selected, the new account form is valid, and the password and
        // verify password input fields match before continuing. 10/28/2015 0327 PM - josiahb
        if (account.role === undefined) {
            $scope.noRole = true;

            return;
        } else if (!$scope.newAccount.$valid) {
            return;
        } else if (account.password !== account.passwordVerify) {
            $scope.passwordsMatch = false;

            return;
        }

        // Create an object with the relevant account information, and make a call to create the user account. 10/28/2015 0327 PM - josiahb
        var accountInformation = {
            "email": account.email,
            "password": account.password,
            "firstName": account.firstName,
            "lastName": account.lastName,
            "startDate": account.startDate,
            "role": account.role
        };

        // $.ajax({
        //     "contentType": "application/json; charset=utf-8",
        //     "data": JSON.stringify(accountInformation),
        //     "dataType": "json",
        //     "error": $scope.error,
        //     "success": $scope.success,
        //     "type": "POST",
        //     "url": "methods.aspx/CreateAccount"
        // });
    };
}]);

/////////////////////////////////////////////////////////////////////////////////////
// Group: mainApp Directives.
/////////////////////////////////////////////////////////////////////////////////////

mainApp.directive('navigationHeader', function () {
    var template = '<a href="#home"><img alt="AllenComm logo" height="36" id="allencommLogo" src="./img/allencomm_logo.svg" width="36" /></a>' +
                   '<nav>' +
                       '<a href="#admin">Administrator</a>' +
                   '</nav>';

    return {
        "template": template
    };
});

mainApp.directive('preloader', function () {
    var template = '<div class="delay-show" id="preloadContainer">' +
                       '<img alt="preloader" id="preloader" src="./img/loading.gif" />' +
                   '</div>';

    return {
        "template": template
    };
});

/////////////////////////////////////////////////////////////////////////////////////
// Group: mainApp Config.
/////////////////////////////////////////////////////////////////////////////////////

mainApp.config(['$routeProvider', function ($routeProvider) {
    $routeProvider
    .when('/home', {
        "templateUrl": "home.html",
        "controller": "HomeController"
    })
    .when('/admin', {
        "templateUrl": "admin.html",
        "controller": "AdminController"
    })
    .when('/login', {
        "templateUrl": "login.html",
        "controller": "LoginController"
    })
    .when('/resetPassword', {
      "templateUrl": "reset_password.html",
      "controller": "ResetPasswordController"
    })
    .otherwise({
        "redirectTo": "/home"
    });
}]);
