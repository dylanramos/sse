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

#outline(target: figure, title: "Table des illustrations")

#pagebreak()

= Introduction

La sécurité informatique offensive a longtemps reposé sur l'expertise de spécialistes humains : comprendre une base de code, identifier des patterns vulnérables, construire un exploit valide sont des tâches qui demandent des années de pratique. Les Large Language Models (LLMs) sont en train de changer cette réalité. Capables de raisonner sur du code, de planifier des actions et d'interagir avec des outils, ces modèles ouvrent la voie à une nouvelle génération d'agents autonomes dédiés à la recherche et à l'exploitation de vulnérabilités. Des frameworks comme #link("https://github.com/gadievron/raptor")[#underline("RAPTOR")] illustrent concrètement cette évolution, en orchestrant des pipelines d'attaque complets, de l'analyse statique à la génération d'exploit, sans intervention humaine.

#pagebreak()

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
  caption: [Architecture d'un Agent LLM.],
)

== Boucle de rétroaction ReAct

La découverte de vulnérabilités et l'exploitation de celles-ci sont des tâches complexes qui nécessitent une compréhension approfondie du contexte et une capacité à s'adapter aux résultats obtenus. C'est là que la boucle de rétroaction ReAct (Reason + Act) entre en jeu. L'Agent ne se contente pas de prédire du texte, il suit un cycle @react :

*1. Think :* le LLM analyse l'état du système (ex: "Le port 80 est ouvert, je vois un en-tête Apache 2.4.41"). \
*2. Action :* il choisit un outil dans sa boîte à outils (ex: `searchsploit apache 2.4.41`). \
*3. Observation :* il lit le résultat de la commande et ajuste sa stratégie. \

#figure(
  rect(image("./img/react.png", width: 70%), stroke: 0.1pt),
  caption: [Boucle de rétroaction Reason + Act.],
)

#pagebreak()

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
  caption: [Rôles pouvant être assignés aux LLMs par RAPTOR.],
)

== Fonctionnalités

RAPTOR propose des commandes individuelles comme `/scan` pour lancer une analyse statique de code, `/exploit` pour générer un exploit à partir d'une vulnérabilité trouvée, etc. Mais il propose également des commandes puissantes comme `/agentic`, qui permet de lancer un workflow complet automatisé (scan, validation, exploitation et patch). La #underline[@features] ci-dessous présente les différentes fonctionnalités de RAPTOR, à noter qu'elles ne sont pas toutes stables, certaines sont encore en développement ou expérimentales comme `/web` par exemple.

#figure(
  rect(image("./img/features.png", width: 80%), stroke: 0.1pt),
  caption: [Fonctionnalités de RAPTOR.],
) <features>

== Utilisation

L'utilisation typique de RAPTOR est la suivante :

