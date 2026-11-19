class MOHAVoiceChatMenu extends MOHAHUDStr
    native;

enum VoiceChatMenuState
{
    VOICECHAT_MENU_HIDDEN,          // 0
    VOICECHAT_MAIN_MENU,            // 1
    VOICECHAT_SUB_MENU,             // 2
    VOICECHAT_MAX                   // 3
};

struct native MainMenuItem
{
    var int SubMenuTextOffset;
    var bool bTeamOnly;

    structdefaultproperties
    {
        SubMenuTextOffset=0
        bTeamOnly=false
    }
};

struct native VoiceChatCommand
{
    var SoundCue SoundToPlayAxis;
    var SoundCue SoundToPlayAllies;

    structdefaultproperties
    {
        SoundToPlayAxis=none
        SoundToPlayAllies=none
    }
};

var MainMenuItem MainMenuItems[5];
var VoiceChatCommand VCommands[25];
var MOHAVoiceChatMenu.VoiceChatMenuState MenuState;
var int CurrentSubMenu;
var const localized string MOHAVoiceMenuStrings[5];

function bool IsMenuOpen()
{
    return int(MenuState) != int(0);
    //return ReturnValue;    
}

function ShowMenu()
{
    switch(MenuState)
    {
        // End:0x1B
        case 0:
            EnterState(1);
            // End:0x3A
            break;
        // End:0x20
        case 1:
        // End:0x34
        case 2:
            EnterState(0);
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            // End:0x3A
            break;
            break;
    }
    //return;    
}

function UserInput(int which)
{
    // End:0x1B
    if((which < 0) || which > 4)
    {
        return;
    }
    switch(MenuState)
    {
        // End:0x41
        case 1:
            CurrentSubMenu = which;
            EnterState(2);
            // End:0x6A
            break;
        // End:0x64
        case 2:
            DoCommand(which);
            EnterState(0);
            // End:0x6A
            break;
        // End:0xFFFF
        default:
            // End:0x6A
            break;
            break;
    }
    //return;    
}

function DoCommand(int which)
{
    local bool bTeamOnly;
    local int Command;
    local SoundCue vsound;

    bTeamOnly = MainMenuItems[CurrentSubMenu].bTeamOnly;
    Command = MainMenuItems[CurrentSubMenu].SubMenuTextOffset + which;
    // End:0x103
    if((MOHAHUD != none) && MOHAMultiplayerController(MOHAHUD.PlayerOwner) != none)
    {
        // End:0xB7
        if(MOHAMultiplayerController(MOHAHUD.PlayerOwner).PlayerReplicationInfo.Team.TeamIndex == 0)
        {
            vsound = VCommands[Command].SoundToPlayAllies;            
        }
        else
        {
            vsound = VCommands[Command].SoundToPlayAxis;
        }
        MOHAMultiplayerController(MOHAHUD.PlayerOwner).ServerSendMOHAVoiceChatMessage(Command, vsound, bTeamOnly);
    }
    //return;    
}

function EnterState(MOHAVoiceChatMenu.VoiceChatMenuState NextState)
{
    local int I;

    switch(NextState)
    {
        // End:0x17
        case 0:
            bRender = false;
            // End:0x13E
            break;
        // End:0x92
        case 1:
            Text = "";
            I = 0;
            J0x2B:

            // End:0x87 [Loop If]
            if(I < 5)
            {                
                Text $= (string(I + 1) $ " - ");                
                Text $= MOHAVoiceMenuStrings[I];                
                Text $= "\n";
                ++I;
                // [Loop Continue]
                goto J0x2B;
            }
            bRender = true;
            // End:0x13E
            break;
        // End:0x138
        case 2:
            Text = "";
            I = 0;
            J0xA6:

            // End:0x130 [Loop If]
            if(I < 5)
            {                
                Text $= (string(I + 1) $ " - ");                
                Text $= MOHAMultiplayerController(MOHAHUD.PlayerOwner).MOHAVoiceChatStrings[I + MainMenuItems[CurrentSubMenu].SubMenuTextOffset];                
                Text $= "\n";
                ++I;
                // [Loop Continue]
                goto J0xA6;
            }
            bRender = true;
        // End:0xFFFF
        default:
            // End:0x13E
            break;
            break;
    }
    MenuState = NextState;
    //return;    
}

defaultproperties
{
    MainMenuItems[0]=(SubMenuTextOffset=0,bTeamOnly=true)
    MainMenuItems[1]=(SubMenuTextOffset=5,bTeamOnly=true)
    MainMenuItems[2]=(SubMenuTextOffset=10,bTeamOnly=true)
    MainMenuItems[3]=(SubMenuTextOffset=15,bTeamOnly=true)
    MainMenuItems[4]=(SubMenuTextOffset=20,bTeamOnly=false)
    VCommands[0]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_ESPT_GEC_50330_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_SQCM_USC_50200_01')
    VCommands[1]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_SQCM_GEC_50301_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_SQCM_USC_50201_01')
    VCommands[2]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_SQCM_GEC_50302_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_SQCM_USC_50202_01')
    VCommands[3]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_SQCM_GEC_50303_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_SQCM_USC_50203_01')
    VCommands[4]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_SQCM_GEC_50304_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_SQCM_USC_50204_01')
    VCommands[5]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_STRS_GEC_50315_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_STRS_USC_50215_01')
    VCommands[6]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_STRS_GEC_50316_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_STRS_USC_50216_01')
    VCommands[7]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_STRS_GEC_50317_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_STRS_USC_50217_01')
    VCommands[8]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_STRS_GEC_50318_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_STRS_USC_50218_01')
    VCommands[9]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_STRS_GEC_50319_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_STRS_USC_50219_01')
    VCommands[10]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_ESPT_GEC_50330_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_ESPT_USC_50230_01')
    VCommands[11]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_ESPT_GEC_50331_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_ESPT_USC_50231_01')
    VCommands[12]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_ESPT_GEC_50332_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_ESPT_USC_50232_01')
    VCommands[13]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_ESPT_GEC_50333_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_ESPT_USC_50233_01')
    VCommands[14]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_ESPT_GEC_50334_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_ESPT_USC_50234_01')
    VCommands[15]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_OBJT_GEC_50345_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_OBJT_USC_50245_01')
    VCommands[16]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_OBJT_GEC_50346_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_OBJT_USC_50246_01')
    VCommands[17]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_OBJT_GEC_50347_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_OBJT_USC_50247_01')
    VCommands[18]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_OBJT_GEC_50348_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_OBJT_USC_50248_01')
    VCommands[19]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_OBJT_GEC_50349_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_OBJT_USC_50249_01')
    VCommands[20]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_TAUN_GEC_50360_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_TAUN_USC_50260_01')
    VCommands[21]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_TAUN_GEC_50361_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_TAUN_USC_50261_01')
    VCommands[22]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_TAUN_GEC_50362_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_TAUN_USC_50262_01')
    VCommands[23]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_TAUN_GEC_50363_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_TAUN_USC_50263_01')
    VCommands[24]=(SoundToPlayAxis=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPGE_TAUN_GEC_50364_01',SoundToPlayAllies=SoundCue'Aud_MP_FakeWAV.PC_Only_Dia.MPUS_TAUN_USC_50264_01')
    MOHAVoiceMenuStrings[0]="Squad Commands"
    MOHAVoiceMenuStrings[1]="Statements & Responses"
    MOHAVoiceMenuStrings[2]="Enemy Spotted"
    MOHAVoiceMenuStrings[3]="Objective"
    MOHAVoiceMenuStrings[4]="Taunts"
}