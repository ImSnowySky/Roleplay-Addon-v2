SS_PlotController_CreateBoth = function(plotName, authorName)
  local plotUniqueName = plotName..'-'..random(1, 1000000)..'-'..random(1, 1000000)..'-'..random(1, 1000000);

  SS_Plots_Create(plotUniqueName, plotName, authorName);
  SS_LeadingPlots_Create(plotUniqueName, plotName, authorName);
  return true;
end;

SS_PlotController_Select = function(plotIndex)
  if (plotIndex == nil) then SS_User.settings.selectedPlot = nil; return; end;
  if (not(SS_Plots_Includes(plotIndex)) or not(SS_LeadingPlots_Includes(plotIndex))) then return false; end;
  SS_User.settings.selectedPlot = plotIndex;
end;

SS_PlotController_MakeCurrent = function(plotIndex)
  if (plotIndex == nil) then SS_User.settings.currentPlot = nil; return; end;
  if (not(SS_Plots_Includes(plotIndex)) or not(SS_LeadingPlots_Includes(plotIndex))) then return false; end;
  SS_User.settings.currentPlot = plotIndex;
end;

SS_PlotController_GetCountOf = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  if (plotType == 'plots') then return SS_Plots_Count(); end;
  if (plotType == 'leadingPlots') then return SS_LeadingPlots_Count(); end;
end;

SS_PlotController_GetSummaryOf = function(plotType)
  if (not(plotType == 'current') and not(plotType == "selected")) then
    return { };
  end;
 
  local plot = { };

  local lookFor = nil;
  if (plotType == 'current') then
    lookFor = 'currentPlot';
  else
    lookFor = 'selectedPlot';
  end;

  if (SS_User.settings[lookFor] == nil) then
    return nil;
  end;

  if (SS_User.plots[SS_User.settings[lookFor]]) then
    plot.name = SS_User.plots[SS_User.settings[lookFor]].name;
    plot.playerInfo = {
      skills = SS_User.plots[SS_User.settings[lookFor]].skills,
    };
  end;

  if (SS_User.leadingPlots[SS_User.settings[lookFor]]) then
    plot.name = SS_User.leadingPlots[SS_User.settings[lookFor]].name;
    plot.leaderInfo = {
      players = SS_User.leadingPlots[SS_User.settings[lookFor]].players;
    };
  end;

  return plot;
end;

SS_PlotController_Draw = function(categoryName)
  local plotType;
  if (categoryName == nil or categoryName == 'Участник') then
    plotType = 'plots';
  else
    plotType = 'leadingPlots';
  end;
  
  local counter = 0;

  SS_Shared_DrawList(SS_Plots_Container, SS_User[plotType], function(plot, index, container)
    local PlotPanel = CreateFrame("Button", "OpenPlotPanel-"..plotType.."-"..index, container);
          PlotPanel:SetToplevel(false);
          PlotPanel:Show();
          PlotPanel:EnableMouse();
          PlotPanel:SetSize(224, 16);
          PlotPanel:SetBackdropColor(0, 0, 0, 1);
          PlotPanel:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -28 * counter);
          PlotPanel:SetNormalTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");
          PlotPanel:SetHighlightTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");

    local PlotName = PlotPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
          PlotName:SetPoint("LEFT", PlotPanel, "LEFT", 0, 4);
          PlotName:SetText(plot.name);
          PlotName:SetFont("Fonts\\FRIZQT__.TTF", 11);
          PlotName:Show();

    if (SS_User.leadingPlots[index]) then
      local PlotButton = CreateFrame("Button", nil, PlotPanel, "SecureHandlerClickTemplate");
            PlotButton:SetSize(16, 16);
            PlotButton:SetPoint("RIGHT", PlotPanel, "RIGHT", 0, 4);
            PlotButton:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\crown.blp");
            PlotButton:Show();
    end;

    if (index == SS_User.settings.currentPlot) then
      local PlotButton = CreateFrame("Button", nil, PlotPanel, "SecureHandlerClickTemplate");
            PlotButton:SetSize(12, 12);
            if (SS_User.leadingPlots[index]) then
              PlotButton:SetPoint("RIGHT", PlotPanel, "RIGHT", -24, 4);
            else
              PlotButton:SetPoint("RIGHT", PlotPanel, "RIGHT", 0, 4);
            end;
            PlotButton:SetNormalTexture("Interface\\AddOns\\SnowySystem\\IMG\\green-check.blp");
            PlotButton:Show();

      PlotName:SetTextColor(0.901, 0.494, 0.133, 1)
    end;

    PlotPanel:SetScript("OnClick", function()
      SS_Controll_Menu:Hide();
      SS_Plot_Activate:Hide();
      SS_PlotController_Select(index);
      SS_Plot_Activate:Show();
    end);

    counter = counter + 1;
  end);

  SS_Plots_Container:SetSize(236, 10 * counter);
