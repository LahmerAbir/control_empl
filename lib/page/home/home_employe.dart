import 'package:control_empl/model/tache.dart';
import 'package:control_empl/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor : Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top :20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Icon(Icons.person , size: 20,),
              const Text(
                'Bonjour Lahmer Abir',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Icon(Icons.logout , size: 20,)
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
        child: DashboardContent(),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

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

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 1.5,
      children: <Widget>[
        _buildInfoCard('Tâches d\'aujoud\'hui', '3', Icons.today, Colors.blue),
        _buildInfoCard('Tâches en attente', '10', Icons.access_time_outlined, Colors.blue),
        _buildInfoCard('Tâches encours', '1', Icons.group_work_outlined, Colors.blue),
        _buildInfoCard('Tâches Terminés', '5', Icons.check_circle, Colors.blue),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
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
                Icon(
                  icon,
                  color: color,
                  size: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    final List<TachePlanning> activities = [
     /* TachePlanning(numeroAppartement: 'Appartement 101', employe: 'Abir lahmer',heure :'Il y a 2h',  date: '16/11/2025', statut: 'Encours'),
      TachePlanning(numeroAppartement: 'Appartement 101', employe: 'Abir lahmer',heure :'Il y a 2h',  date: '16/11/2025', statut: 'Encours'),
      TachePlanning(numeroAppartement: 'Appartement 101', employe: 'Abir lahmer',heure :'Il y a 2h',  date: '16/11/2025', statut: 'Encours'),
      TachePlanning(numeroAppartement: 'Appartement 101', employe: 'Abir lahmer',heure :'Il y a 2h',  date: '16/11/2025', statut: 'Terminé'),
      TachePlanning(numeroAppartement: 'Appartement 101', employe: 'Abir lahmer',heure :'Il y a 2h',  date: '16/11/2025', statut: 'Terminé'),
      TachePlanning(numeroAppartement: 'Appartement 101', employe: 'Abir lahmer',heure :'Il y a 2h',  date: '16/11/2025', statut: 'Terminé'),
      TachePlanning(numeroAppartement: 'Appartement 101', employe: 'Abir lahmer',heure :'Il y a 2h',  date: '16/11/2025', statut: 'Terminé'),*/
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFF0F0F0),
        ),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return GestureDetector(
            onTap: (){
              context.router.push(ModifierTacheRoute(tache: activities[index]));

            },
            child: _buildActivityItem(
           ""  ,// activity.numeroAppartement!,
            ""  ,//activity.employe,
            "" ,// activity.date,
           ""   //activity.statut,
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityItem(String logement, String personne, String temps, String statut) {
    Color statusColor;
    switch (statut) {
      case 'Terminé':
        statusColor = Colors.blue.shade700;
        break;
      case 'En cours':
        statusColor = Colors.green.shade700;
        break;
      case 'Planifié':
        statusColor = Colors.grey.shade500;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
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
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              temps,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),

          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: statusColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                statut,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}