import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_weather/data/my_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

part 'more_weather_event.dart';
part 'more_weather_state.dart';

class MoreWeatherBloc extends Bloc<MoreWeatherEvent, MoreWeatherState> {
  MoreWeatherBloc() : super(MoreWeatherInitial()) {
    on<FetchMoreWeather>((event, emit) async {
      emit(MoreWeatherLoading());
      try {
        WeatherFactory weatherFactory =
            WeatherFactory(API_KEY, language: Language.ENGLISH);
        List<Weather> weather = await weatherFactory.fiveDayForecastByLocation(
            event.position.latitude, event.position.longitude);
        print(weather);
        emit(MoreWeatherSuccess(weather));
      } catch (e) {
        emit(MoreweatherFailure());
      }
    });
  }
}
