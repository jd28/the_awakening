function tall_load_bfeat(pc)
   	local class_pos = pc:GetLocalInt("LL_CLASS_POSITION")
	local class_lvl = pc:GetLocalInt("LL_CLASSLEVEL_"..tostring(class_pos))
    local class = pc:GetLocalInt("LL_CLASS_"..tostring(class_pos)) - 1

    local feats = Rules.GetLevelBonusFeats(pc, class, class_lvl)
    local feat_count = pc:GetLocalInt("LL_FEAT_COUNT")
    for _, f in ipairs(feats) do
       pc:SetLocalInt("LL_FEAT_"..tostring(feat_count), f + 1)
       feat_count = feat_count + 1
    end
    pc:SetLocalInt("LL_FEAT_COUNT", feat_count)
end
