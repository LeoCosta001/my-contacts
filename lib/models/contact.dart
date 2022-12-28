class Contact {
  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageDirectory,
  });

  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? imageDirectory;

  @override
  String toString() {
    return 'id: $id,  name: $name,  email: $email,  phone: $phone,  imageDirectory: $imageDirectory';
  }
}
