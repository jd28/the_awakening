#include "mod_funcs_inc"

void DeliverMail(object oCreature);

void DeliverMail(object oCreature){
    string sSQLName = SQLEncodeSpecialChars(GetPCPlayerName(oCreature));
    string sSQLDB = "SELECT msg_to, msg_from, val FROM msg_system WHERE msg_to = '"+sSQLName+"'";
    string sMessage, sDebug;
    object oMail;

    SQLExecDirect(sSQLDB);
    while(SQLFetch() != SQL_ERROR){
        sMessage = "To: "+ SQLDecodeSpecialChars(SQLGetData(1)) + "\n";
        sMessage += "From: "+ SQLDecodeSpecialChars(SQLGetData(2)) + "\n\n";
        sMessage += SQLDecodeSpecialChars(SQLGetData(3));

        oMail = CreateItemOnObject("sa_mail", oCreature);
        SetIdentified(oMail, TRUE);
        SetDescription(oMail, sMessage, TRUE);
    }

    sSQLDB = "DELETE FROM msg_system WHERE msg_to='" + sSQLName + "'";
    SQLExecDirect(sSQLDB);
}
