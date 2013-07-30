//::////////////////////////////////////////////////////////////////////////:://
//:: SIMTools V3.0 Speech Integration & Management Tools Version 3.0        :://
//:: Created By: FunkySwerve                                                :://
//:: Created On: April 4 2006                                               :://
//:: Last Updated: March 27 2007                                            :://
//:: With Thanks To:                                                        :://
//:: Dumbo - for his amazing plugin                                         :://
//:: Virusman - for Linux versions, and for the reset plugin, and for       :://
//::    his excellent events plugin, without which this update would not    :://
//::    be possible                                                         :://
//:: Dazzle - for his script samples                                        :://
//:: Butch - for the emote wand scripts                                     :://
//:: The DMFI project - for the languages conversions and many of the emotes:://
//:: Lanessar and the players of the Myth Drannor PW - for the new languages:://
//:: The players and DMs of Higher Ground for their input and playtesting   :://
//::////////////////////////////////////////////////////////////////////////:://
/*Changelog
V3.1
-Fixed a bug causing area targetable commands to remprompt targeting after the command targeter was used.
-Fixed a bug preventing the command targeter from being used to confirm delete commands.

V3.0 - Includes some Linux-only features, including command completion and a new events plugin, noted below.
-Added dozens of new commands, emotes, and languages:
  -added emotes: 'nope'; 'sy' and 'sway'; 'hl' and 'hello'; 'tp' and 'trip'; 'co' and 'collapse';
    'lie'; 'rt' and 'rest'; 'lk' and 'look'; 'cn' and 'chant'; 'wl' and 'wail'; 'mn' and 'moan'; 'gn'
    and 'groan'; smoke shortcut changed from 'sm' to 'sk'; 'sm' and 'scream'; 'sz' and 'sneeze';
    'spit' (male only); 'snarl'; 'bk' and 'bark'; 'hw' and 'howl'; 'ht' and 'hoot';
    mock shortcut chaged from 'mo' to 'mk'; 'mw' and 'meow'; 'mo' and 'moo'; 'screech'; 'rr' and 'roar';
    'tt' and 'toast' (male only); 'bh' and 'belch' (male only); 'bp' and 'burp' (male only);
    'hp' and 'hiccup' (male only); 'kn' and 'kneel'; 'gw' and 'guffaw'; 'cr' and 'chortle'; 'bye';
    'gt' and 'goodnight'; 'gb' and 'goodbye'; 'cry'; 'sb' and 'sob'; 'wp' and 'weep'; 'ow' and 'ouch';
    'cg' and 'cough'; 'choke';
  -added languages: Troll, Thri-Kreen, Grimlock, Half-Orc, Kuo-Toan, Kenderspeak, Minotaur, Rakshasa,
    Stinger, Lizardman, Illithid, Hobgoblin, Duergar, Bugbear, Githzerai, Korred, Sahaguin, Yuan-Ti, Pixie,
    Magic, Sirensong, Hengeyokai, Svirfneblin, High Shou, Psionic, Averial, Kobold, Necromantic, Ogre
  -added commands:
    help, settail, setwings, delete, wpnone
  -added dm_ commands:
    dm_align_chaos, dm_align_evil, dm_align_good, dm_align_law, dm_fac_a_allally, dm_fac_a_allfoe,
    dm_fac_a_peace, dm_fac_a_reset, dm_fac_c_allally, dm_fac_c_allfoe, dm_fac_c_peace, dm_fac_c_reset,
    dm_fac_m_allally, dm_fac_m_allfoe, dm_fac_m_peace, dm_fac_m_reset, dm_fac_p_allally, dm_fac_p_allfoe,
    dm_fac_p_peace, dm_fac_p_reset, dm_givepartyxp, dm_givepartylevel, dm_takepartyxp, dm_takepartylevel,
    dm_item_id, dm_item_destroy_all, dm_item_destroy_equip, dm_item_destroy_inv, dm_help, dm_boot, dm_sql,
    dm_rest, dm_reveal, dm_hide, dm_jump, dm_portpartyhere, dm_portpartyhell, dm_portpartyjail, dm_portpartyleader,
    dm_portpartythere, dm_portpartytown, dm_setcha, dm_setcon, dm_setdex, dm_setint, dm_setstr, dm_setwis,
    dm_setfort, dm_setreflex, dm_setwill, dm_settime, dm_setvarint, dm_setvarfloat, dm_setvarstring,
    dm_setvarmodint, dm_setvarmodfloat, dm_setvarmodstring, dm_getvarint, dm_getvarfloat, dm_getvarstring,
    dm_getvarmodint, dm_getvarmodfloat, dm_getvarmodstring, dm_setweather_a_clear, dm_setweather_a_rain,
    dm_setweather_a_reset, dm_setweather_a_snow, dm_setweather_m_clear, dm_setweather_m_rain, dm_setweather_m_reset,
    dm_setweather_m_snow, dm_spawn, dm_vent
-Added command completion, which pops up menus to assist the user when a command or emote is entered
    incorrectly (Linux only).
-Added a Command Targeter, to allow much greater freedom in targeting commands. They may still be
    targeted via tell, but if they are not, the user will be prompted to target by either using the
    Command Targeter or by sending a tell with the !target command.
-Added a channel muting option for silenced characters.
-SIMTools now utilzes a new nwx plugin, nwnx_events by Virusman, which allows users to hook events
    like onattacked, onpickpocket, and more. It also allows detection of conversation node #s via
    script, greatly reducing the number of scripts required for conversations (Linux only).

V2.1
-Colored language text is now correctly translated.
-PROCESS_NPC_SPEECH option now set to TRUE by default. It must be on to prevent
    PCs from evading the ignore feature by possessing their familars.
-Added levels to party list in playerinfo.
-Fixed a bug allowing evasion of talking while dead blocks with the emote symbol.
-You can now speak languages in Whisper.

V2.0
-Added an option to redirect chat from languages, metachannels, and message fowarding to the chat log
    instead of the combat log. This results in a green [Tell] box before text, but prevents the messages
    from being lost from combat scrolling. The ootion is turned on, by default. Thanks to virusman and
    dumbo for the new functionality!
-Moved the NPC listening switch from the ini file to the configuration script, for easier access.
    Thanks to dumbo for the improved functionality!
-Added an option to disable tracking of silent channels while still processing NPC speech, which will
    cut down on scriptcalls but still allows DMs possessing NPCs to have their speech processed. Thanks
    to both dumbo and virusman for the new option!
-Fixed some minor typos introduced in version 1.4.

V1.4
-Added dozens of emotes, based on dmfi emotes, with two-letter shortcuts for most.
-Modified emote handling so that other messages beginning with the emote symbol would not show as
    invalid emotes, unless they were in shout channel. This will allow people to use the * prefix
    for emote commands an still allow normal use of *-prefixed emote sentences, which seemed like
    a more natural setup than forcing a different emote symbol.
-Added a silent lore check option for language recognition and comprehension checks, included in a
    modified GetIsSkillSuccessful function because GISS was bugged in 1.67 Linux.
-Added a switch in the nwnx_ini file to allow processing of npc messages, which allows dms possessing
    npcs to have their speech processed. Credit to dumbo and virusman for the added functionality!
    The switch is off by default. To turn it on, just remove the ; from before the ;processnpc=1 line
    to uncomment it and have SIMTools process NPC speech, and then save.
-Added an escape string option. Adding it to the beginning of the string in a SpeakString call will
    prevent the speaker from translating the string if they are in 'speak another language' mode. It's
    useful for text you don't ever want to be translated, like loot notification messsages. You can set
    it to whatever string you want, of whatever length, so long as it does not begin with your command
    symbol (default is !), your emote symbol (default is *), or the forward slash channel designator (/).
    It should only be used for TALKVOLUME_TALK SpeakStrings, as they are the only volume subject to
    translation.
-Added the nwnx reset plugin and a dm command to reset the server from ingame, dm_reset. Unlike
    calling StartNewModule, the reset plugin stops the nwserver process, clearing the memory to
    eliminate lag buildup.
-Added !d4 and !d10 commands to complete the dice set.
-Updated the playerinfo command to provide more information.
-Added the anon command to hide some of the information given by the playerinfo command, and the unanon
    command to remove anonymous status.
-Corrected the description of the metakick command.
-Added dm commands to award and remove experience and levels: dm_givexp, dm_givelevel, dm_takexp,
    and dm_takelevel.
-Minor bugfix to allow subraces to give characters multiple languages.
-Moved all the strings in the scriptset to a const file to make the task of translating them into other
    languages simpler. If anyone does take the time to translate the whole file, please send it to me so
    I can add it to the scriptset.

V1.3
-Added 39 new languages, provided by Lanessar and the players of the Myth Drannor PW.
-Added the DM Voice Thrower item, to tag objects for use with the ventrilo command. The current script
    uses tag-based scripting, but can easily be converted if you use a single onactivate script. Switch to
    tag-based already! :P
-Added 9 new DM commands:
    /v - (the ventrilo command) when ever you enter this channel prefix, the speech you type is spoken by
        the object you tagged with the DM Voice Thrower Item instead. Works on PCs, creatures, items,
        placeables, and so on. Lots of fun, and a potential mischiefmaker!
    dm_change_appear - sets target appearance to the specified appearance constant (ala the console command)
    dm_change_appear base - restores target appearance (only works with 1- NWNX or 2- Bioware DB with
        languages enabled)
    dm_fx - applys any vfx in the game, at any duration, to the target
    dm_fx_loc - applys any vfx in the game, at any duration, to the target's location
    dm_fx_rem - removes all vfx applied by the sender of the tell to the target
    dm_fx_list_* -lists vfx name and numbers by type, lith 6 types: dur, bea, eye, imp, com, fnf
    dm_learn - teaches the target a specified language
    dm_unlearm - removes knowledge from the target of the specified language
-Added 6 new scripting commands:
    !list languages - lists all the languages the player can speak
    !list alllanguages - lists all the available languages SIMTools has to offer
    !setname - sets an item matching the name input in the speakers inventory to the new name input
    !setname all - same as setname but switches all items of that name
    !skillcheck - does a skillcheck for the player for the specified skill and dc
    !list skills - lists the skill names and numbers for easy input into the skillcheck

V1.2
-Added DMFI languages! Characters may now speak all the languages from the DMFI scriptset, either with
  one-liner commands or via on/off toggles. Their typing appears as the language selected, and their listeners
  (in either talk or party channels) get lore checks to either 1) comprehend the speech if they don't
  know it (optional) or 2) to recognize what language it is. Characters will gain languages on levelup,
  if they add a language-speaking class, and may learn additional languages if you choose to allow it.
  There is a sample language teacher in the test mod provided as an example of how to add languages to PCs.
-Added the dm_create command, so that DMs can create items specified by resrefs.
-Fixed a bug with dm_unbanshout that was leaving characters banned again after a reset.

V1.1
-Added an admin designation with seperate (and potentially greater) powers than the dm designation.
  This may create a little confusion, because 'DM' is now a distinct designation, as well as describing
  whether the person is logged in using the DM client. To summarize, the system has 4 potential sets
  of persons who it treats distinctly:
  ---
  People listed in the VerifyDMKey function (or 'designated DMs') who are logged in with DM client - DMDMs
  People listed in the VerifyDMKey function (or 'designated DMs') who are logged in with PC client - DMPCs
  People listed in the VerifyAdminKey function (or 'designated admins') who are logged in with DM client - AdminDMs
  People listed in the VerifyAdminKey function (or 'designated admins') who are logged in with PC client - ADminPCs
  ---
  You need not know these designations, but they may help clarify the toggles below.
-Added the ability to designate your own emote and command prefix symbols, instead of '*' and '!'.
-Fixed the dm_ignoremeta command. It was unimplemented (oops).
-Fixed the TOWN destination, it was set to JAIL.
-Now only DMs are given the target's ip with the !playerinfo command. Security concerns.
-Broke the disable speech on death option down by channel, so that players acan still use some channels,
  and added the option to prevent use of metachannel while dead.
-Cleaned up the main function using wrapper functions, to make the structure clearer, and optimized it a bit.
*/

