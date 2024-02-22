class User {
  final String username;
  final String email;
  final int? age;
  final String? address;

  User._builder(UserBuilder builder)
      : username = builder.username,
        email = builder.email,
        age = builder.age,
        address = builder.address;

  @override
  String toString() {
    return 'User{username: $username, email: $email, age: $age, address: $address}';
  }
}

class UserBuilder {
  String username = '';
  String email = '';
  int age = 0;
  String? address;

  User build() {
    // Validate or set default values if needed before creating the User
    return User._builder(this);
  }
}