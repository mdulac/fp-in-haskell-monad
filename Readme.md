# Avant toute chose !

Pour plus de simplicité, ce projet est proposé avec Stack, un bootstrapper de projet Haskell Cabal
* Pour setuper le projet (à faire une fois au début) : 
	stack setup
* Pour builder le projet (à faire après chaque modification de source) :
	stack build
* Pour exécuter le binaire :
	stack exec fp-in-haskell-monad-exe

Un docker file est fourni avec le projet, si vous ne voulez pas installer l'écosystème Haskell sur votre machine :
* Builder l'image à partir du Dockerfile :
	docker build -t fp .
* Lancer un container avec la commande :
	docker run -it fp
* Vous pouvez directement accéder au répertoire fp-in-haskell-monad, où se trouve le projet :)

Si vous souhaitez installer les outils haskell sur votre machine :
* Vous pouvez installer haskell-platform à partir de brew (installe GHC et Cabal)
* Ensuite, vous pouvez installer stack à partir de Cabal
* Pour le reste, les commandes sont identiques : cloner le repository, setuper, builder et exécuter le projet !


# Monade

6 lettres et bien du mystère. La monade est souvent le terme le plus entendu quand on parle de pattern en programmation fonctionnelle.
Elle donne du fil à retordre au programmeur qui tente de la comprendre. Nous allons voir ensemble qu'il n'y a rien de mystérieux. 
La monade est au contraire un design pattern puissant permettant de construire des API élégantes et simples à utiliser.


## Petit rappel

Nous avons déjà abordé ensemble :

* la création de types simples en Haskell: Option et List
	
	-- List
	data List a = Cons a (List a) | Nil deriving (Show)

	-- Option
	data Option a = Some a | None deriving (Show)
	

* le parcours purement fonctionnel d'une structure récursive

	runThrough :: List a -> List a
	runThrough Nil = Nil
	runThrough (Cons h t) = runThrough t

* l'abstraction foncteur

Cette abstraction nécessite l'implémentation de la fonction **map** qui applique une fonction sur l'ensemble des valeurs contenu par le type.

	-- Exemple d'utilisation
	map (list [1, 2, 3, 4]) (+1)
	
La somme d'entiers est une opération qui nécessite deux paramètres, ici on doit en figer un des deux (1 pour l'addition).

Mais impossible avec le foncteur de passer une fonction du style \x y -> x + y


* l'abstraction applicative foncteur.

L'applicative est une spécialisation de foncteur. Elle a besoin de deux fonctions abstraites **point** et **ap**.
Grâce à cela, on peut non seulement avoir les mêmes API que le foncteur et bien d'autres encore. Le foncteur est limité à appliquer une fonction sur un ensemble d'éléments ou un ensemble de fonctions sur un seul élément.
L'applicative lève cette contrainte en permettant l'application d'un ensemble de fonctions sur un ensemble d'éléments!

	-- Exemple d'utilisation
	ap (list [1, 2, 3, 4]) (list [(+1), (+2)])
	
Mais l'applicative a lui aussi quelques limitations. Regarder l'exemple suivant

	let x = list ["123", "456"]
 	
	let listOfChars = map x (\str -> list(lenth))
 	
Si on s'intéresse au signature, nous avons

	x: List String
	
	f: String -> List Int
	
	map :: f a -> (a -> b) -> f b
	
	-- Par substitution :
	map :: List String -> (String -> List String) -> List (List String)
	
On remarque en sortie la répétition du type List. C'est un pattern! Voici la signature de ce que nous allons développer:

	x :: List String
    	
	f :: String -> List Int
    	
	flatMap :: f a -> (a -> f b) -> f b
    	
    -- Par substitution :
    flatMap :: List String -> (String -> List Int) -> List Int

En avant!


##Exo1: Monade de List
 
=> Créer le typeclass Monade, avec les fonction abstraite **point** et **flatMap**
La fonction **point** permettra de placer une valeur de type 'a' dans une Monade
La fonction **flatMap** est citée juste au dessus :)

Pour rappel, un typeclass représente "l'équivalent" d'une classe abstraite en Java, ou d'un trait en Scala.


##Exo2: Monade 'extends' Applicative

=> Écrivez **map** et **ap** en fonction de **flatMap** et **point** dans le typeclass Monade


##Exo3: Flatten the Monad

=> Écrivez **flatten** dans le typeclass Monade


##Exo4: Instanciate Monad for List

=> Ecrivez l'instance de Monade pour le type List


##Exo4: Monad laws

La monade repose elle aussi sur une structure mathématique. Il y a donc des propriétés à vérifier :

	Law 1 : point a >>= f ≡ f a

	Law 2 : m >>= point ≡ m

	Law 3 : (m >>= f) >>= g ≡ m >>= (\x -> f x >>= g)

=> En posant les types sur papier, vérifiez que notre Monade List respecte bien ces lois. 


