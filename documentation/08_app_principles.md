# App Principles

### Design Guidelines

##### Material Components (lecture notes 6, page 3 - 7)

We use many different material widgets as the basis of our own customized components. Flutter's Material Widgets offer us the basis of our own customized components. The separation of a shared component set leverages consistent usage and design language. For example, we have developed our own App Bar, which looks similar on all screens and exposes an API for customization.

##### Apples Human Interface Guidelines (lecture notes 4, page 15 - 16)

Our design language is a mixture of Google's Material Design and Apple's Human Interface Guidelines in that e.g.  standard material UI widgets were restyled to match an iOS inspired color scheme.

### User Experience (UX)

##### UX Hierarchy of Needs (lecture notes 5, page 3)

We started designing our app with a with a focus on functionality and usability i.e. we were focused on the costumers needs in every step. In further iterations we used high fidelity prototypes to guarantee convenience and pleasure.

##### User Expectations (lecture notes 5, page 3, lecture notes 6, page 11)

Our design language uses a set of reusable widgets to guarantee consistency throughout the application. These widgets implement common conventions regarding functionality and look & feel. The users cognitive load is kept minimal due to our minimalistic convention based approach. 

##### User Centered Design (lecture notes 5, page 8)

We have developed our application according to the user-centered design. In a research phase we defined our target group, personas, user requirements for the app and the environment. In a user flow diagram we have recorded which actions a user needs when using our app, in order to be able to specify our layout. 

##### UI Navigation (lecture notes 5, page 9 - 42)

We use existing navigation concepts for our app, such as a hierarchical navigation. We use a nested doll navigation for our main functionality, whereby we have a tabbed view in the app's start screen.

### Android concepts

##### Confirm/Acknowledge Concept (lecture notes 2, page 24)

We applied the confirm/acknowledge concept using snackbars and alert dialogs.

##### Android inspired controls and layout (lecture notes 6, page 8 - 10)

We are currently using a scroll-based layout in our song overview. For dropdown menus in our modals we use the concepts of Androids Floating Context Menus. We use custom designed buttons to confirm actions that trigger changes. We use dialogs to warn the user about actions with consequences that cannot be undone. This is mainly used for delete actions (see song, recording delete). We use floating context menus to present the user with a pre-selection of fixed inputs. We use this layout in all dropdown menus.

### Mobile UI navigation

##### Modularized Navigation Graphs (lecture notes 6, page 12)

We have optimized our navigation so that e.g. a user doesn't have to switch back to the overview to edit a song in the details view but can rather access it directly via an edit icon.

##### Navigation Patterns (Lecture notes 6, page 14, 15, 16, 22, 24, 26, 29, 32, 33, 34, 35)

We use a list view to display several song projects on the homepage of our app. We use a tab bar at the bottom of our app as navigation between profile, projects and notifications. Search forms are used to search for participants. A user can invite other members via their email in  the song modal. In our song overview songs are sorted alphabetically by title. For recordings and messages this is done according to their creation date. These concepts are used by many apps and are therefore common to many people.
