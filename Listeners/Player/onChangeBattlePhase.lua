SS_Listeners_Player_OnChangeBattlePhase = function(data, author)
  if (not(SS_Plots_Current())) then return nil; end;
  if (not(SS_Plots_Current().battle)) then return nil; end;

  local plotID, battleType, nextPhase = strsplit('+', data);

  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  if (not(SS_Plots_Current().battle.phase == nextPhase)) then
    SS_Plots_Current().battle.phase = nextPhase;
    SS_BattleControll_RoundStart(battleType, SS_Plots_Current().battle.phase);
  end;
end;