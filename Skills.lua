SS_Skills_GetList = function()
  return {
    melee = 0,
    range = 0,
    magic = 0,
    religion = 0,
    charm = 0,
    missing = 0,
    hands = 0,
    athletics = 0,
    observation = 0,
    knowledge = 0,
    controll = 0,
    judgment = 0,
    acrobats = 0,
    stealth = 0,
  }
end;

SS_Skills_IsSkill = function(name)
  return SS_Shared_Includes(SS_Skills_GetList())(function(value, statName)
    return statName == name
  end);
end;

SS_Skills_GetValue = function(skill)
  if (not(SS_Plots_Current())) then return 0; end;
  local skillValue = SS_Plots_Current().skills[skill];
  local modifier = SS_Modifiers_ReadModifiersValue('skills')(skill);

  return skillValue + modifier;
end;

SS_Skills_GetValueWithoutModifier = function(skill)
  if (not(SS_Plots_Current())) then return 0; end;
  return SS_Plots_Current().skills[skill];
end;

SS_Skills_GetSpentedPoints = function()
  local skillList = SS_Skills_GetList();

  local accum = 0;
  for name in pairs(skillList) do
    accum = accum + SS_Skills_GetValueWithoutModifier(name);
  end;

  return accum;
end;

SS_Skills_GetMaxPoints = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;
  return 10 + playerLevel * 10;
end;

SS_Skills_GetMaxPointsInSingle = function(playerLevel)
  if (not(playerLevel)) then
    playerLevel = SS_Progress_GetLevel();
  end;
  return playerLevel * 5;
end;

SS_Skills_GetMinPointsInSingle = function()
  return -SS_Skills_GetMaxPointsInSingle(1);
end;

SS_Skills_GetAvaliablePoints = function()
  local baseSkillPoints = SS_Skills_GetMaxPoints();
  local summaryPoints = SS_Skills_GetSpentedPoints();
  return baseSkillPoints - summaryPoints;
end;

SS_Skills_AddPoint = function(value, skill, skillView)
  if (SS_Plots_Current().battle) then
    SS_Log_CanNotInBattle();
    return 0;
  end;

  if (SS_Skills_GetValueWithoutModifier(skill) + value < SS_Skills_GetMinPointsInSingle()) then
    return 0;
  end;

  if (SS_Skills_GetAvaliablePoints() < 1 and value > 0) then
    return 0;
  end;

  if (SS_Skills_GetValueWithoutModifier(skill) + value > SS_Skills_GetMaxPointsInSingle()) then
    return 0;
  end;

  SS_Plots_Current().skills[skill] = SS_Skills_GetValueWithoutModifier(skill) + value;
  skillView:SetText(SS_Locale(skill)..": "..SS_Skills_GetValue(skill));
  SS_Skills_Menu_Points_Value:SetText(SS_Skills_GetAvaliablePoints());
  SS_PtDM_UpdatePlayerInfo(SS_Plots_Current().author);
end;

SS_Skills_GetStatOf = function(skill)
  local association = {
    melee = 'power',
    range = 'accuracy',
    magic = 'wisdom',
    religion = 'morale',
    charm = 'empathy',
    missing = 'mobility',
    hands = 'precision',
    athletics = 'power',
    observation = 'accuracy',
    knowledge = 'wisdom',
    controll = 'morale',
    judgment = 'empathy',
    acrobats = 'mobility',
    stealth = 'precision',
  };

  return association[skill];
end;

SS_Skills_DrawValue = function(skill, view)
  view:SetText(SS_Locale(skill)..': '..SS_Skills_GetValue(skill));

  if (SS_Skills_GetValue(skill) - SS_Skills_GetValueWithoutModifier(skill) > 0) then
    view:SetTextColor(0.25, 0.75, 0.25);
  elseif (SS_Skills_GetValue(skill) - SS_Skills_GetValueWithoutModifier(skill) < 0) then
    view:SetTextColor(0.75, 0.15, 0.15);
  else
    view:SetTextColor(1, 1, 1);
  end;
end;

SS_Skills_DrawAll = function()
  SS_Skills_DrawValue('melee', SS_Skills_Menu_Active_Skill_Melee);
  SS_Skills_DrawValue('range', SS_Skills_Menu_Active_Skill_Range);
  SS_Skills_DrawValue('magic', SS_Skills_Menu_Active_Skill_Magic);
  SS_Skills_DrawValue('religion', SS_Skills_Menu_Active_Skill_Religion);
  SS_Skills_DrawValue('charm', SS_Skills_Menu_Active_Skill_Charm);
  SS_Skills_DrawValue('missing', SS_Skills_Menu_Active_Skill_Missing);
  SS_Skills_DrawValue('hands', SS_Skills_Menu_Active_Skill_Hands);
  SS_Skills_DrawValue('stealth', SS_Skills_Menu_Passive_Skill_Stealth);
  SS_Skills_DrawValue('observation', SS_Skills_Menu_Passive_Skill_Observation);
  SS_Skills_DrawValue('knowledge', SS_Skills_Menu_Passive_Skill_Knowledge);
  SS_Skills_DrawValue('controll', SS_Skills_Menu_Passive_Skill_Controll);
  SS_Skills_DrawValue('judgment', SS_Skills_Menu_Passive_Skill_Judgment);
  SS_Skills_DrawValue('athletics', SS_Skills_Menu_Passive_Skill_Athletics);
  SS_Skills_DrawValue('acrobats', SS_Skills_Menu_Passive_Skill_Acrobats);
end;


SS_Stats_ResetSkills = function(stat)
  if (not(SS_Plots_Current())) then return 0; end;

  SS_Shared_ForEach(SS_Skills_GetList())(function(value, skillName)
    SS_Plots_Current().skills[skillName] = 0;
  end);
end;