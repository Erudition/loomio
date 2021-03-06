angular.module('loomioApp').directive 'pollCommonStartPoll', ($window, PollService, LmoUrlService) ->
  scope: {poll: '='}
  templateUrl: 'generated/components/poll/common/start_poll/poll_common_start_poll.html'
  controller: ($scope) ->
    $scope.currentStep = if $scope.poll.pollType then 'save' else 'choose'
    $scope.$on 'chooseComplete',  -> $scope.currentStep = 'save';   $scope.isDisabled = false
    $scope.$on 'saveBack',        -> $scope.currentStep = 'choose'; $scope.isDisabled = false
    $scope.$on 'saveComplete',    -> $scope.currentStep = 'share';  $scope.isDisabled = false
    $scope.$on 'shareComplete',      $scope.$close
