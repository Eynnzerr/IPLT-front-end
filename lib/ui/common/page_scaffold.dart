import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/bean/position.dart';
import 'package:learnflutter/data/bean/running.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/routes.dart';
import 'package:learnflutter/ui/common/common_dialogs.dart';
import 'package:learnflutter/ui/common/data_container.dart';
import 'package:learnflutter/ui/common/data_info_text_field.dart';
import 'package:learnflutter/ui/common/scaffold_drawer.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({Key? key, this.desktopChild, this.mobileChild, this.breakPoint=600}) : super(key: key);
  
  final double breakPoint;
  // Since this widget is already wrapped with Obx(), child must not repeat doing so.
  final Widget? desktopChild;
  final Widget? mobileChild;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Already inject CommonModel at start.
    final model = Get.find<GlobalModel>();

    if (screenWidth >= breakPoint) {
      return DesktopPage(model: model, child: desktopChild,);
    }
    else {
      return MobilePage(model: model, child: mobileChild,);
    }
  }
}

class DesktopPage extends StatelessWidget {
  const DesktopPage({Key? key, this.child, required this.model}) : super(key: key);

  final GlobalModel model;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        leading: IconButton(
            onPressed: () => model.updateExtended(),
            icon: const Icon(Icons.menu)
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline)
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(), 
              icon: const Icon(Icons.dataset_outlined)
            )
          ),
          IconButton(
            onPressed: () {
              model.refreshData();
              Get.snackbar(
                '??????',
                '????????????????????????',
                icon: const Icon(Icons.check_circle_outline_outlined),
                shouldIconPulse: true,
                backgroundColor: Colors.white60.withOpacity(0.2)
              );
            },
              icon: const Icon(Icons.refresh)
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 0,child: Text("????????????")),
              const PopupMenuItem(value: 1,child: Text("????????????")),
              const PopupMenuItem(value: 2,child: Text("????????????")),
            ],
            icon: const Icon(Icons.dark_mode),
            onSelected: (int mode) => model.darkMode = mode,
          ),
          PopupMenuButton(
            itemBuilder: (_) => [const PopupMenuItem(value: 'logout',child: Text("??????"))],
            icon: const Icon(Icons.person),
            onSelected: (_) {
              Get.offAllNamed(Routes.signup);
            },
          )
        ],
      ),
      endDrawer: Drawer( // TODO
        elevation: 16.0,
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '??????????????????-Position',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  IconButton(
                    onPressed: () => model.updateEditing(),
                    icon: Icon(model.dataEditing ? Icons.remove_red_eye : Icons.edit_rounded)
                  )
                ],
              ),
            ),
            DataContainer(
              child: Obx(() => ListView.separated(
                  itemBuilder: (_, index) {
                    final position = model.posList[index];
                    final Position posBuffer = position.clone();
                    return ExpansionTile(
                      title: Text('position $index'),
                      subtitle: Text('x: ${position.x} y: ${position.y} z: ${position.z}'),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataInfoTextField(
                          title: 'address',
                          defaultText: position.address,
                          isEnabled: model.dataEditing,
                          onChanged: (newAddress) => posBuffer.address = newAddress
                        ),
                        DataInfoTextField(
                          title: 'x',
                          defaultText: position.x.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => posBuffer.x = double.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'y',
                          defaultText: position.y.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => posBuffer.y = double.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'z',
                          defaultText: position.z.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => posBuffer.z = double.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'stay',
                          defaultText: position.stay.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => posBuffer.stay = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'timestamp',
                          defaultText: position.timestamp.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => posBuffer.timestamp = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'bsAddress',
                          defaultText: position.bsAddress.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => posBuffer.bsAddress = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'sample time',
                          defaultText: position.sampleTime,
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => posBuffer.sampleTime = newValue
                        ),
                        DataInfoTextField(
                            title: 'sample batch',
                            defaultText: position.sampleBatch.toString(),
                            isEnabled: model.dataEditing,
                            onChanged: (newValue) => posBuffer.sampleBatch = int.parse(newValue)
                        ),
                        ButtonBar(
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {
                                  // ???????????????????????????????????? ????????????????????????????????????
                                  if (model.dataEditing) {
                                    model.posList[index] = posBuffer;
                                    model.updatePos(posBuffer);
                                  }
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('??????')
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // ??????????????? ???????????????????????? ????????????????????????????????????????????????
                                Get.dialog(DeleteDialog(onConfirm: () {
                                  model.deleteData(position.id);
                                  Get.back();
                                }));
                              },
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('??????'),
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
                  itemCount: model.posList.length
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '???????????????-Running',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  IconButton(
                      onPressed: () => model.updateEditing(),
                      icon: Icon(model.dataEditing ? Icons.remove_red_eye : Icons.edit_rounded)
                  )
                ],
              ),
            ),
            DataContainer(
              child: Obx(() => ListView.separated(
                  itemBuilder: (_, index) {
                    final running = model.runList[index];
                    final Running runBuffer = running.clone();
                    return ExpansionTile(
                      title: Text('running $index'),
                      subtitle: Text('accx: ${running.accx} accy: ${running.accy} accz: ${running.accz}'),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataInfoTextField(
                          title: 'address',
                          defaultText: running.address,
                          isEnabled: model.dataEditing,
                          onChanged: (newAddress) => runBuffer.address = newAddress
                        ),
                        DataInfoTextField(
                          title: 'accx',
                          defaultText: running.accx.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.accx = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'accy',
                          defaultText: running.accy.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.accy = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'accz',
                          defaultText: running.accz.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.accz = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'gyroscopex',
                          defaultText: running.gyroscopex.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.gyroscopex = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'gyroscopey',
                          defaultText: running.gyroscopey.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.gyroscopey = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'gyroscopez',
                          defaultText: running.gyroscopez.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.gyroscopez = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'stay',
                          defaultText: running.stay.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.stay = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'timestamp',
                          defaultText: running.timestamp.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.timestamp = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'bsAddress',
                          defaultText: running.bsAddress.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.bsAddress = int.parse(newValue)
                        ),
                        DataInfoTextField(
                          title: 'sample time',
                          defaultText: running.sampleTime.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.sampleTime = newValue
                        ),
                        DataInfoTextField(
                          title: 'sample batch',
                          defaultText: running.sampleBatch.toString(),
                          isEnabled: model.dataEditing,
                          onChanged: (newValue) => runBuffer.sampleBatch = int.parse(newValue)
                        ),
                        ButtonBar(
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {
                                  // ??????????????????????????? ????????????????????????????????????
                                  if (model.dataEditing) {
                                    model.runList[index] = runBuffer;
                                    model.updateRun(runBuffer);
                                  }
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('??????')
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // ???????????????????????? ??????????????????????????????????????????
                                Get.dialog(DeleteDialog(onConfirm: () {
                                  model.deleteData(running.id, isPos: false);
                                  Get.back();
                                }));
                              },
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('??????'),
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
                  itemCount: model.runList.length
              )),
            ),

          ],
        ),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('????????????')
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.data_thresholding_outlined),
                  label: Text('????????????')
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.my_location),
                  label: Text('????????????')
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('????????????')
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('????????????')
              ),
            ],
            trailing: const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: FlutterLogo(),
                ),
              ),
            ),
            extended: model.railExtended,
            selectedIndex: model.navigationIndex,
            onDestinationSelected: (int index) => model.navigationIndex = index,
            elevation: 3,
          ),
          Expanded(
              child: child??Container()
          )
        ],
      ),
    ));
  }
}

