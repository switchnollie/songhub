# Lessons Learned

Flutter and Firebase are highly trending technologies with lots of modern app development paradigms. Both of us learned data modeling using entities and relationships so the biggest challenge was to get into NoSQL concepts such as denormalization and document based data modeling. The results were impressive, we could encounter a drastically improved performance and seamlessly working realtime updates.

Working with realtime data streams was a second key takeaway and a relatively new concept to both of us. Dart was the first language we used that comes with built in support for data streams. Even though this enabled the most of use cases we still had to dive deeper and use extensions from `rxdart` for functional programming and stream composition with methods like `switchMap` or `Rx.combineLatest2`.

Another learning factor was the runtime type checking features of Dart which helped a lot in finding bugs.

All in all the biggest takeaway was the architectural patterns for state management and widget composition that apply to both Flutter and other reactive frameworks like React.js / React Native: We did several refactorings to further minimalize mutable state in our application and keep the widgets clean and separated. 

The two biggest challenges in this process were the following: Firstly to find the right APIs for shared widgets that were both applicable to all possible variants and concise and secondly to find the right place to locate mutable state. 

With the concepts "lift state up", view models and InheritedWidgets (enabled by the provider package), we could finally get an approach that was scalable, reusable, clear and maintainable.

