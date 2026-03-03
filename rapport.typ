#let title = "SSE - Automatisation offensive par LLMs"
#let subtitle = "Génération d'exploits et orchestration d'attaques"
#let author = "Dylan Oliveira Ramos"
#let date = datetime.today().display("[day]-[month]-[year]")
#let logo = "./img/00-logo.png"

#set text(font: "New Computer Modern", lang: "fr")
#set heading(numbering: "1.")
#set par(justify: true)

#place(
  top + right,
  image(logo, width: 25%),
)

#place(
  horizon + center,
  align(center)[
    #line(length: 100%, stroke: 0.1pt)
    #v(0.4em)
    #text(2em, weight: 700, title)
    #v(0.4em)
    #line(length: 100%, stroke: 0.1pt)
    #v(1em)
    #text(1.2em, subtitle)
  ],
)

#place(
  bottom + left,
  align(left)[
    #text(1.2em, strong(author))
    #v(0.2em)
    #text(1.2em, date)
  ],
)

#set page(
  numbering: "1 / 1",
  header: [
    #author
    #h(1fr)
    #title
    #line(length: 100%, stroke: 0.1pt)
  ],
  footer: context [
    #line(length: 100%, stroke: 0.1pt)
    #align(center)[
      #counter(page).display() / #counter(page).final().at(0)
    ]
  ],
)

#pagebreak()

= Introduction

L'ascension fulgurante des LLMs ces dernières années est en train de redéfinir le paysage de la sécurité informatique. Ces modèles capables de comprendre et de générer du texte de manière cohérente, ont ouvert de nouvelles perspectives pour l'automatisation offensive. Des frameworks comme RAPTOR permettent désormais de générer des exploits et d'orchestrer des attaques de manière plus rapide et efficace que jamais auparavant.

= Architecture d'un agent offensif

= Découverte de vulnérabilités

= Génération d'exploits

= Orchestration d'attaques

= Limitations

= Conclusion

Mais cette révolution technologique n'est pas un solution miracle. Bien que puissants, les LLMs ont leurs limites et ne peuvent pas remplacer entièrement l'expertise humaine, hallucinations, biais et manque de contexte sont autant de défis à surmonter pour tirer pleinement parti de ces outils.

= Bibliographie