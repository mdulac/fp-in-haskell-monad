module Lib
    ( 	List(Cons, Nil),
    	Box(Full, Empty),
    	concat,
    	list,
    	box,
    	empty
    ) where

import Prelude hiding (concat)
import Control.Exception

data List a = Cons a (List a) | Nil deriving (Show, Eq)

instance Functor List where
	fmap _ Nil = Nil
	fmap f (Cons h t) = Cons (f h) (fmap f t)

instance Applicative List where
	pure x = Cons x Nil
	(<*>) Nil _ = Nil
	(<*>) (Cons f t) fa = fmap f fa `concat` (<*>) t fa

instance Monad List where
	return x = Cons x Nil
	(>>=) Nil _ = Nil
	(>>=) (Cons h t) f = f h `concat` (>>=) t f

data Box a = Full a | Empty deriving (Show, Eq)

instance Functor Box where
	fmap _ Empty = Empty
	fmap f (Full v) = Full (f v)

instance Applicative Box where
	pure = Full
	(<*>) Empty _ = Empty
	(<*>) (Full f) fa = fmap f fa

instance Monad Box where
	return = Full
	(>>=) Empty _ = Empty
	(>>=) (Full v) f = f v

list :: [a] -> List a
list l = foldr Cons Nil l

box :: a -> Box a
box = Full

empty :: Box a
empty = Empty

concat :: List a -> List a -> List a
concat Nil c = c
concat (Cons h t) c = Cons h $ concat t c