const int USING_LINUX = TRUE;//Set this to TRUE if you are using Linux instead of Windows. The Linux version of the
//chat plugin has some added functionality which allows popup conversations with command completion when a command
//or emote is misentered.

const int USING_NWNX_DB = TRUE;//Set this to TRUE if you are using NWNX/APS persistence ints. Leave
//it set to FALSE otherwise, or if you are unsure what this means. The persistence ints in these scripts
//use the default APS database and columns, so if you did not customize your MySQL/MySQLite database they are
//ready to use.

const int PROCESS_NPC_SPEECH = TRUE;//Leave this set this to TRUE if you want speech from NPCs to be processed through SIMTools.
//This means that all channels (including silent channels) will be monitored. It is useful for processing the speech
//of DMs possesssing NPCs. It's also necessary if you want to prevent avoidance of the ignore function by PCs possessing
//their familiars. The only downside is the increased number of scriptcalls generated, but the effect on performance should
//not be noticeable.

const int IGNORE_SILENT_CHANNELS = TRUE;//This switch turns off processing of silent channel speech if you have chosen to
//process NPC speech with the PROCESS_NPC_SPEECH speech above. This is important because monsters communicate across
//the entire module using the silent channels, and processing them could result in a greatly increased number of
//scriptcalls. You should only set this switch to FALSE if you plan to add to the functionality of SIMTools in a way
//that requires processing of silent channels. The current SIMTools scripts do not rely on processing silent channels
//at all, and DMs possessing NPCs will still have their speech processed with IGNORE_SILENT_CHANNELS set to TRUE.

