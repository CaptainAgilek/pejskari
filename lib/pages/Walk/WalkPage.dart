import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pedometer/pedometer.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/DogTrainingPlace.dart';
import 'package:pejskari/data/Walk.dart';
import 'package:pejskari/pages/Walk/StopwatchText.dart';
import 'package:pejskari/pages/Walk/WalkEditPageArgs.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/DogProfileService.dart';
import 'package:pejskari/service/MapPlacesService.dart';
import 'package:pejskari/util/DistanceUtil.dart';

import '../../data/DogPark.dart';

/// This class represents page with walk, there is map on this page.
class WalkPage extends StatefulWidget {
  static const String routeName = "/walk";

  const WalkPage({Key? key}) : super(key: key);

  @override
  _WalkPageState createState() => _WalkPageState();
}

class _WalkPageState extends State<WalkPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(50.073658, 14.418540), //Prague
    zoom: 14.4746,
  );

  final MapPlacesService _mapPlacesService = MapPlacesService();
  final DogProfileService _dogProfileService = DogProfileService();
  List<DogProfile> _dogProfiles = [];
  Map<String, bool> _dogsForWalk = {};

  double _distance = 0;
  bool _isLocationGranted = false;
  final stopwatch = Stopwatch();
  final Location _locationService = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  late LocationData _initialLocation;
  late LocationData _locationData;
  Set<Marker> markers = {};
  List<LatLng> _recordedCoordinates = [];
  List<LocationData> _locationBuffer = [];

  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  String _pedesitrianStatus = "stopped";

  Map<String, bool> _objectsOnMap = {"dogTrainingPlace": true, "dogPark": true};
  List<DogPark> _dogParks = [];
  List<DogTrainingPlace> _dogTrainingPlaces = [];
  double _radius = 500;

  @override
  void initState() {
    super.initState();
    fetchDogProfiles();
    Future.delayed(const Duration(milliseconds: 200)).whenComplete(() {
      _getInitialPosition().whenComplete(() {
        _moveCameraToPosition();
        fetchDogParks().whenComplete(() {
          setState(() {
            _addDogParks();
          });
        });
        fetchDogTrainingPlaces().whenComplete(() {
          setState(() {
            _addDogTrainingPlaces();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
      _locationSubscription = null;
    }
    if (_pedestrianStatusSubscription != null) {
      _pedestrianStatusSubscription!.cancel();
      _pedestrianStatusSubscription = null;
    }
    super.dispose();
  }

  /// Fetches dog parks (from api).
  Future<void> fetchDogParks() async {
    _dogParks = await _mapPlacesService.getDogParks();
  }

  /// Fetches dog training places (from api).
  Future<void> fetchDogTrainingPlaces() async {
    _dogTrainingPlaces = await _mapPlacesService.getDogTrainingPlaces();
  }

  /// Gets initial gps position
  Future<void> _getInitialPosition() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationService.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationService.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    _permissionGranted = await _locationService.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationService.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    _locationData = await _locationService
        .getLocation()
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Error();
    }).catchError((error) {
      if (mounted) {
        setState(() {});
      }
      return _locationService.getLocation();
    });

    await _locationService.changeSettings(
        distanceFilter: 1,
        accuracy: LocationAccuracy.navigation,
        interval: 2000); //1 meter
    await _locationService.changeNotificationOptions(
        title: "Určování polohy pomocí GPS");

    _locationData = await _repeatGetLocationNTimes(5);

    await _locationService.enableBackgroundMode(enable: true);

    _pedesitrianStatus = "stopped";

    setState(() {
      _isLocationGranted = true;
      _initialLocation = _locationData;
      markers.add(Marker(
          markerId: const MarkerId("location"),
          position:
              LatLng(_initialLocation.latitude!, _initialLocation.longitude!)));

      _recordedCoordinates
          .add(LatLng(_locationData.latitude!, _locationData.longitude!));
    });
  }

  /// Called when pedometer changes status (walking/stopped).
  void _onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _pedesitrianStatus = event.status;
    });
  }

  void _onPedestrianStatusError(error) {
    setState(() {
      _pedesitrianStatus = 'ERROR';
    });
  }

  /// Creates subscription for GPS coordinates. Handles creating path and calculating distance from this data.
  createLocationSubscription() {
    _locationSubscription = _locationService.onLocationChanged
        .listen((LocationData currentLocation) {
      var bestLocation = currentLocation;
      if (_locationBuffer.length < 3) {
        _locationBuffer.add(currentLocation);
        return;
      }
      // store last 3 locations in buffer
      if (_locationBuffer.length == 3) {
        //pick one with best accuracy
        bestLocation = _locationBuffer
            .reduce((a, b) => (a.accuracy! < b.accuracy!) ? a : b);
        _locationBuffer = [];
        _locationBuffer.add(currentLocation);
      }

      setState(() {
        _locationData = bestLocation;

        _recordedCoordinates
            .add(LatLng(_locationData.latitude!, _locationData.longitude!));
        if (_recordedCoordinates.length >= 2) {
          var previousCoords =
              _recordedCoordinates.elementAt(_recordedCoordinates.length - 2);
          double distanceBetweenPreviousAndCurrentPoint =
              DistanceUtil.calculateDistance(
                  previousCoords.latitude,
                  previousCoords.longitude,
                  _recordedCoordinates.last.latitude,
                  _recordedCoordinates.last.longitude);

          if (distanceBetweenPreviousAndCurrentPoint <= 0.0001 ||
              _pedesitrianStatus == "stopped") {
            //discarding distance
            _recordedCoordinates.removeLast();
          } else {
            _distance += distanceBetweenPreviousAndCurrentPoint;
          }
        }
      });
    });
  }

  /// Fetches dog profiles from database.
  void fetchDogProfiles() async {
    _dogProfiles = await _dogProfileService.getAll();
    for (var element in _dogProfiles) {
      _dogsForWalk.putIfAbsent(element.name, () => false);
    }
    setState(() {});
  }

  /// Stops recording walk.
  _onStopButtonPressed(BuildContext context) {
    late Walk walk;
    setState(() {
      markers.add(Marker(
          markerId: const MarkerId("endLocation"),
          position: LatLng(_locationData.latitude!, _locationData.longitude!)));
      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }

      List<int> _dogProfilesIds = [];
      for (var entry in _dogsForWalk.entries) {
        if (entry.value == true) {
          for (var profile in _dogProfiles) {
            if (entry.key == profile.name) {
              _dogProfilesIds.add(profile.id);
            }
          }
        }
      }

      walk = Walk(0, DateTime.now().toIso8601String(), "", _distance,
          stopwatch.elapsedMilliseconds, _dogProfilesIds);
      stopwatch.reset();
      stopwatch.stop();
    });

    NavigationDrawer.isWalkActive = false;
    Navigator.of(context).pushNamed(Routes.walkEditPage,
        arguments: WalkEditPageArgs(walk, _dogProfiles));
  }

  /// Adds dog training places to map.
  _addDogTrainingPlaces() async {
    var whistleIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/whistle.png");
    //add dog training places
    setState(() {
      for (var element in _dogTrainingPlaces) {
        if (DistanceUtil.calculateDistance(element.latitude, element.longitude,
                    _locationData.latitude, _locationData.longitude)
                .compareTo(_radius) <=
            0) {
          //if within radius, add marker
          markers.add(Marker(
              markerId: MarkerId("dog-training-place" + element.id.toString()),
              position: LatLng(element.latitude, element.longitude),
              icon: whistleIcon,
              infoWindow: InfoWindow(
                  title: element.name,
                  snippet: element.street +
                      (element.street.isNotEmpty ? ", " : "") +
                      element.city,
                  onTap: () {})));
        }
      }
    });
  }

  /// Adds dog parks to map.
  _addDogParks() async {
    var whistleIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/dog_park.png");
    //add dog parks
    setState(() {
      for (var element in _dogParks) {
        if (DistanceUtil.calculateDistance(element.latitude, element.longitude,
                    _locationData.latitude, _locationData.longitude)
                .compareTo(_radius) <=
            0) {
          markers.add(Marker(
              markerId: MarkerId("dog-park" + element.id.toString()),
              position: LatLng(element.latitude, element.longitude),
              icon: whistleIcon,
              infoWindow: InfoWindow(
                  title: element.name,
                  snippet: element.street +
                      (element.street.isNotEmpty ? ", " : "") +
                      element.city,
                  onTap: () {})));
        }
      }
    });
  }

  /// Shows dialog with settings.
  _onMapObjectSettingsPressed(BuildContext context) async {
    var result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Text(
                      'Nastavte, jaké objekty chcete na mapě zobrazovat.'),
                  content: ListView(
                    children: [
                      const Text("Vzdálenost"),
                      Slider(
                        value: _radius,
                        max: 500,
                        divisions: 100,
                        label: _radius.round().toString() + " km",
                        onChanged: (double value) {
                          setState(() {
                            _radius = value;
                          });
                        },
                      ),
                      const Text("Objekty"),
                      const SizedBox(
                        height: 10,
                      ),
                      CheckboxListTile(
                        title: const Text("Cvičiště"),
                        secondary: Image.asset(
                          "assets/whistle.png",
                        ),
                        value: _objectsOnMap["dogTrainingPlace"],
                        activeColor: Colors.pink,
                        checkColor: Colors.white,
                        tristate: false,
                        onChanged: (value) {
                          setState(() {
                            _objectsOnMap["dogTrainingPlace"] = value!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CheckboxListTile(
                        title: const Text("Psí parky"),
                        secondary: Image.asset(
                          "assets/dog_park.png",
                        ),
                        value: _objectsOnMap["dogPark"],
                        activeColor: Colors.pink,
                        checkColor: Colors.white,
                        tristate: false,
                        onChanged: (value) {
                          setState(() {
                            _objectsOnMap["dogPark"] = value!;
                          });
                        },
                      )
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Potvrdit'),
                    ),
                  ],
                );
              },
            ));

    if (result == true) {
      setState(() {
        markers.removeWhere((element) =>
            element.markerId.value.startsWith("dog-training-place"));
        markers.removeWhere(
            (element) => element.markerId.value.startsWith("dog-park"));
      });

      if (_objectsOnMap["dogTrainingPlace"] == true) {
        _addDogTrainingPlaces();
      }
      if (_objectsOnMap["dogPark"] == true) {
        _addDogParks();
      }
    }
  }

  /// Starts recording walk.
  _onStartButtonPressed(BuildContext context) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Kdo s Vámi jde na procházku?'),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return ListView(
              children: _dogProfiles
                  .map((e) => CheckboxListTile(
                        title: Text(e.name),
                        value: _dogsForWalk[e.name],
                        activeColor: Colors.pink,
                        checkColor: Colors.white,
                        tristate: false,
                        onChanged: (value) {
                          setState(() {
                            if (_dogsForWalk.isNotEmpty) {
                              _dogsForWalk[e.name] = value!;
                            }
                          });
                        },
                      ))
                  .toList());
        }),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Zrušit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Potvrdit'),
          ),
        ],
      ),
    );

    if (result == true) {
      //start geolocation and timer and distance
      setState(() {
        _distance = 0;
        markers.removeWhere((element) =>
            element.markerId.value == "location" ||
            element.markerId.value == "endLocation");
        _recordedCoordinates = [];
        stopwatch.start();
      });
      await _getInitialPosition();

      _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream
          .listen(_onPedestrianStatusChanged)
        ..onError(_onPedestrianStatusError);

      createLocationSubscription();
      NavigationDrawer.isWalkActive = true;
    }
  }

  _moveCameraToPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_locationData.latitude!, _locationData.longitude!),
        zoom: 14.4746)));
  }

  /// Retrieves location N times and returns location with best accuracy from all attempts
  Future<LocationData> _repeatGetLocationNTimes(int n) async {
    int i = 0;
    var locationDataList = [];
    while (i < n) {
      var locationData = await _locationService.getLocation();
      locationDataList.add(locationData);
      i++;
    }
    var result =
        locationDataList.reduce((a, b) => a.accuracy < b.accuracy ? a : b);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color.fromRGBO(102, 99, 99, 0.05),
      ),
      body: Column(children: [
        Expanded(
            child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: {
                Polyline(
                    polylineId: const PolylineId("path"),
                    points: _recordedCoordinates)
              },
              myLocationEnabled: _isLocationGranted,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    heroTag: 'map_settings',
                    onPressed: () async {
                      _onMapObjectSettingsPressed(context);
                    },
                    child: const Icon(
                      Icons.settings,
                      color: Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Color(0xFFECEDF1))),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    heroTag: 'recenter',
                    onPressed: () async {
                      _moveCameraToPosition();
                    },
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Color(0xFFECEDF1))),
                  ),
                ),
              )
            ]),
          ],
        )),
        Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              )
            ]),
            width: MediaQuery.of(context).size.width,
            child: Row(children: [
              Expanded(
                  child: Column(children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("VZDÁLENOST"),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text(
                        _distance.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 31),
                      ),
                      const Text("km")
                    ],
                  ),
                )
              ])),
              //  Spacer(),
              Expanded(
                  child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: !stopwatch.isRunning
                      ? const Text("START")
                      : const Text("STOP"),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    onPressed: () {
                      !stopwatch.isRunning == true
                          ? _onStartButtonPressed(context)
                          : _onStopButtonPressed(context);
                    },
                    child: !stopwatch.isRunning == true
                        ? const Icon(Icons.play_arrow, color: Colors.white)
                        : const Icon(
                            Icons.stop,
                            color: Colors.white,
                          ),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                      primary: Colors.blue, // <-- Button color
                      onPrimary: Colors.red, // <-- Splash color
                    ),
                  ),
                )
              ])),
              //  Spacer(),
              Expanded(
                  child: Column(children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("ČAS"),
                ),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(children: [
                      StopwatchText(
                        stopwatch: stopwatch,
                        textStyle: const TextStyle(fontSize: 31),
                      ),
                      const Text("min")
                    ]))
              ]))
            ])),
      ]),
    );
  }
}
