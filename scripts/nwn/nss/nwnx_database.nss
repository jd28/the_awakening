// Name     : Avlis Persistence System include
// Purpose  : Various APS/NWNX2 related functions
// Authors  : Ingmar Stieger, Adam Colon, Josh Simon
// Modified : January 1st, 2005

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

/************************************/
/* Return codes                     */
/************************************/

const int SQL_ERROR = 0;
const int SQL_SUCCESS = 1;

/************************************/
/* Function prototypes              */
/************************************/

// Setup placeholders for ODBC requests and responses
void SQLInit();

// Execute statement in sSQL
void SQLExecDirect(string sSQL);

// Position cursor on next row of the resultset
// Call this before using SQLGetData().
// returns: SQL_SUCCESS if there is a row
//          SQL_ERROR if there are no more rows
int SQLFetch();

// * deprecated. Use SQLFetch instead.
// Position cursor on first row of the resultset and name it sResultSetName
// Call this before using SQLNextRow() and SQLGetData().
// returns: SQL_SUCCESS if result set is not empty
//          SQL_ERROR is result set is empty
int SQLFirstRow();

// * deprecated. Use SQLFetch instead.
// Position cursor on next row of the result set sResultSetName
// returns: SQL_SUCCESS if cursor could be advanced to next row
//          SQL_ERROR if there was no next row
int SQLNextRow();

// Return value of column iCol in the current row of result set sResultSetName
string SQLGetData(int iCol);

// Return a string value when given a location
string APSLocationToString(location lLocation);

// Return a location value when given the string form of the location
location APSStringToLocation(string sLocation);

// Return a string value when given a vector
string APSVectorToString(vector vVector);

// Return a vector value when given the string form of the vector
vector APSStringToVector(string sVector);




/*
// Set oObject's persistent string variable sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void SetPersistentString(object oObject, string sVarName, string sValue, int iGlobal = FALSE, int iExpiration = 0, string sTable = "pwdata");
void SetPersistentString2(string sPlayer, string sTag, string sVarName, string sValue, int iGlobal = FALSE, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent integer variable sVarName to iValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void SetPersistentInt(object oObject, string sVarName, int iValue, int iGlobal = FALSE, int iExpiration = 0, string sTable = "pwdata");
void SetPersistentInt2(string sPlayer, string sTag, string sVarName, int iValue, int iGlobal = FALSE, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent float variable sVarName to fValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void SetPersistentFloat(object oObject, string sVarName, float fValue, int iGlobal = FALSE, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent location variable sVarName to lLocation
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
//   This function converts location to a string for storage in the database.
void SetPersistentLocation(object oObject, string sVarName, location lLocation, int iGlobal = FALSE, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent vector variable sVarName to vVector
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
//   This function converts vector to a string for storage in the database.
void SetPersistentVector(object oObject, string sVarName, vector vVector, int iGlobal = FALSE, int iExpiration = 0, string sTable = "pwdata");

// Set oObject's persistent object with sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwobjdata)
void SetPersistentObject(object oObject, string sVarName, object oObject2, int iGlobal = FALSE, int iExpiration = 0, string sTable = "pwobjdata");

// Get oObject's persistent string variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: ""
string GetPersistentString(object oObject, string sVarName, int iGlobal = FALSE, string sTable = "pwdata");

//
string GetPersistentString2(string sPlayer, string sTag, string sVarName, int iGlobal = FALSE, string sTable = "pwdata");

// Get oObject's persistent integer variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
int GetPersistentInt(object oObject, string sVarName, int iGlobal = FALSE, string sTable = "pwdata");

// Get oObject's persistent float variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
float GetPersistentFloat(object oObject, string sVarName, int iGlobal = FALSE, string sTable = "pwdata");

// Get oObject's persistent location variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
location GetPersistentLocation(object oObject, string sVarname, int iGlobal = FALSE, string sTable = "pwdata");

// Get oObject's persistent vector variable sVarName
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
// * Return value on error: 0
vector GetPersistentVector(object oObject, string sVarName, int iGlobal = FALSE, string sTable = "pwdata");

// Get oObject's persistent object sVarName
// Optional parameters:
//   sTable: Name of the table where object is stored (default: pwobjdata)
// * Return value on error: 0
object GetPersistentObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID, int iGlobal = FALSE, string sTable = "pwobjdata");

// Delete persistent variable sVarName stored on oObject
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
void DeletePersistentVariable(object oObject, string sVarName, int iGlobal = FALSE, string sTable = "pwdata");

// Deletes all persistent variables in sTable
// Optional parameters:
//   sTable: Name of the table where variable is stored (default: pwdata)
void DeleteAllPersistentVariables(object oObject, int iGlobal = FALSE, string sTable = "pwdata");
*/

