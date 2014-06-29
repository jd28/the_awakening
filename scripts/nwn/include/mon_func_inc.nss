// Monster AI include files.
#include "dip_func_inc"
#include "nw_i0_generic"
#include "pl_dds_100"
#include "pl_dds_200"
#include "rlgs_func_inc"
#include "x2_inc_compon"
#include "x0_i0_spawncond"

void ApplyDDS(object oSelf, int nID);
void ApplyDDS(object oSelf, int nID){
    if(nID <= 0) return;
    else if(nID < 100) DDS_100(oSelf, nID);
    else if(nID < 200) DDS_200(oSelf, nID);
}
