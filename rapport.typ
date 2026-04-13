#let title = "Automatisation offensive par LLMs"
#let subtitle = "SSE"
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

= Fondements techniques

== LLM standard vs Agent LLM

Un LLM (Large Language Model) est un type de programme d'intelligence artificielle (IA) qui une fois entraîné, est capable de reconnaître et de générer du texte @llm. Il faut bien faire la distinction entre le LLM standard et l'Agent LLM, qui contrairement au standard, est capable d'interagir avec son environnement, de prendre des décisions et d'exécuter des actions en fonction des résultats obtenus. Ainsi, les Agents LLMs sont particulièrement adaptés pour des tâches complexes comme la découverte de vulnérabilités et l'exploitation.

== Boucle de rétroaction ReAct

La découverte de vulnérabilités et l'exploitation de celles-ci sont des tâches complexes qui nécessitent une compréhension approfondie du contexte et une capacité à s'adapter aux résultats obtenus. C'est là que la boucle de rétroaction ReAct (Reason + Act) entre en jeu. L'Agent ne se contente pas de prédire du texte, il suit un cycle @react :

*1. Thought :* le LLM analyse l'état du système (ex: "Le port 80 est ouvert, je vois un en-tête Apache 2.4.41"). \
*2. Action :* il choisit un outil dans sa boîte à outils (ex: `searchsploit apache 2.4.41`). \
*3. Observation :* il lit le résultat de la commande et ajuste sa stratégie. \

#figure(
  rect(image("./img/react.png", width: 70%), stroke: 0.1pt),
  caption: [Boucle de rétroaction Reason + Act]
)

= Analyse de RAPTOR

= Expérimentations et résultats

= Limites et implications

= Conclusion

Mais cette révolution technologique n'est pas un solution miracle. Bien que puissants, les LLMs ont leurs limites et ne peuvent pas remplacer entièrement l'expertise humaine, hallucinations, biais et manque de contexte sont autant de défis à surmonter pour tirer pleinement parti de ces outils.

= Bibliographie

#bibliography("references.yml")