class Medicines {
  final String code;
  final String genericName;
  final String uom;
  final String brandName;
  final String type;
  final String atcCode;

  Medicines(this.code, this.genericName, this.uom, this.brandName, this.type,
      this.atcCode);

  Medicines.fromMap(Map<String, dynamic> drug)
      : code = drug["code"].toString(),
        genericName = drug["genericName"].toString(),
        uom = drug["uom"].toString(),
        brandName = drug["brandName"].toString(),
        type = drug["type"].toString(),
        atcCode = drug["atcCode"].toString();

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'genericName': genericName,
      'uom': uom,
      'brandName': brandName,
      'type': type,
      'atcCode': atcCode
    };
  }
}
