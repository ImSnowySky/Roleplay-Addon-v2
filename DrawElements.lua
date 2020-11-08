SS_Draw_HideEmptyPlotsText = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  if (SS_PlotController_GetCountOf(plotType) == 0) then
    SS_Controll_Menu_Settings_EmptyPlot:Show();
    SS_Controll_Menu_Settings_EmptyPlot:SetText("Сюжетов не найдено");
  else
    SS_Controll_Menu_Settings_EmptyPlot:Hide();
  end;
end;

SS_Draw_HideSubmenus = function()
  SS_Stats_Menu:Hide();
  SS_Stats_Menu_Info:Hide();
  SS_Skills_Menu:Hide();
  SS_Skills_Menu_Info:Hide();
  SS_Controll_Menu:Hide();
  SS_Armor_Menu:Hide();
  SS_Dices_Menu:Hide();
end;

SS_Draw_HidePlayerInfoPlates = function()
  SS_TargetFrame:Hide();
  SS_TargetFrame_HP_Icon:Hide();
  SS_TargetFrame_Barrier_Icon:Hide();
  SS_TargetFrame_Settings_Icon:Hide();
  SS_TargetFrame_HP_Text:SetText(nil);
  SS_TargetFrame_Barrier_Text:SetText(nil);
  SS_TargetFrame_Settings_Text:SetText(nil);
end;

SS_Draw_InfoAboutPlayer = function(params)
  TargetFrame.levelText:SetText(params.level);
  TargetFrame.levelText:SetTextColor(1, 1, 1);
  TargetFrame.levelText:SetFont("Fonts\\FRIZQT__.TTF", 11);

  SS_TargetFrame_HP_Text:SetText(params.health..'/'..params.maxHealth);
  SS_TargetFrame_Barrier_Text:SetText(params.barrier..'/'..params.maxBarrier);
  SS_TargetFrame_Settings_Text:SetText("Подробнее");

  SS_TargetFrame_HP_Icon:Show();
  SS_TargetFrame_Barrier_Icon:Show();
  SS_TargetFrame_Settings_Icon:Show();
  SS_TargetFrame:Show();
end;

SS_Draw_HideCurrentTargetVisual = function()
  SS_Draw_HidePlayerInfoPlates();
  TargetFrame.levelText:SetText(UnitLevel("player"));
  TargetFrame.levelText:SetTextColor(0.82, 0.71, 0);
  TargetFrame.levelText:SetFont("Fonts\\FRIZQT__.TTF", 10);
end;

SS_Draw_OnEventStarts = function()
  SS_Plot_Controll:Hide();
  SS_Event_Controll:Show();
end;

SS_Draw_OnEventStop = function()
  SS_Event_Controll:Hide();
  SS_Plot_Controll:Show();
end;

