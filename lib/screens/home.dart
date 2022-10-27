import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x_last_launch/bloc/launches_bloc/launches_bloc.dart';
import 'package:space_x_last_launch/datas/model/launches_model.dart';
import 'package:space_x_last_launch/datas/repos/launches_repository.dart';

// Home Screen of The App
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaunchesBloc(
        RepositoryProvider.of<LaunchesRepository>(context),
      )..add(LoadLaunchesEvent()),
      child: Scaffold(
        //App Bar
        appBar: AppBar(
          centerTitle: true,
          title: const Text('SpaceX Last Launch Info'),
        ),
        // Body of the page
        // We use Bloc builder here because this is the only part that may change
        body: BlocBuilder<LaunchesBloc, LaunchesState>(
          builder: (context, state) {
            if (state is LaunchesLoadingState) {
              return const Center(
                // Loading Indicator while the page is loading
                child: CircularProgressIndicator(),
              );
            }
            if (state is LaunchesLoadedState) {
              // Here we find the last launch (lastLaunch) in the launches list
              //which we get from the http request
              Launches lastLaunch = state.launches.reduce((max, e) =>
                  e.dateUtc!.isAfter(max.dateUtc!) && e.upcoming == false
                      ? e
                      : max);

              // Refresh with sliver part
              return RefreshIndicator(
                onRefresh: () async {
                  // On refresh:We add PullToRefresh event  to the BloC
                  context.read<LaunchesBloc>().add(PullToRefreshEvent());
                },
                child: CustomScrollView(slivers: <Widget>[
                  //AppBar with SpaceX Logo
                  SliverAppBar(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    expandedHeight: 100,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        "https://www.spacex.com/static/images/share.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  //Sliver Listh To show Launch Details
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            //PATCH
                            Container(
                              height: 300,
                              width: 300,
                              child: lastLaunch.links!.patch!.small == null
                                  ? Image.asset("assets/images/nopatch.png")
                                  : Image.network(
                                      lastLaunch.links!.patch!.large.toString(),
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          //SHOW INDICATOR WHILE LOADING
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),

                            // MISSION NAME
                            Text("Mission Name: ${lastLaunch.name}"),
                            const SizedBox(
                              height: 20,
                            ),
                            // MISSION TIME
                            Text("Date(UTC): ${lastLaunch.dateUtc}"),
                            const SizedBox(
                              height: 20,
                            ),
                            // MISSION DETAILS
                            lastLaunch.details == null
                                ? const Text("Details: No detail info")
                                : Text("Details: ${lastLaunch.details}"),
                            const SizedBox(
                              height: 20,
                            ),
                            // ROCKET NUMBER
                            Text("Rocket Number: ${lastLaunch.rocket}"),
                            const SizedBox(
                              height: 20,
                            ),
                            // SUCCESSFULL STATUE
                            Text(
                                "Is Succesfull: ${lastLaunch.success == true ? "Yes" : "False"}"),
                            const SizedBox(
                              height: 20,
                            ),
                            // FLIGHT NUMBER
                            Text(
                                "Flight Number: ${lastLaunch.flightNumber.toString()}"),
                            const SizedBox(
                              height: 180,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ]),
              );
            }
            // If there is an error...:
            if (state is LaunchesErrorState) {
              return Center(
                child: Text(state.error.toString()),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