class MobilePage extends StatelessWidget {
  const MobilePage({Key? key, this.child, required this.model}) : super(key: key);

  final GlobalModel model;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: const Text('IPLT ?????????????????????????????? v1.0.0'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline)
          ),
          IconButton(
            onPressed: () {
              model.refreshData();
              Get.snackbar(
                '??????',
                '????????????????????????',
                icon: const Icon(Icons.check_circle_outline_outlined),
                shouldIconPulse: true,
                backgroundColor: Colors.white60.withOpacity(0.2)
              );
            },
            icon: const Icon(Icons.refresh)
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 0,child: Text("????????????")),
              const PopupMenuItem(value: 1,child: Text("????????????")),
              const PopupMenuItem(value: 2,child: Text("????????????")),
            ],
            icon: const Icon(Icons.dark_mode),
            onSelected: (int mode) => model.darkMode = mode,
          ),
          PopupMenuButton(
            itemBuilder: (_) => [const PopupMenuItem(value: 'logout',child: Text("??????"))],
            icon: const Icon(Icons.person),
            onSelected: (_) {
              Get.offAllNamed(Routes.signup);
            },
          )
        ],
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => model.navigationIndex = 0,
              icon: Icon(
                Icons.home,
                color: model.navigationIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).highlightColor,
              ),
            ),
            const SizedBox(),
            IconButton(
              onPressed: () => model.navigationIndex = 4,
              icon: Icon(
                Icons.settings,
                color: model.navigationIndex == 4 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            middleText: 'you opened FAB.',
            onConfirm: () { }
          );
        },
        child: const Icon(Icons.unfold_more),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: child,
    ));
  }
}
