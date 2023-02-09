import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/data/model/datamanage_model.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';

import 'data_dialogs.dart';

class DataPage extends StatelessWidget {
  DataPage({Key? key}) : super(key: key);

  final globalModel = Get.find<GlobalModel>();
  final dataModel = Get.put(DataManageModel());

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      //_DesktopDataPage(dataModel: dataModel, globalModel: globalModel)
      desktopChild: _DesktopDataPage(dataModel: dataModel, globalModel: globalModel),
      mobileChild: const Text('DATA mobile'),
    );
  }
}

class _DesktopDataPage extends StatelessWidget {
  const _DesktopDataPage({Key? key, required this.dataModel, required this.globalModel}) : super(key: key);
  final DataManageModel dataModel;
  final GlobalModel globalModel;  // Share pos & run data with map page.

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ManageItem(
          icon: Icons.cloud_download,
          description: "加载数据",
          onClick: () => Get.dialog(DownloadDialog(dataModel: dataModel, globalModel: globalModel)),
        ),
        ManageItem(
          icon: Icons.upload_file_rounded,
          description: "上传数据",
          onClick: () => Get.dialog(UploadDialog(model: dataModel)),
        ),
        ManageItem(
          icon: Icons.cached,
          description: "查看缓存",
          onClick: () => Get.dialog(const CacheDialog()),
        )
      ],
    );
  }
}

class ManageItem extends StatelessWidget {
  const ManageItem({
    Key? key,
    required this.icon,
    required this.description,
    required this.onClick
  }) : super(key: key);
  final IconData icon;
  final String description;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints.tightFor(width: 300, height: 300),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 4.0,
                )
              ],
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 150,
                color: Theme.of(context).cardColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  description,
                  style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 27,
                      fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