SS_Draw_PlayerControll = function(player)
  -- Текст в главном меню осмотра цели
  SS_Player_Controll_Name:SetText(player);
  SS_Player_Controll_HP_Text:SetText(SS_Target_TMPData.health..'/'..SS_Target_TMPData.maxHealth);
  SS_Player_Controll_Barrier_Text:SetText(SS_Target_TMPData.barrier..'/'..SS_Target_TMPData.maxBarrier..', '..SS_Locale(SS_Target_TMPData.armorType));
  SS_Player_Controll_Level_Text:SetText("Уровень: "..SS_Target_TMPData.level);
  SS_Player_Controll_Exp_Text:SetText("Опыт: "..SS_Target_TMPData.experience..'/'..SS_Target_TMPData.experienceForUp);

  local drawTargetStat = function(stat, modified, view)
    view:SetText(SS_Locale(stat)..': '..SS_Target_TMPData.stats[stat]);
    if (modified == 'up') then
      view:SetTextColor(0.25, 0.75, 0.25);
    elseif (modified == 'down') then
      view:SetTextColor(0.75, 0.15, 0.15);
    else
      view:SetTextColor(1, 1, 1);
    end;
  end;

  -- Дайсы возле скиллов
  local diceCount = SS_Roll_GetDicesCount(SS_Target_TMPData.level);

  local getSummaryModifier = function(skill)
    local statModifier = SS_Stats_GetModifierFor(skill, SS_Target_TMPData.stats[SS_Skills_GetStatOf(skill)]);

    local armorModifier = SS_Armor_GetModifierFor(skill, {
      from = SS_Roll_GetMinimum(skill, paramsForRoll),
      to = SS_Roll_GetMaximum(skill, paramsForRoll),
    }, SS_Target_TMPData.armorType);

    return statModifier + armorModifier;
  end;
  local getDiceStr = function(skill)
    local paramsForRoll = {
      level = SS_Target_TMPData.level,
      skill = SS_Target_TMPData.skills[skill]
    };

    local rollString = diceCount.."d("..SS_Roll_GetMinimum(skill, paramsForRoll)..'-'..SS_Roll_GetMaximum(skill, paramsForRoll)..")";
    local summaryModifier = getSummaryModifier(skill);
    
    if (summaryModifier >= 0) then
      rollString = rollString.."+"..summaryModifier;
    else
      rollString = rollString..summaryModifier;
    end;
  
    return rollString;
  end;

  local drawTargetSkill = function(skill, modified, skillView, skillDiceView)
    if (modified == 'up') then
      skillView:SetTextColor(0.25, 0.75, 0.25);
    elseif (modified == 'down') then
      skillView:SetTextColor(0.75, 0.15, 0.15);
    else
      skillView:SetTextColor(1, 1, 1);
    end;
  
    skillView:SetText(SS_Locale(skill)..': '..SS_Target_TMPData.skills[skill]);
    local summaryModifier = getSummaryModifier(skill);
    
    if (summaryModifier > 0) then
      skillDiceView:SetTextColor(0.25, 0.75, 0.25)
    elseif (summaryModifier < 0) then
      skillDiceView:SetTextColor(0.75, 0.15, 0.15)
    else
      skillDiceView:SetTextColor(1, 1, 1);
    end;

    skillDiceView:SetText(getDiceStr(skill));
  end;

  -- Статы в меню статов
  drawTargetStat('power', SS_Target_TMPData.stats.powerModified, SS_Player_Controll_Stats_Power);
  drawTargetStat('accuracy', SS_Target_TMPData.stats.accuracyModified, SS_Player_Controll_Stats_Accuracy);
  drawTargetStat('morale', SS_Target_TMPData.stats.wisdomModified, SS_Player_Controll_Stats_Wisdom);
  drawTargetStat('wisdom', SS_Target_TMPData.stats.moraleModified, SS_Player_Controll_Stats_Morale);
  drawTargetStat('empathy', SS_Target_TMPData.stats.empathyModified, SS_Player_Controll_Stats_Empathy);
  drawTargetStat('mobility', SS_Target_TMPData.stats.mobilityModified, SS_Player_Controll_Stats_Mobility);
  drawTargetStat('precision', SS_Target_TMPData.stats.precisionModified, SS_Player_Controll_Stats_Precision);

  -- Скиллы в меню скиллов
  drawTargetSkill('melee', SS_Target_TMPData.skills.meleeModified, SS_Player_Controll_Skills_Scroll_Inner_Melee, SS_Player_Controll_Skills_Scroll_Inner_Melee_DiceInfo);
  drawTargetSkill('range', SS_Target_TMPData.skills.rangeModified, SS_Player_Controll_Skills_Scroll_Inner_Range, SS_Player_Controll_Skills_Scroll_Inner_Range_DiceInfo);
  drawTargetSkill('magic', SS_Target_TMPData.skills.magicModified, SS_Player_Controll_Skills_Scroll_Inner_Magic, SS_Player_Controll_Skills_Scroll_Inner_Magic_DiceInfo);
  drawTargetSkill('religion', SS_Target_TMPData.skills.religionModified, SS_Player_Controll_Skills_Scroll_Inner_Religion, SS_Player_Controll_Skills_Scroll_Inner_Religion_DiceInfo);
  drawTargetSkill('perfomance', SS_Target_TMPData.skills.perfomanceModified, SS_Player_Controll_Skills_Scroll_Inner_Perfomance, SS_Player_Controll_Skills_Scroll_Inner_Perfomance_DiceInfo);
  drawTargetSkill('missing', SS_Target_TMPData.skills.missingModified, SS_Player_Controll_Skills_Scroll_Inner_Missing, SS_Player_Controll_Skills_Scroll_Inner_Missing_DiceInfo);
  drawTargetSkill('hands', SS_Target_TMPData.skills.handsModified, SS_Player_Controll_Skills_Scroll_Inner_Hands, SS_Player_Controll_Skills_Scroll_Inner_Hands_DiceInfo);
  drawTargetSkill('athletics', SS_Target_TMPData.skills.athleticsModified, SS_Player_Controll_Skills_Scroll_Inner_Athletics, SS_Player_Controll_Skills_Scroll_Inner_Athletics_DiceInfo);
  drawTargetSkill('observation', SS_Target_TMPData.skills.observationModified, SS_Player_Controll_Skills_Scroll_Inner_Observation, SS_Player_Controll_Skills_Scroll_Inner_Observation_DiceInfo);
  drawTargetSkill('knowledge', SS_Target_TMPData.skills.knowledgeModified, SS_Player_Controll_Skills_Scroll_Inner_Knowledge, SS_Player_Controll_Skills_Scroll_Inner_Knowledge_DiceInfo);
  drawTargetSkill('controll', SS_Target_TMPData.skills.controllModified, SS_Player_Controll_Skills_Scroll_Inner_Controll, SS_Player_Controll_Skills_Scroll_Inner_Controll_DiceInfo);
  drawTargetSkill('judgment', SS_Target_TMPData.skills.judgmentModified, SS_Player_Controll_Skills_Scroll_Inner_Judgment, SS_Player_Controll_Skills_Scroll_Inner_Judgment_DiceInfo);
  drawTargetSkill('acrobats', SS_Target_TMPData.skills.acrobatsModified, SS_Player_Controll_Skills_Scroll_Inner_Acrobats, SS_Player_Controll_Skills_Scroll_Inner_Acrobats_DiceInfo);
  drawTargetSkill('stealth', SS_Target_TMPData.skills.stealthModified, SS_Player_Controll_Skills_Scroll_Inner_Stealth, SS_Player_Controll_Skills_Scroll_Inner_Stealth_DiceInfo);

  SS_Player_Controll:Show();
