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
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: const Text("ライセンス情報"),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: ListView(
            children: ref
                .watch(ossLicensesProvider)
                .map(
                  (e) => Column(
                    children: [
                      const SizedBox(height: 10),
                      ListTile(
                          title: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(20)),
                              child: Padding(
                                child: Column(
                                  children: [
                                    Text('${e.name}  version: ${e.version}\n\n'
                                        '${e.description}\n\n'),
                                    Text('${e.license}\n\n'),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                              ))),
                    ],
                  ),
                )
                .toList(),
          )),
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
