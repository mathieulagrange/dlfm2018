* Slide 21. 
* De MFCC 25 none (pas de projection) à MFCC 50 none
* en passant de none à LMNN, s'il y avait un sauf différent entre pas de split et un split (none à 25 ou 50)
* le boost de performance apporté par l'apprentissage est le même que l'on ait un split ou pas de split
* courbe noire : c'est plus facile d'apprendre un invariance par translation à l'octave avec du scattering que de l'apprendre sur des MFCC car les MFCC sont déjà invariants "by design" sans adaptation à la distribution des données.
* 
none: pas de split
25: 75% pour apprendre, 25% pour tester
50: 50/50
octave: on réduit la taille de la base à l'octave 4.

les courbes bleu ciel, bleu foncé, et rouge sont parallèles : on a bien de meilleures performances avec la base de données mais c'est parce qu'on a plus de points, pas parce que le LMNN overfit.

croisement de la courbe rouge et de la courbe noire : en se concentrant sur une seule octave, on apprend mieux avec le scattering.