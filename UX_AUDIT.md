# AUDIT UX / UI & ERGONOMIE MOBILE — STRONG TRACK

## Contexte d'usage réel en salle de musculation
L'application est utilisée dans des conditions biomécaniques et environnementales extrêmes :
- Mains moites, tremblantes ou couvertes de magnésie après un effort maximal à RPE élevé (9-10).
- Utilisation fréquente d'une seule main (le pouce) en marchant entre deux machines ou assis sur un banc.
- Éclairage variable (spots directionnels aveuglants, zones sombres).
- Attention cognitive réduite par la fatigue du système nerveux central (SNC) et le décompte du chronomètre de repos.
- Écran qui doit impérativement rester allumé (Wakelock) sans mise en veille intempestive.

---

## 1. Ergonomie physique & "Thumb-Zone" (Zone du pouce)

### Points forts
- **Ancrage inférieur (Zone naturelle du pouce)** : La barre de saisie rapide `OneHandedQuickInputBar` est ancrée en bas d'écran (`bottomNavigationBar`), évitant à l'athlète les tensions musculaires pour atteindre le haut de l'écran.
- **Bouton de validation principal massif** : Le bouton `Valider la série ✓` occupe toute la largeur disponible pour maximiser la cible tactile (Loi de Fitts) et avance automatiquement au prochain set.
- **Anti-rebond & stabilité des calculs** : Anti-rebond (*debounce*) de 280 ms sur la saisie textuelle pour épargner la base SQLite, et arrondissement strict `toStringAsFixed(1)` pour éviter les bugs d'arrondi flottant IEEE 754.
- **Retour haptique sensoriel** : Retours haptiques gradués (`selectionClick` pour les incréments, `mediumImpact` pour la validation, `heavyImpact` pour un record personnel PR).

### Frictions identifiées
1. **Cibles tactiles trop petites sur les steppers** : Les boutons d'incrément de charge et reps mesuraient initialement ~32x26 dp, en deçà de la norme WCAG / Material 3 ($\ge 44 \times 44\text{ dp}$).
2. **Absence d'incréments de 1 kg** : Impossibilité d'ajuster finement (+1/-1 kg) sans recourir au clavier virtuel.
3. **Collision tactile dans la rangée de série** : L'icône du calculateur de disques était superposée dans le champ texte de poids, provoquant des ouvertures modales accidentelles.
4. **Changement de type de série hors de la zone du pouce** : Nécessité de remonter dans la liste pour modifier un set en Warmup ou Dropset.

---

## 2. Charge cognitive & Flux de séance (Live Workout Flow)

### Points forts
- **Wakelock actif** : L'écran reste allumé durant toute la durée de la séance active (`WakelockPlus`).
- **Chronomètre "Dynamic Island"** : Barre flottante persistante indiquant le temps restant avec chiffres tabulaires non vacillants et indication du prochain exercice.
- **Ghost hints** : Rappel direct de la performance de la séance précédente avec bouton de copie en 1 tap.

### Frictions identifiées
1. **Rupture du flux Superset** : L'avance automatique au set suivant bouclait sur toutes les séries de l'exercice A1 avant de passer à A2, au lieu d'alterner les séries A1 -> A2 -> A1.
2. **Empilement excessif en bas d'écran** : Le bouton `+ Ajouter un exercice` était logé en permanence dans le `bottomNavigationBar`, occupant plus de 50 dp d'écran utile et masquant la vue de séance.
3. **Séries d'échauffement ajoutées en fin d'exercice** : Le générateur d'échauffement insérait les séries légères après les séries effectives lourdes.
4. **Actions destructrices sans confirmation** : Fin de séance ou suppression d'exercice/série sans confirmation ni possibilité d'annulation.

---

## 3. Onboarding, Recommandation & Première Valeur (AHA Moment)

### Points forts
- **Zéro barrière d'authentification** : Accès instantané en mode 100 % hors-ligne (*Offline-First*).
- **Time-to-First-Workout < 30s** : Possibilité de démarrer immédiatement la routine recommandée à l'issue de l'onboarding.
- **Stepper clair** : Navigation par étapes fluides avec option pour passer (`Skip`).