*1. Création du projet :* les commandes `/project create myapp --target /path/to/code` et `/project use myapp` permettent d'organiser les fichiers de sortie générés et d'avoir un espace de travail stable où chaque exécution enregistre ses résultats et offre la possibilité de relancer les analyses en les comparant au fil du temps. \
*2. Compréhension de la base de code :* la commande `/understand --map` permet d'obtenir une cartographie de la base de code, notamment les points d'entrée (endpoints API, arguments de CLI, etc.) et les limites de confiance (construction d'une requête SQL à partir d'une entrée utilisateur, parsing d'un fichier, etc.). \
*3. Lancement du workflow automatisé :* la commande `/agentic` exécute `Semgrep` et `CodeQL` pour trouver des patterns vulnérables, regroupe les mêmes trouvailles provenant des différents outils pour éviter les doublons, soumet chaque trouvaille aux étapes de validation A-D (voir chapitre suivant), puis génère des PoCs et des correctifs pour les trouvailles validées. \

== Étapes de validation

Les trouvailles passent par quatre étapes de validation avant d'être considérées comme exploitables :

*Étape A :* le pattern est-il vraiment vulnérable ou s'agit-il d'un faux positif? \
*Étape B :* de quoi un attaquant a-t-il besoin pour y accéder et quels sont les obstacles? \
*Étape C :* le chemin d'exécution existe-t-il réellement? Peut-on y accéder depuis l'extérieur? \
*Étape D :* s'agit-il d'un code de test ? Nécessite-t-il des conditions préalables irréalistes ? Le modèle est-il trop prudent ?

Ainsi, les résultats ayant passé ces quatre étapes donnent lieu à des PoCs et des correctifs.

== Limites et implications

RAPTOR est un projet de recherche récent (premier commit en novembre 2025), il n'est pas encore prêt pour une utilisation en production, les auteurs eux-mêmes le disent : #emph["It is not polished software. It was built in free time, held together with enthusiasm and duct tape, and it works well enough that we can't stop using it. If you want to make it better, open a PR."]

Ainsi, il est important d'être informé des risques et des bonnes pratiques liés à son utilisation :
- *Exécution de code non fiable :* les outils d'analyse statique analysent du code potentiellement malveillant et exécutent parfois des outils de compilation, il faut donc veiller à utiliser RAPTOR dans un environnement isolé pour éviter tout risque de compromission.
- *Prompt injection :* les LLMs peuvent être trompés par des entrées malveillantes (commentaires dans le code, résultats d'un outil d'analyse, etc.), il est donc important de traiter tous les exploits générés par RAPTOR comme sensibles.
- *Hallucinations :* les LLMs peuvent mal interpréter le code ou classer à tort des fichiers inoffensifs, ainsi, une intervention humaine reste indispensable pour valider les résultats obtenus par RAPTOR.
- *Fuite d'informations :* l'utilisation de RAPTOR sur du code propriétaire ou sensible peut entraîner une fuite d'informations si le code est envoyé à un LLM externe, il faut donc veiller à utiliser des LLMs locaux si le code est confidentiel.

#pagebreak()

= Industrialisation de la recherche de vulnérabilités

Il existe d'autres projets que RAPTOR, comme #link("https://github.com/GreyDGL/PentestGPT")[#underline[PentestGPT]], #link("https://github.com/vxcontrol/pentagi")[#underline[PentAGI]] ou encore #link("https://github.com/Vasco0x4/AIDA")[#underline[AIDA]], mais ce ne sont pas ces outils qui sont en train de révolutionner cette industrie, ce sont les LLMs, et les géants de l'IA l'ont bien compris.

== Google

En novembre 2024, une équipe de Google a annoncé la découverte d'une vulnérabilité de type Stack Buffer Underflow dans le logiciel SQLite par son agent IA appelé Big Sleep @big-sleep. Cet événement marque la première fois qu'une vulnérabilité a été découverte par une IA dans un projet réel. En juillet 2025, grâce à des informations fournies par Google Threat Intelligence, l'agent Big Sleep a découvert une autre vulnérabilité dans SQLite uniquement connue par les acteurs malveillants @big-sleep-2. Cela a permis à Google d'empêcher une exploitation de la vulnérabilité avant que celle-ci ne soit exploitée dans la nature, cela marque la première fois qu'un agent IA a permis de prévenir une attaque dans la nature.

== OpenAI

En mars 2026, OpenAI a déployé Codex Security, un agent de sécurité qui a analysé plus de 1,2 million de commits sur des dépôts externes, identifiant 792 vulnérabilités critiques et 10'561 de haute sévérité @codex-security. Parmi les CVEs découvertes figurent notamment plusieurs failles dans des projets Open Source populaires comme OpenSSH, GnuTLS, PHP et Chromium.

== Anthropic

En avril 2026, Anthropic a annoncé la sortie de son nouveau modèle Claude Mythos, un modèle qui affiche d'excellentes performances dans tous les domaines, mais #emph["qui se distingue particulièrement dans les tâches liées à la sécurité informatique"] @claude-mythos. Ce modèle a permis à l'aide d'un seul prompt et sans intervention humaine d'identifier des milliers de vulnérabilités dont deux particulièrement intéressantes :
- Une vulnérabilité datant de 27 ans dans OpenBSD permettant à un attaquant de faire planter tout système répondant par TCP.
- Une vulnérabilité datant de 16 ans dans FFmpeg permettant un Out-of-Bounds Write et ainsi de faire planter le programme.

#pagebreak()

= Conclusion

L'utilisation de LLMs pour l'automatisation offensive devient inévitable. Les avantages de ces modèles par rapport à un expert humain sont nombreux : disponibilité permanente, capacité à traiter de grands volumes de code en parallèle, absence de fatigue cognitive et surtout une vitesse d'exécution incomparable. Là où un auditeur humain peut mettre plusieurs semaines à analyser une base de code complexe, un agent LLM peut produire un premier rapport en quelques heures, couvrant des milliers de fichiers avec un niveau de détail difficile à atteindre manuellement.

Cependant, ces modèles ne sont pas sans limites. La fenêtre de contexte constitue aujourd'hui l'un des freins majeurs : un agent ne peut raisonner que sur une portion limitée de code à la fois, ce qui complique l'analyse de projets de grande envergure où les vulnérabilités résultent souvent d'interactions entre plusieurs composants. Par ailleurs, la complexité d'apprentissage de ces systèmes est élevée : les hallucinations, les faux positifs et les mauvaises interprétations restent fréquents, rendant une supervision humaine indispensable pour valider les résultats.

L'industrialisation de la recherche de vulnérabilités par les LLMs soulève également des questions éthiques. D'un côté, l'accessibilité croissante de ces outils représente un risque sérieux pour la sécurité globale : n'importe quel individu, sans compétences techniques particulières, peut désormais déléguer à un agent la découverte et l'exploitation de failles, la barrière d'entrée à la cybercriminalité n'a jamais été aussi basse.

De l'autre côté, la recherche offensive se concentre entre les mains de ceux qui ont les moyens de la financer. L'utilisation intensive de LLMs de pointe représente un coût non négligeable, accessible aux grandes entreprises et aux États mais hors de portée pour la plupart des chercheurs indépendants. Des projets comme Glasswing @glasswing, orientés vers les grandes entreprises technologiques, illustrent cette tendance : la découverte de vulnérabilités à grande échelle devient un avantage concurrentiel réservé aux acteurs disposant d'infrastructures et de budgets conséquents, creusant davantage l'écart entre les capacités offensives des grands groupes et celles des acteurs plus modestes.

Au fond, ce que ces évolutions révèlent est simple : dans un futur proche, trouver une vulnérabilité ne nécessitera plus d'être un expert en sécurité. Il suffira d'avoir de l'argent. _Token is all you need._

#pagebreak()

= Bibliographie

#bibliography(title: none, "references.yml")
