#!/usr/bin/env python

#C: THIS FILE IS PART OF THE CYLC FORECAST SUITE METASCHEDULER.
#C: Copyright (C) 2008-2012 Hilary Oliver, NIWA
#C:
#C: This program is free software: you can redistribute it and/or modify
#C: it under the terms of the GNU General Public License as published by
#C: the Free Software Foundation, either version 3 of the License, or
#C: (at your option) any later version.
#C:
#C: This program is distributed in the hope that it will be useful,
#C: but WITHOUT ANY WARRANTY; without even the implied warranty of
#C: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#C: GNU General Public License for more details.
#C:
#C: You should have received a copy of the GNU General Public License
#C: along with this program.  If not, see <http://www.gnu.org/licenses/>.

class CyclerError( Exception ):
    pass

class CyclerOverrideError( CyclerError ):
    def __init__( self, method_name ):
        self.meth = method_name
    def __str__( self ):
        return repr("ERROR: derived classes must override cycler." + self.meth + "()" )

class cycler( object ):
    """A base class to define the interface that derived cycler classes
    must implement in order for cylc to generate tasks with a particular
    sequence of cycle times.
    
    NOTE: in method arguments and return values below: 
    * T represents a cycle time in string form (YYYYMMDDHHmmss)
    * CT represents a cycle_time.ct(T) object
    We will eventually use cycle time objects throughout cylc,
    extracting the string form from the object only when necessary."""

    @classmethod
    def offset( cls, T, n, reverse ):
        """Decrement the cycle time T by the integer n, where the units
        of n (e.g. days or years) are defined by the derived class. This
        is a class method because a time offset T-n does not depend on
        the details of the sequence, other than the units.
        """
        raise CyclerOverrideError( "offset" )

    def __init__( self, *args ):
        """Initialize a cycler object. The number and type of arguments,
        and stored object data, may depend on the derived cycler class."""
        raise CyclerOverrideError( "__init__" )

    def valid( self, CT ):
        """Return True or False according to whether or not T is a valid
        member of this cycler's cycle time sequence."""
        raise CyclerOverrideError( "valid" )

    def initial_adjust_up( self, T ):
        """Return T if it is a valid cycle time for this cycler, or
        otherwise round it up to the next subequent cycle time that is
        valid.  This method is used at suite start-up to find the first
        valid cycle at or after the suite initial cycle time; in
        subsequent cycles next() ensures we remain on valid cycles."""
        raise CyclerOverrideError( "initial_adjust_up" )

    def next( self, T ):
        """Return the cycle time next in the sequence after T. It may 
        be assumed that T is already on sequence."""
        raise CyclerOverrideError( "next" )
