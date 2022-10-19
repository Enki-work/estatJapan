import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../oss_licenses.dart';

final ossLicensesProvider = StateProvider<List<PackageStatus>>((ref) {
  return ossLicenses
      .where((element) => element.isDirectDependency)
      .map((e) => PackageStatus(
          name: e.name,
          description: e.description,
          authors: e.authors,
          isDirectDependency: e.isDirectDependency,
          isMarkdown: e.isMarkdown,
          isSdk: e.isSdk,
          version: e.version,
          repository: e.repository,
          license: e.license,
          homepage: e.homepage))
      .toList();
});

class LicenseInfoPage extends ConsumerWidget {
  const LicenseInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ossLicensesData = ref.watch(ossLicensesProvider);
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: const Text("ライセンス情報"),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(20),
          ),
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              final updated = ref.read(ossLicensesProvider)
                ..[panelIndex].isExpanded = !isExpanded;
              // updated[panelIndex] =
              //     updated[panelIndex].copyWith(isExpanded: !isExpanded);
              ref.read(ossLicensesProvider.notifier).state = [...updated];
            },
            children: ossLicensesData
                .map((e) => ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: e.isExpanded,
                      headerBuilder: (context, isExpanded) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('${e.name}  version: ${e.version}\n\n'
                              '${e.description}\n\n'),
                        );
                      },
                      body: DecoratedBox(
                        decoration:
                            BoxDecoration(color: Colors.grey.withAlpha(20)),
                        child: Padding(
                          child: Text('${e.license}\n\n'),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class PackageStatus extends Package {
  bool isExpanded;
  PackageStatus(
      {required String name,
      required String description,
      required List<String> authors,
      required String version,
      required bool isMarkdown,
      required bool isSdk,
      required bool isDirectDependency,
      String? homepage,
      String? license,
      String? repository,
      this.isExpanded = false})
      : super(
            name: name,
            description: description,
            authors: authors,
            version: version,
            isMarkdown: isMarkdown,
            isSdk: isSdk,
            isDirectDependency: isDirectDependency,
            homepage: homepage,
            license: license,
            repository: repository);
}
