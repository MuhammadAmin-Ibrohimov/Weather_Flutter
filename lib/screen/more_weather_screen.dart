import 'dart:ui';

import 'package:fast_weather/bloc_more_weather/more_weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class MoreWeather extends StatefulWidget {
  const MoreWeather({super.key});

  @override
  State<MoreWeather> createState() => _MoreWeatherState();
}

class _MoreWeatherState extends State<MoreWeather> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BlocProvider<MoreWeatherBloc>(
              create: (context) => MoreWeatherBloc()
                ..add(FetchMoreWeather(snapshot.data as Position)),
              child: MoreWeatherDetail(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MoreWeatherDetail extends StatefulWidget {
  const MoreWeatherDetail({super.key});

  @override
  State<MoreWeatherDetail> createState() => _MoreWeatherDetailState();
}

class _MoreWeatherDetailState extends State<MoreWeatherDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light),
            backgroundColor: Color.fromARGB(0, 255, 253, 253),
            title: const Text('More Weather',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600))),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.deepPurple),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.deepPurple),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 250,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle, color: Color(0xFFFFAB40)),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              BlocBuilder<MoreWeatherBloc, MoreWeatherState>(
                builder: (context, state) {
                  if (state is MoreWeatherSuccess) {
                    return ListView.builder(
                      itemCount: state.weather.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            elevation: 8,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd - MMM  H:mm')
                                        .format(state.weather[index].date!),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Row(children: [
                                    Text(
                                        state
                                            .weather[index].weatherDescription!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        "${state.weather[index].temperature!.celsius!.round()}°C",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300)),
                                  ]),
                                  Text("${state.weather[index].windSpeed} m/s",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300)),
                                  Row(children: [
                                    Text(
                                        "min: ${state.weather[index].tempMin!.celsius!.round()}°C",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300)),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                        "max: ${state.weather[index].tempMax!.celsius!.round()}°C",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300)),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                      "Please Wait",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ));
                  }
                },
              ),
            ],
          ),
        ));
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
