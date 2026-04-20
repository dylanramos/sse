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

#set outline.entry(fill: line(length: 100%, stroke: 0.1pt))
#outline(title: "Table des matières")

#pagebreak()

= Introduction

L'ascension fulgurante des LLMs ces dernières années est en train de redéfinir le paysage de la sécurité informatique. Ces modèles capables de comprendre et de générer du texte de manière cohérente, ont ouvert de nouvelles perspectives pour l'automatisation offensive, notamment grâce à l'IA agentique. Des frameworks comme #link("https://github.com/gadievron/raptor")[#underline("RAPTOR")] permettent désormais de générer des exploits et d'orchestrer des attaques de manière plus rapide et efficace que jamais auparavant.

= Fondements techniques

== LLM standard vs Agent LLM

Un LLM est un type de programme d'intelligence artificielle qui une fois entraîné, est capable de reconnaître et de générer du texte @llm. Il faut bien faire la distinction entre le LLM standard et l'Agent LLM, qui contrairement au standard, est capable d'interagir avec son environnement, de prendre des décisions et d'exécuter des actions en fonction des résultats obtenus. Ainsi, les Agents LLMs sont particulièrement adaptés pour des tâches complexes comme la découverte de vulnérabilités et l'exploitation.

== Architecture d'un Agent LLM

Un agent LLM est composé de quatre éléments clés @architecture:

*1. Le système de perception :* qui est chargé de collecter et de traiter les données provenant de l'environnement, telles que du texte, des images ou toute autre forme d'information. \
*2. Le système de raisonnement :* qui reçoit les instructions relatives à la tâche ainsi que les données provenant du système de perception, puis élabore un plan décomposé en étapes distinctes. \
*3. Le système de mémoire :* qui conserve les connaissances qui ne sont pas intégrées dans les poids du modèle. \
*4. Le système d'action :* qui exécute les actions planifiées par le système de raisonnement, en utilisant les outils disponibles dans la boîte à outils de l'agent (appels API, mouvements de souris, etc.).

#figure(
  rect(image("./img/architecture.png", width: 70%), stroke: 0.1pt),
  caption: [Architecture d'un Agent LLM.]
)

== Boucle de rétroaction ReAct

La découverte de vulnérabilités et l'exploitation de celles-ci sont des tâches complexes qui nécessitent une compréhension approfondie du contexte et une capacité à s'adapter aux résultats obtenus. C'est là que la boucle de rétroaction ReAct (Reason + Act) entre en jeu. L'Agent ne se contente pas de prédire du texte, il suit un cycle @react :

*1. Thought :* le LLM analyse l'état du système (ex: "Le port 80 est ouvert, je vois un en-tête Apache 2.4.41"). \
*2. Action :* il choisit un outil dans sa boîte à outils (ex: `searchsploit apache 2.4.41`). \
*3. Observation :* il lit le résultat de la commande et ajuste sa stratégie. \

#figure(
  rect(image("./img/react.png", width: 70%), stroke: 0.1pt),
  caption: [Boucle de rétroaction Reason + Act.]
)

= Analyse de RAPTOR

RAPTOR (Recursive Autonomous Penetration Testing and Observation Robot) est un framework de test de sécurité autonome qui combine l'analyse statique, la validation du flux de données et le fuzzing binaire avec une analyse des vulnérabilités alimentée par des LLMs @raptor. Son objectif est d'identifier, valider et exploiter de manière autonome les failles de sécurité avec une intervention humaine minimale.

== Concept

Les outils de sécurité traditionnels génèrent des milliers de résultats, mais ne fournissent ni contexte ni évaluation de l'exploitabilité. RAPTOR résout ce problème en : 
+ Identifiant les vulnérabilités.
+ Validant l'exploitabilité.
+ Comprenant les chemins d'attaque.
+ Automatisant l'exploitation.
+ Fournissant un raisonnement détaillé.

La puissance de RAPTOR réside dans sa capacité à résonner grâce à des LLMs pour déterminer si une vulnérabilité est vraiment exploitable en analysant :
- Si la source est contrôlée par l'attaquant.
- Si les mécanismes de validation peuvent être contournés.
- Si le chemin d'exécution est accessible.
- Si la complexité de l'attaque est réalisable.

== Modes d'opération

- *Analyse du code source :* analyse statique à l'aide de Semgrep et CodeQL avec validation approfondie du flux de données. Ce mode permet d'identifier des bugs de logique, vulnérabilités d'injection (SQL, XSS, etc.), mauvaises utilisations cryptographiques, etc.
- *Fuzzing binaire :* fuzzing guidé en utilisant AFL++ avec des analyses de crash GDB. Ce mode permet d'identifier des vulnérabilités de mémoire (buffer overflow, use-after-free, integer overflow, etc.).
- *Analyse de crash :* analyse autonome des causes profondes à l'aide du traçage des fonctions et de la couverture de code. Ce mode permet de comprendre d'où viennent les bugs et d'identifier les chemins d'exploitation.

= Expérimentations et résultats

project glasswing

= Limites et implications

context window : voir @architecture

= Conclusion

Mais cette révolution technologique n'est pas un solution miracle. Bien que puissants, les LLMs ont leurs limites et ne peuvent pas remplacer entièrement l'expertise humaine, hallucinations, biais et manque de contexte sont autant de défis à surmonter pour tirer pleinement parti de ces outils.

= Table des illustrations

#outline(target: figure, title: none)

= Bibliographie

#bibliography(title: none, "references.yml")