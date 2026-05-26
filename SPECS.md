# Fonctionnalités

## Session

[x] Liste des sessions
[x] CRUD sessions
[x] pagination (onScroll)

## Check point

[x] Liste check_point par session
[x] Crud check_point
[x] On click check_point allez sur la page effectuer le pointage

## Page pour faire le pointage

[x] Statistique pointage(nbr à servir, nbr servi, reste à servir)
[x] Onglet liste des personnes à servir
[x] Onglet liste des personnes servi
[] Recherche personne à servir, servi, n'appartenant pas à la session
[x] Pointage d'une nouvelle personne au checkpoint:

- [x] Ajout automatique de cette personne à la session
- [x] Ajout automatique de cette personne au pointage
- [x] Pointée cette personne

[x] Supprimer le pointage d'une personne
[x] Ajouter une personne existante dans la session au pointage en cours

### Recherche

[x] Dans le résultat des recherches de personne il faut y mettre les boutons:

- [x] Affectation au pointage (si pas encore pointé)
- [x] Si recherche dans la tab "A servir" d'une personne déja pointé il faut juste affiche que la personne est déja pointé

### Gestion des personnes

Cette partie se fera directement dans la page pour faire le pointage.

[] Ajouter une liste d'action sur chaque personne afin d'avoir les trois menus suivantes:

- [] Lien pour supprimer une personne:
  - Supprimer la personne de la checkpoint en cours
  - S'il appartient déjà à une session existante il faut juste le supprimer de la session en cours SINON le supprimer définitivement de la table person

- [x] Lien pour modifier les informations d'une personne

## Stocker/synchro les données sur firebase

- [] Exporter la base de données sur firebase
- [] Importer les données à partir de firebase
