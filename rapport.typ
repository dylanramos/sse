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

RAPTOR (Recursive Autonomous Penetration Testing and Observation Robot) est un framework de recherche en sécurité informatique offensive/défensive autonome construit sur Claude Code @raptor. Il coordonne les outils de sécurité traditionnels comme Semgrep, CodeQL, AFL++, GDB/rr, puis utilise des LLMs pour trier les résultats, valider l'exploitabilité, générer des PoC et proposer des correctifs, le tout accompagné de rapports structurés.

== Architecture

RAPTOR est composé de deux couches, la couche de décision Claude Code et la couche d'exécution.

- *La couche de décision Claude Code* "réfléchit" et prend des décisions. Quelles trouvailles privilégier? Comment interpréter les résultats? Quel est le scénario d'attaque? Est-ce que l'exploitation est plausible? Cette couche est implémentée sous forme de Claude Code Skills, de commandes et d'agents qui se chargent progressivement.

- *La couche d'exécution* se charge des tâches les plus lourdes comme l'exécution de Semgrep et CodeQL, la gestion des sous-processus, l'analyse des fichiers SARIF (standard pour les résultats d'une analyse statique de code), etc. Cette couche interagit avec le LLM via une API, elle ne prend pas de décisions, elle exécute.

Cette séparation permet d'utiliser RAPTOR sans Claude Code, en utilisant simplement la couche d'exécution (code Python) pour lancer les outils de sécurité traditionnels, obtenir des résultats structurés, etc.

À noter que la couche de décision n'est pas limitée aux modèles de la famille Claude, elle fonctionne avec n'importe quel LLM que ce soit par le biais d'une API ou d'une instance locale. D'autre part, il est possible d'utiliser plusieurs LLMs en parallèle, chacun s'occupant d'une tâche spécifique.

#figure(
  rect(image("./img/roles.png", width: 60%), stroke: 0.1pt),
  caption: [Rôles pouvant être assignés aux LLMs par RAPTOR.]
)

== Fonctionnalités

RAPTOR propose des commandes individuelles comme `/scan` pour lancer une analyse statique de code, `/exploit` pour générer un exploit à partir d'une vulnérabilité trouvée, etc. Mais il propose également des commandes puissantes comme `/agentic`, qui permet de lancer un workflow complet automatisé (scan, validation, exploitation et patch). La #underline[@features] ci-dessous présente les différentes fonctionnalités de RAPTOR, à noter qu'elles ne sont pas toutes stables, certaines sont encore en développement ou expérimentales comme `/web` par exemple.

#figure(
  rect(image("./img/features.png", width: 80%), stroke: 0.1pt),
  caption: [Fonctionnalités de RAPTOR.]
) <features>

#text(fill: red)[TODO : PIPELINE? STAGES?]

== Risques et bonnes pratiques

RAPTOR est un projet de recherche récent (premier commit en novembre 2025), il n'est pas encore prêt pour une utilisation en production, les auteurs eux-mêmes le disent : #emph["It is not polished software. It was built in free time, held together with enthusiasm and duct tape, and it works well enough that we can't stop using it. If you want to make it better, open a PR."]

Ainsi, il est important d'être informé des risques et des bonnes pratiques liés à son utilisation :
- *Exécution de code non fiable :* les outils d'analyse statique analysent du code potentiellement malveillant et exécutent parfois des outils de compilation, il faut donc veiller à utiliser RAPTOR dans un environnement isolé pour éviter tout risque de compromission.
- *Prompt injection :* les LLMs peuvent être trompés par des entrées malveillantes (commentaires dans le code, résultats d'un outil d'analyse, etc.), il est donc important de traiter tous les exploits générés par RAPTOR comme sensibles.
- *Fuite d'informations :* l'utilisation de RAPTOR sur du code propriétaire ou sensible peut entraîner une fuite d'informations si le code est envoyé à un LLM externe, il faut donc veiller à utiliser des LLMs locaux si le code est confidentiel.

= Expérimentations et résultats

RAPTOR n'est pas le seul projet à explorer l'automatisation offensive par LLMs, d'autres projets comme 

project glasswing

= Limites et implications

hallucinations
coût
context window : voir @architecture
étique (n'importe qui peut utiliser ces outils, plus besoin d'être un pro)

= Conclusion

Token is all you need @token-is-all-you-need

Mais cette révolution technologique n'est pas un solution miracle. Bien que puissants, les LLMs ont leurs limites et ne peuvent pas remplacer entièrement l'expertise humaine, hallucinations, biais et manque de contexte sont autant de défis à surmonter pour tirer pleinement parti de ces outils.

= Table des illustrations

#outline(target: figure, title: none)

= Bibliographie

#bibliography(title: none, "references.yml")