// Name     : Demo create table
// Purpose  : Create a table for persistent data
// Authors  : Ingmar Stieger
// Modified : February 02, 2005

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

#include "nwnx_inc"

void CreatePWDataTable(){
    SQLExecDirect("DROP TABLE pwdata");
    SendMessageToPC(GetLastUsedBy(), "Table 'pwdata' deleted.");
/*
    // For SQLite
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for SQLite...");
    SQLExecDirect("CREATE TABLE pwdata (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val text," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default current_timestamp," +
        "PRIMARY KEY (player,tag,name)" +
        ")");
*/
    // For MySQL

    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for MySQL...");
    SQLExecDirect("CREATE TABLE pwdata (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val text," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default CURRENT_TIMESTAMP," +
        "PRIMARY KEY  (player,tag,name)" +
        ") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

    // For Access
    /*
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for Access...");
    SQLExecDirect("CREATE TABLE pwdata (" +
                    "player text(64)," +
                    "tag text(64)," +
                    "name text(64)," +
                    "val memo," +
                    "expire text(4)," +
                    "last date)");
    */

    SendMessageToPC(GetLastUsedBy(), "Table 'pwdata' created.");
}

void CreateQSStatusTable(){
    SQLExecDirect("DROP TABLE qsstatus");
    SendMessageToPC(GetLastUsedBy(), "Table 'qsstatus' deleted.");
/*
    // For SQLite
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for SQLite...");
    SQLExecDirect("CREATE TABLE pwdata (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val text," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default current_timestamp," +
        "PRIMARY KEY (player,tag,name)" +
        ")");
*/
    // For MySQL

    SendMessageToPC(GetLastUsedBy(), "Creating Table 'qsstatus' for MySQL...");
    SQLExecDirect("CREATE TABLE qsstatus (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val text," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default CURRENT_TIMESTAMP," +
        "PRIMARY KEY  (player,tag,name)" +
        ") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

    // For Access
    /*
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for Access...");
    SQLExecDirect("CREATE TABLE pwdata (" +
                    "player text(64)," +
                    "tag text(64)," +
                    "name text(64)," +
                    "val memo," +
                    "expire text(4)," +
                    "last date)");
    */

    SendMessageToPC(GetLastUsedBy(), "Table 'qsstatus' created.");
}

void CreateSpellBookTable(){
    SQLExecDirect("DROP TABLE spellbook");
    SendMessageToPC(GetLastUsedBy(), "Table 'spellbook' deleted.");
/*
    // For SQLite
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for SQLite...");
    SQLExecDirect("CREATE TABLE pwdata (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val text," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default current_timestamp," +
        "PRIMARY KEY (player,tag,name)" +
        ")");
*/
    // For MySQL

    SendMessageToPC(GetLastUsedBy(), "Creating Table 'spellbook' for MySQL...");
    SQLExecDirect("CREATE TABLE spellbook (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val text," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default CURRENT_TIMESTAMP," +
        "PRIMARY KEY  (player,tag,name)" +
        ") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

    // For Access
    /*
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for Access...");
    SQLExecDirect("CREATE TABLE pwdata (" +
                    "player text(64)," +
                    "tag text(64)," +
                    "name text(64)," +
                    "val memo," +
                    "expire text(4)," +
                    "last date)");
    */

    SendMessageToPC(GetLastUsedBy(), "Table 'spellbook' created.");
}

void CreateQuickSlotTable(){
    SQLExecDirect("DROP TABLE quickslot");
    SendMessageToPC(GetLastUsedBy(), "Table 'quickslot' deleted.");
/*
    // For SQLite
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for SQLite...");
    SQLExecDirect("CREATE TABLE pwdata (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val text," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default current_timestamp," +
        "PRIMARY KEY (player,tag,name)" +
        ")");
*/
    // For MySQL

    SendMessageToPC(GetLastUsedBy(), "Creating Table 'quickslot' for MySQL...");
    SQLExecDirect("CREATE TABLE quickslot (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val text," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default CURRENT_TIMESTAMP," +
        "PRIMARY KEY  (player,tag,name)" +
        ") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

    // For Access
    /*
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwdata' for Access...");
    SQLExecDirect("CREATE TABLE pwdata (" +
                    "player text(64)," +
                    "tag text(64)," +
                    "name text(64)," +
                    "val memo," +
                    "expire text(4)," +
                    "last date)");
    */

    SendMessageToPC(GetLastUsedBy(), "Table 'quickslot' created.");
}

void CreatePWObjdataTable(){

    SQLExecDirect("DROP TABLE pwobjdata");
    SendMessageToPC(GetLastUsedBy(), "Table 'pwobjdata' deleted.");
/*
    // For SQLite
    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwobjdata' for SQLite...");
    SQLExecDirect("CREATE TABLE pwobjdata (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val blob," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default current_timestamp," +
        "PRIMARY KEY (player,tag,name)" +
        ")");
*/
    // For MySQL

    SendMessageToPC(GetLastUsedBy(), "Creating Table 'pwobjdata' for MySQL...");
    SQLExecDirect("CREATE TABLE pwobjdata (" +
        "player varchar(64) NOT NULL default '~'," +
        "tag varchar(64) NOT NULL default '~'," +
        "name varchar(64) NOT NULL default '~'," +
        "val blob," +
        "expire int(11) default NULL," +
        "last timestamp NOT NULL default CURRENT_TIMESTAMP," +
        "PRIMARY KEY  (player,tag,name)" +
        ") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

    SendMessageToPC(GetLastUsedBy(), "Table 'pwobjdata' created.");
}

void main(){
    CreatePWDataTable();
    CreateQSStatusTable();
    //CreateSpellBookTable();
    //CreateQuickSlotTable();
    CreatePWObjdataTable();
}
