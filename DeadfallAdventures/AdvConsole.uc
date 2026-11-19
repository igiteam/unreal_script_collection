class AdvConsole extends UTConsole within GameViewportClient
    transient
    native
    config(Input)
    hidecategories(Object,UIRoot);

var array<AutoCompleteCommand> AllowedCommands;

// Export UAdvConsole::execTrim(FFrame&, void* const)
native static final function string Trim(coerce string InStr);

function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
{
    return super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    //return ReturnValue;    
}

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
    AllowedCommands[6]=(Command="",Desc="")
    AllowedCommands[7]=(Command="",Desc="")
    AllowedCommands[8]=(Command="",Desc="")
    AllowedCommands[9]=(Command="DOFOcclusionTweak",Desc="")
    AllowedCommands[10]=(Command="FogDensity",Desc="")
    AllowedCommands[11]=(Command="FogStartDistance",Desc="")
    AllowedCommands[12]=(Command="FOV",Desc="Set FOV angle")
    AllowedCommands[13]=(Command="GetPlayerLoc",Desc="GetPlayerLoc")
    AllowedCommands[14]=(Command="ImageGrain",Desc="")
    AllowedCommands[15]=(Command="MotionBlurAmount",Desc="")
    AllowedCommands[16]=(Command="MotionBlurMaxVelocity",Desc="")
    AllowedCommands[17]=(Command="MotionBlurSoftEdge",Desc="")
    AllowedCommands[18]=(Command="MotionBlurTimeScaleMax",Desc="")
    AllowedCommands[19]=(Command="MotionBlurTimeScaleMin",Desc="")
    AllowedCommands[20]=(Command="Say",Desc="AdvGFxUI_Menu_Options_Controls:GBA_Talk")
    AllowedCommands[21]=(Command="ShowHUD",Desc="ShowHUD")
    AllowedCommands[22]=(Command="STARTMOVIECAPTURE",Desc="STARTMOVIECAPTURE")
    AllowedCommands[23]=(Command="Stat ANIM",Desc="Stat ANIM")
    AllowedCommands[24]=(Command="Stat AUDIO",Desc="Stat AUDIO")
    AllowedCommands[25]=(Command="Stat COLLISION",Desc="Stat COLLISION")
    AllowedCommands[26]=(Command="Stat FPS",Desc="Stat FPS (Shows FPS counter)")
    AllowedCommands[27]=(Command="Stat GAME",Desc="Stat GAME (Displays game performance stats)")
    AllowedCommands[28]=(Command="Stat LEVELS",Desc="Stat LEVELS (Displays level streaming info)")
    AllowedCommands[29]=(Command="Stat LIST",Desc="Stat LIST Groups/Sets/Group (List groups of stats, saved sets, or specific stats within a specified group)")
    AllowedCommands[30]=(Command="Stat MEMORY",Desc="Stat MEMORY (Displays memory stats)")
    AllowedCommands[31]=(Command="Stat NET",Desc="Stat NET")
    AllowedCommands[32]=(Command="Stat PARTICLES",Desc="Stat PARTICLES")
    AllowedCommands[33]=(Command="Stat PHYSICS",Desc="Stat PHYSICS (Displays physics performance stats)")
    AllowedCommands[34]=(Command="Stat SCRIPT",Desc="Stat SCRIPT")
    AllowedCommands[35]=(Command="Stat SOUNDCUES",Desc="Stat SOUNDCUES (Shows active SoundCues)")
    AllowedCommands[36]=(Command="Stat SOUNDS",Desc="Stat SOUNDS <?> <sort=distance|class|name|waves|default> <-debug> <off> (Shows active SoundCues and SoundWaves)")
    AllowedCommands[37]=(Command="Stat SOUNDWAVES",Desc="Stat SOUNDWAVES (Shows active SoundWaves)")
    AllowedCommands[38]=(Command="Stat STREAMING",Desc="Stat STREAMING (Displays basic texture streaming stats)")
    AllowedCommands[39]=(Command="Stat STREAMINGDETAILS",Desc="Stat STREAMINGDETAILS (Displays detailed texture streaming stats)")
    AllowedCommands[40]=(Command="Stat UNIT",Desc="Stat UNIT (Shows hardware unit framerate)")
    AllowedCommands[41]=(Command="STOPMOVIECAPTURE",Desc="STOPMOVIECAPTURE")
    AllowedCommands[42]=(Command="Talk",Desc="Talk")
    AllowedCommands[43]=(Command="TeamSay",Desc="AdvGFxUI_Menu_Options_Controls:GBA_TeamTalk")
    AllowedCommands[44]=(Command="TeamTalk",Desc="TeamTalk")
    AllowedCommands[45]=(Command="ToggleHUD",Desc="ToggleHUD")
    AllowedCommands[46]=(Command="TonemapperType",Desc="")
    AllowedCommands[47]=(Command="SetSensitivity",Desc="SetSensitivity F[FLOAT]")
    AllowedCommands[48]=(Command="SetBind",Desc="SetBind BindName[FName] Command[FString]")
    AllowedCommands[49]=(Command="Screenshot",Desc="")
    AllowedCommands[50]=(Command="Tiledshot",Desc="")
    AllowedCommands[51]=(Command="PackageMap",Desc="")
}