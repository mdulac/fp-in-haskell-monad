module Main where

import Lib
import Data.Char
import Prelude hiding (concat, map)

-- INTRO
runThrough :: List a -> List a
runThrough Nil = Nil
runThrough (Cons h t) = runThrough t

-- EXO 1
class Monade m where
	point :: a -> m a
	flatMap :: m a -> (a -> m b) -> m b
	-- EXO 2
	map :: m a -> (a -> b) -> m b
	map ma f = flatMap ma (\a -> point $ f a)
	ap :: m a -> m (a -> b) -> m b
	ap ma mf = flatMap ma (\a -> map mf (\f -> f a))
	-- EXO 3
	flatten :: m (m a) -> m a
	flatten mma = flatMap mma id

-- EXO 4
instance Monade List where
	point x = Cons x Nil
	flatMap Nil f = Nil
	flatMap (Cons h t) f = f h `concat` flatMap t f

instance Monade Box where
	point = Full
	flatMap Empty f = Empty
	flatMap (Full v) f = f v

-- EXO 9
composeListAndBox :: List (Box a) -> (a -> b) -> List (Box b)
composeListAndBox l f = (fmap . fmap) f l

composeBoxAndList :: Box (List a) -> (a -> b) -> Box (List b)
composeBoxAndList l f = (fmap . fmap) f l

-- EXO 8
composeF :: (Functor f1, Functor f2) => (a -> b) -> f1 (f2 a) -> f1 (f2 b)
composeF = fmap . fmap

-- EXO 10
data Writer a = Writer {value :: a, logg :: String} deriving (Show)

instance Functor Writer where
	fmap f (Writer v l) = Writer (f v) l

instance Applicative Writer where
	pure v = Writer v ""
	(<*>) (Writer f l) fa = fmap f fa

instance Monad Writer where
	return v = Writer v ""
	(>>=) (Writer v l) f =
		let w = f v in Writer (value w) (logg w ++ l) 

write :: a -> String -> Writer a
write = Writer

main :: IO ()
main = do
	putStrLn "Si ça compile, c'est que ça fonctionne :)"

{-
	-- EXO 1

	print $ list [1, 2, 3, 4]
	print $ list [1, 2, 3, 4] `concat` list [5, 6, 7, 8]

-}
{-	
	-- EXO 2, 3, 4

	print $ map (list [1, 2, 3, 4]) (+1)
	print $ ap (list [1, 2, 3, 4]) (list [(+1), (+2)])
	print $ flatten (list [list [1, 2, 3], list [4, 5, 6]])
	print $ (list [(+1), (+2), (+3)]) <*> (list [10, 11, 12])
	print $ flatMap (list [1, 2, 3, 4]) (\x -> (list [x-1, x, x+1]))

-}
{-
	-- EXO 5

	print $ box 4
	print $ map (box 6) (+1)
	print $ ap (box 4) (box (+1))
	print $ flatten (box (box 2))
	print $ flatten (box (box (box 7)))
	print $ (box (+1)) <*> (box 10)
	print $ flatMap (box 3) (\x -> (box (x-1)))
	print $ flatMap (box 6) (\x -> (box [x-1, x, x+1]))

-}
{-
	-- EXO 6, 7

	print $ Full 6 >>= (\x -> Full (x + 10) >>= (\y -> Full (y + 100)))

	print $ do
		x <- box 6
		y <- return (x + 10)
		z <- if (y > 15) then Empty else return y
		return (z + 100)

	print $ do
		func <- list [(+1), (+2), (+3)]
		e <- list [10, 11, 12]
		return $ func e

	print $ do
		v <- box 34
		v1 <- box $ v + 12
		return v1

	print $ do
		v <- box 34
		v1 <- box $ v + 12
		v2 <- Empty
		return v1 :: Box Int

-}
{-
	-- EXO 8

	print $ composeListAndBox (list [box 1, box 2]) (+1)
	print $ composeBoxAndList (box (list [1, 2, 3, 4])) (+1)
	print $ composeF (+1) (list [box 1, box 2])
	print $ composeF (+1) (box (list [1, 2, 3, 4]))

-}
{-
	-- EXO 9

	value <- getLine
	print $ "Hello " ++ (fmap toUpper value)

	x <- getLine
	y <- getLine
	z <- getLine
	print $ x ++ y ++ z

-}
{-
	-- EXO 10

	print $ do
		x <- write 3 "Put 3\n"
		y <- write 5 "Put 5\n"
		z <- write (x + y) "Add both\n"
		return z

-}