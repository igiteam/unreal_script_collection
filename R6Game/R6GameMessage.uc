class R6GameMessage extends GameMessage;

var const localized string MatchBeginsMsg;
var const localized string MatchHasBegunMsg;
var const localized string MatchHasEndedMsg;
var const localized string MatchRoundBeginsMsg;
var const localized string MatchRoundHasEndedMsg;
var const localized string MatchRoundWinnerMsg;
var const localized string MatchRoundDrawMsg;
var const localized string MatchEndSucceededMsg;
var const localized string MatchEndFailedMsg;
var const localized string PlayerRevivedMsg;
var const localized string PlayerRevivedHelperMsg;
var const localized string MatchWaitingMsg;
var const localized string SpawnZoneDestroyedMsg;
var const localized string PlayerBannedMsg;
var const localized string TeamKillerBannedMsg;
var const localized string PunkBusterBannedMsg3;
var Color TeamColor;
var Color EnemyTeamColor;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local Color clrTextMsg;
    local float fMessageLifeTime;
    local string szTextMsg;
    local SoundCue sndVoiceMsg;
    local R6PlayerController PC;

    PC = R6PlayerController(P);
    szTextMsg = RetrieveString(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    clrTextMsg = RetrieveColor(PC, Switch, RelatedPRI_1, RelatedPRI_2);
    fMessageLifeTime = GetLifeTime(Switch);
    // End:0x12B
    if((RelatedPRI_1 == P.PlayerReplicationInfo) && ((int(byte(Switch)) == int(45)) || int(byte(Switch)) == int(44)) || int(byte(Switch)) == int(49))
    {
        // End:0x12B
        if((PC != none) && RelatedPRI_1 != none)
        {
            PC.SetMainMenuParameters(int(byte(Switch)) == int(44), int(byte(Switch)) == int(45), int(byte(Switch)) == int(49));
        }
    }
    switch(byte(Switch))
    {
        // End:0x139
        case 1:
        // End:0x13E
        case 4:
        // End:0x143
        case 17:
        // End:0x148
        case 26:
        // End:0x14D
        case 27:
        // End:0x152
        case 28:
        // End:0x157
        case 29:
        // End:0x15C
        case 30:
        // End:0x161
        case 31:
        // End:0x166
        case 32:
        // End:0x16B
        case 44:
        // End:0x170
        case 45:
        // End:0x175
        case 49:
        // End:0x1C2
        case 3:
            // End:0x1BF
            if(PC.m_MagmaInteraction != none)
            {
                PC.m_MagmaInteraction.ShowGameMessage(byte(Switch), Caps(szTextMsg), fMessageLifeTime, clrTextMsg);
            }
            // End:0x40C
            break;
        // End:0x208
        case 43:
            // End:0x205
            if(PC.m_MagmaInteraction != none)
            {
                PC.m_MagmaInteraction.ShowTextInformationBox(Caps(szTextMsg), fMessageLifeTime, clrTextMsg);
            }
            // End:0x40C
            break;
        // End:0x20D
        case 20:
        // End:0x212
        case 22:
        // End:0x217
        case 24:
        // End:0x308
        case 23:
            // End:0x305
            if(PC.m_MagmaInteraction != none)
            {
                PC.m_MagmaInteraction.ShowGameMessage(byte(Switch), szTextMsg, fMessageLifeTime, clrTextMsg);
                sndVoiceMsg = RetrieveSound(PC, Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                PC.StopSound(PC.GetPlayerInfo().GetGameStatusVoiceMsg());
                PC.PlaySound(sndVoiceMsg, 13, false, true);
                PC.GetPlayerInfo().SaveGameStatus(szTextMsg, sndVoiceMsg);
            }
            // End:0x40C
            break;
        // End:0xFFFF
        default:
            // End:0x386
            if(P.myHUD != none)
            {
                P.myHUD.LocalizedMessage(default.Class, RelatedPRI_1, szTextMsg, Switch, GetPos(Switch), fMessageLifeTime, GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), clrTextMsg);
            }
            // End:0x409
            if(((IsConsoleMessage(Switch)) && LocalPlayer(P.Player) != none) && LocalPlayer(P.Player).ViewportClient != none)
            {
                LocalPlayer(P.Player).ViewportClient.ViewportConsole.OutputText(szTextMsg);
            }
            // End:0x40C
            break;
            break;
    }
    return;
}

