#include "pl_dlg_include_i"
#include "pl_pclevel_inc"

// Proper Order should be Stat, Skill, Feat Spells...
const string WELCOME_CONFIRM = "welcome_confirm";

const string CLASS_SELECT = "class_select";
const string CLASS_CONFIRM = "class_confrim";

const string STAT_SELECT = "stat_select";
const string STAT_CONFIRM = "stat_confirm";

const string SKILL_SELECT = "skills_select";
const string SKILL_CONFIRM = "skills_confirm";

const string FEAT_SELECT = "feat_select";
const string FEAT_CONFIRM = "feat_confirm";

const string SIXPOINTONE_PAGE = "spells_ask";
const string SIXPOINTTWO_PAGE = "spells_level";
const string SIXPOINTTHREE_PAGE = "spells_remove_select";
const string SIXPOINTFOUR_PAGE = "spells_replace_select";
const string SIXPOINTFIVE_PAGE = "spells_confirm";
const string SIXPOINTSIX_PAGE = "spells_gain_level";
const string SIXPOINTSEVEN_PAGE = "spells_gain_list";
const string SIXPOINTEIGHT_PAGE = "spells_gain_confirm";
const string SEVENTH_PAGE = "final_confirm";

void BuildFeatList(object pc, int nStartFeat, int nInterval, float fDelay) {
    int feat, nCount2;
	int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
	int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos)) - 1;

    DelayCommand(fDelay, BuildFeatList(pc, nStartFeat-nInterval, nInterval, fDelay));

    for (feat = nStartFeat; feat > (nStartFeat-nInterval); feat--) {
        if (feat < 0)
            return;
        if (GetIsValidFeat(feat) &&
			GetIsFeatAvailable(pc, feat, class)) {
            string sList = "feat_select";

            string sMaster = Get2DAString("feat", "MASTERFEAT", feat);
            int nMaster = StringToInt(sMaster);

            if (nMaster > 0 || sMaster == "0") {
                sList += IntToString(-(nMaster + 1));

                if (GetElementCount(sList, pc) == 0) {
                    nCount2 = AddStringElement("Main feat list ...", sList, pc);
                    ReplaceIntElement(nCount2 - 1, -1, sList, pc);

                    sMaster = GetStringByStrRef(StringToInt(Get2DAString("masterfeats", "STRREF", nMaster))) + " ...";
                    nCount2 = AddStringElement(sMaster, "feat_select", pc);
                    ReplaceIntElement(nCount2 - 1, -(nMaster + 1), "feat_select", pc);
   		        }
            }

            nCount2 = AddStringElement(GetFeatName(feat), sList, pc);
            ReplaceIntElement(nCount2 - 1, feat, sList, pc);

        }
    }
}

void BuildSkillList(object pc, int rebuild = FALSE){
   	//Skill Response List
	int i, count, class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
	int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos)) - 1;
	string sCrossClass;

	if(rebuild)
		DeleteList(SKILL_SELECT, pc);

	if(GetElementCount(SKILL_SELECT, pc) != 0)
		return;

	for(i = 0; i < 28; i++){
		if (GetIsSkillAvailable(pc, i, class)){ //if the PC can take the skill, it is displayed
			if (GetSkillCost(class, i) == 2)
	           	sCrossClass = " [Cross-Class]";
		    else
    			sCrossClass = "";

    	    count = AddStringElement(GetSkillName(i) + sCrossClass, SKILL_SELECT, pc );
        	ReplaceIntElement(count - 1, i, SKILL_SELECT, pc); //store the skill int with the skill
   		}
    }
   	AddStringElement ("I cannot or do not wish to select any more skills at this time.", SKILL_SELECT, pc );
}

int GetHasSpellLevel(object pc, int cls, int cls_level, int sp_level){
    int ability = ABILITY_CHARISMA;
    string twoda, sValue;

    switch (cls){
        case CLASS_TYPE_WIZARD:
            ability = ABILITY_INTELLIGENCE;
            twoda = "cls_spgn_wiz";
        break;
        case CLASS_TYPE_SORCERER:
            twoda = "cls_spgn_sorc";
        break;
        case CLASS_TYPE_BARD:
            twoda = "cls_spgn_bard";
        break;
    }

    if(GetAbilityScore(pc, ability, TRUE) - sp_level - 10 < 0)
        return FALSE;

    sValue = Get2DAString(twoda, "SpellLevel"+IntToString(sp_level), cls_level);
    if(sValue == "****")
        return FALSE;

    return TRUE;
}

