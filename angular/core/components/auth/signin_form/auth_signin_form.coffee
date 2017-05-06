angular.module('loomioApp').directive 'authSigninForm', (AuthService, KeyEventService) ->
  scope: {user: '='}
  templateUrl: 'generated/components/auth/signin_form/auth_signin_form.html'
  controller: ($scope) ->

    $scope.back = ->
      $scope.user.emailStatus = null

    $scope.signIn = ->
      AuthService.signIn($scope.user)

    $scope.sendLoginLink = ->
      AuthService.sendLoginLink($scope.user)

    $scope.submit = ->
      $scope.$emit 'processing'
      if $scope.user.hasPassword
        $scope.signIn().finally -> $scope.$emit 'doneProcessing'
      else
        $scope.sendLoginLink().finally -> $scope.$emit 'doneProcessing'

    $scope.setPassword = ->
      $scope.$emit 'processing'
      AuthService.forgotPassword($scope.user).finally -> $scope.$emit 'doneProcessing'

    KeyEventService.registerKeyEvent $scope, 'pressedEnter', $scope.submit