const int TEXT_LOGGING_ENABLED = FALSE;//Set to TRUE to send all messages to the text log.

const int SPAMBLOCK_ENABLED = TRUE;//Set this to FALSE to turn off spam blocker. It is intended to
//stop advertising of other servers on yours.

const string DM_COMMAND_SYMBOL = "dm_";

const string EMOTE_SYMBOL = "*";//Set this to whatever single character you want players to access the emotes
//with. It is recommended that you select only a normally unused symbol, because any line beginning with this
//symbol will be seen by the system as an attempted emote, and suppressed accordingly (with an 'invalid emote'
//warning if they aren't among the listed emotes). ONLY A SINGLE CHARACTER MAY BE USED. Do not choose the
//forward slash (/), or metachannels and languages will not work. You may simply choose to use the default
//asterisk symbol, if you prefer. If you select a symbol other than the asterisk, the list commands and list
//emotes functions will display the correct symbol automatically, but you will have to change the descriptions
//of the 2 command list items to reflect the change, if you plan to use them and want them to be accurate.

const string COMMAND_SYMBOL = "!";//Set this to whatever single character you want players to access the
//commands with. It is recommended that you select only a normally unused symbol, because any line beginning
//with this symbol will be seen by the system as an attempted emote, and suppressed accordingly (with an
//'invalid emote' warning if they aren't among the listed emotes). ONLY A SINGLE CHARACTER MAY BE USED. YOU
//MUST PICK A DIFFERENT SYMBOL THAN THE ONE YOU CHOOSE FOR EMOTES, OR THE COMMANDS WILL NOT WORK. Do not
//choose the forward slash (/), or metachannels will not work. You may simply choose to use the default
//exclamation mark symbol, if you prefer. If you select a symbol other than the exclamation mark, the list commands
//and list emotes functions will display the correct symbol automatically, but you will have to change the
//descriptions of the 2 command list items to reflect the change, if you plan to use them and want them to be accurate.

const int ENABLE_WEAPON_VISUALS = TRUE;//Set this to TRUE to allow players to change the vfx on their weapons
//via the !wp commands.

const int ENABLE_PLAYER_SETNAME = TRUE;//Set this to TRUE to allow players to use the !setname command.

const int ENABLE_PLAYER_SETTAILWINGS = FALSE;//Set this to TRUE to allow players to use the !settail and !setwings commands.

const int ENABLE_METALANGUAGE_CONVERSION = FALSE;//Set this to FALSE to stop common metagame chat like 'lol'
//from being converted to emotes like *Laughs out loud* when spoken in the talk channel. Currently only 'lol'
//is converted, more will be added.

/////////////////////////////////Message Routing////////////////////////////////

const int SEND_CHANNELS_TO_CHAT_LOG = TRUE;//Set this to FALSE if you want languages, listening, and metachannels
//sent to the combat log instead of the chat log. This will elimimate the [Tell] bracketed text in front of messages
//but can make messages harder for players to read.

