int StartingConditional()
    {
      int iDC = 15;
      int iBonus = GetSkillRank(SKILL_PERSUADE, GetPCSpeaker());
      if ((d20() + iBonus) >= iDC)
      {
        return TRUE;
      }
      return FALSE;
    }
