# VehicleCompanion
VehicleCompanion sample

- Running XCode 16, iOS 17.6+

- Architecure used - MVVM

- Currently the SwiftData models are: Vehicle and SavedPlace. There is no relationship between them.
Upon adding support for maintenance items - MaintenanceItem model would be needed. The relationship between the Vehicle and MaintenanceItem would be one to many, so that it is possible that several maintenance items be associated with a vehicle. The delete rule would be .cascade, e.g. when a vehicle is deleted - all maintenance items related it are deleted too. (Assuming there is no business need for the items to exist by themselves)

- Empty state is supported in the Garage screen (GarageView.swift, GarageViewModel.swift). Empty state and Error state is supported in Places screen (PlacesView.swift, PlacesViewModel.swift)

- Next steps might be:
    - Adding UI tests.
    - Adding support for maintenance items.
    - Storing the last searched location which would be used in the next app launch (upon user approval).
    - Requesting location permission from the user and upon request showing interesting places around them.
    - Adding UI component which would allow adjusting the distance from the central point at which to search for POIs
    - Allowing the user to specify start and end position, show the path and POIs along the way. Adjustable distance/radius from the path might be made configurable.
    - Filtering the POIs by using categories, specified by the user.
     