void BuildSpellLevelList(object pc, int gain = TRUE, string page = SIXPOINTSIX_PAGE){
	int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
	int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos)) - 1;
    int class_level = GetLocalInt(pc, "LL_CLASSLEVEL_"+IntToString(class_pos)) + 1;
    int max = 10, i, count;

    DeleteList(page, pc);//must build the next page here based on their selection

    if(class == CLASS_TYPE_BARD)
        max = 7;

    //if(class == CLASS_TYPE_WIZARD || GetLocalInt(pc, "LL_SPKN_0") > 0)
    //    AddStringElement("Cantrips", page, pc );

    for(i = 1; i < max; i++){
        if(GetHasSpellLevel(pc, class, class_level , i)
           && (!gain || class == CLASS_TYPE_WIZARD || GetLocalInt(pc, "LL_SPKN_"+IntToString(i)) > 0)){
            count = AddStringElement("Level "+IntToString(i), page, pc );
            //SendMessageToPC(pc, IntToString(count) + " " + IntToString(i));
            ReplaceIntElement(count - 1, i, page, pc);
            //SendMessageToPC(pc, "IntElt: " + IntToString(GetIntElement(count - 1, page, pc)));
        }
    }
    AddStringElement("No, I want to start over.", page, pc );
}
void BuildKnownSpellList(object pc, int spell_level){
	int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
	int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos)) - 1;
	int known_spells = GetTotalKnownSpells(pc, class, spell_level);
	int spell, i, count;

	for(i = 0; i < known_spells; i++){
		spell = GetKnownSpell(pc, class, spell_level, i);
		count = AddStringElement(GetSpellName(spell), SIXPOINTTHREE_PAGE, pc );
        ReplaceIntElement(count - 1, spell, SIXPOINTTHREE_PAGE, pc);
	}
    AddStringElement ("Nevermind, I don't want to replace any more spells.", SIXPOINTTHREE_PAGE, pc );
}

void BuildUnknownSpellList(object pc, int spell_level, string page){
	int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
	int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos)) - 1;
	int i, count, innate, knows, selection;
    string sValue, sClass;

    if(class == CLASS_TYPE_BARD)
        sClass = "Bard";
    else
        sClass = "Wiz_Sorc";

    //SendMessageToPC(pc, IntToString(spell_level));

    DeleteList(page, pc);//must build the next page here based on their selection
    if( GetElementCount(page, pc) != 0 )
		return;

	for(i = 0; i < 570; i++){
        sValue = Get2DAString("spells", sClass, i);
        if(sValue == "****")
            continue;

        innate = StringToInt(sValue);
	    knows = GetKnowsSpell(i, pc, class);
		if (innate != spell_level || knows)
			continue;

        count = AddStringElement(GetSpellName(i), page, pc );
        ReplaceIntElement(count - 1, i, page, pc);
        selection++;
    }
/*
    if (selection == 0){
        AddStringElement ("I am unable to gain any more spells.", SIXPOINTONE_PAGE, pc );
    }
*/
}

int GetPositionByClass(object pc, int class){
    if(GetClassByPosition(1, pc) == class)
        return 1;
    if(GetClassByPosition(2, pc) == class)
        return 2;
    if(GetClassByPosition(3, pc) == class)
        return 3;

    return -1;
}

