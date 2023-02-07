import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/data/model/datamanage_model.dart';
import 'package:learnflutter/routes.dart';
import 'package:learnflutter/ui/common/data_container.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';

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

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({Key? key, required this.dataModel, required this.globalModel}) : super(key: key);
  final DataManageModel dataModel;
  final GlobalModel globalModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("选择批次"),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 1200
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 24),
                  child: Text(
                    'Batch:',
                    style: TextStyle(
                        fontSize: 18.0
                    ),
                  ),
                ),
                Obx(() => DropdownButton(
                  items: dataModel.batchList.map((batch) => DropdownMenuItem<int>(value: batch, child: Text(batch.toString()),)).toList(),
                  onChanged: (batch) => dataModel.selectedBatch = batch??0,
                  value: dataModel.selectedBatch,
                )),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: () {
                    globalModel.loadPositions(dataModel.selectedBatch);
                    globalModel.loadRunning(dataModel.selectedBatch);
                    Fluttertoast.showToast(
                        msg: '数据加载成功',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM
                    );
                  },
                  child: const Text('加载'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // dataModel.batchList.clear();
                    globalModel.posList.clear();
                    globalModel.runList.clear();
                    // dataModel.selectedBatch = -1;
                    Fluttertoast.showToast(
                        msg: '数据已清空',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM
                    );
                  } ,
                  child: const Text('清空'),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Text(
                "数据预览",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DataContainer(
                  child: Obx(() => ListView.separated(
                      itemBuilder: (_, index) {
                        final position = globalModel.posList[index];
                        return ExpansionTile(
                          title: Text('position $index'),
                          subtitle: Text('x: ${position.x} y: ${position.y} z: ${position.z}'),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TODO modify with TextSpan
                            Text('address: ${position.address}'),
                            Text('x: ${position.x} y: ${position.y} z: ${position.z}'),
                            Text('stay: ${position.stay}'),
                            Text('timestamp: ${position.timestamp}'),
                            Text('bsAddress: ${position.bsAddress}'),
                            Text('sample time: ${position.sampleTime}'),
                            Text('sample batch: ${position.sampleBatch}'),
                            ButtonBar(
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO 弹出一个对话框，对当前所选数据修改 同时修改远端数据库中数据
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text('编辑')
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO 删除当前所选数据 同时从远端数据库中删除该数据
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                  label: const Text('删除'),
                                  style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context).errorColor
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Theme.of(context).primaryColor,
                        thickness: 1,
                      ),
                      itemCount: globalModel.posList.length
                  )),
                ),
                DataContainer(
                  child: Obx(() => ListView.separated(
                      itemBuilder: (_, index) {
                        final running = globalModel.runList[index];
                        return ExpansionTile(
                          title: Text('running $index'),
                          subtitle: Text('accx: ${running.accx} accy: ${running.accy} accz: ${running.accz}'),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('address: ${running.address}'),
                            Text('accx: ${running.accx} y: ${running.accy} z: ${running.accz}'),
                            Text('gyroscopex: ${running.gyroscopex}'),
                            Text('gyroscopey: ${running.gyroscopey}'),
                            Text('gyroscopez: ${running.gyroscopez}'),
                            Text('stay: ${running.stay}'),
                            Text('timestamp: ${running.timestamp}'),
                            Text('bsAddress: ${running.bsAddress}'),
                            Text('sample time: ${running.sampleTime}'),
                            Text('sample batch: ${running.sampleBatch}'),
                            ButtonBar(
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO 弹出一个对话框，对当前所选数据修改 同时修改远端数据库中数据
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text('编辑')
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO 删除当前所选数据 同时从远端数据库中删除该数据
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                  label: const Text('删除'),
                                  style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context).errorColor
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Theme.of(context).primaryColor,
                        thickness: 1,
                      ),
                      itemCount: globalModel.runList.length
                  )),
                )
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("确认并退出"),
          onPressed: () => Get.back(),
        ),
        TextButton(
          child: const Text("前往地图区"),
          onPressed: () {
            Get.back();
            globalModel.navigationIndex = 2;
          },
        ),
      ],
    );
  }
}

class CacheDialog extends StatelessWidget {
  const CacheDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("缓存列表"),
      content: const Text("此功能即将推出~"),
      actions: <Widget>[
        TextButton(
            child: const Text("取消"),
            onPressed: () => Get.back()
        ),
        TextButton(
          child: const Text("确认"),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}

class UploadDialog extends StatelessWidget {
  const UploadDialog({Key? key, required this.model}) : super(key: key);
  final DataManageModel model;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("上传数据"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text("路径："),
              Obx(() => Text(
                model.uploadPath,
                style: const TextStyle(
                  decoration: TextDecoration.underline
                ),
              )),
            ],
          ),
          const Text("（仅支持上传.csv文件，且必须满足要求格式。格式见软件课程设计数据说明文档。）"),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () => model.pickFile(),
                child: const Text('浏览'),
              ),
              ElevatedButton(
                onPressed: () => model.uploadFile(),
                child: const Text('上传'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close_rounded)
        )
      ],
    );
  }
}