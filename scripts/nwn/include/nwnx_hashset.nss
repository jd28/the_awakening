
//::///////////////////////////////////////////////
//:: Global Hash Include
//:: global_hash_inc.nss
//:://////////////////////////////////////////////

/*  A general purpose implementation combining a hash and a set (NWNX version) */

//:://////////////////////////////////////////////
//:: Created By: Ingmar Stieger
//:: Created On: 18/12/2003
//:://////////////////////////////////////////////
//:: Updated By: SpiderX
//:: Updated On: 14/02/2008
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*********************************************** Hash Functions Constants ******************************************/

int HASH_ERROR = FALSE;
int HASH_SUCCESS = TRUE;

/*******************************************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/********************************************** Hash Functions Prototypes ******************************************/

// Create a new HashSet on oObject with name sHashSetName (iSize is optional)
int CreateHash(object oObject, string sHashSetName, int iSize = 500);

// Clear and delete sHashSetName on oObject
void DestroyHash(object oObject, string sHashSetName);

// * Return TRUE if hashset sHashSet is valid
int GetHashValid(object oObject, string sHashSetName);

// * Return TRUE if hashset sHashSet contains key sKey
int GetHashKeyExists(object oObject, string sHashSetName, string sKey);

// Set key sKey of sHashset to string sValue
int SetHashString(object oObject, string sHashSetName, string sKey, string sValue);

// Retrieve string value of sKey in sHashset
// NOTE: sHashset must be existed.
string GetHashString(object oObject, string sHashSetName, string sKey);

// Set key sKey of sHashset to integer iValue
// NOTE: sHashset must be existed.
int SetHashInt(object oObject, string sHashSetName, string sKey, int iValue);

// Retrieve integer value of sKey in sHashset
// NOTE: sHashset must be existed.
int GetHashInt(object oObject, string sHashSetName, string sKey);

// Delete sKey in sHashset
int DeleteHashVariable(object oObject, string sHashSetName, string sKey);

// * Return the n-th key in sHashset
// NOTE: This returns the KEY, not the value of the key;
string GetHashNthKey(object oObject, string sHashSetName, int i);

// * Return the first key in sHashset
// NOTE: This returns the KEY, not the value of the key;
string GetHashFirstKey(object oObject, string sHashSetName);

// * Return the next key in sHashset
// NOTE: This returns the KEY, not the value of the key;
string GetHashNextKey(object oObject, string sHashSetName);

// * Return the current key in sHashset
// NOTE: This returns the KEY, not the value of the key;
string GetHashCurrentKey(object oObject, string sHashSetName);

// * Return the number of elements in sHashset
int GetHashSize(object oObject, string sHashSetName);

// * Return TRUE if the current key is not the last one, FALSE otherwise
int GetHashHasNext(object oObject, string sHashSetName);

/*******************************************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/********************************************* Hash Functions Implementation ***************************************/

int CreateHash(object oObject, string sHashSetName, int iSize = 500)
   {
    SetLocalString(oObject, "NWNX!HASHSET!CREATE", sHashSetName + "!" + IntToString(iSize) + "!");
    return HASH_SUCCESS;
   }

void DestroyHash(object oObject, string sHashSetName)
    {
     SetLocalString(oObject, "NWNX!HASHSET!DESTROY", sHashSetName + "!!");
    }

int GetHashValid(object oObject, string sHashSetName)
   {
    SetLocalString(oObject, "NWNX!HASHSET!VALID", sHashSetName + "!!");
    return StringToInt(GetLocalString(oObject, "NWNX!HASHSET!VALID"));
   }

int GetHashKeyExists(object oObject, string sHashSetName, string sKey)
   {
    SetLocalString(oObject, "NWNX!HASHSET!EXISTS", sHashSetName + "!" + sKey + "!");
    return StringToInt(GetLocalString(oObject, "NWNX!HASHSET!EXISTS"));
   }

int SetHashString(object oObject, string sHashSetName, string sKey, string sValue)
   {
    SetLocalString(oObject, "NWNX!HASHSET!INSERT", sHashSetName + "!" + sKey + "!" + sValue);
    return HASH_SUCCESS;
   }

string GetHashString(object oObject, string sHashSetName, string sKey)
      {
       SetLocalString(oObject, "NWNX!HASHSET!LOOKUP", sHashSetName + "!" + sKey + "!                                                                                                                                          ");
       return GetLocalString(oObject, "NWNX!HASHSET!LOOKUP");
      }

int SetHashInt(object oObject, string sHashSetName, string sKey, int iValue)
   {
    SetHashString(oObject, sHashSetName, sKey, IntToString(iValue));
    return HASH_SUCCESS;
   }

int GetHashInt(object oObject, string sHashSetName, string sKey)
   {
    string sValue = GetHashString(oObject, sHashSetName, sKey);
    if (sValue == "") return 0;
    else return StringToInt(sValue);
   }

int DeleteHashVariable(object oObject, string sHashSetName, string sKey)
   {
    SetLocalString(oObject, "NWNX!HASHSET!DELETE", sHashSetName + "!" + sKey + "!");
    return HASH_SUCCESS;
   }

string GetHashNthKey(object oObject, string sHashSetName, int i)
      {
       SetLocalString(oObject, "NWNX!HASHSET!GETNTHKEY", sHashSetName + "!" + IntToString(i) + "!                                                                                                                                          ");
       return GetLocalString(oObject, "NWNX!HASHSET!GETNTHKEY");
      }

string GetHashFirstKey(object oObject, string sHashSetName)
      {
       SetLocalString(oObject, "NWNX!HASHSET!GETFIRSTKEY", sHashSetName + "!!                                                                                                                                          ");
       return GetLocalString(oObject, "NWNX!HASHSET!GETFIRSTKEY");
      }

string GetHashNextKey(object oObject, string sHashSetName)
      {
       SetLocalString(oObject, "NWNX!HASHSET!GETNEXTKEY", sHashSetName + "!!                                                                                                                                          ");
       return GetLocalString(oObject, "NWNX!HASHSET!GETNEXTKEY");
      }

string GetHashCurrentKey(object oObject, string sHashSetName)
      {
       SetLocalString(oObject, "NWNX!HASHSET!GETCURRENTKEY", sHashSetName + "!!                                                                                                                                          ");
       return GetLocalString(oObject, "NWNX!HASHSET!GETCURRENTKEY");
      }

int GetHashSize(object oObject, string sHashSetName)
   {
    SetLocalString(oObject, "NWNX!HASHSET!GETSIZE", sHashSetName + "!!           ");
    return StringToInt(GetLocalString(oObject, "NWNX!HASHSET!GETSIZE"));
   }

int GetHashHasNext(object oObject, string sHashSetName)
   {
    SetLocalString(oObject, "NWNX!HASHSET!HASNEXT", sHashSetName + "!!           ");
    return StringToInt(GetLocalString(oObject, "NWNX!HASHSET!HASNEXT"));
   }

/*******************************************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*Debug*/
//void main(){}