### Frictions identifiées
1. **Absence de saisie biométrique à l'onboarding** : Tous les utilisateurs démarraient avec un poids par défaut de 75 kg et 178 cm.
2. **Textes scientifiques non traduits** : La justification et les noms de routines de `RoutineRecommender` étaient codés en dur en anglais.
3. **Incompréhension de l'ajustement pour débutant** : Réduction automatique à 3 jours sans explication pour les débutants ayant demandé 4 ou 5 jours.

---

## 4. Expérience multilingue et sens de lecture (RTL / LTR)

### Points forts
- **Hiérarchie linguistique neutre** : Arabe en tête, suivi de l'anglais et du français, sans emojis de drapeaux.
- **Support RTL étendu** : Utilisation généralisée de `EdgeInsetsDirectional` et `AlignmentDirectional`.
- **Échelle RPE/RIR trilingue** : Descriptions complètes en français, anglais et arabe.

### Frictions identifiées
1. **Bordure Superset inversée en RTL** : L'indicateur latéral violet utilisait `Border(left: ...)` au lieu de `BorderDirectional(start: ...)`.
2. **Graphiques fl_chart en RTL** : Les axes et infobulles restaient calés à gauche en mode arabe.
3. **Textes résiduels en français** : Plusieurs mentions dans `WeightProgressionCard` étaient codées en dur en français.

---

## 5. Visualisation de la donnée & Motivation (Historique / Profil)

### Points forts
- **Célébration des Records Personnels (PR)** : Bordure dorée, badge trophée 🏆, calcul de 1RM estimé et retour haptique lourd.
- **Empty States pédagogiques** : Explications claires lorsqu'une seule pesée est disponible pour inciter à la régularité.
- **Exports CSV / JSON et Import transactionnel** : Protection complète de la souveraineté des données de l'athlète.

### Frictions identifiées
1. **Accessibilité lecteur d'écran** : Les graphiques `fl_chart` manquaient d'annotations `Semantics` pour TalkBack et VoiceOver.
2. **Suppression RGPD trop abrupte** : Absence d'option rapide d'export de sauvegarde avant suppression irréversible.
3. **Indicateur IMC non nuancé** : IMC non localisé qualifiant les athlètes musclés de surpoids sans précaution.

---

## Plan d'actions correctif (P0, P1, P2)

### P0 (Critique)
- [x] Agrandissement des cibles tactiles des steppers de `OneHandedQuickInputBar` à $\ge 44 \times 44\text{ dp}$.
- [x] Ajout des steppers fins $\pm 1\text{ kg}$ et sélecteur de type de série (`Normal`, `Warmup`, `Dropset`, `Failure`) dans la barre rapide.
- [x] Retrait de l'icône de calculatrice de disques en superposition directe dans le champ de saisie de `SetRowWidget`.
- [x] Déplacement du bouton `+ Ajouter un exercice` dans la liste d'exercices (libération de la barre inférieure).
- [x] Support des Supersets dans l'avance automatique de série (`A1 (Set 1)` -> `A2 (Set 1)`).

### P1 (Important)
- [x] Insertion ordonnée des séries d'échauffement au début de l'exercice (`WarmupSetsDialog`).
- [x] Dialogues de confirmation sur `Terminer la séance` (si séries incomplètes) et `Supprimer l'exercice`.
- [x] Remplacement de `Border(left: ...)` par `BorderDirectional(start: ...)` sur les cartes d'exercices en Superset.
- [x] Traduction et internationalisation des textes de `WeightProgressionCard` et `RoutineRecommender` en AR / EN / FR.

### P2 (Confort & Accessibilité)
- [x] Étape biométrique rapide (Poids & Taille) dans l'onboarding pour personnaliser le profil dès la première utilisation.
- [x] Ajout de balises `Semantics` sur les graphiques de progression corporelle.
- [x] Option de sauvegarde préventive avant suppression définitive du profil RGPD.
