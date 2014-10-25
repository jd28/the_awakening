#include "pc_funcs_inc"

void DeleteCharacter(object pc) {
	ExportSingleCharacter(pc);//export needed to ensure this .bic is the most recently edited
	SetLocalInt(pc, VAR_PC_DELETED, 1);
	DeleteAllDbVariables(pc, FALSE, "pwdata");
	DeleteAllDbVariables(pc, FALSE, "qsstatus");

	int nCurrentXP = GetXP(pc) - 3000;
	if(nCurrentXP < 0)
		nCurrentXP = 0;
	if(!GetIsTestCharacter(pc)){
		int nXPBalance = GetLocalInt(pc, VAR_PC_XP_BANK) + nCurrentXP;
		DelayCommand(2.0, GiveTakeXP(pc, -GetXP(pc)));
		SetLocalInt(pc, VAR_PC_XP_BANK, nXPBalance);

		Logger(pc, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Attempting to delete: %s and deposit %sXP in %s's bank.",
			   GetName(pc), IntToString(nXPBalance), GetPCPlayerName(pc));
	}
	DelayCommand(3.0, AssignCommand(GetModule(), DeleteBic(pc)));
}

void main() {
	DeleteCharacter(GetPCSpeaker());
}