void Init(){

    object pc = GetPcDlgSpeaker();
    string page = GetDlgPageString();
    int nSkill, nFeat, nCount = 0, nCount2 = 0, nCount3;
    string sCrossClass;
	int level = GetLocalInt(pc, "LL_LEVEL");

    if( page == "" ){
        if( GetElementCount(WELCOME_CONFIRM, pc) == 0){
            AddStringElement("Yes.", WELCOME_CONFIRM, pc );
            AddStringElement("No. I want to start over.", WELCOME_CONFIRM, pc );
        }

		if(GetElementCount(CLASS_SELECT, pc) == 0){
            if(GetSubRace(pc) == "Paragon"){
                int class = GetControlClass(pc);
			    AddStringElement(GetClassName(class), CLASS_SELECT, pc);
                ReplaceIntElement(0, GetPositionByClass(pc, class), CLASS_SELECT, pc);

            }
            else {
		    	int class = GetLocalInt(pc, "LL_CLASS_1") - 1;
			    AddStringElement(GetClassName(class), CLASS_SELECT, pc);
                ReplaceIntElement(0, 1, CLASS_SELECT, pc);

    			class = GetLocalInt(pc, "LL_CLASS_2") - 1;
			    if(class >= 0){
			    	AddStringElement(GetClassName(class), CLASS_SELECT, pc);
            	    ReplaceIntElement(1, 2, CLASS_SELECT, pc);
			    }
		    	class = GetLocalInt(pc, "LL_CLASS_3") - 1;
	    		if(class >= 0){
    				AddStringElement(GetClassName(class), CLASS_SELECT, pc);
            	    ReplaceIntElement(2, 3, CLASS_SELECT, pc);
			    }
            }
            //AddStringElement("No. I want to start over.", CLASS_SELECT, pc );
		}
		if(GetElementCount(CLASS_CONFIRM, pc) == 0){
            AddStringElement("Yes.", CLASS_CONFIRM, pc );
            AddStringElement("No. I want to start over.", CLASS_CONFIRM, pc );
		}

        //Stat Response List
        if( GetElementCount(STAT_SELECT, pc ) == 0){
            AddStringElement("Strength", STAT_SELECT, pc );
            ReplaceIntElement(0, ABILITY_STRENGTH, STAT_SELECT, pc);
            AddStringElement("Dexterity", STAT_SELECT, pc );
            ReplaceIntElement(1, ABILITY_DEXTERITY, STAT_SELECT, pc);
            AddStringElement("Constitution", STAT_SELECT, pc );
            ReplaceIntElement(2, ABILITY_CONSTITUTION, STAT_SELECT, pc);
            AddStringElement("Intelligence", STAT_SELECT, pc );
            ReplaceIntElement(3, ABILITY_INTELLIGENCE, STAT_SELECT, pc);
            AddStringElement("Wisdom", STAT_SELECT, pc );
            ReplaceIntElement(4, ABILITY_WISDOM, STAT_SELECT, pc);
            AddStringElement("Charisma", STAT_SELECT, pc );
            ReplaceIntElement(5, ABILITY_CHARISMA, STAT_SELECT, pc);
        }
        if( GetElementCount(STAT_CONFIRM, pc) == 0){
            AddStringElement("Yes.", STAT_CONFIRM, pc );
            AddStringElement("No. I want to start over.", STAT_CONFIRM, pc );
        }
        if( GetElementCount(SKILL_CONFIRM, pc) == 0 ){ // Skill confirm
            AddStringElement("Yes, and I would like to add more skill points.", SKILL_CONFIRM, pc );
            AddStringElement("Yes, and I am done adding skill points.", SKILL_CONFIRM, pc );
            AddStringElement("No. I want to start over.", SKILL_CONFIRM, pc );
        }

        if( GetElementCount(FEAT_CONFIRM, pc) == 0){ //Feat Confimation.
            AddStringElement("Yes.", FEAT_CONFIRM, pc );
            AddStringElement("No. I want to start over.", FEAT_CONFIRM, pc );
        }
        //Spell Response List
        if( GetElementCount(SIXPOINTONE_PAGE, pc) == 0)
        {
            AddStringElement("Yes.", SIXPOINTONE_PAGE, pc );
            AddStringElement("No.", SIXPOINTONE_PAGE, pc );
        }
        if( GetElementCount(SIXPOINTTWO_PAGE, pc) == 0)
        {
            BuildSpellLevelList(pc, FALSE, SIXPOINTTWO_PAGE);
        }
        if( GetElementCount(SIXPOINTFIVE_PAGE, pc) == 0)     //skip 6.3 and 6.4 because the lists are totally dependant on 6.2
        {
            AddStringElement("Yes, and I want to change more spells.", SIXPOINTFIVE_PAGE, pc );
            AddStringElement("Yes, and I'm done changing spells.", SIXPOINTFIVE_PAGE, pc );
            AddStringElement("No, I want to start over.", SIXPOINTFIVE_PAGE, pc );
        }
        if( GetElementCount(SIXPOINTEIGHT_PAGE, pc) == 0)     //skip 6.3 and 6.4 because the lists are totally dependant on 6.2
        {
            AddStringElement("Yes.", SIXPOINTEIGHT_PAGE, pc );
            AddStringElement("No, I want to start over.", SIXPOINTEIGHT_PAGE, pc );
        }
        if( GetElementCount(SEVENTH_PAGE, pc ) == 0)
        {
            AddStringElement("Yes.", SEVENTH_PAGE, pc );
            AddStringElement("No. I want to start over.", SEVENTH_PAGE, pc );
        }
    }
}

