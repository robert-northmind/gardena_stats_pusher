class GardenaLocation {
  final String id;
  final String name;

  GardenaLocation({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'GardenaLocation(id: $id, name: $name)';
  }
}
