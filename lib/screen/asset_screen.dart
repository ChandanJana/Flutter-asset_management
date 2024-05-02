import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/asset/asset_data.dart';
import 'package:mindteck_iot/widgets/custom_search_delegate.dart';

import '../provider/api_data_provider.dart';
import '../resource/app_resource.dart';
import '../utils/constants.dart';
import '../widgets/asset_list_row.dart';
import '../widgets/error_screen.dart';
import '../widgets/no_data_screen.dart';

/// Created by Chandan Jana on 05-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  void _reload() {
    ref.invalidate(assetListProvider);
    ref.read(assetListProvider);
  }

  void _addNewAsset() async {
    /*final isAdded = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (context) {
        return const AddAssetScreen();
      },
    ));

    if (isAdded!) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Asset add feature available soon!',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(
          seconds: 5,
        ),
        backgroundColor: Colors.black,
      ));
    }*/
  }

  FlutterSecureStorage storage = FlutterSecureStorage();
  String? role;

  Future<void> _getValueFromSecureStorage() async {
    try {
      role = await storage.read(key: AppDatabase.roleName);
    } catch (e) {
      // Handle error
      print('Error reading value: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getValueFromSecureStorage();
    //ref.read(assetListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final assetData = ref.watch(assetListProvider);
    return Scaffold(
      /// WillPopScope is a widget in the Flutter framework, which is used for
      /// controlling the behavior of the back button or the system navigation
      /// gestures on Android devices. It allows you to intercept and handle
      /// the back button press event to perform custom actions
      ///
      /// Inside the CustomScrollView, we add several Sliver widgets:
      //
      // SliverAppBar: A flexible app bar with a title.
      // SliverList: A scrollable list of items.
      // SliverGrid: A scrollable grid with cards.
      // SliverToBoxAdapter: A custom container with non-sliver content.
      // SliverFillRemaining: A custom container with fills all remaining space in a
      // scroll view, and lays a box widget out inside that space.
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            elevation: 4,
            floating: true,
            pinned: true,
            title: Text(
              AppText.allAssets,
              style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white, // Change the color of the back button
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {
                  assetData.when(
                    data: (data) {
                      List<AssetData> assetList = data.map((e) => e).toList();
                      return showSearch(
                        context: context,
                        delegate: CustomSearchDelegate<AssetData>(
                            optionName: Constants.allAssets,
                            searchList: assetList,
                            role: role),
                      );
                    },
                    error: (error, stackTrace) {},
                    loading: () {},
                  );
                },
              ),
              IconButton(
                onPressed: _addNewAsset,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: _reload,
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: assetData.when(
              data: (data) {
                List<AssetData> assetList = data.map((e) => e).toList();
                if (assetList.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: NoDataScreen(onRetry: _reload),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return AssetListRow(
                      assetData: assetList[index],
                    );
                  },
                  itemCount: assetList.length,
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: ErrorScreen(
                      errorMessage: error.toString(), onRetry: _reload),
                );
              },
              loading: () {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.blueAccent,
                    size: 70,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
