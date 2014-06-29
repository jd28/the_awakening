// Flag Sets v1.3 by Axe
//:://///////////////////////
// _flagsets_inc
//:://///////////////////////


// Constants
const int FLAG1           = 0x00000001;
const int FLAG2           = 0x00000002;
const int FLAG3           = 0x00000004;
const int FLAG4           = 0x00000008;
const int FLAG5           = 0x00000010;
const int FLAG6           = 0x00000020;
const int FLAG7           = 0x00000040;
const int FLAG8           = 0x00000080;
const int FLAG9           = 0x00000100;
const int FLAG10          = 0x00000200;
const int FLAG11          = 0x00000400;
const int FLAG12          = 0x00000800;
const int FLAG13          = 0x00001000;
const int FLAG14          = 0x00002000;
const int FLAG15          = 0x00004000;
const int FLAG16          = 0x00008000;
const int FLAG17          = 0x00010000;
const int FLAG18          = 0x00020000;
const int FLAG19          = 0x00040000;
const int FLAG20          = 0x00080000;
const int FLAG21          = 0x00100000;
const int FLAG22          = 0x00200000;
const int FLAG23          = 0x00400000;
const int FLAG24          = 0x00800000;
const int FLAG25          = 0x01000000;
const int FLAG26          = 0x02000000;
const int FLAG27          = 0x04000000;
const int FLAG28          = 0x08000000;
const int FLAG29          = 0x10000000;
const int FLAG30          = 0x20000000;
const int FLAG31          = 0x40000000;
const int FLAG32          = 0x80000000;
const int ALLFLAGS        = 0xFFFFFFFF;
const int NOFLAGS         = 0x00000000;

const int TINYGROUP1      = 0x0000000F; // 4 Flags per group. 8 groups per flagset.
const int TINYGROUP2      = 0x000000F0; // Value range 0-15.
const int TINYGROUP3      = 0x00000F00;
const int TINYGROUP4      = 0x0000F000;
const int TINYGROUP5      = 0x000F0000;
const int TINYGROUP6      = 0x00F00000;
const int TINYGROUP7      = 0x0F000000;
const int TINYGROUP8      = 0xF0000000;
const int ALLTINYGROUPS   = 0xFFFFFFFF;

const int SMALLGROUP1     = 0x0000003F; // 6 Flags per group. 5 groups per flagset plus 1 extra group with only 2 flags.
const int SMALLGROUP2     = 0x00000FC0; // Value range 0-63.
const int SMALLGROUP3     = 0x0003F000;
const int SMALLGROUP4     = 0x00FC0000;
const int SMALLGROUP5     = 0x3F000000;
const int SMALLGROUPX     = 0xC0000000; // Special Group with only 2 flags. Value range 0-3.
const int ALLSMALLGROUPS  = 0x3FFFFFFF;

const int MEDIUMGROUP1    = 0x000000FF; // 8 Flags per group. 4 groups per flagset.
const int MEDIUMGROUP2    = 0x0000FF00; // Value range 0-255.
const int MEDIUMGROUP3    = 0x00FF0000;
const int MEDIUMGROUP4    = 0xFF000000;
const int ALLMEDIUMGROUPS = 0xFFFFFFFF;

const int LARGEGROUP1     = 0x000003FF; // 10 Flags per group. 3 groups per flagset plus 1 extra group with only 2 flags.
const int LARGEGROUP2     = 0x000FFC00; // Value range 0-1023
const int LARGEGROUP3     = 0x3FF00000;
const int LARGEGROUPX     = 0xC0000000; // Special Group with only 2 flags. Value range 0-3.
const int ALLLARGEGROUPS  = 0x3FFFFFFF;

const int HUGEGROUP1      = 0x0000FFFF; // 16 Flags per group. 2 groups per flagset.
const int HUGEGROUP2      = 0xFFFF0000; // Value range 0-65535
const int ALLHUGEGROUPS   = 0xFFFFFFFF;

const int ALLGROUPS       = 0xFFFFFFFF;
const int GROUPVALUE      = 0xFFFFFFFF;
const int NOGROUPS        = 0x00000000;

const string DECTOBINARY  = "0000000100100011010001010110011110001001101010111100110111101111";


