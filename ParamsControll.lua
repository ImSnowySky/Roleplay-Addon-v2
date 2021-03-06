SS_ParamsControll_Show = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_ParamsControll_Menu:Show();
  SS_Event_Controll_ParamsControll_Button:SetText("- Показатели");
  SS_ParamsControll_Data = {
    target = 'player',
    param = 'health',
  };
  
  SS_ParamsControll_Menu_Check_Target_Group:Show();
  SS_ParamsControll_Menu_Check_Target_Group_Text:Show()
end;

SS_ParamsControll_Hide = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  SS_ParamsControll_Menu:Hide();
  SS_Event_Controll_ParamsControll_Button:SetText("+ Показатели");
  SS_ParamsControll_Menu_Check_Target_Player:SetChecked(true);
  SS_ParamsControll_Menu_Check_Target_Group:SetChecked(false);
  
  SS_ParamsControll_Menu_Check_Params_Health:SetChecked(true);
  SS_ParamsControll_Menu_Check_Params_Barrier:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Level:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Exp:SetChecked(false);

  SS_ParamsControll_Menu_Value_Input:SetText("");
  SS_ParamsControll_Data = nil;
end;

SS_ParamsControll_SelectTarget = function(target)
  SS_ParamsControll_Data.target = target;
  SS_ParamsControll_Menu_Check_Target_Player:SetChecked(false);
  SS_ParamsControll_Menu_Check_Target_Group:SetChecked(false);

  if (target == 'player') then
    SS_ParamsControll_Menu_Check_Target_Player:SetChecked(true);
  elseif (target == 'group') then
    SS_ParamsControll_Menu_Check_Target_Group:SetChecked(true);
  end;
end;

SS_ParamsControll_SelectParam = function(target)
  SS_ParamsControll_Data.param = target;
  SS_ParamsControll_Menu_Check_Params_Health:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Barrier:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Level:SetChecked(false);
  SS_ParamsControll_Menu_Check_Params_Exp:SetChecked(false);
  SS_ParamsControll_Menu_Check_Target_Group:Show();
  SS_ParamsControll_Menu_Check_Target_Group_Text:Show()

  if (target == 'health') then
    SS_ParamsControll_Menu_Check_Params_Health:SetChecked(true);
    SS_ParamsControll_Menu_Send_Reset:Show();
  elseif (target == 'barrier') then
    SS_ParamsControll_Menu_Check_Params_Barrier:SetChecked(true);
    SS_ParamsControll_Menu_Send_Reset:Show();
  elseif (target == 'level') then
    SS_ParamsControll_Menu_Check_Params_Level:SetChecked(true);
    SS_ParamsControll_SelectTarget('player');
    SS_ParamsControll_Menu_Send_Reset:Hide();
    SS_ParamsControll_Menu_Check_Target_Group:Hide();
    SS_ParamsControll_Menu_Check_Target_Group_Text:Hide();
  elseif (target == 'exp') then
    SS_ParamsControll_Menu_Check_Params_Exp:SetChecked(true);
    SS_ParamsControll_Menu_Send_Reset:Hide();
  end;
end;

SS_ParamsControll_SendUpdateInfo = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;

  local updateValue = SS_ParamsControll_Menu_Value_Input:GetText();
  
  if (not(SS_Shared_IsNumber(updateValue))) then
    SS_Log_ValueMustBeNum();
    return nil;
  end;

  if (not(updateValue) or updateValue == '' or updateValue == '0') then
    SS_Log_ValueMustBeNum();
    return nil;
  end;

  if (SS_ParamsControll_Data.param == 'level' and SS_LeadingPlots_Current().battle) then
    SS_Log_CanNotInBattle();
    return;
  elseif (SS_ParamsControll_Data.param == 'exp' and SS_Shared_NumFromStr(updateValue) < 0 and SS_LeadingPlots_Current().battle) then
    SS_Log_CanNotInBattle();
    return;
  end;

  if (SS_ParamsControll_Data.target == 'player' and SS_Shared_TargetIsNPC() and not(SS_Shared_TargetIsConnectedNPC())) then
    SS_Log_NoTarget();
    return;
  end;

  if (SS_ParamsControll_Data.target == 'player' and SS_Shared_TargetIsConnectedNPC()) then
    if (SS_ParamsControll_Data.param == 'level' or SS_ParamsControll_Data.param == 'exp') then
      SS_Log_NoTarget();
      return;
    end;

    local guid = SS_NPCControll_GetGUID();

    local currentNPCInfo = SS_LeadingPlots_Current().npcConnections[guid];
    if (not(currentNPCInfo)) then return nil; end;

    local defaultNPCInfo = SS_LeadingPlots_Current().npc[currentNPCInfo.id];
    if (not(defaultNPCInfo)) then return nil; end;
  
    updateValue = SS_Shared_NumFromStr(updateValue);

    if (SS_ParamsControll_Data.param == 'health') then
      if (currentNPCInfo.health + updateValue >= defaultNPCInfo.health) then
        currentNPCInfo.health = defaultNPCInfo.health;
      elseif (currentNPCInfo.health + updateValue <= 0) then
        currentNPCInfo.health = 0;
      else
        currentNPCInfo.health = currentNPCInfo.health + updateValue;
      end;
    end;

    if (SS_ParamsControll_Data.param == 'barrier') then
      if (currentNPCInfo.barrier + updateValue <= 0) then
        currentNPCInfo.barrier = 0;
      else
        currentNPCInfo.barrier = currentNPCInfo.barrier + updateValue;
      end;
    end;

    SS_LeadingPlots_Current().npcConnections[guid] = currentNPCInfo;
    SS_Draw_NPCInfoPlates();
    return;
  end;

  SS_DMtP_SendParamUpdate(updateValue);
end;

SS_ParamsControll_SendResetInfo = function()
  if (not(SS_LeadingPlots_Current()) or not(SS_LeadingPlots_Current().isEventOngoing)) then return nil; end;


  if (SS_ParamsControll_Data.target == 'player' and SS_Shared_TargetIsNPC() and not(SS_Shared_TargetIsConnectedNPC())) then
    SS_Log_NoTarget();
    return;
  end;
  
  if (SS_ParamsControll_Data.target == 'player' and SS_Shared_TargetIsConnectedNPC()) then
    if (SS_ParamsControll_Data.param == 'level' or SS_ParamsControll_Data.param == 'exp') then
      SS_Log_NoTarget();
      return;
    end;

    local guid = SS_NPCControll_GetGUID();

    local currentNPCInfo = SS_LeadingPlots_Current().npcConnections[guid];
    if (not(currentNPCInfo)) then return nil; end;

    local defaultNPCInfo = SS_LeadingPlots_Current().npc[currentNPCInfo.id];
    if (not(defaultNPCInfo)) then return nil; end;

    if (SS_ParamsControll_Data.param == 'health') then
      currentNPCInfo.health = defaultNPCInfo.health;
    end;

    if (SS_ParamsControll_Data.param == 'barrier') then
      currentNPCInfo.barrier = defaultNPCInfo.barrier;
    end;
    SS_LeadingPlots_Current().npcConnections[guid] = currentNPCInfo;
    SS_Draw_NPCInfoPlates();
    return;
  end;
  SS_DMtP_SendParamUpdate(88005553535);
end;