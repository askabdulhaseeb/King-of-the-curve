class SinglePlayerModesModel {
  final String aboutMode;
  final String categoryId;
  final String modeBackgroundColor;
  final String modeIcon;
  final String modeName;
  final String modeTextColor;

  SinglePlayerModesModel(
      {this.modeName,
      this.categoryId,
      this.aboutMode,
      this.modeIcon,
      this.modeBackgroundColor,
      this.modeTextColor});

  SinglePlayerModesModel.fromMap(Map<String, dynamic> data, String documentId)
      : aboutMode = data['aboutMode'],
        categoryId = data['categoryId'],
        modeBackgroundColor = data['modeBackgroundColor'],
        modeIcon = data['modeIcon'],
        modeName = data['modeName'],
        modeTextColor = data['modeTextColor'];
}