void PageInit(){
    string page = GetDlgPageString();
    object pc= GetPcDlgSpeaker();
	int nResponse = GetLocalInt(pc, "LastResponseInt");
    string sPrompt;

    if( page == ""){
        SetDlgPrompt("Welcome to the NEW Legendary Leveler, would you like to gain a level?  Note throughout the process there will be some small "+
                     "delays in the conversation, this is to ensure that all nodes are properly initialized.  Please report missing nodes, but "+
                     "restarting the conversation or exiting the dialog typically will fix it.  If not try taking the conversation slow.\n");
        SetDlgResponseList( WELCOME_CONFIRM, pc );
    }
    else if( page == "class" ){
        SetDlgPrompt("Please select the class you would like to increase this level.");
        SetDlgResponseList( CLASS_SELECT, pc );
    }
    else if( page == "classresponse" ){
        SetDlgPrompt("You selected " + GetLocalString(pc, "LastResponse") +
        ". Is that the class you want?");
        SetDlgResponseList( CLASS_CONFIRM, pc );
    }
    else if( page == "stat" ){
        SetDlgPrompt("Please select the ability you would like to increase this level.");
        SetDlgResponseList( STAT_SELECT, pc );
    }
    else if( page == "statresponse" ){
        SetDlgPrompt("You selected " + GetLocalString(pc, "LastResponse") +
        ". Is that the ability you want?");
        SetDlgResponseList( STAT_CONFIRM, pc );
    }
    else if(page == "skill"){
        SetDlgPrompt("Please select a skill to add a point to." +
        " You have " + IntToString(GetLocalInt(pc, "LL_SKILL_POINTS")) +
        " points remaining to spend.");
        SetDlgResponseList( SKILL_SELECT, pc );
    }
    else if( page == "skillresponse" ){
        SetDlgPrompt("You selected " + GetLocalString(pc, "LastResponse") +
        ". Is that the skill you want?");
        SetDlgResponseList( SKILL_CONFIRM, pc );
    }
    else if( page == "feat" ){
        SetDlgPrompt("Please select the feat you would like to gain this level.");
	    SetDlgResponseList( FEAT_SELECT, pc );
    }
    else if( page == "featresponse" ){
        	SetDlgPrompt("You selected " + GetLocalString(pc, "LastResponse") +
        	". Is that the feat you want?");
        	SetDlgResponseList( FEAT_CONFIRM, pc );
    }
    else if( page == "masterfeat" ){
        SetDlgPrompt("Please select the feat you would like to gain this level.");
	    SetDlgResponseList( FEAT_SELECT+IntToString(nResponse), pc );
    }
    else if( page == "masterfeatresponse" ){
        	SetDlgPrompt("You selected " + GetLocalString(pc, "LastResponse") +
        	". Is that the feat you want?");
        	SetDlgResponseList( FEAT_CONFIRM, pc );
    }

    else if( page == "spells_ask" ){
        SetDlgPrompt( "Would you like to change any of your spell selections?");
        SetDlgResponseList( SIXPOINTONE_PAGE, pc );
    }
    else if( page == "spells_level" ){
        SetDlgPrompt( "What level spell would you like to change?");
        SetDlgResponseList( SIXPOINTTWO_PAGE, pc );
    }
    else if( page == "spells_gain" ){
 		int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
		int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos)) - 1;
        int nSpellsGained = GetLocalInt(pc, "LL_SPGN");
        string sDialog;

        if(class == CLASS_TYPE_WIZARD)
            sDialog = "You are able to learn " + IntToString(nSpellsGained) + " new spells.  ";

        SetDlgPrompt(sDialog + "What level spell would you like to add spells to?");
        SetDlgResponseList( SIXPOINTSIX_PAGE, pc );
    }
    else if( page == "spells_gain_select" ){
        SetDlgPrompt("Which spell would you like to add?");
        SetDlgResponseList( SIXPOINTSEVEN_PAGE, pc );
    }
    else if( page == "spells_gain_confirm" ){
        SetDlgPrompt("You have chosen to add " + GetLocalString(pc, "SpellToGain") + ". Is that correct?");
        SetDlgResponseList( SIXPOINTEIGHT_PAGE, pc );
    }
    else if( page == "spells_remove_select" ){
        SetDlgPrompt( "What spell would you like to remove?");
        SetDlgResponseList( SIXPOINTTHREE_PAGE, pc );
    }
    else if( page == "spells_replace_select" ){
        SetDlgPrompt( "What spell would you like to have instead of " + GetLocalString(pc, "SpellToRemove") + "?");
        SetDlgResponseList( SIXPOINTFOUR_PAGE, pc );
    }
    else if( page == "spells_confirm" ){
        SetDlgPrompt( "You have chosen to remove " + GetLocalString(pc, "SpellToRemove") + ". Is that correct?");
        SetDlgResponseList( SIXPOINTFIVE_PAGE, pc );
    }
    else if( page == "finish" ){
		int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
		int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos)) - 1;

        sPrompt = "You will gain the maximum number of hitpoints automatically, as well as any saving throw bonuses.\n";
		sPrompt += "Class: " + GetClassName(class) + "\n";
		//sPrompt += "Hitpoints: " + IntToString(GetLocalInt(pc, "LL_HP")) + "\n";

		string temp;
        int i, value;
		for(i = 0; i < 6; i++) {
			value = GetLocalInt(pc, "LL_STAT_" + IntToString(i));
			if(value > 0)
				temp += "    " + GetAbilityName(i) + ": +" + IntToString(value) + "\n";
		}
		sPrompt += "Abilities:";
		if(temp != "")
			sPrompt += "\n" + temp + "\n";
		else
			sPrompt += " none\n";

        //Rebuild the skills
		temp = "";
		sPrompt += "Skills:\n";
        for(i = 0; i < 27; i++){
			value = GetLocalInt(pc, "LL_SKILL_"+IntToString(i));
			if(value > 0)
				temp += "     " + GetSkillName(i) + ": +" + IntToString(value) + "\n";
        }
		if(temp != "")
			sPrompt += " " + temp + "\n";
		else
			sPrompt += " none\n";

		temp = "";
		sPrompt += "Feats:";
        for(i = 0; i < GetLocalInt(pc, "LL_FEAT_COUNT"); i++){

			value = GetLocalInt(pc, "LL_FEAT_"+IntToString(i)) - 1;
            if(value > 0)
    			temp += "    " + GetFeatName(value) + "\n";
        }
		if(temp != "")
			sPrompt += "\n" + temp + "\n";
		else
			sPrompt += " none\n";

		temp = "";
        struct SubString ss;
		sPrompt += "Spells Added:";
        int j;
        for(j = 0; j < 10; j++){
            for(i = 0; i < GetLocalInt(pc, "LL_SPGN"+IntToString(j)+"_USED"); i++){
                value = GetLocalInt(pc, "LL_SPGN"+IntToString(j)+"_"+ IntToString(i)) - 1;
                if(value > 0)
    	            temp += "    " + GetSpellName(value) + "\n";
            }
        }
		if(temp != "")
			sPrompt += "\n" + temp + "\n";
		else
			sPrompt += " none\n";

		temp = "";
		sPrompt += "Spells Removed:";
        for(j = 0; j < 10; j++){
            for(i = 0; i < GetLocalInt(pc, "LL_SPRM"+IntToString(j)+"_USED"); i++){
                value = GetLocalInt(pc, "LL_SPRM"+IntToString(j)+"_"+ IntToString(i)) - 1;
                if(value > 0)
    	            temp += "    " + GetSpellName(value) + "\n";
            }
        }
		if(temp != "")
			sPrompt += "\n" + temp + "\n";
		else
			sPrompt += " none\n";

        sPrompt += "Are these the selections you want?";

        SetDlgPrompt(sPrompt);
        SetDlgResponseList( SEVENTH_PAGE, pc );
    }
}

