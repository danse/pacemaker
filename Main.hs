import Exmargination( Margin, time, value )
import Data.List( sort )
import Data.DateTime( DateTime, diffMinutes )
import System.Environment( getArgs )
import Data.Aeson( eitherDecode )
import Data.Either( isRight, rights)
import Data.ByteString.Lazy( ByteString )
import Data.ByteString.Lazy.Char8( pack )

-- not working on Saturdays and Sundays and 24 vacation days per year

hoursPerDay = 7
workingDaysPerWeek = 5

vacationsPerYear = 24
nationalHolidays = 11 -- in Italy

-- Work days for a vacation day
vacationMultiplier = work / vacation
  where work = 365 * weekly
        weekly = workingDaysPerWeek / 7
        vacation = vacationsPerYear + nationalHolidays

-- convert to Unix seconds in order to calculate the days in between
daysBetween :: DateTime -> DateTime -> Float
daysBetween first last =
  let diff = fromInteger $ diffMinutes last first
      minutesInDay = 60 * 24
  in diff / minutesInDay

sortMarginDates :: [Margin] -> [DateTime]
sortMarginDates = sort . (map time)

sumAll :: [Margin] -> Float
sumAll = sum . (map value)

report :: [Margin] -> String
report margins =
  let dates = sortMarginDates margins
      firstDay = head dates
      lastDay = last dates
      worked = (sumAll margins) / hoursPerDay
      potential = (daysBetween firstDay lastDay) * (5/7)
      skipped = potential - worked
      deserved = worked / vacationMultiplier
      difference = deserved - skipped
      comparison = if (difference > 0)
                   then "You can take "++ (show difference) ++" vacation days"
                   else "You took "++ (show $ negate difference) ++" extra vacation days!"
  in
    "Between "++ (show firstDay) ++" and "++ (show lastDay) ++ " " ++
    "you worked "++ (show worked) ++ " days, " ++
    "deserving "++ (show deserved) ++" vacation days, " ++
    "you relaxed "++ (show skipped) ++ " days. " ++
    comparison

readMarginFiles :: [String] -> IO [String]
readMarginFiles names = sequence $ map readFile names

analyse parsed = report $ concat parsed

areRights :: [Either a b] -> [Bool]
areRights = map isRight

allRights :: [Either a b] -> Bool
allRights = and . areRights

main = do
  args <- getArgs
  contents <- readMarginFiles args
  let parsed = map (eitherDecode . pack) contents
    in if (allRights parsed)
       then print $ analyse $ rights parsed
       else print "parsing error"
