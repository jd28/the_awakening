#include "mod_const_inc"

string GetGuildName(int nGuild){
    switch (nGuild){
        case GUILD_KNIGHTS_OF_THE_AWAKENING:
            return GUILD_KNIGHTS_OF_THE_AWAKENING_NAME;
        case GUILD_NEW_AWAKENING_GUARDIANS:
            return GUILD_NEW_AWAKENING_GUARDIANS_NAME;
        case GUILD_THE_SACRED_RIDERS:
            return GUILD_THE_SACRED_RIDERS_NAME;
        case GUILD_THE_LEGION_OF_DEATH:
            return GUILD_THE_LEGION_OF_DEATH_NAME;
        case GUILD_THE_DIRTY_DOZEN:
            return GUILD_THE_DIRTY_DOZEN_NAME;
        case GUILD_AWAKENING_ADVENTURERS:
            return GUILD_AWAKENING_ADVENTURERS_NAME;
        case GUILD_AWAKENING_ROLE_PLAYERS:
            return GUILD_AWAKENING_ROLE_PLAYERS_NAME;
    }

    return "";
}

string GetGuildAbbreviation(int nGuild){
    switch (nGuild){
        case GUILD_KNIGHTS_OF_THE_AWAKENING:
            return GUILD_KNIGHTS_OF_THE_AWAKENING_ABBRV;
        case GUILD_NEW_AWAKENING_GUARDIANS:
            return GUILD_NEW_AWAKENING_GUARDIANS_ABBRV;
        case GUILD_THE_SACRED_RIDERS:
            return GUILD_THE_SACRED_RIDERS_ABBRV;
        case GUILD_THE_LEGION_OF_DEATH:
            return GUILD_THE_LEGION_OF_DEATH_ABBRV;
        case GUILD_THE_DIRTY_DOZEN:
            return GUILD_THE_DIRTY_DOZEN_ABBRV;
        case GUILD_AWAKENING_ADVENTURERS:
            return GUILD_AWAKENING_ADVENTURERS_ABBRV;
        case GUILD_AWAKENING_ROLE_PLAYERS:
            return GUILD_AWAKENING_ROLE_PLAYERS_ABBRV;
    }

    return "";
}
