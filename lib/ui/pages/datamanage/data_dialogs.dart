import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/bean/position.dart';
import 'package:learnflutter/data/bean/running.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/data/model/datamanage_model.dart';
import 'package:learnflutter/ui/common/common_dialogs.dart';
import 'package:learnflutter/ui/common/data_container.dart';
import 'package:learnflutter/ui/common/data_info_text_field.dart';

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({Key? key, required this.dataModel, required this.globalModel}) : super(key: key);
  final DataManageModel dataModel;
  final GlobalModel globalModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("1. 选择批次"),
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
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "2. 数据预览",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Obx(() => IconButton(
                    onPressed: () => globalModel.updateEditing(),
                    icon: Icon(globalModel.dataEditing ? Icons.remove_red_eye : Icons.edit_rounded)
                  )),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    '定位基站数据-Position',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  Text(
                    '传感器读数-Running',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ],
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
                      final Position posBuffer = position.clone();
                      return ExpansionTile(
                        title: Text('position $index'),
                        subtitle: Text('x: ${position.x} y: ${position.y} z: ${position.z}'),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataInfoTextField(
                              title: 'address',
                              defaultText: position.address,
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newAddress) => posBuffer.address = newAddress
                          ),
                          DataInfoTextField(
                              title: 'x',
                              defaultText: position.x.toString(),
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newValue) => posBuffer.x = double.parse(newValue)
                          ),
                          DataInfoTextField(
                              title: 'y',
                              defaultText: position.y.toString(),
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newValue) => posBuffer.y = double.parse(newValue)
                          ),
                          DataInfoTextField(
                              title: 'z',
                              defaultText: position.z.toString(),
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newValue) => posBuffer.z = double.parse(newValue)
                          ),
                          DataInfoTextField(
                              title: 'stay',
                              defaultText: position.stay.toString(),
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newValue) => posBuffer.stay = int.parse(newValue)
                          ),
                          DataInfoTextField(
                              title: 'timestamp',
                              defaultText: position.timestamp.toString(),
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newValue) => posBuffer.timestamp = int.parse(newValue)
                          ),
                          DataInfoTextField(
                              title: 'bsAddress',
                              defaultText: position.bsAddress.toString(),
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newValue) => posBuffer.bsAddress = int.parse(newValue)
                          ),
                          DataInfoTextField(
                              title: 'sample time',
                              defaultText: position.sampleTime,
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newValue) => posBuffer.sampleTime = newValue
                          ),
                          DataInfoTextField(
                              title: 'sample batch',
                              defaultText: position.sampleBatch.toString(),
                              isEnabled: globalModel.dataEditing,
                              onChanged: (newValue) => posBuffer.sampleBatch = int.parse(newValue)
                          ),
                          ButtonBar(
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    // 确认对当前所选数据的修改 同步修改远端数据库中数据
                                    if (globalModel.dataEditing) {
                                      globalModel.posList[index] = posBuffer;
                                      globalModel.updatePos(posBuffer);
                                    }
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text('编辑')
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // 弹出对话框 删除当前所选数据 同时从远端数据库中同步删除该数据
                                  Get.dialog(DeleteDialog(onConfirm: () {
                                    globalModel.deleteData(position.id);
                                    Get.back();
                                  }));
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
                        final Running runBuffer = running.clone();
                        return ExpansionTile(
                          title: Text('running $index'),
                          subtitle: Text('accx: ${running.accx} accy: ${running.accy} accz: ${running.accz}'),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DataInfoTextField(
                                title: 'address',
                                defaultText: running.address,
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newAddress) => runBuffer.address = newAddress
                            ),
                            DataInfoTextField(
                                title: 'accx',
                                defaultText: running.accx.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.accx = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'accy',
                                defaultText: running.accy.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.accy = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'accz',
                                defaultText: running.accz.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.accz = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'gyroscopex',
                                defaultText: running.gyroscopex.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.gyroscopex = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'gyroscopey',
                                defaultText: running.gyroscopey.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.gyroscopey = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'gyroscopez',
                                defaultText: running.gyroscopez.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.gyroscopez = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'stay',
                                defaultText: running.stay.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.stay = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'timestamp',
                                defaultText: running.timestamp.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.timestamp = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'bsAddress',
                                defaultText: running.bsAddress.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.bsAddress = int.parse(newValue)
                            ),
                            DataInfoTextField(
                                title: 'sample time',
                                defaultText: running.sampleTime.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.sampleTime = newValue
                            ),
                            DataInfoTextField(
                                title: 'sample batch',
                                defaultText: running.sampleBatch.toString(),
                                isEnabled: globalModel.dataEditing,
                                onChanged: (newValue) => runBuffer.sampleBatch = int.parse(newValue)
                            ),
                            ButtonBar(
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () {
                                      // 对当前所选数据修改 同时修改远端数据库中数据
                                      if (globalModel.dataEditing) {
                                        globalModel.runList[index] = runBuffer;
                                        globalModel.updateRun(runBuffer);
                                      }
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text('编辑')
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // 删除当前所选数据 同时从远端数据库中删除该数据
                                    Get.dialog(DeleteDialog(onConfirm: () {
                                      globalModel.deleteData(running.id, isPos: false);
                                      Get.back();
                                    }));
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text("（仅支持上传.csv文件，且必须满足要求格式。格式见软件课程设计数据说明文档。）"),
          ),
          const Text("Position 数据上传"),
          Row(
            children: [
              const Text("路径："),
              Obx(() => Text(
                model.posPath,
                style: const TextStyle(
                    decoration: TextDecoration.underline
                ),
              )),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () => model.pickPosFile(),
                child: const Text('浏览'),
              ),
              TextButton(
                onPressed: () => model.uploadPosFile(),
                child: const Text('上传'),
              ),
            ],
          ),

          const Text("Running 数据上传"),
          Row(
            children: [
              const Text("路径："),
              Obx(() => Text(
                model.runPath,
                style: const TextStyle(
                    decoration: TextDecoration.underline
                ),
              )),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () => model.pickRunFile(),
                child: const Text('浏览'),
              ),
              TextButton(
                onPressed: () => model.uploadRunFile(),
                child: const Text('上传'),
              ),
            ],
          ),

          const Text("Ground Truth 数据上传"),
          Row(
            children: [
              const Text("路径："),
              Obx(() => Text(
                model.truthPath,
                style: const TextStyle(
                    decoration: TextDecoration.underline
                ),
              )),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () => model.pickTruthFile(),
                child: const Text('浏览'),
              ),
              TextButton(
                onPressed: () => model.uploadTruthFile(),
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