##Exo5: Mise en pratique

On va créer un nouveau type nommé **Box**, possédant 2 valeurs : **Full** et **Empty**. Full représente une Box pleine (avec une valeur), et Empty une Box vide

En fait, le typeclass Monade existe déjà dans Prelude (le SDK de Haskell), et se nomme **Monad** ! ;)

	class Applicative m => Monad m where
  		(>>=)  :: m a -> (a -> m b) -> m b
  		return :: a -> m a

Les fonctions **point** et **flatMap** se nomment respectivement **return** et **>>=**

=> Créez l'instance de **Monad** pour **Box**

Dans la définition du typeclass Monad, on aperçoit un **type constraint** sur 'm', 'm' doit être un Applicative !

=> Créez l'instance de **Applicative** pour **Box**
=> De la même manière, pour être un Applicative, un type doit être un Functor : créez l'instance de **Functor** pour **Box**

Ok, maintenant il va être possible d'écrire des expressions de ce genre :
	Full 6 >>= (\x -> Full (x + 10) >>= (\y -> Full (y + 100)))


##Exo6: Do notation

On est d'accord que la syntaxe de l'exemple précédent est lourde !!
Instancier Monad permet d'utiliser la **do notation**

=> Traduisez l'exemple précédent sous forme de do-notation...
Ne regarde pas la suite, il y a la solution :)

.
.
.
.
.
.
.
.
.
.
.
.
.

Ainsi, l'expression précédente devient :
	
Code

	do
		x <- Full 6
		y <- Full (x + 10)
		return y + 100

Le compilateur va transformer ceci en suite de fmap et >>= correspondant !
Cette syntaxe se rapproche des langages impératifs que nous utilisons quotidiennement :)

L'intérêt de la Monade se montre ici : écrire une séquence de traitement, à travers un type !

Code

	do
		x <- box 6
		y <- return (x + 10)
		z <- if (y > 15) then return (y + 50) else return y
		return (z + 100)


##Exo7: Monads and do notation, the happy path

La do notation permet de traduire le "happy path", c'est à dire la séquence de traitement nominale. Les cas d'erreur, d'absence de valeurs, etc seront traités par le type. Ainsi :

Code

	do
		x <- box 6
		y <- return (x + 10)
		z <- if (y > 15) then Empty else return y
		return (z + 100)

retournera la valeur Full 116.
Alors que l'expression :

Code

	do
		a <- box 6
		b <- return (a + 10)
		c <- if (b > 14) then Empty else return b
		d <- if (c < 65) then Empty else return c
		e <- if (d < 164) then Empty else return d
		return (e + 100)

retournera la valeur Empty (dès la 3ème ligne), ensuite revenir à la définition de >>= pour Empty pour se rendre compte que la valeur résultant ne peut-être qu'Empty :)


##Exo8: Composition de fonctors

Les foncteurs et les applicatives se composent bien, contrairement aux monades !
=> Ecrivez les fonctions **composeListAndBox** et **composeBoxAndList**, pour composer une transformation de List de Box, et de Box de List respectivement

=> Que constatez-vous ?
=> Généralisez la composition en écrivant la fonction **composeF**


##Exo9: Cas pratique: IO

En Haskell, les IO sont des monades et traduisent la présence d'effets de bord.
Le prototype du main est d'ailleurs :

	main :: IO ()

C'est à dire qu'il ne prends pas de paramètres et retourne un IO vide.
Ceci permet de réaliser des effets de bord dans un programme Haskell : tout le programme se déroule dans une monade IO !

=> Utilisez la monade IO pour écrire un programme qui lit un input utilisateur, et qui affiche "HELLO <input>" à la validation ! (l'input' doit-être transformée en uppercase)
Indice : utilisez les fonctions getLine, print et toUpper

=> Utilisez la monade IO pour écrire un programme qui lit trois input utilisateurs, et les concatène


##Exo10: La Monade Writer

La Monade Writer (Logger) va permettre de stocker une valeur, ainsi qu'une log sur le traitement qui a méne à cette valeur. Ces logs sont concaténés, ce qui permet de suivre l'ensemble des événements qui ont menés au calcul de la valeur finale !

=> Créez cette data structure appelée Writer, typé avec une valeur de type 'a', et une chaîne de type 'String'
=> Créer les instances de Functor, Applicative et Monade pour Writer
=> Ecrire un programme en utilisant la do notation dans lequel :
	- inscrire une valeur initiale dans le writer, logguez
	- inscrire une deuxième valeur dans le writer, logguez
	- ajouter les 2 valeurs, logguez

=> Vous devez obtenir : Writer <valeur finale> <"Add 2 values | Put second value | Put first value">

##Exo 11: Ouverture sur la prochaine session

Le log du Writer n'est pas forcément une chaîne de caractères, mais peut-être n'importe quel type "assemblable".

=> Quelles contraintes doit-on avoir sur ce type ? :)

