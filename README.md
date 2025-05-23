Мой первый пет проект. 

🌦️ WeatherApp

WeatherApp — это iOS-приложение, которое показывает текущую погоду и прогноз на неделю, используя чистую архитектуру и современные подходы к разработке.

Приложение разработано с акцентом на:
	•	чистоту и поддерживаемость кода,
	•	отзывчивый и визуально привлекательный интерфейс,
	•	хранение истории просмотров,
	•	оффлайн-доступ к кэшу и избранным.

⸻

📱 Функциональность
	•	📍 Автоопределение местоположения с возможностью ручного выбора города
	•	🌤️ Текущая погода с отображением иконки и погодных параметров
	•	📊 7-дневный прогноз с визуальным представлением
	•	🕓 История просмотров с разделением на “Today” и “All Time”
	•	⭐ Добавление городов в избранное
	•	🌈 Динамический фон (градиент по типу погоды)
	•	🌙 Поддержка тёмной и светлой темы
	•	⚙️ Обработка ошибок и оффлайн-фолбэк через Reachability
	•	🔧 Кэширование изображений с использованием собственного ImageCacheManager

⸻

🧱 Архитектура и технологии
	•	UIKit + SnapKit — для построения UI
	•	Alamofire — для запросов к API OpenWeatherMap
	•	CLLocationManager — для получения текущей геопозиции
	•	NSCache, UserDefaults — для локального кэширования данных
	•	SwiftLint — для контроля качества кода
	•	MVC + Менеджеры — структурная чистота и простота поддержки

⸻

🔌 API

Приложение использует OpenWeatherMap API.
Чтобы запустить проект, вам потребуется зарегистрировать API-ключ на openweathermap.org и прописать его в Constants.swift.

⸻

📌 Требования
	•	iOS 15.0+
	•	Xcode 15+

⸻
 
 📷 Скриншоты

![Simulator Screenshot - iPhone 16 - 2025-05-07 at 18 02 06](https://github.com/user-attachments/assets/287ca4d4-a53b-48df-b68e-1c3c3f3bb31a)
![Simulator Screenshot - iPhone 16 - 2025-05-07 at 18 02 09](https://github.com/user-attachments/assets/5efe5440-61dc-4d63-8121-165b729e59d6)
![Simulator Screenshot - iPhone 16 - 2025-05-07 at 19 37 02](https://github.com/user-attachments/assets/6fe947e0-5d36-4d3a-aa77-23d3ef6f9250)
![Simulator Screenshot - iPhone 16 - 2025-05-15 at 13 09 42](https://github.com/user-attachments/assets/4c1984a8-f678-48f9-8ce5-66eff4cd385e)

⸻

📄 Лицензия

Проект открыт в обучающих целях. Все API и изображения принадлежат их владельцам.

This is my first Pet-project

🌦️ WeatherApp

WeatherApp is a  iOS application that displays the current weather and 7-day forecast using clean architecture and up-to-date development practices.

The app focuses on:
	•	code clarity and maintainability,
	•	a responsive and visually appealing interface,
	•	browsing history,
	•	offline access through caching and favorites.

⸻

📱 Features
	•	📍 Automatic location detection with manual city input option
	•	🌤️ Current weather with icon and key weather parameters
	•	📊 7-day forecast with visual layout
	•	🕓 Viewing history, split into “Today” and “All Time”
	•	⭐ Add cities to favorites
	•	🌈 Dynamic background (gradient based on weather conditions)
	•	🌙 Light and dark theme support
	•	⚙️ Error handling and offline fallback using Reachability
	•	🔧 Image caching with a custom ImageCacheManager

⸻

🧱 Architecture & Technologies
	•	UIKit + SnapKit — for layout and interface building
	•	Alamofire — for working with OpenWeatherMap API
	•	CLLocationManager — for location-based weather
	•	NSCache, UserDefaults — for caching and local storage
	•	SwiftLint — for style and code quality enforcement
	•	MVC + service managers — clean and testable architecture

⸻

🔌 API

The app uses the OpenWeatherMap API.
To run the project, register your API key at openweathermap.org and set it in Constants.swift.

⸻

📌 Requirements
	•	iOS 15.0+
	•	Xcode 15+

⸻

📄 License

This project is open for educational purposes. All weather data and icons belong to their respective providers.
