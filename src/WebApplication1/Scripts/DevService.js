(function (angular) {

    angular.module('app').factory('DevService', function ($rootScope, $window) {
        var service = {};
        service.BeginCallback = {};
        service.EndCallback = {};

        service.changeSomething = function () { };

        function BeginCallback(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync) {
            service.BeginCallback = {
                eventTarget: eventTarget,
                eventArgument: eventArgument,
                eventCallback: eventCallback,
                context: context,
                errorCallback: errorCallback,
                useAsync: useAsync,
            };

            $rootScope.$broadcast("BeginCallback");
        }

        function EndCallback(result, context) {
            service.EndCallback = {
                result: result,
                context: context,
            };
            $rootScope.$broadcast("EndCallback");
        }

        var oldWebForm_DoCallback = $window.WebForm_DoCallback;

        $window.WebForm_DoCallback = function (eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync) {

            BeginCallback(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync)

            if (oldWebForm_DoCallback != null) {
                oldWebForm_DoCallback(eventTarget, eventArgument, function (result, context) {
                    EndCallback(result, context);
                    eventCallback(result, context);
                }, context, errorCallback, useAsync);
            }
        };

        return service;
    });

})(angular);