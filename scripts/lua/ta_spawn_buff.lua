local Creature = require 'ta.creature'
local Eff = require 'solstice.effect'
function ta_spawn_buff(cre)
   Creature.Generate(cre)

   if math.random(100) <= 65 then
      cre:ApplyEffect(DURATION_TYPE_INNATE, Eff.Immunity(IMMUNITY_TYPE_MIND_SPELLS, 100))
   end
end
