part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isLoadedIcon;
  final bool isMapInitialized;
  final bool isfollowingUser;
  final bool isAccepted;

  const MapState({
    this.isMapInitialized= false,
    this.isfollowingUser = true,
    this.isLoadedIcon     = false,
    this.isAccepted = false, 
    });


  MapState copyWith({
    bool? isMapInitialized,
    bool? isfollowingUser,
    bool? isLoadedIcon,
    bool? isAccepted,

  })
   => MapState(
     isMapInitialized: isMapInitialized ?? this.isMapInitialized,
     isfollowingUser: isfollowingUser ?? this.isfollowingUser,
     isLoadedIcon: isLoadedIcon ?? this.isLoadedIcon,
     isAccepted: isAccepted?? this.isAccepted,
   );
  
  @override
  List<Object> get props => [isMapInitialized, isfollowingUser, isLoadedIcon,  isAccepted];
}