end;

SS_PlotController_DrawPlayers = function(_plot)
  local plot;
  if (not(_plot)) then plot = SS_User.settings.currentPlot; end;
  if (plot == nil) then return nil end;
  if (not(SS_User.leadingPlots[plot])) then return nil end;

  local counter = 0;

  SS_Shared_DrawList(SS_Plot_Controll_List_Players, SS_User.leadingPlots[plot].players, function(player, index, container)
    local PlayerPanel = CreateFrame("Button", "PlayerPanel-"..player.."-"..index, container);
          PlayerPanel:SetToplevel(false);
          PlayerPanel:Show();
          PlayerPanel:EnableMouse();
          PlayerPanel:SetSize(224, 27);
          PlayerPanel:SetBackdropColor(0, 0, 0, 1);
          PlayerPanel:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -28 * counter);
          PlayerPanel:SetNormalTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");
          PlayerPanel:SetHighlightTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");

    local PlayerName = PlayerPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
          PlayerName:SetPoint("LEFT", PlayerPanel, "LEFT", 0, 4);
          PlayerName:SetText(player);
          PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 12);
          PlayerName:Show();

    if (not (player == UnitName("player"))) then
      local PlayerRemove = CreateFrame("Button", nil, PlayerPanel, "UIPanelButtonTemplate")
            PlayerRemove:SetSize(20, 20)
            PlayerRemove:SetText("x")
            PlayerRemove:SetPoint("TOPRIGHT")
            PlayerRemove:SetScript("OnClick", function()
              table.remove(SS_User.leadingPlots[plot].players, index)
              SS_PlotController_DrawPlayers(_plot);
            end)
    end;
  
    counter = counter + 1;
  end);

  SS_Plot_Controll_List_Players:SetSize(236, 12 * counter);
end;

SS_PlotController_OnActivate = function()
  SS_Player_Menu:SetSize(84, 255);
  SS_Player_Menu_DicesIcon:Show();
  SS_Player_Menu_StatsIcon:Show();
  SS_Player_Menu_SkillsIcon:Show();
  SS_Player_Menu_ArmorIcon:Show();
  SS_Player_Menu_SettingsIcon:ClearAllPoints()
  SS_Player_Menu_SettingsIcon:SetPoint("BOTTOM", SS_Player_Menu, "BOTTOM", 0, 20);
  SS_Progress_DrawAddonLevel();
  SS_Progress_ShowExpBar();
  SS_PlayerFrame:Show();
  SS_Params_DrawHealth();

  if (SS_LeadingPlots_Includes(SS_User.settings.currentPlot)) then
    SS_Plot_Controll:Show();
  end;
end;

SS_PlotController_OnDeactivate = function()
  SS_Player_Menu:SetSize(84, 84);
  SS_Player_Menu_DicesIcon:Hide();
  SS_Player_Menu_StatsIcon:Hide();
  SS_Player_Menu_SkillsIcon:Hide();
  SS_Player_Menu_ArmorIcon:Hide();
  SS_Player_Menu_SettingsIcon:ClearAllPoints()
  SS_Player_Menu_SettingsIcon:SetPoint("CENTER", SS_Player_Menu, "CENTER", 0, 0);
  SS_Progress_DrawDefaultLevel();
  SS_Progress_HideExpBar();
  SS_PlayerFrame:Hide();

  SS_Plot_Controll:Hide();
end;