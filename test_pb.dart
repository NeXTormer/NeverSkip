import 'package:pocketbase/pocketbase.dart';
void main() {
  final pb = PocketBase('http://127.0.0.1:8090');
  var users = pb.collection('users');
  // Just want to see what methods are available by looking at the class definition or triggering an error
  print(users.runtimeType);
}
