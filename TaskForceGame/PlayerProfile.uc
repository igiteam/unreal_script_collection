//=============================================================================
// PlayerProfile.
// Copyright 2001 Digital Extremes - All Rights Reserved.
// Confidential.
//=============================================================================
class PlayerProfile extends ProfileBase;


// --- WARNING --------------------------------------------------------------------------------------------------------
var  private string     PlayerName;
var int                 PlayerRecordIndex;
// --- WARNING --------------------------------------------------------------------------------------------------------
// -Update ULoadSaveManager::MaxSaveGameFileSize if the maximum save game size changes
// -Update ULoadSaveManager::SaveGameFileVersion if the data layout changes
// --- WARNING --------------------------------------------------------------------------------------------------------


static simulated function PlayerProfile CreatePlayerProfile(GameInfo    game, 
                                                            string      inGameName,
                                                            string      inPlayerName, 
                                                            int         inPlayerRecordIndex)
{
    local PlayerProfile pProfile;

    pProfile = PlayerProfile(game.SaveGameCreateObject(class'PlayerProfile', inGameName));
    pProfile.SetPlayerName(inPlayerName);
    pProfile.PlayerRecordIndex = inPlayerRecordIndex;


    return pProfile;
}

simulated function SetPlayerName(string inName)
{
    PlayerName = CapStringLen(inName);
}

simulated function string GetPlayerName()
{
    return PlayerName;
}

simulated function LogPlayerProfile()
{
    log(self$" LogPlayerProfile... PlayerName="$PlayerName);
    log(self$" LogPlayerProfile... PlayerRecordIndex="$PlayerRecordIndex);
    log(self$" DONE LogPlayerProfile...");
}


