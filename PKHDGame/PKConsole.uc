class PKConsole extends UTConsole within GameViewportClient
    transient
    native
    config(Input)
    hidecategories(Object,UIRoot);

var array<AutoCompleteCommand> AllowedCommands;

// Export UPKConsole::execTrim(FFrame&, void* const)
native static final function string Trim(coerce string InStr);

function ConsoleCommand(string Command)
{
    local string ActualCmd;
    local int I, ActualLen;

    Command = Trim(Command);
    ActualLen = InStr(Command, " ");
    // End:0xBA
    if(ActualLen > 0)
    {
        ActualCmd = Left(Command, ActualLen);
        // End:0xB7
        if((ActualCmd ~= "STAT") || ActualCmd ~= "SHOW")
        {
            ActualCmd = Command;
            ActualLen = Len(Command);
        }        
    }
    else
    {
        ActualCmd = Command;
        ActualLen = Len(Command);
    }
    ActualCmd = Caps(ActualCmd);
    I = 0;
    J0x102:

    // End:0x173 [Loop If]
    if(I < AllowedCommands.Length)
    {
        // End:0x165
        if(ActualCmd == Caps(AllowedCommands[I].Command))
        {
            super(Console).ConsoleCommand(Command);
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x102;
    }
    super(Console).ConsoleCommand("Say" @ Command);
    //return;    
}

defaultproperties
{
    AllowedCommands[0]=(Command="AmbientOcclusionQuality",Desc="")
    AllowedCommands[1]=(Command="BloomQuality",Desc="")
    AllowedCommands[2]=(Command="BloomScale",Desc="")
    AllowedCommands[3]=(Command="BloomSize",Desc="")
    AllowedCommands[4]=(Command="BloomThreshold",Desc="")
    AllowedCommands[5]=(Command="BloomType",Desc="")
    AllowedCommands[6]=(Command="CaptureMode",Desc="Toggles display state of all on-screen warnings/messages")
    AllowedCommands[7]=(Command="ConsoleKey",Desc="ConsoleKey Key[FName]")
    AllowedCommands[8]=(Command="DisableAllScreenMessages",Desc="Disables all on-screen warnings/messages")
    AllowedCommands[9]=(Command="DOFOcclusionTweak",Desc="")
    AllowedCommands[10]=(Command="EnableAllScreenMessages",Desc="Enables all on-screen warnings/messages")
    AllowedCommands[11]=(Command="Exit",Desc="Generic:ConfirmSurrender_Title")
    AllowedCommands[12]=(Command="FogDensity",Desc="")
    AllowedCommands[13]=(Command="FogStartDistance",Desc="")
    AllowedCommands[14]=(Command="FOV",Desc="Set FOV angle")
    AllowedCommands[15]=(Command="FreezeAtPosition",Desc="")
    AllowedCommands[16]=(Command="GetPlayerLoc",Desc="GetPlayerLoc")
    AllowedCommands[17]=(Command="ImageGrain",Desc="")
    AllowedCommands[18]=(Command="Jump",Desc="Jump")
    AllowedCommands[19]=(Command="ListTextures",Desc="ListTextures (Lists all loaded textures and their current memory footprint)")
    AllowedCommands[20]=(Command="MotionBlurAmount",Desc="")
    AllowedCommands[21]=(Command="MotionBlurMaxVelocity",Desc="")
    AllowedCommands[22]=(Command="MotionBlurSoftEdge",Desc="")
    AllowedCommands[23]=(Command="MotionBlurTimeScaleMax",Desc="")
    AllowedCommands[24]=(Command="MotionBlurTimeScaleMin",Desc="")
    AllowedCommands[25]=(Command="NextWeapon",Desc="NextWeapon")
    AllowedCommands[26]=(Command="Pause",Desc="Pause")
    AllowedCommands[27]=(Command="PostprocessAAType",Desc="")
    AllowedCommands[28]=(Command="PreViewTranslation",Desc="")
    AllowedCommands[29]=(Command="PrevWeapon",Desc="PrevWeapon")
    AllowedCommands[30]=(Command="Quit",Desc="Generic:ConfirmSurrender_Title")
    AllowedCommands[31]=(Command="ReloadCfg",Desc="ReloadCfg <Class/ObjectName> (Reloads config variables for the specified object/class)")
    AllowedCommands[32]=(Command="ReloadLoc",Desc="ReloadLoc <Class/ObjectName> (Reloads localized variables for the specified object/class)")
    AllowedCommands[33]=(Command="RenderTimeFrozen",Desc="")
    AllowedCommands[34]=(Command="ResetSoundState",Desc="ResetSoundState (Resets volumes to default and removes test filters)")
    AllowedCommands[35]=(Command="RestartLevel",Desc="RestartLevel (restarts the level)")
    AllowedCommands[36]=(Command="Say",Desc="PKGFxUI_Menu_Options_Controls:GBA_Talk")
    AllowedCommands[37]=(Command="SetAudioGroupVolume",Desc="SetAudioGroupVolume GroupName[FName] Volume[FLOAT]")
    AllowedCommands[38]=(Command="SetShowSubtitles",Desc="SetShowSubtitles bValue[UBOOL]")
    AllowedCommands[39]=(Command="Show BOUNDS",Desc="Show BOUNDS (Displays bounding boxes for all visible objects)")
    AllowedCommands[40]=(Command="Show BSP",Desc="Show BSP (Toggles BSP rendering)")
    AllowedCommands[41]=(Command="Show COLLISION",Desc="Show COLLISION (Toggles collision rendering)")
    AllowedCommands[42]=(Command="Show COVER",Desc="Show COVER (Toggles cover rendering)")
    AllowedCommands[43]=(Command="Show DECALS",Desc="Show DECALS (Toggles decal rendering)")
    AllowedCommands[44]=(Command="Show FOG",Desc="Show FOG (Toggles fog rendering)")
    AllowedCommands[45]=(Command="Show LEVELCOLORATION",Desc="Show LEVELCOLORATION (Toggles per-level coloration)")
    AllowedCommands[46]=(Command="Show PATHS",Desc="Show PATHS (Toggles path rendering)")
    AllowedCommands[47]=(Command="Show POSTPROCESS",Desc="Show POSTPROCESS (Toggles post process rendering)")
    AllowedCommands[48]=(Command="Show SKELMESHES",Desc="Show SKELMESHES (Toggles skeletal mesh rendering)")
    AllowedCommands[49]=(Command="Show SPLINES",Desc="Show SPLINES (Toggles spline rendering)")
    AllowedCommands[50]=(Command="Show TERRAIN",Desc="Show TERRAIN (Toggles terrain rendering)")
    AllowedCommands[51]=(Command="Show VOLUMES",Desc="Show VOLUMES (Toggles volume rendering)")
    AllowedCommands[52]=(Command="ShowHUD",Desc="ShowHUD")
    AllowedCommands[53]=(Command="SpeedMeter",Desc="Speed meter")
    AllowedCommands[54]=(Command="StartAltFire",Desc="StartAltFire FireModeNum[BYTE]")
    AllowedCommands[55]=(Command="StartFire",Desc="StartFire FireModeNum[BYTE]")
    AllowedCommands[56]=(Command="STARTMOVIECAPTURE",Desc="STARTMOVIECAPTURE")
    AllowedCommands[57]=(Command="Stat ANIM",Desc="Stat ANIM")
    AllowedCommands[58]=(Command="Stat AUDIO",Desc="Stat AUDIO")
    AllowedCommands[59]=(Command="Stat COLLISION",Desc="Stat COLLISION")
    AllowedCommands[60]=(Command="Stat FPS",Desc="Stat FPS (Shows FPS counter)")
    AllowedCommands[61]=(Command="Stat GAME",Desc="Stat GAME (Displays game performance stats)")
    AllowedCommands[62]=(Command="Stat LEVELS",Desc="Stat LEVELS (Displays level streaming info)")
    AllowedCommands[63]=(Command="Stat LIST",Desc="Stat LIST Groups/Sets/Group (List groups of stats, saved sets, or specific stats within a specified group)")
    AllowedCommands[64]=(Command="Stat MEMORY",Desc="Stat MEMORY (Displays memory stats)")
    AllowedCommands[65]=(Command="Stat NET",Desc="Stat NET")
    AllowedCommands[66]=(Command="Stat PARTICLES",Desc="Stat PARTICLES")
    AllowedCommands[67]=(Command="Stat PHYSICS",Desc="Stat PHYSICS (Displays physics performance stats)")
    AllowedCommands[68]=(Command="Stat SCRIPT",Desc="Stat SCRIPT")
    AllowedCommands[69]=(Command="Stat SOUNDCUES",Desc="Stat SOUNDCUES (Shows active SoundCues)")
    AllowedCommands[70]=(Command="Stat SOUNDS",Desc="Stat SOUNDS <?> <sort=distance|class|name|waves|default> <-debug> <off> (Shows active SoundCues and SoundWaves)")
    AllowedCommands[71]=(Command="Stat SOUNDWAVES",Desc="Stat SOUNDWAVES (Shows active SoundWaves)")
    AllowedCommands[72]=(Command="Stat splitscreen",Desc="")
    AllowedCommands[73]=(Command="Stat STREAMING",Desc="Stat STREAMING (Displays basic texture streaming stats)")
    AllowedCommands[74]=(Command="Stat STREAMINGDETAILS",Desc="Stat STREAMINGDETAILS (Displays detailed texture streaming stats)")
    AllowedCommands[75]=(Command="Stat UNIT",Desc="Stat UNIT (Shows hardware unit framerate)")
    AllowedCommands[76]=(Command="StopAltFire",Desc="StopAltFire FireModeNum[BYTE]")
    AllowedCommands[77]=(Command="StopFire",Desc="StopFire FireModeNum[BYTE]")
    AllowedCommands[78]=(Command="STOPMOVIECAPTURE",Desc="STOPMOVIECAPTURE")
    AllowedCommands[79]=(Command="Suicide",Desc="Suicide")
    AllowedCommands[80]=(Command="SwitchToBestWeapon",Desc="SwitchToBestWeapon bForceNewWeapon[UBOOL]")
    AllowedCommands[81]=(Command="SwitchWeapon",Desc="SwitchWeapon T[BYTE]")
    AllowedCommands[82]=(Command="Talk",Desc="Talk")
    AllowedCommands[83]=(Command="TeamSay",Desc="PKGFxUI_Menu_Options_Controls:GBA_TeamTalk")
    AllowedCommands[84]=(Command="TeamTalk",Desc="TeamTalk")
    AllowedCommands[85]=(Command="ToggleAllScreenMessages",Desc="Toggles display state of all on-screen warnings/messages")
    AllowedCommands[86]=(Command="ToggleFlashlight",Desc="ToggleFlashlight")
    AllowedCommands[87]=(Command="ToggleHUD",Desc="ToggleHUD")
    AllowedCommands[88]=(Command="TonemapperType",Desc="")
    AllowedCommands[89]=(Command="Use",Desc="Use")
    AllowedCommands[90]=(Command="Admin",Desc="Admin CommandLine[FString]")
    AllowedCommands[91]=(Command="AdminForceTextMute",Desc="AdminForceTextMute TargetPlayer[FString]")
    AllowedCommands[92]=(Command="AdminForceTextUnMute",Desc="AdminForceTextUnMute TargetPlayer[FString]")
    AllowedCommands[93]=(Command="AdminKick",Desc="AdminKick S[FString]")
    AllowedCommands[94]=(Command="AdminKickBan",Desc="AdminKickBan S[FString]")
    AllowedCommands[95]=(Command="AdminLogin",Desc="AdminLogin Password[FString]")
    AllowedCommands[96]=(Command="AdminLogout",Desc="AdminLogout")
    AllowedCommands[97]=(Command="AdminPlayerList",Desc="AdminPlayerList")
    AllowedCommands[98]=(Command="AdminRestartMap",Desc="AdminRestartMap")
    AllowedCommands[99]=(Command="Disconnect",Desc="Disconnect")
    AllowedCommands[100]=(Command="InvertMouse",Desc="InvertMouse ReturnValue[UBOOL]")
    AllowedCommands[101]=(Command="InvertTurn",Desc="InvertTurn ReturnValue[UBOOL]")
    AllowedCommands[102]=(Command="Kick",Desc="Kick S[FString]")
    AllowedCommands[103]=(Command="KickBan",Desc="KickBan S[FString]")
    AllowedCommands[104]=(Command="PlayerList",Desc="PlayerList")
    AllowedCommands[105]=(Command="RestartMap",Desc="RestartMap")
    AllowedCommands[106]=(Command="SetSensitivity",Desc="SetSensitivity F[FLOAT]")
    AllowedCommands[107]=(Command="SwitchTeam",Desc="SwitchTeam")
    AllowedCommands[108]=(Command="SetBind",Desc="SetBind BindName[FName] Command[FString]")
    AllowedCommands[109]=(Command="Screenshot",Desc="")
    AllowedCommands[110]=(Command="Tiledshot",Desc="")
    AllowedCommands[111]=(Command="PackageMap",Desc="")
    HistoryTop=7
    HistoryBot=0
    HistoryCur=7
    History[0]="PKGold 666"
    History[1]="DebugUnlockCards"
    History[2]="DebugGiveSilverCard 9"
    History[3]="DebugGiveSilverCard 3"
    History[4]="DebugGiveSilverCard 2"
    History[5]="DebugGiveSilverCard 1"
    History[6]="asd"
}