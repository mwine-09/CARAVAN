Positioned(
  bottom = 0,


  left = 0,
  right = 0,
  child = SizedBox(
    height: MediaQuery.of(context).size.height * 0.6, // Set the height to 60% of the screen height
    child: DraggableScrollableSheet(
      initialChildSize: 0.25, // Initial size of the bottom sheet
      minChildSize: 0.1, // Minimum size of the bottom sheet
      maxChildSize: 0.6, // Maximum size of the bottom sheet
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
 Column(
                children: [
                  TextField(
                    controller: pickupController,
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          pickupText = value;
                          pickupFocus = true;
                        });
                      }
                      LocationService()
                          .getLocationSuggestions(value)
                          .then((value) => {
                                if (mounted)
                                  {
                                    setState(() {
                                      locationSuggestions = value;
                                    })
                                  }
                              });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter pickup location',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: destinationController,
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          destinationText = value;
                          pickupFocus = false;
                        });
                      }
                      LocationService()
                          .getLocationSuggestions(value)
                          .then((value) => {
                                if (mounted)
                                  {
                                    setState(() {
                                      locationSuggestions = value;
                                    })
                                  }
                              });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter destinationCoordinates location',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Get the coordinates of the pickup and destinationCoordinates locations
                      pickupLocationCoordinates =
                          await _searchLocation(pickupText);
                      destinationCoordinates =
                          await _searchLocation(destinationText);
                      // Update the markers on the map
                      updateMarkers(
                          pickupLocationCoordinates, destinationCoordinates);

                      // Fetch the polyline points between the pickup and destinationCoordinates locations
                      fetchPolylinePoints(
                              pickupLocationCoordinates, destinationCoordinates)
                          .then((polylinePoints) {
                        // Generate the polyline from the points
                        generatePolyLineFromPoints(polylinePoints);

                        // initialise the map
                        initializeMap();

                        // Move the camera to the pickup location

                        // animateToLocation(pickupLocationCoordinates, 10);

                        animateToBounds(
                            pickupLocationCoordinates, destinationCoordinates);
                      });
                    },
                    child: const Text('Get Directions'),
                  ),
                  const SizedBox(height: 16),
                  if (locationSuggestions.isNotEmpty)
                    Column(
                      children: locationSuggestions
                          .map((location) => ListTile(
                                leading: const Icon(Icons.location_on),
                                title: Text(location),
                                onTap: () {
                                  // Auto-fill the search bar with the selected location and search for it
                                  if (mounted) {
                                    setState(() {
                                      if (pickupFocus) {
                                        pickupText = location;
                                        pickupController.text = location;
                                      } else {
                                        destinationText = location;
                                        destinationController.text = location;
                                      }
                                      locationSuggestions.clear();
                                    });
                                  }
                                },
                              ))
                          .toList(),
                    ),
                ],
              ),
            
              ],
            ),
          ),
        );
      },
    ),
  ),
),