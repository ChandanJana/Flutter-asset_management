import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/tenant/tenant_data.dart';

import '../provider/api_data_provider.dart';
import '../resource/app_resource.dart';
import '../widgets/error_screen.dart';
import '../widgets/no_data_screen.dart';
import '../widgets/tenant_list_row.dart';

class TenantScreen extends ConsumerStatefulWidget {
  const TenantScreen({super.key});

  @override
  ConsumerState<TenantScreen> createState() => _TenantManagementState();
}

class _TenantManagementState extends ConsumerState<TenantScreen> {
  // late Future<List<Result>> _loadedItems;

  void _reload() {
    ref.invalidate(tenantListProvider);
    ref.read(tenantListProvider);
    /*setState(() {
      _loadedItems = Future.value([]);
      //_error = null;
      //_isLoading = true;
      _loadedItems = _loadUsers();
    });*/
  }

  @override
  void initState() {
    super.initState();
    // ref.read(loadUserProvider);
    //_loadedItems = _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    var userData = ref.watch(tenantListProvider);
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
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            elevation: 4,
            floating: true,
            snap: true,
            title: Text(
              AppText.tenants,
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
              // IconButton(
              //   onPressed: _addNewUser,
              //   icon: const Icon(
              //     Icons.add,
              //     color: Colors.white,
              //   ),
              // ),
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
            child: userData.when(
              data: (data) {
                List<TenantData> tenantList = data.map((e) => e).toList();
                if (tenantList.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: NoDataScreen(onRetry: _reload),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return TenantListRow(
                      tenantData: tenantList[index],
                    );
                  },
                  itemCount: tenantList.length,
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
          /*SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return FutureBuilder(
                  future: _loadedItems,
                  builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.blueAccent,
                      size: 70,
                    ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  if (snapshot.data!.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      child: const Text('No Users available'),
                    );
                  }
                  return const Card(
                    child: Text(Constants.tenants),
                  );
                },);
              },
            ),
          )*/
        ],
      ),
    );
  }
}
