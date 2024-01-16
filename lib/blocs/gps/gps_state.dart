part of 'gps_bloc.dart';


class GpsState extends Equatable{
  
  final GpsModel? gpsModel;
 

  const GpsState({   
    this.gpsModel
  });

  GpsState copyWith({   
    GpsModel? gpsModel
  }) => GpsState(    
    gpsModel: gpsModel?? this.gpsModel
  );

  @override
  List<Object?> get props => [ gpsModel ];
}