end;

SS_Draw_HideTargetSubmenus = function()
  SS_Player_Controll_Stats:Hide();
  SS_Player_Controll_Skills:Hide();
end;

SS_Draw_StatInfo = function(stat, content)
  local childs = { SS_Stats_Menu_Info_Inner_Content:GetChildren() };
  for _, child in pairs(childs) do
    child:Hide();
  end

  SS_Stats_Menu_Info_Title:SetText(SS_Locale(stat));
  SS_Stats_Menu_Info_Inner_Content_Description:SetText(content);

  local modifiers = SS_Modifiers_GetModifiersOf('stats')(stat);

  if (modifiers == nil) then
    SS_Stats_Menu_Info_Inner_Content_Modifiers:Hide();
  else
    SS_Stats_Menu_Info_Inner_Content_Modifiers:Show();
    local counter = 0;

    SS_Shared_ForEach(modifiers)(function(modifier, id)
      local ModifierPanel = CreateFrame("Frame", nil, SS_Stats_Menu_Info_Inner_Content);
            ModifierPanel:Show();
            ModifierPanel:EnableMouse();
            ModifierPanel:SetSize(180, 23);
            ModifierPanel:SetPoint("TOPLEFT", SS_Stats_Menu_Info_Inner_Content, "TOPLEFT", 8, -55 - 30 * counter);

      local modifierTitleStr = modifier.name..' (';
      if (tonumber(modifier.value) >= 0) then
        modifierTitleStr = modifierTitleStr..'+'..modifier.value
      else
        modifierTitleStr = modifierTitleStr..modifier.value
      end;
      modifierTitleStr = modifierTitleStr..')';

      local ModifierName = ModifierPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            ModifierName:SetPoint("TOPLEFT", ModifierPanel, "TOPLEFT", 0, 0);
            ModifierName:SetText(modifierTitleStr);
            ModifierName:SetFont("Fonts\\FRIZQT__.TTF", 11);
            ModifierName:Show();

      if (tonumber(modifier.value) >= 0) then
        ModifierName:SetTextColor(0.25, 0.75, 0.25);
      else
        ModifierName:SetTextColor(0.75, 0.15, 0.15);
      end;

      local ModifierCount = ModifierPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            ModifierCount:SetPoint("TOPLEFT", ModifierPanel, "TOPLEFT", 0, -14);
            ModifierCount:SetFont("Fonts\\FRIZQT__.TTF", 9);
            ModifierCount:Show();

      if (tonumber(modifier.count) > 0) then
        ModifierCount:SetText('ещё '..modifier.count..' бросков');
      else
        ModifierCount:SetText('до отмены мастером');
      end;

      counter = counter + 1;
    end);
  end;

  SS_Stats_Menu_Info:Show();
end;