// Function Definitions
//:://///////////////////////


//:://///////////////////////
// string FlagToString( int iSet)
//    Returns the specified flagset as a string of 1's and 0's in the form:
//    "XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX" where FLAG1 is on the far right and FLAG32 the far left.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//
// Returns: The converted flagset in the form "XXXX XXXX XXXX XXXX XXXX XXXX XXXX"
//:://///////////////////////
string FlagToString( int iSet);
string FlagToString( int iSet)
{ if( iSet == 0) return "0000 0000 0000 0000 0000 0000 0000 0000";

  string sSet       = "";
  int    nTinyCount = 0;
  for( nTinyCount = 1; nTinyCount <= 8; nTinyCount++)
  { string sTiny = GetSubString( DECTOBINARY, (iSet & TINYGROUP1) *4, 4);
    if( (iSet >>= 4) < 0) iSet &= 0x0FFFFFFF;
    sSet = sTiny +((sSet == "") ? "" : " ") +sSet;
  }
  return sSet;
}


//:://///////////////////////
// string GroupFlagToString( int iSet, int iGroup)
//    Returns the specified flag group from the given flagset as a string of 1's and 0's in the form:
//    "XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX" where FLAG1 is on the far right and FLAG32 the far left.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iGroup - the flag group to get the flags from.
//
// Returns: The converted flag group from the flagset in the form "XXXX XXXX XXXX XXXX XXXX XXXX XXXX"
//:://///////////////////////
string GroupFlagToString( int iSet, int iGroup);
string GroupFlagToString( int iSet, int iGroup)
{ if( iGroup == NOGROUPS) return "0000 0000 0000 0000 0000 0000 0000 0000";
  iSet &= iGroup;
  while( (iGroup & FLAG1) != FLAG1)
  { if( (iSet   >>= 1) < 0) iSet   &= 0x7FFFFFFF;
    if( (iGroup >>= 1) < 0) iGroup &= 0x7FFFFFFF;
  }
  return FlagToString( iSet);
}


//:://///////////////////////
// int SetFlag( int iSet, int iFlag, int bOn = TRUE)
//    Turns a flag or set of flags on or off in a flagset variable.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to set or clear.
//             int bOn   - turn flags on if TRUE, off if FALSE
//
// Returns: The value of the iSet flagset with the flag(s) specified in iFlag turned on or off
//          based on the value of bOn.
//:://///////////////////////
int SetFlag( int iSet, int iFlag, int bOn = TRUE);
int SetFlag( int iSet, int iFlag, int bOn = TRUE)
{ return (bOn ? (iSet | iFlag) : (iSet & ~iFlag)); }


//:://///////////////////////
// int ClearFlag( int iSet, int iFlag)
//    Clears a flag or set of flags in a flagset variable.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to turn off.
//
// Returns: The value of the iSet flagset with the flag(s) specified in iFlag turned off.
//:://///////////////////////
int ClearFlag( int iSet, int iFlag);
int ClearFlag( int iSet, int iFlag)
{ return SetFlag( iSet, iFlag, FALSE); }


//:://///////////////////////
// int GetFlag( int iSet, int iFlag)
//    Returns the values of the flag(s) specified from the given flagset.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to turn off.
//
// Returns: The value of the flag(s) requested in the iFlag parameter from the iSet flagset.
//:://///////////////////////
int GetFlag( int iSet, int iFlag);
int GetFlag( int iSet, int iFlag)
{ return (iSet & iFlag); }


//:://///////////////////////
// int GetIsFlagSet( int iSet, int iFlag, int bAny = TRUE)
//    Returns TRUE or FALSE if the flags specified in iFlag are turned on. The bAny parameter
//    is used to request an ANY or ALL test.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to test.
//             int bAny  - TRUE means test for any of the flags being set.
//                         FALSE means test for all of the flags being set.
//
// Returns: TRUE if any or all of the flags specified in iFlag are turned on in the flagset variable.
//:://///////////////////////
int GetIsFlagSet( int iSet, int iFlag, int bAny = TRUE);
int GetIsFlagSet( int iSet, int iFlag, int bAny = TRUE)
{ if( iFlag == NOFLAGS) return FALSE;
  return (bAny ? ((iSet & iFlag) != NOFLAGS) : ((iSet & iFlag) == iFlag));
}


