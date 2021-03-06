SS_Listeners_DM_OnPlayerSendBattleInitiative = function(data, player)
  if (not(SS_LeadingPlots_Current())) then return nil; end;
  if (not(SS_LeadingPlots_Current().battle)) then return nil; end;

  local plotID, initiative = strsplit('+', data);
  if (not(plotID == SS_User.settings.currentPlot)) then return nil; end;

  initiative = SS_Shared_NumFromStr(initiative);

  if (SS_LeadingPlots_Current().battle.playersByInitiative) then
    SS_LeadingPlots_Current().battle.players[player] = {
      isTurnEnded = false,
    };
  
    table.insert(SS_LeadingPlots_Current().battle.playersByInitiative, { name = player, initiative = initiative });
    SS_Log_PlayerJoinedToBattle(player);
    SS_DMtP_PlayerJoinSuccess(player);
    SS_DMtP_Direct('initiativeBattleJoinSuccess', SS_User.settings.currentPlot..'+'..SS_LeadingPlots_Current().battle.phase, player);
    return nil;
  end;

  if (not(SS_LeadingPlots_Current().battle.playersByInitiative)) then
    SS_LeadingPlots_Current().battle.playersByInitiative = {}; 
  end;

  if (not(SS_LeadingPlots_Current().battle.players)) then
    SS_LeadingPlots_Current().battle.players = {};
  end;

  if (not(SS_LeadingPlots_Current().battle.players[player])) then
    SS_LeadingPlots_Current().battle.players[player] = {
      isTurnEnded = false,
    };
    
    SS_Log_PlayerJoinedToBattle(player);
  end;

  if (not(SS_LeadingPlots_Current().battle.players[player].isTurnEnded)) then
    table.insert(SS_LeadingPlots_Current().battle.playersByInitiative, { name = player, initiative = initiative });
    table.sort(SS_LeadingPlots_Current().battle.playersByInitiative, function(player, nextPlayer)
      return player.initiative > nextPlayer.initiative
    end);

    local syncTime = 1;
    if (SS_LeadingPlots_Current().battle.syncTimer) then
      SS_LeadingPlots_Current().battle.syncTimer:Hide();
      SS_LeadingPlots_Current().battle.syncTimer = nil;
    end;

    SS_LeadingPlots_Current().battle.syncTimer = CreateFrame("Frame")
    SS_LeadingPlots_Current().battle.syncTimer:SetScript("OnUpdate", function(self, elapsed)
      syncTime = syncTime - elapsed
      if syncTime <= 0 then
        if (not(SS_LeadingPlots_Current().battle)) then 
          self:Hide();
          self = nil;
          return;
        end;
        SS_LeadingPlots_Current().battle.syncTimer:Hide();
        SS_LeadingPlots_Current().battle.syncTimer = nil;

        if (not(SS_LeadingPlots_Current().battle.phase == 'defence')) then
          SS_LeadingPlots_Current().battle.phase = SS_LeadingPlots_Current().battle.playersByInitiative[1].name;
        end;

        SS_DMtP_BattleInitiativeTableFormed(SS_LeadingPlots_Current().battle.phase);

        if (not(SS_BattleControll_AmIPlayer())) then
          SS_BattleControll_RoundStart('initiative', SS_LeadingPlots_Current().battle.phase);
        end;
      end
    end)
  end;
end;