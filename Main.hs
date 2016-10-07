import Margin( Margin, time, value, onAllMargins )
import Data.List( sort )
import Data.DateTime( DateTime, diffMinutes )
import System.Environment( getArgs )
import Data.ByteString.Lazy( ByteString )
import MyShow( (&) )

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
                   then "You can take" & difference & "vacation days"
                   else "You took" & negate difference & "extra vacation days!"
  in
    "Between" & firstDay & "and" & lastDay &
    "you worked" & worked & "days," &
    "deserving" & deserved & "vacation days," &
    "you relaxed" & skipped & "days." & comparison


space t = unlines ["", t, ""]

main = do
  args <- getArgs
  onAllMargins args (space . report)