//:://///////////////////////
// int GetIsFlagClear( int iSet, int iFlag, int bAll = TRUE)
//    Returns TRUE or FALSE if the flags specified in iFlag are turned off. The bAll parameter
//    is used to request an ANY or ALL test.
//:://///////////////////////
// Parameters: int iSet  - the flagset variable.
//             int iFlag - the flags to test.
//             int bAll  - TRUE means test for all of the flags being clear.
//                         FALSE means test for any of the flags being clear.
//
// Returns: TRUE if any or all of the flags specified in iFlag are turned off in the flagset variable.
//:://///////////////////////
int GetIsFlagClear( int iSet, int iFlag, int bAll = TRUE);
int GetIsFlagClear( int iSet, int iFlag, int bAll = TRUE)
{ if( iFlag == NOFLAGS) return FALSE;
  return !GetIsFlagSet( iSet, iFlag, !bAll);
}


//:://///////////////////////
// int SetGroupFlag( int iSet, int iFlag, int iGroup, int bOn = TRUE)
//    Turns a flag or set of flags on or off in a flag group of a flagset variable.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to set or clear.
//             int iGroup - the flag group to apply the changes to.
//             int bOn    - turn flags on if TRUE, off if FALSE
//
// Returns: The value of the iSet flagset with the flag(s) specified in iFlag turned on or off
//          based on the value of bOn in the flag group specified by iGroup.
//:://///////////////////////
int SetGroupFlag( int iSet, int iFlag, int iGroup, int bOn = TRUE);
int SetGroupFlag( int iSet, int iFlag, int iGroup, int bOn = TRUE)
{ if( (iFlag == NOFLAGS) || (iGroup == NOGROUPS)) return iSet;

  int iShift = 0;
  int iLimit = iGroup;
  while( (iLimit != NOFLAGS) && GetIsFlagClear( iLimit, FLAG1))
  { ++iShift;   iLimit >>= 1;   if( iLimit < 0) iLimit &= 0x7FFFFFFF; }
  return ((iLimit == NOFLAGS) ? iSet : SetFlag( iSet, ((iFlag & iLimit) << iShift), bOn));
}


//:://///////////////////////
// int SetGroupFlagValue( int iSet, int iValue, int iGroup)
//    Sets the group value for a group flag.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iValue - the value to set.
//             int iGroup - the flag group to apply the changes to.
//
// Returns: The iSet flagset with the value specified in iValue set as the group value for the
//          group specified by iGroup.
//:://///////////////////////
int SetGroupFlagValue( int iSet, int iValue, int iGroup);
int SetGroupFlagValue( int iSet, int iValue, int iGroup)
{ if( iGroup == NOGROUPS) return iSet;
  return SetGroupFlag( SetGroupFlag( iSet, iValue, iGroup), ~iValue, iGroup, FALSE);
}


//:://///////////////////////
// int ClearGroupFlag( int iSet, int iFlag, int iGroup)
//    Turns a flag or set of flags off in a flag group of a flagset variable.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to clear.
//             int iGroup - the flag group to apply the changes to.
//             int bOn    - turn flags on if TRUE, off if FALSE
//
// Returns: The value of the iSet flagset with the flag(s) specified in iFlag turned off in the
//          flag group specified by iGroup.
//:://///////////////////////
int ClearGroupFlag( int iSet, int iFlag, int iGroup);
int ClearGroupFlag( int iSet, int iFlag, int iGroup)
{ return SetGroupFlag( iSet, iFlag, iGroup, FALSE); }