////////////////////////////////Listening Options///////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
//DM Listening//////////////////////////////////////////////////////////////////
const int DMS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the VerifyDMKey function
//who are logged in as DMs to receive all player tell messages.
//
const int DM_PLAYERS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the VerifyDMKey
//function who are logged in as players to receive all player tell messages in their combat logs. It will
//NOT route tells to people logged in as DMs, so you should use both this and the above command if you
//want both. Neither of the above commands will route tells from DMs.
//
const int DM_PLAYERS_HEAR_DM = FALSE;//Set this to TRUE if you want people listed in the VerifyDMKey
//function who are logged in as players to receive all DM messages in their combat logs. This will route
//DM messages to anyone with a cdkey you list below, if they are logged as a player. It will route DM
//messages from both players and DMs. People listed in the VerifyDMKey function who are logged as players
//will have the option to ignore these messages if this option is enabled, via the dm_ignoredm command.
//
//Admin Listening///////////////////////////////////////////////////////////////
const int ADMIN_DMS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the VerifyAdminKey
//function who are logged in as DMs to receive all player tell messages.
//
const int ADMIN_PLAYERS_HEAR_TELLS = FALSE;//Set this to TRUE if you want people listed in the VerifyAdminKey
//function who are logged in as players to receive all tell messages in their combat logs. It will NOT route
//tells to people logged in as DMs, so you should use both this and the above command if you want both.
//Neither of the above commands will route tells from DMs.
//
const int ADMIN_PLAYERS_HEAR_DM = FALSE;//Set this to TRUE if you want administrators logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the VerifyAdminKey function, if they are logged as a player. It will route DM messages from
//both players and DMs. DMs logged as players will have the option to ignore these messages if this option
//is enabled, via the dm_ignoredm command.
//
//General Listening/////////////////////////////////////////////////////////////
const int ENABLE_DM_TELL_ROUTING = FALSE;//Set this to TRUE if you want tells from the DM tell channel
//routed as well as tells from the player channel. This is dependant on what channel is used, and not on
//player/dm/admin status.
//
const int DM_TELLS_ROUTED_ONLY_TO_ADMINS = FALSE;//Set this to TRUE if you want DM tells routed to
//administrators (people with cd keys listed in the VerifyAdminKey function) but not to DMs (people with
//cd keys listed in the VerifyAdminKey function. You should leave the above function set to FALSE if you
//enable this.


//////////////////////////////////Metachannels//////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//Metachannels are added chat channels. They are very similar to the party channel, in that players
//control who is in their metachannel via invites. They may invite whomever they like, however, and
//are not limited to the members of their party. There is no set number of metachannels; rather, a
//metachannel is created whenever a player wants. The first invite sent out determines who the 'leader'
//of the metachannel is. When that invite is accepted, the inviter becomes the leader of a new metachannel.
//From that point on, any messages that any member types that begin with '/m' will be sent to every member
//of the metachannel, via the combat log. Metachannels will be logged with other text if you enable
//text logging. If you are uncertain what use these channels could be put to, the whole reason that I
//implemented them at all was for guild use on my PW, but I'm certain they will find other uses.
////////////////////////////////////////////////////////////////////////////////
//
const int ENABLE_METACHANNELS = TRUE;//Set this to FALSE if you do not want players to have access
//to metachannels.
//
const int DMS_HEAR_META = FALSE;//Set this to TRUE if you want DMs to receive all player metamessages. DMs
//will have the option to ignore these messages with the command dm_ignoremeta. If a DM is also in a
//metachannel, it will not duplicate the messages (like NWN does with party channel when a DM joins a party).
//
const int DM_PLAYERS_HEAR_META = FALSE;///Set this to TRUE if you want DMs logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the VerifyDMKey function, if they are logged as a player. It will NOT route metamessages
//to people logged in as DMs, so you should use both this and the above command if you want both. DMs
//logged in as players will have the option to ignore these messages with the command dm_ignoremeta.
//If a DM is also in a metachannel, it will not duplicate the messages (like NWN does with party channel
//when a DM joins a party).
//
const int ADMIN_DMS_HEAR_META = FALSE;//Set this to TRUE if you want administrators logged in as DMs to receive
//all player metamessages. Administrators will have the option to ignore these messages with the command
//dm_ignoremeta. If a administrator is also in a metachannel, it will not duplicate the messages
//(like NWN does with party channel when a DM joins a party).
//
const int ADMIN_PLAYERS_HEAR_META = FALSE;///Set this to TRUE if you want administrators logged in as players
//to receive all DM messages in their combat logs. This will route DM messages to anyone with a cdkey you
//list below in the VerifyAdminKey function,if they are logged as a player. It will NOT route metamessages
//to people logged in as DMs, so you should use both this and the above command if you want both.
//Administrators logged in as players will have the option to ignore these messages with the command
//dm_ignoremeta. If an administrator is also in a metachannel, it will not duplicate the messages
//(like NWN does with party channel when a DM joins a party).

/////////////////////////Conditional Channel Disabling//////////////////////////
////////////////////////////////////////////////////////////////////////////////
const int DISALLOW_SPEECH_WHILE_DEAD = FALSE;//Set to TRUE to disable speech by dead players on one,
//several, or all chat channels. Then set the constants for the channels you want to disable to TRUE.
//These channels will only block player speakers, not DM speakers, and not DMs logged in as players. Emotes
//and Commands are automatically blocked on all channels when the player using them is dead.