// (private function) Replace special character ' with ~
string SQLEncodeSpecialChars(string sString);

// (private function)Replace special character ' with ~
string SQLDecodeSpecialChars(string sString);

string GetDbString(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata");
void SetDbString(object oObject, string sVarName, string sValue, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata");

void SetDbInt(object oObject, string sVarName, int iValue, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata");
int GetDbInt(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata");

void SetDbFloat(object oObject, string sVarName, float fValue, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata");
float GetDbFloat(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata");

void SetDbLocation(object oObject, string sVarName, location lLocation, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata");
location GetDbLocation(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata");

void SetDbVector(object oObject, string sVarName, vector vVector, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata");
vector GetDbVector(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata");

void SetDbObject(object oOwner, string sVarName, object oObject, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwobjdata");
// TODO MAY NEED TO FIX THIS!!!!!
object GetDbObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID, int bGlobal = FALSE, string sTable = "pwobjdata");

void DeleteDbVariable(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata");

void DeleteAllDbVariables(object oObject, int bGlobal = FALSE, string sTable = "pwdata");

//************************************
//* Implementation                   *
//************************************

// Functions for initializing APS and working with result sets

void SQLInit()
{
    int i;

    // Placeholder for ODBC persistence
    string sMemory;

    for (i = 0; i < 8; i++)     // reserve 8*128 bytes
        sMemory +=
            "................................................................................................................................";

    SetLocalString(GetModule(), "NWNX!ODBC!SPACER", sMemory);
}

void SQLExecDirect(string sSQL)
{
    SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sSQL);
}

int SQLFetch()
{
    string sRow;
    object oModule = GetModule();

    SetLocalString(oModule, "NWNX!ODBC!FETCH", GetLocalString(oModule, "NWNX!ODBC!SPACER"));
    sRow = GetLocalString(oModule, "NWNX!ODBC!FETCH");
    if (GetStringLength(sRow) > 0)
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", sRow);
        return SQL_SUCCESS;
    }
    else
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", "");
        return SQL_ERROR;
    }
}

// deprecated. use SQLFetch().
int SQLFirstRow()
{
    return SQLFetch();
}

// deprecated. use SQLFetch().
int SQLNextRow()
{
    return SQLFetch();
}

string SQLGetData(int iCol)
{
    int iPos;
    string sResultSet = GetLocalString(GetModule(), "NWNX_ODBC_CurrentRow");

    // find column in current row
    int iCount = 0;
    string sColValue = "";

    iPos = FindSubString(sResultSet, "¬");
    if ((iPos == -1) && (iCol == 1))
    {
        // only one column, return value immediately
        sColValue = sResultSet;
    }
    else if (iPos == -1)
    {
        // only one column but requested column > 1
        sColValue = "";
    }
    else
    {
        // loop through columns until found
        while (iCount != iCol)
        {
            iCount++;
            if (iCount == iCol)
                sColValue = GetStringLeft(sResultSet, iPos);
            else
            {
                sResultSet = GetStringRight(sResultSet, GetStringLength(sResultSet) - iPos - 1);
                iPos = FindSubString(sResultSet, "¬");
            }

            // special case: last column in row
            if (iPos == -1)
                iPos = GetStringLength(sResultSet);
        }
    }

    return sColValue;
}

// These functions deal with various data types. Ultimately, all information
// must be stored in the database as strings, and converted back to the proper
// form when retrieved.

string APSVectorToString(vector vVector)
{
    return "#POSITION_X#" + FloatToString(vVector.x) + "#POSITION_Y#" + FloatToString(vVector.y) +
        "#POSITION_Z#" + FloatToString(vVector.z) + "#END#";
}

vector APSStringToVector(string sVector)
{
    float fX, fY, fZ;
    int iPos, iCount;
    int iLen = GetStringLength(sVector);

    if (iLen > 0)
    {
        iPos = FindSubString(sVector, "#POSITION_X#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#POSITION_Y#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "#POSITION_Z#") + 12;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sVector, iPos, iCount));
    }

    return Vector(fX, fY, fZ);
}

string APSLocationToString(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);
    float fOrientation = GetFacingFromLocation(lLocation);
    string sReturnValue;

    if (GetIsObjectValid(oArea))
        sReturnValue =
            "#AREA#" + GetTag(oArea) + "#POSITION_X#" + FloatToString(vPosition.x) +
            "#POSITION_Y#" + FloatToString(vPosition.y) + "#POSITION_Z#" +
            FloatToString(vPosition.z) + "#ORIENTATION#" + FloatToString(fOrientation) + "#END#";

    return sReturnValue;
}

location APSStringToLocation(string sLocation)
{
    location lReturnValue;
    object oArea;
    vector vPosition;
    float fOrientation, fX, fY, fZ;

    int iPos, iCount;
    int iLen = GetStringLength(sLocation);

    if (iLen > 0)
    {
        iPos = FindSubString(sLocation, "#AREA#") + 6;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        oArea = GetObjectByTag(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_X#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_Y#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#POSITION_Z#") + 12;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sLocation, iPos, iCount));

        vPosition = Vector(fX, fY, fZ);

        iPos = FindSubString(sLocation, "#ORIENTATION#") + 13;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fOrientation = StringToFloat(GetSubString(sLocation, iPos, iCount));

        lReturnValue = Location(oArea, vPosition, fOrientation);
    }

    return lReturnValue;
}

// Problems can arise with SQL commands if variables or values have single quotes
// in their names. These functions are a replace these quote with the tilde character

string SQLEncodeSpecialChars(string sString)
{
    if (FindSubString(sString, "'") == -1)      // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "'")
            sReturn += "~";
        else
            sReturn += sChar;
    }
    return sReturn;
}

string SQLDecodeSpecialChars(string sString)
{
    if (FindSubString(sString, "~") == -1)      // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == "~")
            sReturn += "'";
        else
            sReturn += sChar;
    }
    return sReturn;
}
//void main(){}


void SQLExecStatement(string sSQL, string sStr0="",
            string sStr1="", string sStr2="", string sStr3="", string sStr4="",
            string sStr5="", string sStr6="", string sStr7="", string sStr8="",
            string sStr9="", string sStr10="", string sStr11="", string sStr12="",
            string sStr13="", string sStr14="", string sStr15="");

void SQLExecStatement(string sSQL, string sStr0="",
            string sStr1="", string sStr2="", string sStr3="", string sStr4="",
            string sStr5="", string sStr6="", string sStr7="", string sStr8="",
            string sStr9="", string sStr10="", string sStr11="", string sStr12="",
            string sStr13="", string sStr14="", string sStr15="")
{
    int nPos, nCount = 0;

    string sLeft = "", sRight = sSQL;

    while ((nPos = FindSubString(sRight, "?")) >= 0) {
        string sInsert;

        switch (nCount++) {
            case 0:  sInsert = sStr0; break;
            case 1:  sInsert = sStr1; break;
            case 2:  sInsert = sStr2; break;
            case 3:  sInsert = sStr3; break;
            case 4:  sInsert = sStr4; break;
            case 5:  sInsert = sStr5; break;
            case 6:  sInsert = sStr6; break;
            case 7:  sInsert = sStr7; break;
            case 8:  sInsert = sStr8; break;
            case 9:  sInsert = sStr9; break;
            case 10: sInsert = sStr10; break;
            case 11: sInsert = sStr11; break;
            case 12: sInsert = sStr12; break;
            case 13: sInsert = sStr13; break;
            case 14: sInsert = sStr14; break;
            case 15: sInsert = sStr15; break;
            default: sInsert = "*INVALID*"; break;
        }

        sLeft += GetStringLeft(sRight, nPos) + "'" + SQLEncodeSpecialChars(sInsert) + "'";
        sRight = GetStringRight(sRight, GetStringLength(sRight) - (nPos + 1));
    }

    SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sLeft + sRight);
}

string GetDbString(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata"){
    string sTag;

    if(bGlobal && GetLocalInt(oObject, "pc_is_pc")){
        sTag = GetLocalString(oObject, "pc_player_name");
    }
    else sTag = GetTag(oObject);

    sTag = SQLEncodeSpecialChars(sTag);
    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS)
        return SQLDecodeSpecialChars(SQLGetData(1));
    else
        return "";
}

void SetDbString(object oObject, string sVarName, string sValue, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata"){
    string sTag;

    if(bGlobal && GetLocalInt(oObject, "pc_is_pc")){
        sTag = GetLocalString(oObject, "pc_player_name");
    }
    else sTag = GetTag(oObject);

    sTag = SQLEncodeSpecialChars(sTag);
    sVarName = SQLEncodeSpecialChars(sVarName);
    sValue = SQLEncodeSpecialChars(sValue);

//    SQLExecStatement("UPDATE " + sTable + " SET val=? );

    string sSQL = "SELECT tag FROM " + sTable + " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS){
        // row exists
        sSQL = "UPDATE " + sTable + " SET val='" + sValue +
            "',expire=" + IntToString(iExpiration) + " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
        SQLExecDirect(sSQL);
    }
    else{
        // row doesn't exist
        sSQL = "INSERT INTO " + sTable + " (tag,name,val,expire) VALUES" +
            "('" + sTag + "','" + sVarName + "','" + sValue + "'," + IntToString(iExpiration) + ")";
        SQLExecDirect(sSQL);
    }
}

void SetDbInt(object oObject, string sVarName, int iValue, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata"){
    SetDbString(oObject, sVarName, IntToString(iValue), iExpiration, bGlobal, sTable);
}

int GetDbInt(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata"){
    object oModule;
    string sTag;

    if(bGlobal && GetLocalInt(oObject, "pc_is_pc")){
        sTag = GetLocalString(oObject, "pc_player_name");
    }
    else sTag = GetTag(oObject);

    sTag = SQLEncodeSpecialChars(sTag);
    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    oModule = GetModule();
    SetLocalString(oModule, "NWNX!ODBC!FETCH", "-2147483647");
    return StringToInt(GetLocalString(oModule, "NWNX!ODBC!FETCH"));
}

void SetDbFloat(object oObject, string sVarName, float fValue, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata"){
    SetDbString(oObject, sVarName, FloatToString(fValue), iExpiration, bGlobal, sTable);
}

float GetDbFloat(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata"){
    object oModule;
    string sTag;

    if(bGlobal && GetLocalInt(oObject, "pc_is_pc")){
        sTag = GetLocalString(oObject, "pc_player_name");
    }
    else sTag = GetTag(oObject);

    sTag = SQLEncodeSpecialChars(sTag);
    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    oModule = GetModule();
    SetLocalString(oModule, "NWNX!ODBC!FETCH", "-340282306073709650000000000000000000000.000000000");
    return StringToFloat(GetLocalString(oModule, "NWNX!ODBC!FETCH"));
}

void SetDbLocation(object oObject, string sVarName, location lLocation, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata"){
    SetDbString(oObject, sVarName, APSLocationToString(lLocation), iExpiration, bGlobal, sTable);
}

location GetDbLocation(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata"){
    return APSStringToLocation(GetDbString(oObject, sVarName, bGlobal, sTable));
}

void SetDbVector(object oObject, string sVarName, vector vVector, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata"){
    SetDbString(oObject, sVarName, APSVectorToString(vVector), iExpiration, bGlobal, sTable);
}

vector GetDbVector(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata"){
    return APSStringToVector(GetDbString(oObject, sVarName, bGlobal, sTable));
}

void SetDbObject(object oOwner, string sVarName, object oObject, int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwobjdata"){
    string sTag;

    if(bGlobal && GetLocalInt(oOwner, "pc_is_pc")){
        sTag = GetLocalString(oOwner, "pc_player_name");
    }
    else sTag = GetTag(oOwner);

    sTag = SQLEncodeSpecialChars(sTag);
    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT tag FROM " + sTable + " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS){
        // row exists
        sSQL = "UPDATE " + sTable + " SET val=%s,expire=" + IntToString(iExpiration) +
            " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
        SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
        StoreCampaignObject ("NWNX", "-", oObject);
    }
    else
    {
        // row doesn't exist
        sSQL = "INSERT INTO " + sTable + " (tag,name,val,expire) VALUES" +
            "('" + sTag + "','" + sVarName + "',%s," + IntToString(iExpiration) + ")";
        SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
        StoreCampaignObject ("NWNX", "-", oObject);
    }
}

// TODO MAY NEED TO FIX THIS!!!!!
object GetDbObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID, int bGlobal = FALSE, string sTable = "pwobjdata"){
    string sTag;

    if(bGlobal && GetLocalInt(oObject, "pc_is_pc")){
        sTag = GetLocalString(oObject, "pc_player_name");
    }
    else sTag = GetTag(oObject);

    sTag = SQLEncodeSpecialChars(sTag);
    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
    SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);

    if (!GetIsObjectValid(oOwner))
        oOwner = oObject;
    return RetrieveCampaignObject ("NWNX", "-", GetLocation(oOwner), oOwner);
}

void DeleteDbVariable(object oObject, string sVarName, int bGlobal = FALSE, string sTable = "pwdata"){
    string sTag;

    if(bGlobal && GetLocalInt(oObject, "pc_is_pc")){
        sTag = GetLocalString(oObject, "pc_player_name");
    }
    else sTag = GetTag(oObject);

    sTag = SQLEncodeSpecialChars(sTag);
    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "DELETE FROM " + sTable + " WHERE tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);
}

void DeleteAllDbVariables(object oObject, int bGlobal = FALSE, string sTable = "pwdata"){
    string sTag;

    if(bGlobal && GetLocalInt(oObject, "pc_is_pc")){
        sTag = GetLocalString(oObject, "pc_player_name");
    }
    else sTag = GetTag(oObject);

    sTag = SQLEncodeSpecialChars(sTag);

    //sVarName = SQLEncodeSpecialChars(sVarName);
    string sSQL = "DELETE FROM " + sTable + " WHERE tag='" + sTag + "'";
    SQLExecDirect(sSQL);
}

/*
// These functions are responsible for transporting the various data types back
// and forth to the database.

void SetPersistentString(object oObject, string sVarName, string sValue, int iGlobal = FALSE,
                         int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata")
{
    string sPlayer;
    object oObject;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        if(iGlobal){
            sTag = "~";
        }
        else{
            sTag = SQLEncodeSpecialChars(GetName(oObject));
        }
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);
    sValue = SQLEncodeSpecialChars(sValue);

    string sSQL = "SELECT player FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS)
    {
        // row exists
        sSQL = "UPDATE " + sTable + " SET val='" + sValue +
            "',expire=" + IntToString(iExpiration) + " WHERE player='" + sPlayer +
            "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
        SQLExecDirect(sSQL);
    }
    else
    {
        // row doesn't exist
        sSQL = "INSERT INTO " + sTable + " (player,tag,name,val,expire) VALUES" +
            "('" + sPlayer + "','" + sTag + "','" + sVarName + "','" +
            sValue + "'," + IntToString(iExpiration) + ")";
        SQLExecDirect(sSQL);
    }
}

void SetPersistentString2(string sPlayer, object oObject, string sVarName, string sValue, int iGlobal = FALSE,
                         int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata")
{
    sPlayer = SQLEncodeSpecialChars(sPlayer);
    if(iGlobal) sTag = "~";
    else sTag = SQLEncodeSpecialChars(sTag);

    sVarName = SQLEncodeSpecialChars(sVarName);
    sValue = SQLEncodeSpecialChars(sValue);

    string sSQL = "SELECT player FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS)
    {
        // row exists
        sSQL = "UPDATE " + sTable + " SET val='" + sValue +
            "',expire=" + IntToString(iExpiration) + " WHERE player='" + sPlayer +
            "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
        SQLExecDirect(sSQL);
    }
    else
    {
        // row doesn't exist
        sSQL = "INSERT INTO " + sTable + " (player,tag,name,val,expire) VALUES" +
            "('" + sPlayer + "','" + sTag + "','" + sVarName + "','" +
            sValue + "'," + IntToString(iExpiration) + ")";
        SQLExecDirect(sSQL);
    }
}

string GetPersistentString(object oObject, string sVarName, int iGlobal = FALSE,
                           string sTable = "pwdata"){
    string sPlayer;
    object oObject;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        if(iGlobal){
            sTag = "~";
        }
        else{
            sTag = SQLEncodeSpecialChars(GetName(oObject));
        }
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS)
        return SQLDecodeSpecialChars(SQLGetData(1));
    else
    {
        return "";
    }
}

string GetPersistentString2(string sPlayer, object oObject, string sVarName, int iGlobal = FALSE, string sTable = "pwdata"){

    sPlayer = SQLEncodeSpecialChars(sPlayer);
    if(iGlobal) sTag = "~";
    else sTag = SQLEncodeSpecialChars(sTag);

    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    if (SQLFetch() == SQL_SUCCESS)
        return SQLDecodeSpecialChars(SQLGetData(1));
    else
    {
        return "";
    }
}

void SetPersistentInt(object oObject, string sVarName, int iValue, int iGlobal = FALSE,
                      int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata")
{
    SetPersistentString(oObject, sVarName, IntToString(iValue), iGlobal, iExpiration, sTable);
}

void SetPersistentInt2(string sPlayer, object oObject,  string sVarName, int iValue, int iGlobal = FALSE,
                      int iExpiration = 0, int bGlobal = FALSE, string sTable = "pwdata")
{
    SetPersistentString2(sPlayer, sTag, sVarName, IntToString(iValue), iGlobal, iExpiration, sTable);
}

int GetPersistentInt(object oObject, string sVarName, int iGlobal = FALSE, string sTable = "pwdata")
{
    string sPlayer;
    object oObject;
    object oModule;

    if (GetIsPC(oObject))
    {
        sPlayer = SQLEncodeSpecialChars(GetPCPlayerName(oObject));
        if(iGlobal){
            sTag = "~";
        }
        else{
            sTag = SQLEncodeSpecialChars(GetName(oObject));
        }
    }
    else
    {
        sPlayer = "~";
        sTag = GetTag(oObject);
    }

    sVarName = SQLEncodeSpecialChars(sVarName);

    string sSQL = "SELECT val FROM " + sTable + " WHERE player='" + sPlayer +
        "' AND tag='" + sTag + "' AND name='" + sVarName + "'";
    SQLExecDirect(sSQL);

    oModule = GetModule();
    SetLocalString(oModule, "NWNX!ODBC!FETCH", "-2147483647");
    return StringToInt(GetLocalString(oModule, "NWNX!ODBC!FETCH"));
}



*/
