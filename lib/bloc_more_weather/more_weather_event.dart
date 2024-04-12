part of 'more_weather_bloc.dart';

sealed class MoreWeatherEvent extends Equatable {
  const MoreWeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchMoreWeather extends MoreWeatherEvent {
  final Position position;
  const FetchMoreWeather(this.position);

  @override
  List<Object> get props => [position];
}