const int DISABLE_DEAD_TALK    = FALSE;
const int DISABLE_DEAD_SHOUT   = FALSE;
const int DISABLE_DEAD_WHISPER = FALSE;
const int DISABLE_DEAD_TELL    = FALSE;
const int DISABLE_DEAD_PARTY   = FALSE;
const int DISABLE_DEAD_DM      = FALSE;

const int DISALLOW_METASPEECH_WHILE_DEAD = FALSE;//Set to TRUE to disable speech by dead players on
//metachannels. This setting is seperate from the above commands, and can be enabled even if
//DISALLOW_SPEECH_WHILE_DEAD is left equal to FALSE.

const int DISALLOW_SPEECH_WHILE_SILENCED = FALSE;//Set to TRUE to disable speech by silenced players on one,
//several, or all chat channels. Then set the constants for the channels you want to disable to TRUE.
//These channels will only block player speakers, not DM speakers, and not DMs logged in as players.

const int DISABLE_SILENCED_TALK    = FALSE;
const int DISABLE_SILENCED_SHOUT   = FALSE;
const int DISABLE_SILENCED_WHISPER = FALSE;
const int DISABLE_SILENCED_TELL    = FALSE;
const int DISABLE_SILENCED_PARTY   = FALSE;
const int DISABLE_SILENCED_DM      = FALSE;

const int DISALLOW_METASPEECH_WHILE_SILENCED = FALSE;//Set to TRUE to disable speech by silenced players on
//metachannels. This setting is seperate from the above commands, and can be enabled even if
//DISALLOW_SPEECH_WHILE_SILENCED is left equal to FALSE.

//////////////////////////Permanent Channel Disabling///////////////////////////
////////////////////////////////////////////////////////////////////////////////
const int ENABLE_PERMANENT_CHANNEL_MUTING = FALSE;//Set this to TRUE if you want to permanently disable
//one, several, or all chat channels. Then set the constants for the channels you want to disable to TRUE.
//These channels will only block player speakers, not DM speakers, and not DMs logged in as players.
//Disabling a channel will ONLY prevent text from displaying on that channel. Emotes and commands can still
//be entered on it.

const int PERMANENT_CHANNEL_MUTING_FOR_PC_ONLY = TRUE;//Set this to FALSE to have permanent channel muting affect
//NPCs as well as PCs. Server shouts will be unaffacted.

const int DISABLE_TALK_CHANNEL    = FALSE;
const int DISABLE_SHOUT_CHANNEL   = FALSE;
const int DISABLE_WHISPER_CHANNEL = FALSE;
const int DISABLE_TELL_CHANNEL    = FALSE;
const int DISABLE_PARTY_CHANNEL   = FALSE;
const int DISABLE_DM_CHANNEL      = FALSE;


//////////////////////////////DM_PORT DESTINATIONS//////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//If you want the DM commands dm_porthell, dm_portjail, and dm_porttown to work, you must specify the tags
//of their waypoints here.
//dm_porthell
const string LOCATION_HELL = "FKY_WAY_HELL"; //Replace FKY_WAY_HELL with the tag of your 'hell' waypoint.
//dm_portjail
const string LOCATION_JAIL = "FKY_WAY_JAIL"; //Replace FKY_WAY_JAIL with the tag of your 'jail' waypoint.
//dm_porttown
const string LOCATION_TOWN = "FKY_WAY_TOWN"; //Replace FKY_WAY_TOWN with the tag of your 'town' waypoint.

////////////////////////CHARACTER EDITING WITH LETOSCRIPT///////////////////////
////////////////////////////////////////////////////////////////////////////////
//If you want the DM commands dm_setcha, dm_setcon, dm_setdex, dm_setint, dm_setstr, dm_setwis, dm_setfort,
//dm_setreflex, dm_setwill, and the standard command !delete to work, you must specify your servervault path
//here so that leto can locate the character files to edit them. These commands will not work on a localvault
//server. The character is booted after each command so that the file can be edited. Sample windows and linux
//servervault paths are shown below. Leaving this const blank will disable the commands above.
const string VAULTPATH_CHAT = "";
//const string VAULTPATH_CHAT = "C:/NeverwinterNights/NWN/servervault/";//windows sample
//const string VAULTPATH_CHAT = "/home/funkyswerve/nwn/servervault/";//linux sample

const int LETO_FOR_ADMINS_ONLY = FALSE; //Set this to TRUE if you want to prevent dungeon masters from
//using the leto DM commands. DMs and players can still use the !delete command, unless you change the
//DMS_CAN_DELETE and PLAYERS_CAN_DELETE consts, below, to FALSE.

const int ALREADY_USING_LETO = TRUE; //Set this to TRUE if you are already using letoscript elsewhere in
//your module (most likely for subraces). If you don't know what this means leave this set to FALSE. This
//will prevent some conflicts that might arise in the onclientexit event. If you set this to TRUE and the
//SIMTools leto commands stop working, you will need to set it back to FALSE and make edits to your onclientexit
//script to prevent conflict between your leto scripts and SIMTools. Or, if you decide that you would rather
//not use the SIMTools leto functions because of a conflict, just set this to TRUE, and leave the VAULTPATH_CHAT
//const above set to "".

const int SAFE_DELETE = FALSE; //Set this to TRUE if you do not want the !delete command to actually delete the
//characte file. If you do this it will simply rename the file to a .utc extension, so that it will not appear
//in the player's character selection screen, but can be retrieved simply by renaming the file back to a
//.bic extension. The only downside to enabling this option is that it will interfere with later leto edits of
//characters of the same name in that player's vault, if those leto edits use a method that converts the file to
//.utc format before editing (as SIMTools edits do).