//:://///////////////////////
// int GetGroupFlag( int iSet, int iFlag, int iGroup)
//    Returns the values of the flag(s) specified from the specified flag group of the given flagset.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to return.
//             int iGroup - the flag group to get the flags from.
//
// Returns: The value of the flag(s) requested by the iFlag parameter from the flag group
//          specified in the iGroup parameter from the iSet flagset.
//:://///////////////////////
int GetGroupFlag( int iSet, int iFlag, int iGroup);
int GetGroupFlag( int iSet, int iFlag, int iGroup)
{ if( (iFlag == NOFLAGS) || (iGroup == NOGROUPS)) return NOFLAGS;

  int iShift = 0;
  int iLimit = iGroup;
  while( (iLimit != NOFLAGS) && GetIsFlagClear( iLimit, FLAG1))
  { ++iShift;   iLimit >>= 1;   if( iLimit < 0) iLimit &= 0x7FFFFFFF; }
  int iGroupFlag = GetFlag( iSet, ((iFlag & iLimit) << iShift));
  if( (iGroupFlag < 0) && (iShift > 0))
  { iGroupFlag >>= 1;   iGroupFlag &= 0x7FFFFFFF;   --iShift; }
  return ((iLimit == NOFLAGS) ? NOFLAGS : (iGroupFlag >> iShift));
}


//:://///////////////////////
// int GetGroupFlagValue( int iSet, int iGroup)
//    Returns the group value of the specified group in the iSet flagset.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iGroup - the flag group to get the value of.
//
// Returns: The group value of the group specified by iGroup from the iSet flagset.
//:://///////////////////////
int GetGroupFlagValue( int iSet, int iGroup);
int GetGroupFlagValue( int iSet, int iGroup)
{ if( iGroup == NOGROUPS) return NOFLAGS;
  return GetGroupFlag( iSet, GROUPVALUE, iGroup);
}


//:://///////////////////////
// int GetIsGroupFlagSet( int iSet, int iFlag, int iGroup, int bAny = TRUE)
//    Returns TRUE or FALSE if the flags specified in iFlag are turned on in the flag group
//    specified by iGroup. The bAny parameter is used to request an ANY or ALL test.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to test.
//             int iGroup - the flag group to get the flags from.
//             int bAny   - TRUE means test for any of the flags being set.
//                          FALSE means test for all of the flags being set.
//
// Returns: TRUE if any or all of the flags specified in iFlag are turned on in the specified
//          flag group of the given flagset variable.
//:://///////////////////////
int GetIsGroupFlagSet( int iSet, int iFlag, int iGroup, int bAny = TRUE);
int GetIsGroupFlagSet( int iSet, int iFlag, int iGroup, int bAny = TRUE)
{ if( (iFlag == NOFLAGS) || (iGroup == NOGROUPS)) return FALSE;

  int iShift = 0;
  int iLimit = iGroup;
  while( (iLimit != NOFLAGS) && GetIsFlagClear( iLimit, FLAG1))
  { ++iShift;   iLimit >>= 1;   if( iLimit < 0) iLimit &= 0x7FFFFFFF; }
  return ((iLimit == NOFLAGS) ? FALSE : GetIsFlagSet( iSet, ((iFlag & iLimit) << iShift), bAny));
}


//:://///////////////////////
// int GetIsGroupFlagClear( int iSet, int iFlag, int iGroup, int bAll = TRUE)
//    Returns TRUE or FALSE if the flags specified in iFlag are turned off in the flag group
//    specified by iGroup. The bAll parameter is used to request an ANY or ALL test.
//:://///////////////////////
// Parameters: int iSet   - the flagset variable.
//             int iFlag  - the flags to test.
//             int iGroup - the flag group to get the flags from.
//             int bAll   - TRUE means test for all of the flags being cleared.
//                          FALSE means test for any of the flags being cleared.
//
// Returns: TRUE if any or all of the flags specified in iFlag are turned off in the specified
//          flag group of the given flagset variable.
//:://///////////////////////
int GetIsGroupFlagClear( int iSet, int iFlag, int iGroup, int bAll = TRUE);
int GetIsGroupFlagClear( int iSet, int iFlag, int iGroup, int bAll = TRUE)
{ if( (iFlag == NOFLAGS) || (iGroup == NOGROUPS)) return FALSE;
  return !GetIsGroupFlagSet( iSet, iFlag, iGroup, !bAll);
}


//:://///////////////////////
// void SetLocalFlag( object oObject, string sVariable, int iFlag, int bOn = TRUE)
//    Sets a local flag variable on an object.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iFlag     - the flag(s) to set or clear.
//             int    bOn       - turn flags on if TRUE, off if FALSE
//
// Returns: None.
//:://///////////////////////
void SetLocalFlag( object oObject, string sVariable, int iFlag, int bOn = TRUE);
void SetLocalFlag( object oObject, string sVariable, int iFlag, int bOn = TRUE)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, SetFlag( iSet, iFlag, bOn));
}


