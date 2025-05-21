# 🚀 ReactiveRealmKit

![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Platform](https://img.shields.io/badge/platform-iOS%2013+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

> Модульный реактивный data-layer фреймворк на базе Realm + RxSwift  
> Автоматическое кэширование, загрузка с сервера и наблюдение за изменениями — всё в одном пакете.

---

## 🧩 Возможности

- 🔁 Реактивные observable потоки с `RxSwift`
- 💾 Инкапсулированная работа с `Realm`
- 🌐 Универсальный `NetworkService` на `Observable<T>`
- ✅ Кэш + API + автонаблюдение = единый слой доступа к данным
- 🧱 Структурирован под `.framework` или SPM

---

## 📦 Установка через Swift Package Manager

1. В Xcode:  
   `File > Swift Packages > Add Package Dependency`

2. Вставь URL:

```bash
    https://github.com/Pixel-ux-source/ReactiveRealmKit.git

3. Выбери `main` или нужный tag (`from: "1.0.0"`)

---

## 🧪 Пример использования

```swift
let dataService = UserDataService(
    network: NetworkService(),
    strorage: RealmService(),
    apiKey: "https://api.example.com/users"
)

dataService.loadDataUser()
    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    .observe(on: MainScheduler.instance)
    .subscribe(onNext: { users in
        print("Пользователи: \(users.count)")
    })
    .disposed(by: disposeBag)
