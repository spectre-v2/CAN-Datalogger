#import "header.typ": *
#show: thesis

// -------------------------Titelseite-------------------------

#v(2cm)
#align(center)[
  #text(7.1mm, weight: "medium")[#labtitle]
  #v(0.5cm)
  #text(4.9mm)[#experiment]
]
#v(2cm)


#table(
  columns: (1.3fr, 2.7fr),
  inset: (y: 3.5mm, x: 1.4mm),
  stroke: (x: none, y: 0.1mm),
  align: (left, left),

  [#text(weight: "medium")[Name]],            [#author],
  [#text(weight: "medium")[Matrikelnummer]],  [#student-id],
  [#text(weight: "medium")[Datum]],           [#submission-date],
  [#text(weight: "medium")[Betreuer]],        [#supervisor],
)
#pagebreak()

// -------------------------Inhaltsverzeichnis-------------------------
 
#outline()
#pagebreak()

// -------------------------Inhalt-------------------------

#include "01-intro.typ"
#include "02-system-arcitecture.typ"
#include "03-state-machine.typ"
#include "04-can-drivers.typ"
#include "05-data-storage.typ"
#include "06-evaluation.typ"
#include "07-reflexion.typ"


// -------------------------Quellen-------------------------

#pagebreak()
= Literaturverzeichnis
#bibliography("sources.bib", title: none, style: "ieee")

// -------------------------Verzeichnisse-------------------------

#pagebreak()
= Tabellenverzeichnis
#outline(
  title: none,
  target: figure.where(kind: table),
)

#pagebreak()
= Abbildungsverzeichnis
#outline(
  title: none,
  target: figure.where(kind: image),
)
