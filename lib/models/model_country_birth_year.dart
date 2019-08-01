class ModelDataCountry {
  String countryName;
  String countryCode;
  String countryNumberPhoneCode;
  bool selectedCountry;

  ModelDataCountry({
    this.countryName = "Choose country",
    this.countryCode,
    this.countryNumberPhoneCode = "",
    this.selectedCountry = false,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {
      // "countryName": this.countryName,
      "countryCode": this.countryCode,
      "countryNumberPhoneCode": this.countryNumberPhoneCode,
    };
    return map;
  }

  set setSelectedCountry(newValue) => selectedCountry = newValue;
}

class ModelDataBirthYear {
  String birthYear;
  bool selectedBirthYear;

  ModelDataBirthYear({
    this.birthYear = "Choose birth year",
    this.selectedBirthYear,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {"birthYear": this.birthYear};
    return map;
  }

  bool get selectedBirthYears => selectedBirthYear == true;
  set setSelectedBirthYear(newValue) => selectedBirthYear = newValue;
}
