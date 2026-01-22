import 'package:control_empl/main.data.dart';
import 'package:control_empl/model/appartement.dart';
import 'package:control_empl/model/tache.dart';
import 'package:control_empl/model/user/user.dart';
import 'package:control_empl/ui/common/loading.dart';
import 'package:control_empl/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/building.dart';
import '../../repository/building_repository.dart';
import '../../router/app_router.dart';
import '../appartemennt/appartement.dart';
import '../employe/employe.dart';
import '../taches/tache.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  String? selectedBuildingId;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Building> buildings = [];
  List<Appartement> appartement = [];
  List<TachePlanning> tacheList = [];
  List<User> users = [];

  bool isLoading = true;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        buildings = await BuildingRepository().getBuilding() ?? [];
        if (buildings.isNotEmpty) {
          selectedBuildingId = buildings.first.id;
          Utils.idBuilding = selectedBuildingId;

          appartement =
              await BuildingRepository().getRommByBuilding(
                buildings.first.id ?? "",
              ) ??
              [];
          tacheList =
              await BuildingRepository().getTachesByBuilding(
                buildings.first.id ?? "",
              ) ??
              [];
          users = await ref.users.findAll();
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print("exception $e");
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Widget _buildIconWithCircle(IconData iconData, int index) {
    final isSelected = _selectedIndex == index;

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue.shade800, width: 1.5),
        ),
        child: Icon(iconData, color: Colors.blue.shade800, size: 24),
      );
    } else {
      return Icon(iconData, color: Colors.grey.shade600, size: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : buildings.isNotEmpty
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 65,
                      child: Text(
                        "Bâtiment : ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: DropdownButton<String>(
                        value: selectedBuildingId,
                        //  hint: const Text("Sélectionner un bâtiment"),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        isExpanded: true,
                        items: buildings.map((building) {
                          return DropdownMenuItem<String>(
                            value: building.id,
                            child: Text(
                              building.name ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          if (selectedBuildingId != value)
                            setState(() {
                              selectedBuildingId = value;
                              isLoading = true;
                            });
                          try {
                            Utils.idBuilding = selectedBuildingId;
                            var auxappartement =
                                await BuildingRepository().getRommByBuilding(
                                  selectedBuildingId ?? "",
                                ) ??
                                [];
                            var auxtacheList =
                                await BuildingRepository().getTachesByBuilding(
                                  selectedBuildingId ?? "",
                                ) ??
                                [];
                            var auxusers = await ref.users.findAll();

                            setState(() {
                              isLoading = false;
                              appartement = auxappartement;
                              tacheList = auxtacheList;
                              users = auxusers;
                            });
                          } catch (e) {
                            print("exception $e");
                            setState(() {
                              isLoading = false;
                            });
                          }
                          print(
                            "Building ID sélectionné : $selectedBuildingId",
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Utils.setMe(null);
                        Utils.setToken(null);
                        context.router.replaceAll([LoginRoute()]);
                      },
                      child: Icon(Icons.logout, size: 20),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              toolbarHeight: 60,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _selectedIndex == 0
                  ? DashboardContent(
                      appartement: appartement,
                      users: users,
                      tacheList: tacheList,
                    )
                  : _selectedIndex == 1
                  ? LogementsScreen(
                      selectedBuildingId: selectedBuildingId ?? "",
                    )
                  : _selectedIndex == 2
                  ? EquipeScreen()
                  : _selectedIndex == 3
                  ? PlanningScreen(selectedBuildingId: selectedBuildingId ?? "")
                  : Container(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              // ... (Styles généraux) ...
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue.shade800,
              unselectedItemColor: Colors.grey.shade600,

              currentIndex: _selectedIndex,
              onTap: _onItemTapped,

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: _buildIconWithCircle(Icons.house_outlined, 0),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: _buildIconWithCircle(Icons.meeting_room, 1),
                  label: 'Appartements',
                ),
                BottomNavigationBarItem(
                  icon: _buildIconWithCircle(Icons.people_alt_outlined, 2),
                  label: 'Employés',
                ),
                BottomNavigationBarItem(
                  icon: _buildIconWithCircle(Icons.calendar_month_outlined, 3),
                  label: 'Taches',
                ),
              ],
            ),
          )
        : Center(child: Text("Une erreur s\'est produite"));
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.appartement,
    required this.users,
    required this.tacheList,
  });

  final List<Appartement> appartement;
  final List<User> users;
  final List<TachePlanning> tacheList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSummaryCards(appartement, users, tacheList),
            const SizedBox(height: 20),
            const Text(
              'Activité récente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            _buildRecentActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    List<Appartement> appartement,
    List<User> users,
    List<TachePlanning> tacheList,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 1.5,
      children: <Widget>[
        _buildInfoCard(
          'Total Appartements',
          appartement.length.toString(),
          Icons.meeting_room_sharp,
          Colors.blue,
        ),
        _buildInfoCard(
          'Employés',
          users.length.toString(),
          Icons.person,
          Colors.blue,
        ),
        _buildInfoCard(
          'Tâches encours',
          tacheList.length.toString(),
          Icons.group_work_outlined,
          Colors.blue,
        ),
        _buildInfoCard(
          'Tâches Terminés',
          tacheList.length.toString(),
          Icons.check_circle,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(icon, color: color, size: 25),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {


    return
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tacheList.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: Colors.white,
        ),
        itemBuilder: (context, index) {
          final activity = tacheList[index];
          return _buildActivityItem(
            activity.room?.name ?? "",
            "${activity.cleaner?.lastName ?? ""} ${activity.cleaner?.firstName ?? ""}",
          );
        },

    );
  }

  Widget _buildActivityItem(
    String logement,
    String personne,
  ) {


    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  logement,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  personne,
                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ],
            ),
          ),


        /*  IconButton(
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.blue.shade600,
              size: 25,
            ),
            onPressed: () {}
            ,
          ),*/
        ],
      ),
    ) );
  }
}
