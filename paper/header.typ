// -------------------------Dokumentvariablen-------------------------

#let labtitle = "Studienarbeit"
#let experiment = "Entwicklung eines CAN-FD Datenloggers"
#let author = "Leif Stechmann"
#let student-id = "940786"
#let submission-date = datetime.today().display("[day].[month].[year]")
#let supervisor = "Achim Boll"

// -------------------------Dokumenteinstellungen-------------------------

#let thesis(body) = {
  set page(
    paper: "a4",
    margin: (x: 2cm, y: 2cm),

    header: [
      #align(left)[
        #move(dy: 1.3cm)[
          #image("pictures/ry_logo.png", height: 0.5cm)
        ]
      ]
      #align(right)[
        #move(dy: 0.2cm)[
          #image("pictures/logo.png", height: 0.5cm)
        ]
      ]

      #align(center)[
        #box(width: 100%)[
          #line(length: 100%, stroke: 0.1mm)
        ]
      ]
    ],

    footer: context [
      #align(center)[
        #box(width: 100%)[
          #line(length: 100%, stroke: 0.1mm)
          #set text(size: 4.2mm)
          #counter(page).display()
        ]
      ]
    ],
  )

  set text(
    font: "IBM Plex Serif",
    size: 4.2mm,
    lang: "de",
  )

  set par(
    justify: true,
    leading: 0.65em,
  )

  set heading(numbering: "1.")

  // -------------------------Überschriften-------------------------

  show heading: set text(weight: "medium")
  show heading.where(level: 1): set block(above: 3em, below: 1em)
  show heading.where(level: 2): set block(above: 2em, below: 1em)
  show heading.where(level: 3): set block(above: 2em, below: 1em)

  // -------------------------Mathematik-------------------------

  show math.equation: set text(
    font: "IBM Plex Math",
    size: 1.1em,
  )

  show math.equation: set block(
    above: 1em,
    below: 1em,
  )

  body
}
  // -------------------------Globale Variablen-------------------------

#let GREY= rgb("#f1f1f1")

