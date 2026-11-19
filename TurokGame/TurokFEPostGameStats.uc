class TurokFEPostGameStats extends TurokFEMultiplayerScreen
    abstract
    native;

const kHASH_M_Accuracy = 678836140;
const kHASH_M_Rank = 1043891978;
const kHASH_M_Name = -17128574;
const kHASH_M_Battle_Rating = -266153633;
const kHASH_M_Suicides = -929371608;
const kHASH_M_Assists = 1197219587;
const kHASH_M_Deaths = -1398711212;
const kHASH_M_Kills = -203724986;
const kHASH_M_Score = 1140952803;
const kHASH_M_Flags = -1515770717;
const kHASH_M_CTFActs = 618105481;
const kHASH_M_WGActs = -529854705;
const kHASH_M_Points = -1009295966;
const kHASH_M_FriendlyFireKills = -749885230;
const kHASH_ShowGamerCard = -2048945104;
const kHASH_Sort = 1704256126;
const kHASH_ReturnToLobby = -536816954;
const kHASH_Feedback = 420615204;
const TUROKFEPOSTGAMESTATS_ROW_SIZE = 27.f;

enum NextScreenDirection
{
    NSD_None,                       // 0
    NSD_Next,                       // 1
    NSD_Prev,                       // 2
    NSD_Lobby,                      // 3
    NSD_MAX                         // 4
};

var protected bool mIsRankedGame;
var bool mbIsInitialized;
var @NULL mTeamAndPlayerStatistics;
var protected array mPlayersToSkip;
var byte mScreenSwitch;
var @NULL mRankInformation;
var protected @NULL RankImage;
var protected @NULL DeviceImage;
var protected @NULL LeftTrigger;
var protected @NULL RightTrigger;
var @NULL TheTable;

// Export UTurokFEPostGameStats::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

event SCCleanUpOnExit()
{
    //return;    
}

protected function CloseMenu()
{
    switch(mScreenSwitch)
    {
        // End:0x19
        case 1:
            GoToNextScreen();
            // End:0x40
            break;
        // End:0x2B
        case 2:
            GoToPrevScreen();
            // End:0x40
            break;
        // End:0x3D
        case 3:
            GotoLobby();
            // End:0x40
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

protected function GoToNextScreen()
{
    local int screenStackSize;
    local array insertStack;

    screenStackSize = SceneClient.GetStackSize(0);
    // End:0x5A
    if(screenStackSize > 0)
    {
        insertStack[0] = GetNextScreen();
        SceneClient.StackInsertSceneControllers(insertStack, screenStackSize - 1, 0);
    }
    GoBackScreen();
    //return;    
}

protected function GoToPrevScreen()
{
    local int screenStackSize;
    local array insertStack;

    screenStackSize = SceneClient.GetStackSize(0);
    // End:0x5A
    if(screenStackSize > 0)
    {
        insertStack[0] = GetPrevScreen();
        SceneClient.StackInsertSceneControllers(insertStack, screenStackSize - 1, 0);
    }
    GoBackScreen();
    //return;    
}

protected function GotoLobby()
{
    GoBackScreen();
    //return;    
}

protected function string GetNextScreen()
{
    //return ReturnValue;    
}

protected function string GetPrevScreen()
{
    //return ReturnValue;    
}

// Export UTurokFEPostGameStats::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int ControllerId, name Key, byte Event, float AmountDepressed);
