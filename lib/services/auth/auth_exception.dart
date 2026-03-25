
//Login Exeptions
class UserNotFoundAuthException implements Exception { }

class WrongPasswordAuthSException implements Exception {}

//Register Exeptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generic Exceptions
class GenericAuthException implements Exception {}
 
class UserNotLoggedInAuthException implements Exception {} 
  

