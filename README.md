I expect this script to help me keeping a good pace of work and
vacation days. We can feel ourselves too tired at times or full of
energy, but it is hard to get aware of the unbalances between work and
vacation over months or years, especially when the amount of hours
worked daily is flexible

# Data structure

I collect some data about my working hours with a simple command line
script called [margin](https://github.com/danse/margin). Pacemaker
parses those files and performs simple calculations on the data

# Usage

    $ pacemaker *.margin

# Dependencies

This depends on an `Exmargination` module which parses Margin
files. The module is not published on Hackage. I do not think that
anybody will use this script except myself, but in case you want to,
open an issue and we will fix this quickly