//:://///////////////////////
// void ClearLocalFlag( object oObject, string sVariable, int iFlag)
//    Clears a local flag variable on an object.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iFlag     - the flag(s) to clear.
//
// Returns: None.
//:://///////////////////////
void ClearLocalFlag( object oObject, string sVariable, int iFlag);
void ClearLocalFlag( object oObject, string sVariable, int iFlag)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, ClearFlag( iSet, iFlag));
}


//:://///////////////////////
// int GetLocalFlag( object oObject, string sVariable, int iFlag = ALLFLAGS)
//    Returns the value of a local flag(s) from an object.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the flag(s) from.
//             int    iFlag     - the flag(s) to be retrieved.
//
// Returns: The requested flag(s) is/are returned as a flagset.
//:://///////////////////////
int GetLocalFlag( object oObject, string sVariable, int iFlag = ALLFLAGS);
int GetLocalFlag( object oObject, string sVariable, int iFlag = ALLFLAGS)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetFlag( iSet, iFlag);
}


//:://///////////////////////
// int GetIsLocalFlagSet( object oObject, string sVariable, int iFlag = ALLFLAGS)
//    Returns TRUE if the flag(s) in the flagset named by sVariable on oObject are set.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the flag(s) from.
//             int    iFlag     - the flag(s) to be retrieved.
//
// Returns: TRUE if all specified flags are set, FALSE otherwise.
//:://///////////////////////
int GetIsLocalFlagSet( object oObject, string sVariable, int iFlag = ALLFLAGS);
int GetIsLocalFlagSet( object oObject, string sVariable, int iFlag = ALLFLAGS)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetIsFlagSet( iSet, iFlag);
}


//:://///////////////////////
// int GetIsLocalFlagClear( object oObject, string sVariable, int iFlag = ALLFLAGS)
//    Returns TRUE if the flag(s) in the flagset named by sVariable on oObject is not set.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the flag(s) from.
//             int    iFlag     - the flag(s) to be retrieved.
//
// Returns: TRUE if all specified flags are cleared, FALSE otherwise.
//:://///////////////////////
int GetIsLocalFlagClear( object oObject, string sVariable, int iFlag = ALLFLAGS);
int GetIsLocalFlagClear( object oObject, string sVariable, int iFlag = ALLFLAGS)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetIsFlagClear( iSet, iFlag);
}


//:://///////////////////////
// void DeleteLocalFlag( object oObject, string sVariable, int iFlag)
//    Removes the specified flag(s) from the given local flagset variable.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to delete the flag(s) from.
//             int    iFlag     - the flag(s) to be deleted.
//
// Returns: None.
//:://///////////////////////
void DeleteLocalFlag( object oObject, string sVariable, int iFlag = ALLFLAGS);
void DeleteLocalFlag( object oObject, string sVariable, int iFlag = ALLFLAGS)
{ if( !GetIsObjectValid( oObject) || (sVariable == "")) return;
  if( iFlag == ALLFLAGS) DeleteLocalInt( oObject, sVariable);
  else SetLocalFlag( oObject, sVariable, iFlag, FALSE);
}


//:://///////////////////////
// void SetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup, int bOn = TRUE)
//    Sets a local group flag variable on an object.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iFlag     - the flag(s) to set or clear.
//             int    iGroup    - the group to set or clear the flags in.
//             int    bOn       - turn flags on if TRUE, off if FALSE
//
// Returns: None.
//:://///////////////////////
void SetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup, int bOn = TRUE);
void SetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup, int bOn = TRUE)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == NOGROUPS)) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, SetGroupFlag( iSet, iFlag, iGroup, bOn));
}


//:://///////////////////////
// void ClearLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
//    Clears a local group flag variable on an object.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iFlag     - the flag(s) to clear.
//             int    iGroup    - the group to set or clear the flags in.
//
// Returns: None.
//:://///////////////////////
void ClearLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup);
void ClearLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == NOGROUPS)) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, ClearGroupFlag( iSet, iFlag, iGroup));
}