void HandleSelection(){

    object pc = GetPcDlgSpeaker();
    string page = GetDlgPageString();
    int nElements;
    int selection = GetDlgSelection();
    string sName, sChange;
    int nChange, nSpell, nSpell2, nSpellLevel, nCount;
	int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
	int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos)) - 1;
	int level = GetLocalInt(pc, "LL_LEVEL");

    if( page == ""){
        if (selection == 0){
        	SetDlgPageString( "class", 0.5f );
        }
        else EndDlg();
    }
	else if(page == "class"){
        nElements = GetElementCount(SKILL_SELECT, pc);
        if (selection == (nElements -1))//last element - end dialog
        {
            EndDlg();
        }
        else{
            nChange = GetIntElement(selection, CLASS_SELECT, pc);
            class = GetLocalInt(pc, "LL_CLASS_"+IntToString(nChange)) - 1;
            sName = GetClassName(class);
            SetLocalString(pc, "LastResponse", sName);
            SetLocalInt(pc, "LastResponseInt", nChange);
            SetDlgPageString( "classresponse" );
        }
	}
	else if(page == "classresponse"){
		if(selection == 0){
			nChange = GetLocalInt(pc, "LastResponseInt");
			class = GetLocalInt(pc, "LL_CLASS_"+IntToString(nChange)) - 1;
			int cls_level = IncrementLocalInt(pc, "LL_CLASSLEVEL_"+IntToString(nChange));
			SetLocalInt(pc, "LL_CLASS", class + 1);
			SetLocalInt(pc, "LL_CLASS_POSITION", nChange);
			SetLocalInt(pc, "LL_HP", GetHitPointsGainedOnLevelUp(class));
			SetLocalInt(pc, "LL_SKILL_POINTS", GetPCSkillPoints(pc) + GetSkillPointsGainedOnLevelUp(pc, class));
			Logger(pc, "tall_debug", LOGLEVEL_DEBUG, "Class: %s, Position: %s, Level: %s",
				   IntToString(class), IntToString(nChange), IntToString(cls_level));
            if(class == CLASS_TYPE_WIZARD && cls_level < 41 && GetAbilityScore(pc, ABILITY_INTELLIGENCE, TRUE) > 10)
                SetLocalInt(pc, "LL_SPGN", 2);
            else if (cls_level < 21){
                int i, last, current, total;
                int cha =  GetAbilityScore(pc, ABILITY_CHARISMA, TRUE) - 10;
                string old, new;
                if(class == CLASS_TYPE_BARD){
                    for(i = 0; i < 7; i++){
                        if(cha - i < 0)
                            continue;

                        old = Get2DAString("cls_spkn_bard", "SpellLevel"+IntToString(i), cls_level - 1);
                        new = Get2DAString("cls_spkn_bard", "SpellLevel"+IntToString(i), cls_level);
                        if(old == "****")
                            last = 0;
                        else
                            last = StringToInt(old);
                        if(new == "****")
                            current = 0;
                        else
                            current = StringToInt(new);

                        //SendMessageToPC(pc, "Level: " + IntToString(i) + " New: " +IntToString(current - last));
                        SetLocalInt(pc, "LL_SPKN_"+IntToString(i), current - last);
                        total += current - last;
                    }
                }
                else if(class == CLASS_TYPE_SORCERER){
                    for(i = 0; i < 10; i++){
                        if(cha - i < 0)
                            continue;

                        old = Get2DAString("cls_spkn_sorc", "SpellLevel"+IntToString(i), cls_level - 1);
                        new = Get2DAString("cls_spkn_sorc", "SpellLevel"+IntToString(i), cls_level);
                        if(old == "****")
                            last = 0;
                        else
                            last = StringToInt(old);
                        if(new == "****")
                            current = 0;
                        else
                            current = StringToInt(new);

                        //SendMessageToPC(pc, "Level: " + IntToString(i) + " New: " +IntToString(current - last));
                        SetLocalInt(pc, "LL_SPKN_"+IntToString(i), current - last);
                        total += current - last;
                    }
                }
                SetLocalInt(pc, "LL_SPGN", total);
            }
			// We need to know the class before we can initialize the Skill and Feat Lists
		    BuildSkillList(pc);
			ExecuteScript("tall_load_bfeat", pc);
			BuildFeatList(pc, 3999, 25, 0.01f);

            if (GetGainsStatOnLevelUp(level))
   	            SetDlgPageString( "stat", 4.0f );
           	else
               	SetDlgPageString( "skill", 4.0f );
		}
		else
			EndDlg();
	}
    else if ( page == "stat" ){
        //add to last selection string and int
        nChange = GetIntElement( selection, STAT_SELECT, pc );
        sName = GetAbilityName(nChange);
        SetLocalString(pc, "LastResponse", sName);
        SetLocalInt(pc, "LastResponseInt", nChange);
        //DoDebug(pc, "Stat Int: " + IntToString(nStat));

        SetDlgPageString( "statresponse" );
    }
    else if ( page == "statresponse" ){
		if(selection == 0){ // Yes
        	nChange = GetLocalInt(pc, "LastResponseInt");
			SetLocalInt(pc, "LL_STAT", nChange + 1);
			SetLocalInt(pc, "LL_STAT_"+IntToString(nChange), 1);
        	SetDlgPageString( "skill" );
		}
		else
			EndDlg();
    }
    else if(page == "skill"){
        nElements = GetElementCount(SKILL_SELECT, pc);
        if (selection == (nElements -1))//last element - they can't (or don't want to) select any more skills
        {
            if (GetGainsFeatOnLevelUp(level)){
                SetDlgPageString( "feat" );
            }
            else if (GetAbilityScore(pc, ABILITY_CHARISMA, TRUE) > 10 && (class == 1 || class == 9)){
                SetDlgPageString( "spells_ask" );
            }
            else if(GetLocalInt(pc, "LL_SPGN") > 0){
                BuildSpellLevelList(pc);
                SetDlgPageString("spells_gain");
            }
            else{
                SetDlgPageString( "finish" );
            }
        }
        else{  //they selected a skill
            nChange = GetIntElement( selection, SKILL_SELECT, pc );
            sName = GetSkillName(nChange);
        	SetLocalString(pc, "LastResponse", sName);
	        SetLocalInt(pc, "LastResponseInt", nChange);

            SetDlgPageString( "skillresponse" );
        }
    }
    else if ( page == "skillresponse" ){
        switch( selection ){
            case 0: // Yes, add more
            case 1: // Yes, done
                //Don't track skill changes, we'll create that list at the end.
                nChange = GetLocalInt(pc, "LastResponseInt");

				IncrementLocalInt(pc, "LL_SKILL_"+IntToString(nChange));
				IncrementLocalInt(pc, "LL_SKILLS_"+IntToString(nChange));

                // subtract cost of skill from points available
				DecrementLocalInt(pc, "LL_SKILL_POINTS", GetSkillCost(class, nChange));

				BuildSkillList(pc, TRUE);

                // if they have skill points left, go back to start page, if they want to add more.
                if(GetLocalInt(pc, "LL_SKILL_POINTS") > 0 && selection == 0){
                    SetDlgPageString( "skill" );
                }
                else if (GetGainsFeatOnLevelUp(level)){
                    SetDlgPageString( "feat" );
                }
                else if (GetAbilityScore(pc, ABILITY_CHARISMA, TRUE) > 10 && (class == 1 || class == 9)){
                    SetDlgPageString( "spells_ask" );
                }
                else if(GetLocalInt(pc, "LL_SPGN") > 0){
                    BuildSpellLevelList(pc);
                    SetDlgPageString("spells_gain");
                }
                else{
                    //SpeakString( "You did not recieve a feat this level.", TALKVOLUME_TALK );
                    SetDlgPageString( "finish" );
                }
            break;
            case 2: // No
                EndDlg();
            break;
        }
    }
    else if ( page == "feat" ){
        nChange = GetIntElement( selection, FEAT_SELECT, pc );
        sName = GetFeatName(nChange);
		//add to last selection string and int
       	SetLocalString(pc, "LastResponse", sName);
       	SetLocalInt(pc, "LastResponseInt", nChange);

		if(nChange < 0){
			SetLocalInt(pc, "LL_MASTER_FEAT", nChange);
       		SetDlgPageString( "masterfeat" );
		}
		else
       		SetDlgPageString( "featresponse" );

    }
    else if ( page == "featresponse" ){
        switch( selection ){
            case 0: // Yes
            nChange = GetLocalInt(pc, "LastResponseInt");
            SetLocalInt(pc, "LL_FEAT_"+IntToString(GetLocalInt(pc, "LL_FEAT_COUNT")), nChange+1 );
            IncrementLocalInt(pc, "LL_FEAT_COUNT");

            if (GetAbilityScore(pc, ABILITY_CHARISMA, TRUE) > 10 && (class == 1 || class == 9)){
                SetDlgPageString( "spells_ask" );
            }
            else if(GetLocalInt(pc, "LL_SPGN") > 0){
                BuildSpellLevelList(pc);
                SetDlgPageString("spells_gain");
            }
            else{
                SetDlgPageString( "finish" );
            }
            break;
            case 1: // No
                EndDlg();
            break;
        }
    }
    else if ( page == "masterfeat" ){
        nChange = GetIntElement( selection, FEAT_SELECT+IntToString(GetLocalInt(pc, "LL_MASTER_FEAT")), pc );
        sName = GetFeatName(nChange);
		//add to last selection string and int
       	SetLocalString(pc, "LastResponse", sName);
       	SetLocalInt(pc, "LastResponseInt", nChange);

		if(nChange == -1)
			SetDlgPageString( "feat" );
		else
       		SetDlgPageString( "masterfeatresponse" );

    }
    else if ( page == "masterfeatresponse" ){
        switch( selection ){
            case 0: // Yes
            nChange = GetLocalInt(pc, "LastResponseInt");
            SetLocalInt(pc, "LL_FEAT_"+IntToString(GetLocalInt(pc, "LL_FEAT_COUNT")), nChange+1 );
            IncrementLocalInt(pc, "LL_FEAT_COUNT");

            if (GetAbilityScore(pc, ABILITY_CHARISMA, TRUE) > 10 && (class == 1 || class == 9)){
                SetDlgPageString( "spells_ask" );
            }
            else if(GetLocalInt(pc, "LL_SPGN") > 0){
                BuildSpellLevelList(pc);
                SetDlgPageString("spells_gain");
            }
            else{
                SetDlgPageString( "finish" );
            }
            break;
            case 1: // No
                EndDlg();
            break;
        }
    }
    else if ( page == "spells_ask" ){
        switch( selection ){
            case 0: // Yes - they want to change a spell selection
                SetDlgPageString( "spells_level" );
            break;
            case 1: // No
                if(GetLocalInt(pc, "LL_SPGN") > 0){
                    BuildSpellLevelList(pc);
                    SetDlgPageString("spells_gain");
                }
                else{
                    SetDlgPageString( "finish" );
                }
            break;
        }
    }
    else if ( page == "spells_level" ){
        nElements = GetElementCount(SIXPOINTTWO_PAGE, pc);
        if (selection == (nElements -1)){
            EndDlg();
        }
        else{
			BuildKnownSpellList(pc, selection + 1);
            SetDlgPageString( "spells_remove_select" );
        }
    }
    else if ( page == "spells_remove_select" )
    {
        nElements = GetElementCount(SIXPOINTTHREE_PAGE, pc);
        if (selection == (nElements -1))//last element - they don't want to change spells, abort
        {
            if(GetLocalInt(pc, "LL_SPGN") > 0){
                BuildSpellLevelList(pc);
                SetDlgPageString("spells_gain");
            }
            else{
                SetDlgPageString( "finish" );
            }
        }
        else
        {
            nSpell = GetIntElement( selection, SIXPOINTTHREE_PAGE, pc );
            sName = GetSpellName(nSpell);

            SetLocalString(pc, "SpellToRemove", sName);//used in dialogue text
            SetLocalInt(pc, "SpellToRemove", nSpell);
            SetDlgPageString( "spells_confirm" );
        }
    }
    else if ( page == "spells_confirm" ){
        nSpell = GetLocalInt(pc, "SpellToRemove");
        int used = GetLocalInt(pc, "LL_SPRM_USED"), innate;

        switch( selection ){
            case 0://Yes, change more
            case 1://Yes, and done
                if(class == CLASS_TYPE_BARD)
                    innate = StringToInt(Get2DAString("spells", "Bard", nSpell));
                else
                    innate = StringToInt(Get2DAString("spells", "Wiz_Sorc", nSpell));

                used = GetLocalInt(pc, "LL_SPRM"+IntToString(innate)+"_USED");
                SetLocalInt(pc, "LL_SPRM"+IntToString(innate)+"_"+IntToString(used), nSpell + 1);
                IncrementLocalInt(pc, "LL_SPRM"+IntToString(innate)+"_USED");
                nCount = DecrementLocalInt(pc, "LL_SPRM");
                IncrementLocalInt(pc, "LL_SPGN");

                IncrementLocalInt(pc, "LL_SPKN_"+IntToString(innate));

                if(selection == 0)
                    SetDlgPageString( "spells_level" ); //Yes, change more
                else if(GetLocalInt(pc, "LL_SPGN") > 0){
                    BuildSpellLevelList(pc);
                    SetDlgPageString("spells_gain");
                }
                else{
                    SetDlgPageString( "finish" );
                }
            break;
            case 2://No
                SetDlgPageString( "spells_ask" );
            break;
        }
    }
    else if ( page == "spells_gain" ){
        nElements = GetElementCount(SIXPOINTSIX_PAGE, pc);
        nChange = GetIntElement( selection, SIXPOINTSIX_PAGE, pc );
        if (selection == (nElements -1)){
            EndDlg();
        }
        else{
			BuildUnknownSpellList(pc, nChange, SIXPOINTSEVEN_PAGE);
            AddStringElement("Back.", SIXPOINTSEVEN_PAGE, pc );
            SetDlgPageString( "spells_gain_select" );
        }
    }
    else if ( page == "spells_gain_select" )
    {
        nElements = GetElementCount(SIXPOINTSEVEN_PAGE, pc);
        if (selection == (nElements - 1))//last element - they don't want to change spells, abort
        {
            BuildSpellLevelList(pc);
            SetDlgPageString( "spells_gain" );
        }
        else
        {
            nSpell = GetIntElement( selection, SIXPOINTSEVEN_PAGE, pc );
            sName = GetSpellName(nSpell);

            SetLocalString(pc, "SpellToGain", sName);//used in dialogue text
            SetLocalInt(pc, "SpellToGain", nSpell);
            SetDlgPageString( "spells_gain_confirm" );
        }
    }
    else if ( page == "spells_gain_confirm" )
    {
        nSpell = GetLocalInt(pc, "SpellToGain");
        int used, innate;

        switch( selection ){
            case 0://Yes
                if(class == CLASS_TYPE_BARD)
                    innate = StringToInt(Get2DAString("spells", "Bard", nSpell));
                else if (class == CLASS_TYPE_SORCERER)
                    innate = StringToInt(Get2DAString("spells", "Wiz_Sorc", nSpell));

                used = GetLocalInt(pc, "LL_SPGN"+IntToString(innate)+"_USED");
                SetLocalInt(pc, "LL_SPGN"+IntToString(innate)+"_"+IntToString(used), nSpell + 1);
                IncrementLocalInt(pc, "LL_SPGN"+IntToString(innate)+"_USED");
                nCount = DecrementLocalInt(pc, "LL_SPGN");

                DecrementLocalInt(pc, "LL_SPKN_"+IntToString(innate));

                if(GetLocalInt(pc, "LL_SPGN") > 0){
                    BuildSpellLevelList(pc);
                    SetDlgPageString("spells_gain");
                }
                else SetDlgPageString( "finish" ); //Yes, done
            break;
            case 1://No
                BuildSpellLevelList(pc);
                SetDlgPageString( "spells_gain" );
            break;
        }
    }
    else if ( page == "finish" ){
		int level = GetLocalInt(pc, "LL_LEVEL");
        switch( selection ){
            case 0: // Yes
				LegendaryLevelComplete(pc);
                if(GetLocalInt(pc, "LL_BOOT")){
                    FloatingTextStringOnCreature("You will have to relog to complete your Legendary Level.", pc, FALSE);
                    DeleteLocalInt(pc, "LL_BOOT");
                    DelayCommand(3.0, BootPlayer(pc));
                }

                EndDlg();
            break;
            case 1: // No
                EndDlg();
            break;
        }
    }
}

