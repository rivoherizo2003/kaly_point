# kaly_point

Checking people who had already took their meal

## Database

Create an sqllite database in the folder data and name it kaly_point.db

## Android path

/usr/local/android-studio/bin

## rebuild icon and splash 

```bash
dart run flutter_launcher_icons && dart run flutter_native_splash:create
```

## reflexion

Feature recherche:

- Liste toute les personnes appartenant ou non à la session/checkpoint encours
- Dans la liste différencier les personnes:
    1- appartenant à la session
    2- appartenant à la session et déja check dans le checkpoint encours
    3- N'appartenant pas à la session
- il doit être possible d'ajouter une personne qui n'est pas dans la session

Gérer les personnes:

- Modifier les infos d'une personne
- Supprimer une personne en doublon