//:://///////////////////////
// void SetLocalGroupFlagValue( object oObject, string sVariable, int iFlag, int iGroup)
//    Sets a local group flag variable on an object as a value.
//:://///////////////////////
// Parameters: object oObject   - the object to have the local flagset attached.
//             string sVariable - the flagset name to set the flag in.
//             int    iValue    - the value to set.
//             int    iGroup    - the group to set the value in.
//
// Returns: None.
//:://///////////////////////
void SetLocalGroupFlagValue( object oObject, string sVariable, int iValue, int iGroup);
void SetLocalGroupFlagValue( object oObject, string sVariable, int iValue, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == NOGROUPS)) return;
  int iSet = GetLocalInt( oObject, sVariable);
  SetLocalInt( oObject, sVariable, SetGroupFlagValue( iSet, iValue, iGroup));
}


//:://///////////////////////
// int GetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
//    Returns the value(s) of a local group flag(s) from an object.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the flag(s) from.
//             int    iFlag     - the flag(s) to be retrieved.
//             int    iGroup    - the group to get the flags from.
//
// Returns: The requested group flag(s) is/are returned as a flagset group.
//:://///////////////////////
int GetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup);
int GetLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == NOGROUPS)) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetGroupFlag( iSet, iFlag, iGroup);
}


//:://///////////////////////
// int GetLocalGroupFlagValue( object oObject, string sVariable, int iGroup)
//    Returns the value of a local group flag number from an object.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to retrieve the value from.
//             int    iGroup    - the group to get the value from.
//
// Returns: The requested group's value is returned as a number.
//:://///////////////////////
int GetLocalGroupFlagValue( object oObject, string sVariable, int iGroup);
int GetLocalGroupFlagValue( object oObject, string sVariable, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == NOGROUPS)) return 0;
  int iSet = GetLocalInt( oObject, sVariable);
  return GetGroupFlagValue( iSet, iGroup);
}


//:://///////////////////////
// void DeleteLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
//    Removes the specified flag(s) from the specified group of the given local flagset variable.
//:://///////////////////////
// Parameters: object oObject   - the object that has the local flagset attached.
//             string sVariable - the flagset name to delete the flag(s) from.
//             int    iFlag     - the flag(s) to be deleted.
//             int    iGroup    - the group to delete the flags from.
//
// Returns: None.
//:://///////////////////////
void DeleteLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup);
void DeleteLocalGroupFlag( object oObject, string sVariable, int iFlag, int iGroup)
{ if( !GetIsObjectValid( oObject) || (sVariable == "") || (iGroup == NOGROUPS)) return;
  if( (iFlag == ALLFLAGS) && (iGroup == ALLGROUPS)) DeleteLocalInt( oObject, sVariable);
  else ClearLocalGroupFlag( oObject, sVariable, iFlag, iGroup);
}


//:://///////////////////////
// int HexToInt( string sHex)
//    Converts a hexidecimal number represented in a string to an integer.
//:://///////////////////////
// Parameters: string sHex - the hex number to convert. The string cannot be longer than 8
//                           characters unless the first two letters are '0x' (or '0X', in that
//                           case the string can be 10 characters long. It can be shorter than
//                           8 letters. Only numbers and letters 'a'-'f' and 'A'-'F' are allowed.
//                           If any of these rules is violated the function considers it an
//                           invalid hex number and returns the value 0.
//
// Returns: Integer value of the converted hex string or 0 if the input string is not a hex number.
//:://///////////////////////
int HexToInt( string sHex);
int HexToInt( string sHex)
{ sHex = GetStringLowerCase( sHex);
  if( GetStringLeft( sHex, 2) == "0x")
    sHex = GetStringRight( sHex, GetStringLength( sHex) -2);
  if( (sHex == "") || (GetStringLength( sHex) > 8)) return 0;

  string sConvert = "0123456789abcdef";
  int iValue = 0;
  int iMult  = 1;
  while( sHex != "")
  { int iDigit = FindSubString( sConvert, GetStringRight( sHex, 1));
    if( iDigit < 0) return 0;
    iValue += iMult *iDigit;
    iMult  *= 16;
    sHex    = GetStringLeft( sHex, GetStringLength( sHex) -1);
  }
  return iValue;
}