const int DMS_CAN_DELETE = FALSE; //Set this to FALSE if you do not want DMs to be able to delete characters
//with the !delete command. The delete commmand allows deletion of the targeted character, though only DMs
//and admins can target characters besides their own.

const int PLAYERS_CAN_DELETE = TRUE; //Set this to FALSE if you do not want players to be able to delete
//their own characters with the !delete command.

//Copied Verification to pc_verify_inc

///////////////////////////////////Languages////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
const int ENABLE_LANGUAGES = FALSE;//Set this to FALSE if you do not want players to be able to speak
//different languages.
//
const string ESCAPE_STRING = "&&";//Adding this escape string to the beginning of a SpeakString call will
//prevent the speaker from translating the string if they are in 'speak another language' mode. The excape
//string is automatically filtered out of what they say, whether or not they are speaking another language
//at the time. It's useful for adding to the begging of strings in scripts that you don't ever want to be
//translated, like loot notification messsages. You can set it to whatever string you want, of whatever
//length, so long as it does not begin with your command symbol (default is !), your emote symbol
//(default is *), or the forward slash channel designator (/). It should only be used for TALKVOLUME_TALK
//SpeakStrings, as they are the only volume subject to translation.
//
const int ENABLE_FULL_LANGUAGE_LIST_FOR_PLAYERS = FALSE;//Set this to true if you want players to be able
//to see the full list of languages available. The !list alllanguages command was created primarily for DMs
//to use when 'teaching' a player a language, but you may want to allow them to see them all. In either case,
//they will be able to see the languages that their character can speak with the !list languages command.
//
//Language Storage Object Tag and Resref////////////////////////////////////////
//This object is used ONLY if you left USING_NWNX_DB set to FALSE above. The slow speed of the Bioware
//database makes it impractical for the number of database reads that the languages system requires
//the first oncliententer of every character each reset, so local ints stored on an item are used instead.
//These ints will be saved across server resets if the character file is saved via ExportSingleCharacter(), AND
//if the character is a PC. DM characters cannot store ints on inventory items across resets. If you want
//to use another object to store language information, you may enter the tag and resref of that object
//below. The system will autmatically create that Item on the PC oncliententer if they do not have one,
//mark it with whatever languages the character can speak based on class, race, and subrace, and then make
//it undroppable via the SetItemCursedFlag function.
const string TAG_OF_LANGUAGE_STORAGE_OBJECT = "languagestone";
const string RESREF_OF_LANGUAGE_STORAGE_OBJECT = "languagestone";

//Lore to Recognize/Understand Languages////////////////////////////////////////

const int LORE_NEEDED_TO_RECOGNIZE_LANGUAGE = 20;//Set this number equal to the lore check difficulty
//you want for chatacters to recognize what language is being spoken. Language recognition is automatic if
//they speak the language.

const int LORE_ALLOWS_LANGUAGE_COMPREHENSION = TRUE;//Set this to FALSE if you do not want high lore skills
//to enable characters to not only recognize but to understand languages they cannot speak.

const int SILENT_LORE_CHECKS = FALSE;//Set this to TRUE if you want the Lore checks for language recognition
//to be performed silently instead of being displayed.

//This function defines what lore skill difficulty check must be passed in order to not just recognize a
//foreign language but to comprehend it. If you disable LORE_ALLOWS_LANGUAGE_COMPREHENSION by setting it to
//FALSE then this function does nothing. You can set the lore values to whatever suits your module.
int GetLoreNeededToComprehendLanguage(int nLanguage);

