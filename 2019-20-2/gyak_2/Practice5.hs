{-# OPTIONS -Wincomplete-patterns #-}
module Practice5 where

-- review
-- Maybe
-- Monad
-- Maybe as Monad

data Maybe' a = Nothing' | Just' a
  deriving (Eq, Ord, Show)

foo :: Eq k => [(k,v)] -> k -> Maybe v
foo [] toFind = Nothing
foo ((k,v) : rest) toFind
  | k == toFind = Just v
  | otherwise   = foo rest toFind

fmapMaybe :: (a -> b) -> Maybe a -> Maybe b
fmapMaybe f (Just x) = Just (f x)
fmapMaybe f Nothing  = Nothing

{- tests
fmapMaybe (Just 5) (2*) == Just 10
fmapMaybe Nothing  (2*) == Nothing
-}

-- class Monad (m :: * -> *) where
--   return :: a -> m a
--   (>>=)  :: m a -> (a -> m b) -> m b

isJust :: Maybe a -> Bool
isJust (Just x) = True
isJust Nothing  = False

fromJust :: Maybe a -> a
fromJust (Just x) = x
fromJust Nothing  = error "Not just"

safeHead :: [a] -> Maybe a
safeHead (x:_) = Just x
safeHead []    = Nothing

catMaybes :: [Maybe a] -> [a]
catMaybes (Just x  : xs) = x : catMaybes xs
catMaybes (Nothing : xs) = catMaybes xs
-- catMaybes (x:xs)
--   | isJust x = fromJust x : catMaybes xs
--   | not (isJust x) = undefined
catMaybes [] = []

mapMaybe :: (a -> Maybe b) -> [a] -> [b]
mapMaybe f xs = catMaybes $ map f xs

{- tests
returnMaybe 5 == Just 5

bindMaybe (Just 5) (\x -> Just (2*x)) == Just 10
bindMaybe Nothing  (\x -> Just (2*x)) == Nothing
bindMaybe (Just 0) (\x -> if (x == 0) then Nothing else 2/x) == Nothing
-}

returnMaybe :: a -> Maybe a
returnMaybe = Just

bindMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
bindMaybe Nothing  f = Nothing
bindMaybe (Just x) f = f x



nameIdDB :: [(String, Int)]
nameIdDB = [ ("John",    1)
           , ("Richard", 2)
           , ("Julie",   3)
           ]

data Currency = USD | GBP
  deriving (Eq, Ord, Show)

idMoneyCurDB :: [(Int, (Double, Currency))]
idMoneyCurDB = [ (1, (11, USD))
               , (5, (22, USD))
               , (3, (33, GBP))
               ]

exchangeRateDB :: [(Currency, Double)]
exchangeRateDB = [ (USD, 1)
                 , (GBP, 1.1)
                 ]

-- lookup, foo

lookupMoneyInUSD :: String -> Maybe Double
lookupMoneyInUSD name =
  case lookup name nameIdDB of
    Nothing -> Nothing
    Just id -> case lookup id idMoneyCurDB of
      Nothing -> Nothing
      Just (money, currency) -> case lookup currency exchangeRateDB of
        Nothing -> Nothing
        Just exRate -> Just (exRate * money)
