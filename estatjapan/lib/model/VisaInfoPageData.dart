class VisaInfoData {
  final String title;
  final String pageUrlStr;
  const VisaInfoData({required this.pageUrlStr, required this.title});
}

class VisaInfoPageData {
  final String title;
  final List<VisaInfoData> pageData;
  const VisaInfoPageData({required this.pageData, required this.title});
}
