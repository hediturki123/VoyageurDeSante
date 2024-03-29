# Voyageur de Santé - Projet XML / XSLT

## À propos

Ce projet a été réalisé par *Hedi TURKI SANEKLI* et *Alexis YVON* (groupe 3) dans le cadre du cours de **Langages pour le Web** en L3 MIAGE de l'Université Grenoble Alpes au cours des mois d'octobre et de novembre 2020.

## Transformations
Pour la transformation d'un patient : 

* Cette transformation est responsable en réalité de 2 transformations : `fichier xml -> fichier xml -> page html`. 
* Faire une première transformation du fichier `cabinet.xml` et un fichier `patient_xml.xsl` en un fichier `output.xml` par exemple, qui doit être placé dans le répertoire `results` (sous-répertoire de `xml`).
* Ensuite il faut faire une deuxième transformation du fichier `output.xml` en un fichier `html` qui doit être aussi placé dans le répertoire `results`.

Pour la transformation d'un infirmier :

* Il faut faire la transformation du fichier `cabinet.xml` et du fichier `infirmier.xsl` pour créé un fichier `cabinet.html` dans le répertoire `results`.

:warning: On met toujours les fichiers dans le répertoire `results` (sous-répertoire `html`) pour le CSS puisse s'appliquer dessus. Nous vous avons mis quelques fichiers déjà transformés à votre disposition, `patient_Alécole.xml` et `patient_Pien.xml` ainsi que `patient_Pien.html` et `infirmier_Fréchie.html`.


## Remarques

### Découpage du projet

Pour faciliter la navigation entre les différents fichiers du projet, nous avons divisé celui-ci en plusieurs dossiers, chacun correspondant à un aspect différent (HTML, CSS, XML, XSLT, etc).

Notez que le sous-dossier `results` dans le dossier `html` (resp. `xml`) est destiné à accueillir les résultats de transformations XSLT en fichier `html` (resp. `xml`).

### Non contrainte de actes.xml

Nous avons fait le choix de supprimer les références aux espaces de noms dans le fichier `actes.xml` car son schéma ne nous a pas été fourni et cela a permis d'éviter des erreurs lors de la transformation XSLT.

### Bootstrap

Pour faciliter la mise en forme de nos pages en ce qui concerne le cabinet, nous avons décidé d'utiliser le framework HTML/CSS/JS Bootstrap. Cela nous permet de garder une cohérence de mise en forme entre les pages pour les infirmiers et les patients.

En revanche, pour montrer nos acquis en HTML et CSS, nous avons bel et bien réalisé nos CV sans l'aide de Bootstrap.

## Sources

### Images

* Image de fond pour les pages des infirmiers et des patients (*background.jpg*) : [Freepik](https://fr.freepik.com/vecteurs-premium/modele-sans-couture-symbole-medical-foret-dentaire-seringue-pilule-fiole-adn_4370641.htm),
* Les photos des infirmiers et des patients représentent des personnes **fictives** générées aléatoirement par le site [ThisPersonDoesNotExist](https://thispersondoesnotexist.com/) par une IA basée sur des réseaux antagonistes génératifs ([GAN](https://en.wikipedia.org/wiki/Generative_adversarial_network)).

### Codes

* Templates de recopie de nœuds sans espace de noms : [StackOverflow](https://stackoverflow.com/a/20001084) *(lien fourni gracieusement par M. Nicolas GLADE sur Mattermost)*.