static simulated function string RetrieveString(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string szText;

    switch(byte(Switch))
    {
        // End:0x1C
        case 17:
            return default.MatchWaitingMsg;
            // End:0x3CF
            break;
        // End:0x4E
        case 18:
            return ((default.MatchBeginsMsg $ " ( ") $ string(GameReplicationInfo(OptionalObject).RemainingTime)) $ " )";
            // End:0x3CF
            break;
        // End:0x5C
        case 19:
            return default.MatchHasBegunMsg;
            // End:0x3CF
            break;
        // End:0x6A
        case 20:
            return default.MatchHasEndedMsg;
            // End:0x3CF
            break;
        // End:0x9C
        case 21:
            return ((default.MatchRoundBeginsMsg $ " ( ") $ string(GameReplicationInfo(OptionalObject).RemainingTime)) $ " )";
            // End:0x3CF
            break;
        // End:0x110
        case 22:
            // End:0xCA
            if(RelatedPRI_1 != none)
            {
                return (RelatedPRI_1.PlayerName $ "\n") $ default.MatchRoundWinnerMsg;                
            }
            else
            {
                // End:0x107
                if(OptionalObject != none)
                {
                    // End:0x107
                    if(R6TeamInfo(OptionalObject) != none)
                    {
                        return (R6TeamInfo(OptionalObject).GetTeamName() $ "\n") $ default.MatchRoundWinnerMsg;
                    }
                }
            }
            return default.MatchRoundHasEndedMsg;
            // End:0x3CF
            break;
        // End:0x11E
        case 24:
            return default.MatchEndFailedMsg;
            // End:0x3CF
            break;
        // End:0x12C
        case 23:
            return default.MatchEndSucceededMsg;
            // End:0x3CF
            break;
        // End:0x17F
        case 26:
            // End:0x17C
            if(class<DamageType>(OptionalObject) != none)
            {
                return Class'Engine.GameInfo'.static.ParseKillMessage("", RelatedPRI_2.PlayerName, class<DamageType>(OptionalObject).static.SuicideMessage(RelatedPRI_2));
            }
            // End:0x3CF
            break;
        // End:0x1D4
        case 27:
            // End:0x1D1
            if(class<DamageType>(OptionalObject) != none)
            {
                return Class'Engine.GameInfo'.static.ParseKillMessage("", RelatedPRI_2.PlayerName, class<DamageType>(OptionalObject).static.DeathMessage(none, RelatedPRI_2));
            }
            // End:0x3CF
            break;
        // End:0x239
        case 28:
            // End:0x236
            if(class<DamageType>(OptionalObject) != none)
            {
                return Class'Engine.GameInfo'.static.ParseKillMessage(RelatedPRI_1.PlayerName, RelatedPRI_2.PlayerName, class<DamageType>(OptionalObject).static.DeathMessage(RelatedPRI_1, RelatedPRI_2));
            }
            // End:0x3CF
            break;
        // End:0x28E
        case 29:
            // End:0x28B
            if(class<DamageType>(OptionalObject) != none)
            {
                return Class'Engine.GameInfo'.static.ParseKillMessage("", RelatedPRI_2.PlayerName, class<DamageType>(OptionalObject).static.DeathMessage(none, RelatedPRI_2, true));
            }
            // End:0x3CF
            break;
        // End:0x2B1
        case 30:
            return (default.PlayerRevivedMsg $ " ") $ RelatedPRI_1.PlayerName;
            // End:0x3CF
            break;
        // End:0x2D4
        case 31:
            return (default.PlayerRevivedHelperMsg $ " ") $ RelatedPRI_1.PlayerName;
            // End:0x3CF
            break;
        // End:0x30F
        case 32:
            // End:0x30C
            if(R6TeamSpawnZone(OptionalObject) != none)
            {
                return (default.SpawnZoneDestroyedMsg $ " ") $ R6TeamSpawnZone(OptionalObject).GetDescription(true);
            }
            // End:0x3CF
            break;
        // End:0x341
        case 43:
            // End:0x33E
            if(R6Objective(OptionalObject) != none)
            {
                R6Objective(OptionalObject).GetDescription(szText);
            }
            // End:0x3CF
            break;
        // End:0x363
        case 44:
            return FormatStrings(default.PlayerBannedMsg, RelatedPRI_1.PlayerName);
        // End:0x385
        case 45:
            return FormatStrings(default.TeamKillerBannedMsg, RelatedPRI_1.PlayerName);
        // End:0x3A7
        case 49:
            return FormatStrings(default.PlayerBannedMsg, RelatedPRI_1.PlayerName);
        // End:0xFFFF
        default:
            return GetString(Switch, bPRI1HUD, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x3CF
    return szText;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x3CF
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x3CF
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x3CF
}

static function Color RetrieveColor(R6PlayerController PC, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    switch(byte(Switch))
    {
        // End:0x8D
        case 26:
            // End:0x68
            if(PC.PlayerReplicationInfo.Team != none)
            {
                return ((PC.PlayerReplicationInfo.Team == RelatedPRI_2.Team) ? default.TeamColor : default.EnemyTeamColor);                
            }
            else
            {
                return ((PC.PlayerReplicationInfo == RelatedPRI_2) ? default.TeamColor : default.EnemyTeamColor);
            }
        // End:0x16C
        case 28:
            // End:0x144
            if(PC.PlayerReplicationInfo.Team != none)
            {
                // End:0x10A
                if(RelatedPRI_1.Team == RelatedPRI_2.Team)
                {
                    return ((PC.PlayerReplicationInfo.Team == RelatedPRI_2.Team) ? default.TeamColor : default.EnemyTeamColor);                    
                }
                else
                {
                    return ((PC.PlayerReplicationInfo.Team != RelatedPRI_2.Team) ? default.TeamColor : default.EnemyTeamColor);
                }                
            }
            else
            {
                return ((PC.PlayerReplicationInfo == RelatedPRI_1) ? default.TeamColor : default.EnemyTeamColor);
            }
            // End:0x193
            break;
        // End:0x171
        case 29:
        // End:0x176
        case 27:
        // End:0xFFFF
        default:
            return GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x193
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x193
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x193
}

static simulated function SoundCue RetrieveSound(R6PlayerController PC, optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch(byte(Switch))
    {
        // End:0x2F
        case 23:
            return PC.GetMiscConfig().m_sndMissionSucceeded;
            // End:0x13B
            break;
        // End:0x50
        case 24:
            return PC.GetMiscConfig().m_sndMissionFailed;
            // End:0x13B
            break;
        // End:0x135
        case 22:
            // End:0x89
            if(RelatedPRI_1 == PC.PlayerReplicationInfo)
            {
                return PC.GetMiscConfig().m_sndMissionSucceeded;                
            }
            else
            {
                // End:0x104
                if((OptionalObject != none) && R6TeamInfo(OptionalObject) != none)
                {
                    // End:0xE8
                    if(PC.PlayerReplicationInfo.Team == R6TeamInfo(OptionalObject))
                    {
                        return PC.GetMiscConfig().m_sndMissionSucceeded;                        
                    }
                    else
                    {
                        return PC.GetMiscConfig().m_sndMissionFailed;
                    }                    
                }
                else
                {
                    // End:0x135
                    if((RelatedPRI_1 != none) || OptionalObject != none)
                    {
                        return PC.GetMiscConfig().m_sndMissionFailed;
                    }
                }
            }
        // End:0xFFFF
        default:
            // End:0x13B
            break;
            break;
    }
    return none;
    return;
}

defaultproperties
{
    MatchBeginsMsg="MATCH BEGINS IN"
    MatchHasBegunMsg="MATCH HAS BEGUN"
    MatchHasEndedMsg="MATCH HAS ENDED!"
    MatchRoundBeginsMsg="ROUND BEGINS IN"
    MatchRoundHasEndedMsg="ROUND HAS ENDED!"
    MatchRoundWinnerMsg="WON THE ROUND!"
    MatchRoundDrawMsg="ROUND IS A DRAW!"
    MatchEndSucceededMsg="MISSION SUCCESSFUL"
    MatchEndFailedMsg="MISSION FAILED"
    PlayerRevivedMsg="YOU'VE BEEN REVIVED BY"
    PlayerRevivedHelperMsg="GOOD JOB! YOU'VE REVIVED"
    MatchWaitingMsg="WAITING FOR PLAYERS"
    SpawnZoneDestroyedMsg="SPAWN POINT DESTROYED."
    PlayerBannedMsg="%s HAS BEEN BANNED FROM THIS SERVER."
    TeamKillerBannedMsg="%s WAS KICKED FOR EXCESSIVE TEAM-KILLING."
    TeamColor=(R=0,G=255,B=0,A=255)
    EnemyTeamColor=(R=255,G=0,B=0,A=255)
    LeftMessage="LEFT THE GAME"
    EnteredMessage=" ENTERED THE GAME"
    TerroristName="TERRORIST"
    Lifetime=5
}