void CleanUp(){
    // Delete the list we create in Init()
    object pc = GetPcDlgSpeaker();

	int class_pos = GetLocalInt(pc, "LL_CLASS_POSITION");
	int class = GetLocalInt(pc, "LL_CLASS_"+IntToString(class_pos));

    int i, j;
	DeleteList( CLASS_SELECT, pc);
	DeleteList( CLASS_CONFIRM, pc);
    DeleteList( SKILL_SELECT, pc );
    DeleteList( SKILL_CONFIRM, pc );
    DeleteList( FEAT_SELECT, pc );
    DeleteList( FEAT_CONFIRM, pc );
    DeleteList( STAT_SELECT, pc );
    DeleteList( STAT_CONFIRM, pc );
    DeleteList( SIXPOINTONE_PAGE, pc );
    DeleteList( SIXPOINTTWO_PAGE, pc );
    DeleteList( SIXPOINTTHREE_PAGE, pc );
    DeleteList( SIXPOINTFOUR_PAGE, pc );
    DeleteList( SIXPOINTFIVE_PAGE, pc );
    DeleteList( SIXPOINTSIX_PAGE, pc );
    DeleteList( SIXPOINTSEVEN_PAGE, pc );
    DeleteList( SIXPOINTEIGHT_PAGE, pc );
    DeleteList( SEVENTH_PAGE, pc );
    DeleteList( FEAT_SELECT+"0", pc );

    for(i = 1; i < 20; i++)
        DeleteList( FEAT_SELECT+IntToString(-i), pc );

    DeleteLocalInt(pc, "SpellToRemove");
    DeleteLocalString(pc, "SpellToRemove");
    DeleteLocalString(pc, "SpellToAdd");
    DeleteLocalInt(pc, "SpellToAdd");
	DeleteLocalInt(pc, "LL_LEVEL");
	DeleteLocalInt(pc, "LL_STAT");
	DeleteLocalInt(pc, "LL_SPGN");

    for(j = 0; j < 10; j++)
        for(i = 0; i < GetLocalInt(pc, "LL_SPGN"+IntToString(j)+"_USED"); i++)
            DeleteLocalInt(pc, "LL_SPGN"+IntToString(j)+"_"+IntToString(i));

    for(j = 0; j < 10; j++)
        for(i = 0; i < GetLocalInt(pc, "LL_SPRM"+IntToString(j)+"_USED"); i++)
            DeleteLocalInt(pc, "LL_SPRM"+IntToString(j)+"_"+IntToString(i));

    for(i = 0; i < 10; i++)
        DeleteLocalInt(pc, "LL_SPKN_"+IntToString(i));

    for(i = 0; i < GetLocalInt(pc, "LL_FEAT_COUNT"); i++)
        DeleteLocalInt(pc, "LL_FEAT_"+IntToString(i));

    DeleteLocalInt(pc, "LL_FEAT_COUNT");

    for(i = 0; i < 28; i++)
        DeleteLocalInt(pc, "LL_SKILL_"+IntToString(i));

	for(i = 0; i < 6; i++)
		DeleteLocalInt(pc, "LL_STAT_"+IntToString(i));

	if(class == 9 || class == 1){
	    for(i = 0; i < 570; i++){
        	DeleteLocalInt(pc, "SpellRemoved"+IntToString(i));
        	DeleteLocalInt(pc, "SpellAdded"+IntToString(i));
    	}
	}
}

void main()
{
    int iEvent = GetDlgEventType();
    switch( iEvent ){
        case DLG_INIT:
            Init();
        break;
        case DLG_PAGE_INIT:
            PageInit();
        break;
        case DLG_SELECTION:
            HandleSelection();
        break;
        case DLG_ABORT:
            SpeakString( "Legendary leveler conversation ended.", TALKVOLUME_TALK );
            CleanUp();
        break;
        case DLG_END:
            SpeakString( "Legendary leveler conversation ended.", TALKVOLUME_TALK );
            CleanUp();
        break;
    }
}
