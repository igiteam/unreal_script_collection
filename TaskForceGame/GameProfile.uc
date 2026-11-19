class GameProfile extends ProfileBase;

// --- WARNING --------------------------------------------------------------------------------------------------------
var private string      GameName;
var bool                bWonFinalMatch;
var int                 SelectedDifficultyIndex;
var PlayerProfile       pProfile;
// --- WARNING --------------------------------------------------------------------------------------------------------
// -Update ULoadSaveManager::MaxSaveGameFileSize if the maximum save game size changes
// -Update ULoadSaveManager::SaveGameFileVersion if the data layout changes
// --- WARNING --------------------------------------------------------------------------------------------------------
 
static simulated function CreateGameProfile(GameInfo    game, 
                                            string      inGameName, 
                                            int         difficultyIndex,
                                            int         teamSymbolIndex,
                                            string      playerName,
                                            string      playerCharacter)
{
    local GameProfile   gProfile;
    local PlayerProfile pProfile;

    assert(inGameName != "");

    gProfile = GameProfile(game.SaveGameCreateObject(class'GameProfile', inGameName));
    gProfile.SetGameName(inGameName);
    gProfile.SelectedDifficultyIndex = difficultyIndex; 

    game.SetCurrentGameProfile(gProfile);
    
    pProfile = class'PlayerProfile'.static.CreatePlayerProfile(game, inGameName, playerName, 0);
    gProfile.pProfile = pProfile;
}

simulated function Finish(GameInfo game) {}

simulated function PlayerProfile GetPlayer() 
{	
	return None; 
}

simulated function SetGameName(string inName)
{
    GameName = CapStringLen(inName);
}

simulated function string GetGameName()
{
    return GameName;
}

simulated function PlayerProfile FindCurrentPlayer(PlayerReplicationInfo pri)
{
    return None;
}