SS_Draw_SkillInfo = function(skill, content, examples, bonusFrom)
  local childs = { SS_Skills_Menu_Info_Inner_Content:GetChildren() };
  for _, child in pairs(childs) do
    child:Hide();
  end

  SS_Skills_Menu_Info_Title:SetText(SS_Locale(skill));
  SS_Skills_Menu_Info_Inner_Content_Description:SetText(content);
  SS_Skills_Menu_Info_Inner_Content_Examples:SetText(examples)

  -- Текст бонус от хар-ки
  local charBonus = 'От хар-ки: '..SS_Locale(SS_Skills_GetStatOf(skill));
  if (SS_Stats_GetModifierFor(skill) >= 0) then
    charBonus = charBonus..' (+';
  else
    charBonus = charBonus..' (';
  end;
  charBonus = charBonus..SS_Stats_GetModifierFor(skill)..')';
  SS_Skills_Menu_Info_Inner_Content_Char_Bonus:SetText(charBonus);

  if (SS_Stats_GetModifierFor(skill) > 0) then
    SS_Skills_Menu_Info_Inner_Content_Char_Bonus:SetTextColor(0.25, 0.75, 0.25);
  elseif (SS_Stats_GetModifierFor(skill) < 0) then
    SS_Skills_Menu_Info_Inner_Content_Char_Bonus:SetTextColor(0.75, 0.15, 0.15);
  else
    SS_Skills_Menu_Info_Inner_Content_Char_Bonus:SetTextColor(1, 1, 1);
  end;

  --Текст бонус от снаряжения
  local armorBonus = 'От снар.: '..SS_Locale(SS_Armor_GetType())
  local dices = SS_Roll_GetDices(skill);
  local armorModifier = SS_Armor_GetModifierFor(skill, dices);
  if (armorModifier >= 0) then
    armorBonus = armorBonus..' (+';
  else
    armorBonus = armorBonus..' (';
  end;
  armorBonus = armorBonus..armorModifier..')';
  SS_Skills_Menu_Info_Inner_Content_Armor_Bonus:SetText(armorBonus);

  if (armorModifier > 0) then
    SS_Skills_Menu_Info_Inner_Content_Armor_Bonus:SetTextColor(0.25, 0.75, 0.25);
  elseif (armorModifier < 0) then
    SS_Skills_Menu_Info_Inner_Content_Armor_Bonus:SetTextColor(0.75, 0.15, 0.15);
  else
    SS_Skills_Menu_Info_Inner_Content_Armor_Bonus:SetTextColor(1, 1, 1);
  end;

  -- Модификаторы
  local modifiers = SS_Modifiers_GetModifiersOf('skills')(skill);
  if (modifiers == nil) then
    SS_Skills_Menu_Info_Inner_Content_Modifiers:Hide();
  else
    SS_Skills_Menu_Info_Inner_Content_Modifiers:Show();
    local counter = 0;

    SS_Shared_ForEach(modifiers)(function(modifier, id)
      local ModifierPanel = CreateFrame("Frame", nil, SS_Skills_Menu_Info_Inner_Content);
            ModifierPanel:Show();
            ModifierPanel:EnableMouse();
            ModifierPanel:SetSize(180, 23);
            ModifierPanel:SetPoint("TOPLEFT", SS_Skills_Menu_Info_Inner_Content, "TOPLEFT", 8, -140 - 30 * counter);

      local modifierTitleStr = modifier.name..' (';
      if (tonumber(modifier.value) >= 0) then
        modifierTitleStr = modifierTitleStr..'+'..modifier.value
      else
        modifierTitleStr = modifierTitleStr..modifier.value
      end;
      modifierTitleStr = modifierTitleStr..')';

      local ModifierName = ModifierPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            ModifierName:SetPoint("TOPLEFT", ModifierPanel, "TOPLEFT", 0, 0);
            ModifierName:SetText(modifierTitleStr);
            ModifierName:SetFont("Fonts\\FRIZQT__.TTF", 11);
            ModifierName:Show();

      if (tonumber(modifier.value) >= 0) then
        ModifierName:SetTextColor(0.25, 0.75, 0.25);
      else
        ModifierName:SetTextColor(0.75, 0.15, 0.15);
      end;

      local ModifierCount = ModifierPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            ModifierCount:SetPoint("TOPLEFT", ModifierPanel, "TOPLEFT", 0, -14);
            ModifierCount:SetFont("Fonts\\FRIZQT__.TTF", 9);
            ModifierCount:Show();

      if (tonumber(modifier.count) > 0) then
        ModifierCount:SetText('ещё '..modifier.count..' бросков');
      else
        ModifierCount:SetText('до отмены мастером');
      end;

      counter = counter + 1;
    end);
  end;

  SS_Skills_Menu_Info:Show();
end;