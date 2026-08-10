In eingebetteten Datenverarbeitungssystemen ist ein exakt definiertes Verhalten die Basis für ein Sicheres, vorhersehbares und Echtzeitfähiges Verhalten. Aus diesem Grund muss ein Zustandsautomat alle möglichen zustände des Systems lückenlos abbilden. Es muss exakt definiert werden, unter welchen umständen das System seinen Zustand wechseln soll.

Um den gesamtzustand des Systems zentral und übersichtlich erfassen zu können, wurde eine Struct definiert, welche sowohl den Systemzustand selbst, als auch die äußeren umstände, wie externe Signale, darstellt.

#code-snippet("../statemachine.h", "statemachine-struct")