int GetLoreNeededToComprehendLanguage(int nLanguage)
{
    int nReturn = 120;//defaults to highest possible in case of error
    switch(nLanguage/10)
    {
        case 0:
        switch(nLanguage)
        {
            case 1: nReturn = 60; break;//Dwarven
            case 2: nReturn = 30; break;//Algarondan
            case 3: nReturn = 35; break;//Alzhedo
            case 4: nReturn = 105; break;//Aquan
            case 5: nReturn = 95; break;//AssassinsCant
            case 6: nReturn = 100; break;//Auran
            case 7: nReturn = 30; break;//Chessentan
            case 8: nReturn = 35; break;//Chondathan
            case 9: nReturn = 65; break;//Elven
        }
        break;
        case 1:
        switch(nLanguage)
        {
            case 10: nReturn = 45; break;//Chultan
            case 11: nReturn = 40; break;//Damaran
            case 12: nReturn = 30; break;//Dambrathan
            case 13: nReturn = 105; break;//DrowSign
            case 14: nReturn = 85; break;//Druidic
            case 15: nReturn = 60; break;//Gnomish
            case 16: nReturn = 35; break;//Durpari
            case 17: nReturn = 55; break;//Giant
            case 18: nReturn = 75; break;//Gnoll
            case 19: nReturn = 40; break;//Halardrim
        }
        break;
        case 2:
        switch(nLanguage)
        {
            case 20: nReturn = 30; break;//Halruaan
            case 21: nReturn = 100; break;//Ignan
            case 22: nReturn = 35; break;//Illuskan
            case 23: nReturn = 55; break;//Halfling
            case 24: nReturn = 30; break;//Imaskar
            case 25: nReturn = 30; break;//Lantanese
            case 26: nReturn = 40; break;//Midani
            case 27: nReturn = 35; break;//Mulhorandi
            case 28: nReturn = 40; break;//Nexalan
            case 29: nReturn = 35; break;//Oillusk
        }
        break;
        case 3:
        switch(nLanguage)
        {
            case 30: nReturn = 30; break;//Rashemi
            case 31: nReturn = 35; break;//Raumvira
            case 32: nReturn = 85; break;//Drow
            case 33: nReturn = 40; break;//Serusan
            case 34: nReturn = 45; break;//Shaaran
            case 35: nReturn = 30; break;//Shou
            case 36: nReturn = 85; break;//Sylvan
            case 37: nReturn = 105; break;//Animal
            case 38: nReturn = 35; break;//Talfiric
            case 39: nReturn = 35; break;//Tashalan
        }
        break;
        case 4:
        switch(nLanguage)
        {
            case 40: nReturn = 105; break;//Terran
            case 41: nReturn = 90; break;//Treant
            case 42: nReturn = 50; break;//Tuigan
            case 43: nReturn = 30; break;//Turmic
            case 44: nReturn = 95; break;//Cant
            case 45: nReturn = 35; break;//Uluik
            case 46: nReturn = 60; break;//Undercommon
            case 47: nReturn = 40; break;//Untheric
            case 48: nReturn = 45; break;//Vaasan
            case 49: nReturn = 70; break;//Goblin
        }
        break;
        case 5:
        switch(nLanguage)
        {
            case 50: nReturn = 80; break;//Troll
            case 51: nReturn = 85; break;//Thri-kreen
            case 52: nReturn = 90; break;//Grimlock
            case 53: nReturn = 60; break;//Helf-orc
            case 54: nReturn = 75; break;//Kuo-toan
            case 55: nReturn = 45; break;//Kenderspeak
            case 56: nReturn = 75; break;//Orc
            case 57: nReturn = 75; break;//Minotaur
            case 58: nReturn = 90; break;//Rakshasa
            case 59: nReturn = 80; break;//Stinger
        }
        break;
        case 6:
        switch(nLanguage)
        {
            case 60: nReturn = 70; break;//Lizardman
            case 61: nReturn = 110; break;//Illithid
            case 62: nReturn = 65; break;//Hobgoblin
            case 63: nReturn = 80; break;//Draconic
            case 64: nReturn = 70; break;//Duergar
            case 65: nReturn = 75; break;//Bugbear
            case 66: nReturn = 105; break;//Githzerai
            case 67: nReturn = 80; break;//Korred
            case 68: nReturn = 75; break;//Sahaguin
            case 69: nReturn = 85; break;//Yuan-ti
        }
        break;
        case 7:
        switch(nLanguage)
        {
            case 70: nReturn = 90; break;//Pixie
            case 71: nReturn = 120; break;//Magic
            case 72: nReturn = 120; break;//Infernal
            case 73: nReturn = 60; break;//Siren song
            case 74: nReturn = 65; break;//Hengeyokai
            case 75: nReturn = 55; break;//Svirfneblin
            case 76: nReturn = 60; break;//High Shou
            case 77: nReturn = 200; break;//Psionic
            case 78: nReturn = 70; break;//Averial
            case 79: nReturn = 50; break;//Kobold
        }
        break;
        case 8:
        switch(nLanguage)
        {
            case 80: nReturn = 120; break;//Necromantic
            case 81: nReturn = 125; break;//Abyssal
            case 82: nReturn = 50; break;//Ogre
            case 89: nReturn = 115; break;//Celestial
        }
        break;
        case 9:
        switch(nLanguage)
        {
            case 99: nReturn = 20; break;//Leetspeak
        }
        break;
    }
    return nReturn;
}

//Subrace Languages/////////////////////////////////////////////////////////////
//
//Some languages are attained only by learning or being of a certain subrace. These functions tell what
//subraces get what languages. I have filled in the ones I use on my PW as an example. Because subrace
//names vary from PW to PW, you will probably have to change mine to match yours. If the player's race
//has already guaranteed him the language because it is required for the subrace, you need not list the
//subrace here (though doing so won't cause any problems). Of course, the player can get one language
//from his race and a second from his subrace. Leetspeak is included only for purposes of completeness. If
//you modify subrace names after creation you will have to 'teach' the character the appropriate language
//when you do, because these are only checked the first time a character enters the server. An example
//language teacher conversation is included in the demo module. If you have disabled languages you may
//ignore these settings completely.

