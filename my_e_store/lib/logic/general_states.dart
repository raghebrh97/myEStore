abstract class GeneralStates{}

class InitialState extends GeneralStates{}
class LoadingState extends GeneralStates{}
class LoadedState extends GeneralStates{
  var model;
  LoadedState(this.model);
}

class ErrorState extends GeneralStates{
  String errorMessage;
  ErrorState(this.errorMessage);
}