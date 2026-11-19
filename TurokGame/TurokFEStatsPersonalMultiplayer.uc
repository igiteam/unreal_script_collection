class TurokFEStatsPersonalMultiplayer extends TurokUISceneController
    native;

const NUM_PERSONAL_MP_STATS = 56;

var @NULL HighlightImages[3];
var @NULL mOverlayEdges[2];
var @NULL mGamertag;
var @NULL StatInfo;
var @NULL TheTable;
var @NULL TheMenu;
var byte StatEnums[56];
var string StatInfos[56];
var int PrevSelectedSlotIndex;
var transient bool SuppressMouseWheel;

// Export UTurokFEStatsPersonalMultiplayer::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event SCInitialized()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x69 [Loop If]
    if(I < 3)
    {
        HighlightImages[I] = UIImage(Scene.FindChild(name("RowHighlight_" $ string(I))));
        // End:0x5F
        if(HighlightImages[I] != none)
        {
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    StatInfo = UILabel(Scene.FindChild(name("StatBlurb")));
    // End:0x9C
    if(StatInfo != none)
    {
    }
    TheTable = TurokUITable(Scene.FindChild(name("TheTable")));
    // End:0x103
    if(TheTable != none)
    {
        SetupStatsList();
        TheTable.PostSetupInitialize();
        UpdateStatInfo();
        PositionHighlightImage(true);
    }
    TheMenu = TurokUIMenu(Scene.FindChild(name("PCOptionsMenu"), true));
    TheMenu.SetItemDelegate(0, CloseMenu);
    TheMenu.PostSetupInitialize();
    TheMenu.StartFadeIn();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().Reset();
    Class'TurokEngine.TurokUIHelpBar'.static.Instance().SetButton(2, 675426377);
    //return;    
}

event SCTick(float DeltaTime)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x77 [Loop If]
    if(I < 3)
    {
        // End:0x6D
        if((HighlightImages[I] != none) && HighlightImages[I].ScriptCtrl != none)
        {
            HighlightImages[I].ScriptCtrl.Tick(HighlightImages[I]);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xB9
    if((StatInfo != none) && StatInfo.ScriptCtrl != none)
    {
        StatInfo.ScriptCtrl.Tick(StatInfo);
    }
    // End:0xD7
    if(TheTable != none)
    {
        TheTable.Tick();
    }
    // End:0xF5
    if(TheMenu != none)
    {
        TheMenu.Tick();
    }
    mGamertag.Tick();
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x51 [Loop If]
    if(I < 3)
    {
        // End:0x47
        if(HighlightImages[I] != none)
        {
            HighlightImages[I].ScriptCtrl = none;
            HighlightImages[I] = none;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x73
    if(StatInfo != none)
    {
        StatInfo.ScriptCtrl = none;
        StatInfo = none;
    }
    // End:0x98
    if(TheTable != none)
    {
        TheTable.Deinitialize();
        TheTable = none;
    }
    I = 0;
    J0x9F:

    // End:0xDB [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x9F;
    }
    mGamertag = none;
    //return;    
}

event bool SCInputKey_StatsAchievements(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    // End:0x136
    if((int(Event) == int(0)) || int(Event) == int(2))
    {
        // End:0xCF
        if(TheTable != none)
        {
            // End:0xCF
            if(TheTable.ProcessInput(ControllerId, Key, Event, AmountDepressed))
            {
                switch(Key)
                {
                    // End:0x6A
                    case 'Gamepad_LeftStick_Up':
                    // End:0x76
                    case 'XboxTypeS_DPad_Up':
                    // End:0x82
                    case 'Up':
                    // End:0x8E
                    case 'Gamepad_LeftStick_Down':
                    // End:0x9A
                    case 'XboxTypeS_DPad_Down':
                    // End:0xA6
                    case 'Down':
                    // End:0xCA
                    case 'LeftMouseButton':
                        UpdateStatInfo();
                        PositionHighlightImage();
                        // End:0xCD
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                return true;
            }
        }
        switch(Key)
        {
            // End:0xF7
            case 'XboxTypeS_Back':
                // End:0xF7
                if(Class'Engine.Engine'.static.IsPS3())
                {
                    // End:0x136
                    break;
                }
            // End:0x103
            case 'XboxTypeS_B':
            // End:0x10F
            case 'MouseXButton1':
            // End:0x11B
            case 'Escape':
            // End:0x133
            case 'BackSpace':
                CloseMenu();
                return true;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return false;
        //return ReturnValue;        
    }
}

// Export UTurokFEStatsPersonalMultiplayer::execPositionHighlightImage(FFrame&, void* const)
native function PositionHighlightImage(optional bool kbForceUpdate);

// Export UTurokFEStatsPersonalMultiplayer::execSetupStatsList(FFrame&, void* const)
native function SetupStatsList();

// Export UTurokFEStatsPersonalMultiplayer::execUpdateStatInfo(FFrame&, void* const)
native function UpdateStatInfo();

function CloseMenu()
{
    SceneClient.GoBackSceneController(1);
    //return;    
}

defaultproperties
{
    StatEnums[0]=45
    StatEnums[1]=46
    StatEnums[2]=47
    StatEnums[3]=132
    StatEnums[4]=130
    StatEnums[5]=17
    StatEnums[6]=41
    StatEnums[7]=7
    StatEnums[8]=39
    StatEnums[9]=6
    StatEnums[10]=38
    StatEnums[11]=136
    StatEnums[12]=137
    StatEnums[13]=138
    StatEnums[14]=133
    StatEnums[15]=134
    StatEnums[16]=135
    StatEnums[18]=1
    StatEnums[19]=131
    StatEnums[20]=2
    StatEnums[21]=3
    StatEnums[22]=43
    StatEnums[23]=37
    StatEnums[24]=33
    StatEnums[25]=32
    StatEnums[26]=34
    StatEnums[27]=40
    StatEnums[28]=14
    StatEnums[29]=13
    StatEnums[30]=11
    StatEnums[31]=9
    StatEnums[32]=8
    StatEnums[33]=15
    StatEnums[34]=16
    StatEnums[35]=12
    StatEnums[36]=4
    StatEnums[37]=115
    StatEnums[38]=116
    StatEnums[39]=118
    StatEnums[40]=119
    StatEnums[41]=117
    StatEnums[42]=120
    StatEnums[43]=121
    StatEnums[44]=122
    StatEnums[45]=139
    StatEnums[46]=114
    StatEnums[47]=111
    StatEnums[48]=112
    StatEnums[49]=123
    StatEnums[50]=124
    StatEnums[51]=125
    StatEnums[52]=126
    StatEnums[53]=127
    StatEnums[54]=128
    StatEnums[55]=140
    PrevSelectedSlotIndex=-1
    SceneName="TurokFEStats.PersonalMultiplayer.PersonalMultiplayer"
}