int SubraceSpeaksDrow(string sSubrace)//List the subraces you want to be able to speak drow here.
{
    if (sSubrace == "Elf - Drow" ||
        sSubrace == "Drider" ||
        sSubrace == "Drey" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksAnimal(string sSubrace)//List the subraces you want to be able to speak animal here.
{
    if (sSubrace == "Half-Elf - Dryadkin" ||
        sSubrace == "Half-Elf - Nymphkin" ||
        sSubrace == "Half-Elf - Nereidkin" ||
        sSubrace == "Half-Satyr" ||
        sSubrace == "Treant" ||
        sSubrace == "Atomie" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksGoblin(string sSubrace)
{
    if (sSubrace == "Humanoid - Goblin" ||
        sSubrace == "Humanoid - Hobgoblin" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksOrcish(string sSubrace)
{
    if (sSubrace == "Humanoid - Orc" ||
        sSubrace == "Humanoid - Deep Orc" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksDraconic(string sSubrace)
{
    if (sSubrace == "Half-Dragon - Black" ||
        sSubrace == "Half-Dragon - Blue" ||
        sSubrace == "Half-Dragon - Green" ||
        sSubrace == "Prismatic" ||
        sSubrace == "Half-Dragon - Red" ||
        sSubrace == "Half-Dragon - White" ||
        sSubrace == "Humanoid - Kobold" ||
        sSubrace == "Lizardfolk" ||
        sSubrace == "Humanoid - Yuan-Ti" ||
        sSubrace == "Hound Archon" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksInfernal(string sSubrace)
{
    if (((sSubrace == "Tiefling") && (d8() > 4)) ||  //There's a 50% chance Tieflings will speak Infernal.
        sSubrace == "Planewalker" ||                 //If not, then they will speak Abyssal.
        sSubrace == "Erinyes" ||
        sSubrace == "Half-Fiend" ||
        sSubrace == "Half-Kyton" ||
        sSubrace == "Hound Archon" ||
        sSubrace == "Kolyarut" ||
        sSubrace == "Maelephant" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksAbyssal(string sSubrace)
{
    if (sSubrace == "Tiefling" ||
        sSubrace == "Planewalker" ||
        sSubrace == "Kolyarut" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksCelestial(string sSubrace)
{
    if (sSubrace == "Aasimar" ||
        sSubrace == "Planewalker" ||
        sSubrace == "Fallen Angel" ||
        sSubrace == "Genie" ||
        sSubrace == "Half-Celestial" ||
        sSubrace == "Hound Archon" ||
        sSubrace == "Kolyarut" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksLeetspeak(string sSubrace)
{
    if (sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}

int SubraceSpeaksAquan(string sSubrace)
{
    if (sSubrace == "PT - Water Genasi" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksAuran(string sSubrace)
{
    if (sSubrace == "PT - Air Genasi" ||
        sSubrace == "Genie" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksGiant(string sSubrace)
{
    if (sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksGnoll(string sSubrace)
{
    if (sSubrace == "Humanoid - Gnoll" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksIgnan(string sSubrace)
{
    if (sSubrace == "PT - Fire Genasi" ||
        sSubrace == "Genie" ||
        sSubrace == "Salamander" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksSylvan(string sSubrace)
{
    if (sSubrace == "Half-Elf - Dryadkin" ||
        sSubrace == "Half-Elf - Nymphkin" ||
        sSubrace == "Half-Elf - Nereidkin" ||
        sSubrace == "Half-Satyr" ||
        sSubrace == "Pixie" ||
        sSubrace == "Fey - Satyr" ||
        sSubrace == "Treant" ||
        sSubrace == "Atomie" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksTerran(string sSubrace)
{
    if (sSubrace == "PT - Earth Genasi" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksTreant(string sSubrace)
{
    if (sSubrace == "Treant" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksDrowSign(string sSubrace)
{
    if (sSubrace == "Elf - Drow" ||
        sSubrace == "Drider" ||
        sSubrace == "Drey" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksUndercommon(string sSubrace)
{
    if (sSubrace == "Elf - Drow" ||
        sSubrace == "Drider" ||
        sSubrace == "Drey" ||
        sSubrace == "Illithid" ||
        sSubrace == "Gnome - Svirfneblin" ||
        sSubrace == "Dwarf - Duergar" ||
        sSubrace == "Dwarf - Derrzagon" ||
        sSubrace == "Dwarf - Deep Dwarf" ||
        sSubrace == "Dwarf - Derro" ||
        sSubrace == "Rilminai" ||
        sSubrace == "XXXXYYYY" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksTroll(string sSubrace)
{
    if (sSubrace == "Troll" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksThriKreen(string sSubrace)
{
    if (sSubrace == "Thri-Kreen" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksGrimlock(string sSubrace)
{
    if (sSubrace == "Humanoid - Grimlock" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksKuoToan(string sSubrace)
{
    if (sSubrace == "Kuo-Toa" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksKenderspeak(string sSubrace)
{
    if (sSubrace == "Kender" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksMinotaur(string sSubrace)
{
    if (sSubrace == "Minotaur" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksRakshasa(string sSubrace)
{
    if (sSubrace == "Rakshasa" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksStinger(string sSubrace)
{
    if (sSubrace == "Stinger" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksLizardMan(string sSubrace)
{
    if (sSubrace == "Lizardfolk" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksIllithid(string sSubrace)
{
    if (sSubrace == "Illithid" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksHobgoblin(string sSubrace)
{
    if (sSubrace == "Humanoid - Hobgoblin" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksDuergar(string sSubrace)
{
    if (sSubrace == "Dwarf - Duergar" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksBugBear(string sSubrace)
{
    if (sSubrace == "Humanoid - Bugbear" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksGithzerai(string sSubrace)
{
    if (sSubrace == "Githzerai" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksKorred(string sSubrace)
{
    if (sSubrace == "Korred" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksSahaguin(string sSubrace)
{
    if (sSubrace == "Sahaguin" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksYuanTi(string sSubrace)
{
    if (sSubrace == "Humanoid - Yuan-Ti" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksPixie(string sSubrace)
{
    if (sSubrace == "Pixie" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksSirenSong(string sSubrace)
{
    if (sSubrace == "Siren" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksHengeyokai(string sSubrace)
{
    if (sSubrace == "Hengeyokai" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksSvirfneblin(string sSubrace)
{
    if (sSubrace == "Gnome - Svirfneblin" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksPsionic(string sSubrace)
{
    if (sSubrace == "Illithid" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksAverial(string sSubrace)
{
    if (sSubrace == "Averial" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksKobold(string sSubrace)
{
    if (sSubrace == "Humanoid - Kobold" ||
        sSubrace == "XXXXYYYY")
    {
        return TRUE;
    }
    else return FALSE;
}
int SubraceSpeaksOgre(string sSubrace)
{
    if (sSubrace == "Half-Ogre" ||
        sSubrace == "Ogre")
    {
        return TRUE;
    }
    else return FALSE;
}
//void main(){}

