function x2_s3_intitemtlk(self)
  local item = self:GetSpellCastItem()
  self:SetLocalBool("CON_ITEM", true)
  self:SetLocalObject("ITEM_TALK_TO", item)
  self:ActionStartConversation(self, item:GetTag(), true, false)
end
