#include "srv_funcs_inc"

void main(){
    object oMod = GetModule();

    //:: Written By: Shayan.
    //:: Contact: mail_shayan@yahoo.com
    //
    // Description: Sets the correct time of the day for the players.
    int iHour               = GetTimeHour ();
    int iMinute             = GetTimeMinute ();
    int iSecond             = GetTimeSecond ();
    int iMillisecond        = GetTimeMillisecond();
    struct CPUUsage cpu     = GetProcessCPUUsage();
    int nMemory             = GetProcessMemoryUsage();

    SetTime(iHour, iMinute, iSecond, iMillisecond);

    // HG
    int nUptime, nRealTime, timekeeper;
    string sBootTime = IntToString(GetLocalInt(oMod, "BootTime"));
    SQLExecDirect("SELECT UNIX_TIMESTAMP() - " + sBootTime + ", UNIX_TIMESTAMP()");
    if (SQLFetch() == SQL_SUCCESS) {
        nUptime = StringToInt(SQLGetData(1));
        SetLocalInt(oMod, "uptime", nUptime);
        nRealTime = StringToInt(SQLGetData(2));
        SetLocalInt(oMod, "realtime", nRealTime);
    }

    /* check for auto-reset */
    // HG
    if (nUptime >= GetLocalInt(oMod, "LastMessageCheck") + 60) {
        SetLocalInt(oMod, "LastMessageCheck", nUptime);

        // Check reset
        timekeeper = GetLocalInt(GetModule(), "MOD_RESET_TIMER")+1;
        SetLocalInt(GetModule(), "MOD_RESET_TIMER", timekeeper);
        if (timekeeper >= SRV_RESET_LENGTH - 45){
            SetLocalInt(GetModule(), "MOD_RESET_STARTED", 1);
            ResetMessageHandler(timekeeper);
        }
        string sMsg = "LOG : mod_heartbeat : ";
        sMsg += "Up Time: " + IntToString(nUptime);
        sMsg += " : Real Time: " + IntToString(nUptime);
        sMsg += " : Timer: " + IntToString(timekeeper);
        sMsg += " : CPU Usage, User: " + FloatToString(cpu.user);
        sMsg += " : CPU Usage, System: " + FloatToString(cpu.sys);
        sMsg += " : Memory Usage: " + IntToString(nMemory);
        WriteTimestampedLogEntry(sMsg);
    }
}
