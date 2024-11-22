import 'package:DocuSort/app/core/extention/build_context/build_context_extension.dart';
import 'package:DocuSort/app/core/extention/string/null_string_extention.dart';
import 'package:DocuSort/app/features/home/view/features/home_directory/model/all_directory_model.dart';
import 'package:DocuSort/app/features/home/view/features/home_directory/view/component/icons/home_directory_more_vertical_icon.dart';
import 'package:DocuSort/app/product/enum/file_type_enum.dart';
import 'package:DocuSort/app/product/navigation/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class HomeDirectoryListLayout extends StatelessWidget {
  const HomeDirectoryListLayout({super.key, required this.allDirectoryModel});

  final AllDirectoryModel? allDirectoryModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = allDirectoryModel?.allDirectory[index];

        return item == null
            ? const SizedBox()
            : Padding(
                padding: context.padding.veryLow,
                child: ListTile(
                  onTap: () {
                    context.router.push(
                      HomeDirectoryOpenRoute(
                        directoryModel: item,
                      ),
                    );
                  },
                  shape: Border.all(
                    color: context.theme.getColor.borderColor,
                  ),
                  leading: Icon(
                    Icons.folder,
                    color: item.tagColor,
                  ),
                  title: Text(
                    '${item.name?.forNull.getGeneralNullMessage}(${item.fileTypeEnum?.getFileName ?? ''})',
                  ),
                  trailing: HomeDirectoryMoreVerticalIcon(
                    directoryModel: item,
                  ),
                ),
              );
      },
      itemCount: allDirectoryModel?.allDirectory.length ?? 0,
    );
  }
}