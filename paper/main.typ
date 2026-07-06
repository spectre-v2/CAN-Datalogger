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
#include "03-can-drivers.typ"
#include "04-data-storage.typ"
#include "05-evaluation.typ"
#include "06-reflexion.typ"


// -------------------------Quellen-------------------------
#bibliography("sources.bib", style: "ieee")

// -------------------------Verzeichnisse-------------------------

#outline(
  title: [Tabellenverzeichnis],
  target: figure.where(kind: table),
)

#outline(
  title: [Abbildungsverzeichnis],
  target: figure.where(kind: image),
)
