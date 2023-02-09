import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key, required this.onConfirm}) : super(key: key);
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("删除数据"),
      content: const Text("确定删除当前所选数据吗？注意：服务器中的相同数据也会被同步删除！"),
      actions: [
        TextButton(
          onPressed: () => Get.back(), 
          child: const Text("取消")
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text("确认"),
        ),
      ],
    );
  }
}

class PosEditDialog extends StatelessWidget {
  const PosEditDialog({Key? key, required this.onConfirm}) : super(key: key);
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("编辑数据"),
      content: const Text("确定删除当前所选数据吗？注意：服务器中的相同数据也会被同步删除！"),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: const Text("取消")
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text("确认"),
        ),
      ],
    );
  }
}

class RunEditDialog extends StatelessWidget {
  const RunEditDialog({Key? key, required this.onConfirm}) : super(key: key);
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("编辑数据"),
      content: const Text("确定删除当前所选数据吗？注意：服务器中的相同数据也会被同步删除！"),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: const Text("取消")
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text("确认"),
        ),
      ],
    );
  }
}
