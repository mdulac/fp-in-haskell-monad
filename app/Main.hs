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
	map ma f = error "todo"
	ap :: m a -> m (a -> b) -> m b
	ap ma mf = error "todo"
	-- EXO 3
	flatten :: m (m a) -> m a
	flatten mma = error "todo"

-- EXO 4
instance Monade List where
	point x = error "todo"
	flatMap _ _ = error "todo"

instance Monade Box where
	point = error "todo"
	flatMap _ _ = error "todo"

-- EXO 5
-- TODO

-- EXO 9
composeListAndBox :: List (Box a) -> (a -> b) -> List (Box b)
composeListAndBox l f = error "todo"

composeBoxAndList :: Box (List a) -> (a -> b) -> Box (List b)
composeBoxAndList l f = error "todo"

-- EXO 8
-- TODO

-- EXO 10
-- TODO

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

	-- TODO

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
	-- TODO

-}
{-
	-- EXO 10

	print $ do
		x <- write 3 "Put 3\n"
		y <- write 5 "Put 5\n"
		z <- write (x + y) "Add both\n"
		return z

-}