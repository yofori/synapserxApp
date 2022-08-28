class Medicines {
  final String code;
  final String genericName;
  final String uom;
  final String brandName;

  Medicines(this.code, this.genericName, this.uom, this.brandName);

  Medicines.fromMap(Map<String, dynamic> drug)
      : code = drug["code"].toString(),
        genericName = drug["genericName"].toString(),
        uom = drug["uom"].toString(),
        brandName = drug["brandName"].toString();

  Map<String, Object> toMap() {
    return {
      'code': code,
      'genericName': genericName,
      'uom': uom,
      'brandName': brandName
    };
  }
}
