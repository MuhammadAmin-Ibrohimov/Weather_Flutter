part of 'more_weather_bloc.dart';

sealed class MoreWeatherState extends Equatable {
  const MoreWeatherState();

  @override
  List<Object> get props => [];
}

final class MoreWeatherInitial extends MoreWeatherState {}

final class MoreWeatherLoading extends MoreWeatherState {}

final class MoreweatherFailure extends MoreWeatherState {}

final class MoreWeatherSuccess extends MoreWeatherState {
  final List<Weather> weather;

  const MoreWeatherSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}
