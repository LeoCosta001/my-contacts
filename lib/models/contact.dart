class Contact {
  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageDirectory,
  });

  int? id;
  String name;
  String email;
  String phone;
  String? imageDirectory;

  @override
  String toString() {
    return 'id: $id,  name: $name,  email: $email,  phone: $phone,  imageDirectory: $imageDirectory';
  }
}
