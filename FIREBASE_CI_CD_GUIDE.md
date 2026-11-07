# 🚀 Guide de Configuration CI/CD : Firebase App Distribution & GitHub Actions

Ce guide vous accompagne pas à pas pour connecter votre dépôt GitHub au projet Firebase **`strongfit-a51cb`** et distribuer automatiquement vos builds de test aux athlètes.

---

## 📋 Prérequis
* **Projet Firebase** : [`strongfit-a51cb`](https://console.firebase.google.com/project/strongfit-a51cb/appdistribution)
* **Package Name Android** : `com.strong.app.strong`
* **Dépôt GitHub** : Votre dépôt où le code source est hébergé.

---

## Étape 1 : Enregistrer l'application Android dans Firebase Console

1. Rendez-vous sur votre [Console Firebase strongfit-a51cb](https://console.firebase.google.com/project/strongfit-a51cb/).
2. Cliquez sur l'icône **Android** pour ajouter une application (ou dans **Paramètres du projet** ⚙️ > **Général** > **Vos applications** > **Ajouter une application**).
3. Renseignez :
   * **Nom du package Android** : `com.strong.app.strong`
   * **Surnom de l'application** : `StrongFit`
4. Enregistrez l'application.
5. Copiez l'**ID d'application (App ID)** affiché.
   * *Format type* : `1:108234567890:android:abcdef0123456789abcdef`
   * 💡 Vous en aurez besoin pour la variable secrète `FIREBASE_APP_ID`.

---

## Étape 2 : Créer le groupe de testeurs dans Firebase App Distribution

1. Rendez-vous sur [Firebase App Distribution - strongfit-a51cb](https://console.firebase.google.com/project/strongfit-a51cb/appdistribution).
2. Ouvrez l'onglet **Testeurs et groupes** (*Testers & Groups*).
3. Cliquez sur **Ajouter un groupe** et nommez-le : `testers`.
4. Ajoutez vos adresses e-mail (ou celles de vos bêta-testeurs).

---

## Étape 3 : Générer la Clé de Compte de Service (Service Account JSON)

Pour permettre à GitHub Actions d'envoyer l'APK sur Firebase sans mot de passe manuel :

1. Dans la Console Firebase, cliquez sur **Paramètres du projet** (roue dentée ⚙️ en haut à gauche).
2. Allez dans l'onglet **Comptes de service** (*Service accounts*).
3. Cliquez sur **Générer une nouvelle clé privée** (*Generate new private key*).
4. Confirmez : un fichier `.json` est téléchargé sur votre ordinateur (ex: `strongfit-a51cb-firebase-adminsdk-xxx.json`).
5. Ouvrez ce fichier JSON avec un éditeur de texte et **copiez l'intégralité de son contenu**.

> [!TIP]
> **Vérification des droits Google Cloud** : Le compte de service généré dispose par défaut des accès Firebase. Si besoin, vérifiez dans la [Google Cloud IAM Console](https://console.cloud.google.com/iam-admin/iam?project=strongfit-a51cb) qu'il possède le rôle **Administrateur Firebase App Distribution** (*Firebase App Distribution Admin*).

---

## Étape 4 : Configurer les Secrets GitHub Actions

1. Rendez-vous sur votre dépôt **GitHub**.
2. Allez dans **Settings** > **Secrets and variables** > **Actions**.
3. Cliquez sur **New repository secret** et ajoutez ces deux secrets :

| Nom du Secret | Valeur à coller |
| :--- | :--- |
| `FIREBASE_APP_ID` | L'ID de l'application Android récupéré à l'étape 1 (ex: `1:108234567890:android:abcdef...`) |
| `FIREBASE_SERVICE_ACCOUNT` | Le contenu brut complet du fichier `.json` téléchargé à l'étape 3 |

*(Optionnel)* : Si vous souhaitez utiliser un nom de groupe différent de `testers`, vous pouvez ajouter la variable `FIREBASE_TESTERS_GROUP`.

---

## Étape 5 : Déclencher un Déploiement

### Déclenchement automatique :
À chaque `git push` sur la branche `main` ou lors de la création d'un tag de version (ex. `v1.0.0`), le workflow se lance automatiquement.

### Déclenchement manuel en 1 clic :
1. Sur GitHub, allez dans l'onglet **Actions**.
2. Cliquez sur le workflow **Deploy to Firebase App Distribution** dans la colonne de gauche.
3. Cliquez sur le bouton **Run workflow**.
4. Vous pouvez renseigner des notes de version personnalisées (ex: *« Version 1.0.1 : ajout du calculateur de barres et navigation fluide »*).
5. Cliquez sur **Run workflow** :
   - Les tests s'exécutent.
   - L'APK release Android est compilé.
   - L'APK est automatiquement distribué à votre groupe `testers` sur Firebase !
   - Vos testeurs reçoivent un e-mail avec le lien d'installation direct.

