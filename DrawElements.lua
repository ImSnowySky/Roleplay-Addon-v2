SS_DrawPlots = function(categoryName)
  local plotType;
  if (categoryName == nil or categoryName == 'Участник') then
    plotType = 'plots';
  else
    plotType = 'leadingPlots';
  end;

  local childs = { SS_Plots_Container:GetChildren() };

  for _, child in pairs(childs) do
    child:Hide();
  end

  local counter = 0;
  for index, plot in pairs(SS_User[plotType]) do
    local panelName = "OpenPlotPanel-"..plotType.."-"..index;
    local PlotPanel = CreateFrame("Button", panelName, SS_Plots_Container);
          PlotPanel:SetToplevel(false);
          PlotPanel:Show();
          PlotPanel:EnableMouse();
          PlotPanel:SetWidth(200);
          PlotPanel:SetHeight(16);
          PlotPanel:SetBackdropColor(0, 0, 0, 1);
          PlotPanel:SetPoint("RIGHT", SS_Controll_Menu, "TOPRIGHT", -92, -86 - 32 * counter);
          PlotPanel:SetNormalTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");
          PlotPanel:SetHighlightTexture("Interface\\AddOns\\STIK_DM\\IMG\\plot-background.blp");

      local PlotName = PlotPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
            PlotName:SetPoint("LEFT", PlotPanel, "LEFT", 0, 4);
            PlotName:SetText(plot.name);
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
        SS_MakePlotSelected(index);
        SS_Plot_Activate:Show();
      end);

      counter = counter + 1;
  end;
end;

SS_HideEmptyPlotsText = function(plotType)
  if (not(plotType == 'plots') and not(plotType == 'leadingPlots')) then
    return 0;
  end;

  if (SS_getPlotsCount(plotType) == 0) then
    SS_Controll_Menu_Settings_EmptyPlot:Show();
    SS_Controll_Menu_Settings_EmptyPlot:SetText("Сюжетов не найдено");
  else
    SS_Controll_Menu_Settings_EmptyPlot:Hide();
  end;
end;

SS_ResizePlayerMenuOnPlotActivate = function()
  SS_Player_Menu:SetSize(84, 168);
  SS_Player_Menu_StatsIcon:Show();
  SS_Player_Menu_SkillsIcon:Show();
  SS_Player_Menu_SettingsIcon:ClearAllPoints()
  SS_Player_Menu_SettingsIcon:SetPoint("BOTTOM", SS_Player_Menu, "BOTTOM", 0, 20);
end;

SS_ResizePlayerMenuOnPlotDeactivate = function()
  SS_Player_Menu:SetSize(84, 84);
  SS_Player_Menu_StatsIcon:Hide();
  SS_Player_Menu_SkillsIcon:Hide();
  SS_Player_Menu_SettingsIcon:ClearAllPoints()
  SS_Player_Menu_SettingsIcon:SetPoint("CENTER", SS_Player_Menu, "CENTER", 0, 0);
end;

SS_HideAllSubmenus = function()
  SS_Stats_Menu:Hide();
  SS_Controll_Menu:Hide();
end;