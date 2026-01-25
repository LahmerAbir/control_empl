import 'package:control_empl/model/planning_cleaner.dart';
import 'package:control_empl/model/tache.dart';
import 'package:control_empl/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '../../repository/building_repository.dart';
import '../../ui/common/loading.dart';
import '../../utils/utils.dart';
import '../appartemennt/appartement.dart';
import '../employe/employe.dart';
import '../taches/tache.dart';

@RoutePage()
class HomeEmployePage extends StatefulWidget {
  const HomeEmployePage({super.key});

  @override
  State<HomeEmployePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomeEmployePage> {
  List<PlanningCleaner> tacheList = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        tacheList =
            await BuildingRepository().getTachesByCleaner(Utils.me?.id ?? "") ??
            [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.person, size: 20),
              const Text(
                'Bonjour Lahmer Abir',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              GestureDetector(onTap : (){
                Utils.setMe(null);
                Utils.setToken(null);
                context.router.replaceAll([LoginRoute()]);
              },child: Icon(Icons.logout, size: 20)),

            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isLoading ? Loader() : DashboardContent(tacheList: tacheList),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  DashboardContent({super.key, required this.tacheList});

  List<PlanningCleaner> tacheList = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSummaryCards(),
            const SizedBox(height: 20),
            tacheList.isNotEmpty  ?   const Text(
              'Activité récente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            )   :   Container(),
            const SizedBox(height: 10),
            _buildRecentActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 1.5,
      children: <Widget>[
        _buildInfoCard('Tâches d\'aujoud\'hui', tacheList.length.toString(), Icons.today, Colors.blue),
        _buildInfoCard(
          'Tâches en attente',
          tacheList.length.toString(),
          Icons.access_time_outlined,
          Colors.blue,
        ),
        _buildInfoCard(
          'Tâches encours',
          tacheList.length.toString(),

          Icons.group_work_outlined,
          Colors.blue,
        ),
        _buildInfoCard('Tâches Terminés', tacheList.length.toString(), Icons.check_circle, Colors.blue),
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
    return  ListView.separated(
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
          return GestureDetector(
            onTap: () {
              context.router.push(ModifierTacheRoute(tache: tacheList[index]));
            },
            child: _buildActivityItem(
              context,
              activity.building?.name ?? "",
              activity.room?.name ?? "",
              activity.startDate ?? "",
              activity.endDate ?? "",
            ),
          );
        },

    );
  }

  Widget _buildActivityItem(
      BuildContext context ,
    String batiment,
    String room,
    String startDate,
    String endDate,
  ) {
    final dtStart = DateTime.parse(startDate);
    final dtEnd = DateTime.parse(endDate);

    final dateStart =
        "${dtStart.year}-${dtStart.month.toString().padLeft(2, '0')}-${dtStart.day.toString().padLeft(2, '0')}";
    final dateEnd =
        "${dtEnd.year}-${dtEnd.month.toString().padLeft(2, '0')}-${dtEnd.day.toString().padLeft(2, '0')}";
    final timeStart =
        "${dtStart.hour.toString().padLeft(2, '0')}:${dtStart.minute.toString().padLeft(2, '0')}";
    final timeEnd =
        "${dtEnd.hour.toString().padLeft(2, '0')}:${dtEnd.minute.toString().padLeft(2, '0')}";


    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  batiment,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(room, style: const TextStyle(fontSize: 14 , color: Colors.blueAccent)),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black, // important sinon texte invisible
                    ),
                    children: [
                      const TextSpan(
                        text: "De ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "$dateStart - $timeStart "),
                      const TextSpan(
                        text: "à ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "$dateEnd - $timeEnd"),
                    ],
                  ),
                ),              ],
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.blue.shade600,
              size: 25,
            ),
            onPressed: () {}
            ,
          ),
        ],
      ),
        ));
  }
}
