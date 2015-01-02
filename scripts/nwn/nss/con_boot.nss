#include "pc_funcs_inc"
#include "mod_const_inc"

void main() {
	DelayCommand(1.0, AssignCommand(GetModule(),
									BootPlayer(GetPCSpeaker())));
}
