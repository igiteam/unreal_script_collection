class UIScene_MPScoreboard extends UIScene_MPBase
    native
    hidecategories(Object,UIRoot,Object);

struct native PlayerWidgetInfo
{
    var UILabelButton PlayerName;
    var UIImage Rank;
    var UILabel Score;
    var UILabel TeamPoints;
    var UILabel Kills;
    var UILabel Deaths;
    var UILabel Objectives;
    var UILabel Position;
    var MOHAPlayerReplicationInfo PRI;
    var bool IsLocalPlayer;
    var int PlayerPosition;

    structdefaultproperties
    {
        PlayerName=none
        Rank=none
        Score=none
        TeamPoints=none
        Kills=none
        Deaths=none
        Objectives=none
        Position=none
        PRI=none
        IsLocalPlayer=false
        PlayerPosition=0
    }
};

struct native PlayerWidgetNameInfo
{
    var name PlayerName;
    var name Rank;
    var name Score;
    var name TeamPoints;
    var name Kills;
    var name Deaths;
    var name Objectives;
    var name Position;

    structdefaultproperties
    {
        PlayerName="None"
        Rank="None"
        Score="None"
        TeamPoints="None"
        Kills="None"
        Deaths="None"
        Objectives="None"
        Position="None"
    }
};

var int TOTALPLAYERS;
var PlayerWidgetInfo m_Players[12];
var UIPanel m_InGamePanel;
var UIPanel m_EndMatchPanel;
var UIPanel m_KickPlayerPanel;
var UIPanel m_KickPlayerPanelPC;
var UILabel m_AllyTeamScoreName;
var UILabel m_AllyTeamScoreValue;
var UILabel m_AllyRoundName;
var UILabel m_AllyRoundValue;
var UILabel m_AxisTeamScoreName;
var UILabel m_AxisTeamScoreValue;
var UILabel m_AxisRoundName;
var UILabel m_AxisRoundValue;
var UIImage m_AllySmallTeamFlag;
var UIImage m_AllyLargeTeamFlag;
var UIImage m_AxisSmallTeamFlag;
var UIImage m_AxisLargeTeamFlag;
var UIPanel m_MoreAlliesPanel;
var UIPanel m_BalancedTeamsPanel;
var UIPanel m_MoreAxisPanel;
var UILabelButton m_BackBtn;
var UILabelButton m_CloseBtn;
var UILabel m_CloseLabel;
var UILabel m_BackLabel;
var UIImage m_CloseImage;
var PlayerWidgetNameInfo m_PlayerWidgetName[12];
var name m_InGamePanelWidgetName;
var name m_EndMatchPanelWidgetName;
var name m_KickPlayerPanelWidgetName;
var name m_KickPlayerPanelPCWidgetName;
var name m_AllyTeamScoreNameWidgetName;
var name m_AllyTeamScoreValueWidgetName;
var name m_AllyRoundNameWidgetName;
var name m_AllyRoundValueWidgetName;
var name m_AxisTeamScoreNameWidgetName;
var name m_AxisTeamScoreValueWidgetName;
var name m_AxisRoundNameWidgetName;
var name m_AxisRoundValueWidgetName;
var name m_AxisSmallTeamFlagWidgetName;
var name m_AxisLargeTeamFlagWidgetName;
var name m_AllySmallTeamFlagWidgetName;
var name m_AllyLargeTeamFlagWidgetName;
var name m_MoreAlliesPanelWidgetName;
var name m_BalancedTeamsPanelWidgetName;
var name m_MoreAxisPanelWidgetName;
var name m_BackBtnWidgetName;
var name m_CloseBtnWidgetName;
var name m_CloseImageWidgetName;
var name m_CloseLabelWidgetName;
var name m_BackLabelWidgetName;
var string m_InGameTimerText;
var string m_EndMatchTimerText;
var array<string> m_AllyRankImages;
var array<string> m_AxisRankImages;
var UIScene m_MatchAwardsScene;
var bool m_bCloseScene;
var bool m_bOpenMatchAwards;
var bool m_bEndMatch;
var bool m_UsingLocalEndMatchTimer;
var string m_PlayerToKick;
var int m_AllyStartPosition;
var int m_AxisStartPosition;
var float m_LocalEndMatchTimer;

// Export UUIScene_MPScoreboard::execUpdateTeamInfo(FFrame&, void* const)
native function UpdateTeamInfo(bool TeamListsHaveBeenBuilt);

// Export UUIScene_MPScoreboard::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

// Export UUIScene_MPScoreboard::execHandleInputKey(FFrame&, void* const)
native function bool HandleInputKey(int ControllerId, name Key, Object.EInputEvent Event, float AmountDepressed);

event SetupLabels()
{
    local int I;

    super.SetupLabels();
    m_InGamePanel = UIPanel(FindChild(m_InGamePanelWidgetName, true));
    m_EndMatchPanel = UIPanel(FindChild(m_EndMatchPanelWidgetName, true));
    m_KickPlayerPanel = UIPanel(FindChild(m_KickPlayerPanelWidgetName, true));
    m_KickPlayerPanelPC = UIPanel(FindChild(m_KickPlayerPanelPCWidgetName, true));
    m_AllySmallTeamFlag = UIImage(FindChild(m_AllySmallTeamFlagWidgetName, true));
    m_AllyLargeTeamFlag = UIImage(FindChild(m_AllyLargeTeamFlagWidgetName, true));
    m_AxisSmallTeamFlag = UIImage(FindChild(m_AxisSmallTeamFlagWidgetName, true));
    m_AxisLargeTeamFlag = UIImage(FindChild(m_AxisLargeTeamFlagWidgetName, true));
    m_AllyTeamScoreName = UILabel(FindChild(m_AllyTeamScoreNameWidgetName, true));
    m_AllyTeamScoreValue = UILabel(FindChild(m_AllyTeamScoreValueWidgetName, true));
    m_AllyRoundName = UILabel(FindChild(m_AllyRoundNameWidgetName, true));
    m_AllyRoundValue = UILabel(FindChild(m_AllyRoundValueWidgetName, true));
    m_AxisTeamScoreName = UILabel(FindChild(m_AxisTeamScoreNameWidgetName, true));
    m_AxisTeamScoreValue = UILabel(FindChild(m_AxisTeamScoreValueWidgetName, true));
    m_AxisRoundName = UILabel(FindChild(m_AxisRoundNameWidgetName, true));
    m_AxisRoundValue = UILabel(FindChild(m_AxisRoundValueWidgetName, true));
    m_MoreAlliesPanel = UIPanel(FindChild(m_MoreAlliesPanelWidgetName, true));
    m_BalancedTeamsPanel = UIPanel(FindChild(m_BalancedTeamsPanelWidgetName, true));
    m_MoreAxisPanel = UIPanel(FindChild(m_MoreAxisPanelWidgetName, true));
    m_BackBtn = UILabelButton(FindChild(m_BackBtnWidgetName, true));
    m_CloseBtn = UILabelButton(FindChild(m_CloseBtnWidgetName, true));
    m_CloseLabel = UILabel(FindChild(m_CloseLabelWidgetName, true));
    m_BackLabel = UILabel(FindChild(m_BackLabelWidgetName, true));
    m_CloseImage = UIImage(FindChild(m_CloseImageWidgetName, true));
    I = 0;
    J0x235:

    // End:0x3CF [Loop If]
    if(I < TOTALPLAYERS)
    {
        m_Players[I].PlayerName = UILabelButton(FindChild(m_PlayerWidgetName[I].PlayerName, true));
        m_Players[I].Rank = UIImage(FindChild(m_PlayerWidgetName[I].Rank, true));
        m_Players[I].Score = UILabel(FindChild(m_PlayerWidgetName[I].Score, true));
        m_Players[I].TeamPoints = UILabel(FindChild(m_PlayerWidgetName[I].TeamPoints, true));
        m_Players[I].Kills = UILabel(FindChild(m_PlayerWidgetName[I].Kills, true));
        m_Players[I].Deaths = UILabel(FindChild(m_PlayerWidgetName[I].Deaths, true));
        m_Players[I].Position = UILabel(FindChild(m_PlayerWidgetName[I].Position, true));
        I++;
        // [Loop Continue]
        goto J0x235;
    }
    __OnInputKey__Delegate = HandleInputKey;
    //return;    
}

event SortPRIPlayers()
{
    // End:0x3A
    if(GetWorldInfo().GRI != none)
    {
        GetWorldInfo().GRI.SortPRIArray();
    }
    //return;    
}

event StartMatchAwardsTimer()
{
    // End:0x47
    if((PlayerOwner != none) && PlayerOwner.Actor != none)
    {
        PlayerOwner.Actor.SetTimer(15.0000000, false, 'ActivateMatchAwards');
    }
    //return;    
}

event EndMatchAwardsTimer()
{
    // End:0x47
    if((PlayerOwner != none) && PlayerOwner.Actor != none)
    {
        PlayerOwner.Actor.SetTimer(0.0000000, false, 'ActivateMatchAwards');
    }
    //return;    
}

function ActivateMatchAwards()
{
    m_bOpenMatchAwards = true;
    //return;    
}

function bool OnShowGamerCard(UIScreenObject obj)
{
    local UILabelButton localObj;
    local LocalPlayer playerObj;
    local GameReplicationInfo localGRI;
    local PlayerReplicationInfo LocalPRI;
    local int I;

    localGRI = GetWorldInfo().GRI;
    // End:0x181
    if(localGRI != none)
    {
        I = 0;
        J0x2B:

        // End:0xC3 [Loop If]
        if(I < localGRI.PRIArray.Length)
        {
            LocalPRI = localGRI.PRIArray[I];
            // End:0xAB
            if((LocalPRI != none) && PlayerController(LocalPRI.Owner) != none)
            {
                playerObj = LocalPlayer(PlayerController(LocalPRI.Owner).Player);
            }
            // End:0xB9
            if(playerObj != none)
            {
                // [Explicit Break]
                goto J0xC3;
            }
            I++;
            // [Loop Continue]
            goto J0x2B;
        }
        J0xC3:

        localObj = UILabelButton(obj);
        // End:0x181
        if((localObj != none) && playerObj != none)
        {
            I = 0;
            J0xF2:

            // End:0x17E [Loop If]
            if(I < TOTALPLAYERS)
            {
                // End:0x174
                if((m_Players[I].PlayerName == localObj) && m_Players[I].PRI != none)
                {
                    return ShowGamercard(playerObj.ControllerId, m_Players[I].PRI.UniqueId);
                }
                I++;
                // [Loop Continue]
                goto J0xF2;
            }            
        }
    }
    return false;
    //return ReturnValue;    
}

function bool OnLeaveFeedback(UIScreenObject obj)
{
    local UILabelButton localObj;
    local LocalPlayer playerObj;
    local GameReplicationInfo localGRI;
    local PlayerReplicationInfo LocalPRI;
    local int I;

    localGRI = GetWorldInfo().GRI;
    // End:0x19E
    if(localGRI != none)
    {
        I = 0;
        J0x2B:

        // End:0xC3 [Loop If]
        if(I < localGRI.PRIArray.Length)
        {
            LocalPRI = localGRI.PRIArray[I];
            // End:0xAB
            if((LocalPRI != none) && PlayerController(LocalPRI.Owner) != none)
            {
                playerObj = LocalPlayer(PlayerController(LocalPRI.Owner).Player);
            }
            // End:0xB9
            if(playerObj != none)
            {
                // [Explicit Break]
                goto J0xC3;
            }
            I++;
            // [Loop Continue]
            goto J0x2B;
        }
        J0xC3:

        localObj = UILabelButton(obj);
        // End:0x19E
        if((localObj != none) && playerObj != none)
        {
            I = 0;
            J0xF2:

            // End:0x19B [Loop If]
            if(I < TOTALPLAYERS)
            {
                // End:0x191
                if(((m_Players[I].PlayerName == localObj) && m_Players[I].PRI != none) && !m_Players[I].IsLocalPlayer)
                {
                    return LeaveFeedback(playerObj.ControllerId, m_Players[I].PRI.xuid);
                }
                I++;
                // [Loop Continue]
                goto J0xF2;
            }            
        }
    }
    return false;
    //return ReturnValue;    
}

function bool OnKickPlayer(UIScreenObject obj)
{
    local UILabelButton localObj;
    local int I;

    localObj = UILabelButton(obj);
    // End:0xBD
    if(localObj != none)
    {
        I = 0;
        J0x22:

        // End:0xBA [Loop If]
        if(I < TOTALPLAYERS)
        {
            // End:0xB0
            if(((m_Players[I].PlayerName == localObj) && m_Players[I].PRI != none) && !m_Players[I].IsLocalPlayer)
            {
                m_PlayerToKick = m_Players[I].PRI.PlayerName;
                return true;
            }
            I++;
            // [Loop Continue]
            goto J0x22;
        }        
    }
    return false;
    //return ReturnValue;    
}

function ConfirmKickPlayer()
{
    local MOHAMultiplayerGameInfo localGI;
    local int I;

    // End:0x0F
    if(Len(m_PlayerToKick) == 0)
    {
        return;
    }
    localGI = MOHAMultiplayerGameInfo(GetWorldInfo().Game);
    // End:0xB5
    if(localGI != none)
    {
        // End:0xB5
        if(localGI.KickPlayer(m_PlayerToKick))
        {
            I = 0;
            J0x5B:

            // End:0xB5 [Loop If]
            if(I < TOTALPLAYERS)
            {
                // End:0xAB
                if(m_Players[I].IsLocalPlayer)
                {
                    m_Players[I].PlayerName.SetFocus(none);
                    // [Explicit Break]
                    goto J0xB5;
                }
                I++;
                // [Loop Continue]
                goto J0x5B;
            }
        }
    }
    J0xB5:

    m_PlayerToKick = "";
    //return;    
}

defaultproperties
{
    TOTALPLAYERS=12
    m_PlayerWidgetName[0]=(PlayerName="WPlayerName0",Rank="WRank0",Score="WScore0",TeamPoints="WTeamPoints0",Kills="WKills0",Deaths="WDeaths0",Objectives="WObjectives0",Position="WPosition0")
    m_PlayerWidgetName[1]=(PlayerName="WPlayerName1",Rank="WRank1",Score="WScore1",TeamPoints="WTeamPoints1",Kills="WKills1",Deaths="WDeaths1",Objectives="WObjectives1",Position="WPosition1")
    m_PlayerWidgetName[2]=(PlayerName="WPlayerName2",Rank="WRank2",Score="WScore2",TeamPoints="WTeamPoints2",Kills="WKills2",Deaths="WDeaths2",Objectives="WObjectives2",Position="WPosition2")
    m_PlayerWidgetName[3]=(PlayerName="WPlayerName3",Rank="WRank3",Score="WScore3",TeamPoints="WTeamPoints3",Kills="WKills3",Deaths="WDeaths3",Objectives="WObjectives3",Position="WPosition3")
    m_PlayerWidgetName[4]=(PlayerName="WPlayerName4",Rank="WRank4",Score="WScore4",TeamPoints="WTeamPoints4",Kills="WKills4",Deaths="WDeaths4",Objectives="WObjectives4",Position="WPosition4")
    m_PlayerWidgetName[5]=(PlayerName="WPlayerName5",Rank="WRank5",Score="WScore5",TeamPoints="WTeamPoints5",Kills="WKills5",Deaths="WDeaths5",Objectives="WObjectives5",Position="WPosition5")
    m_PlayerWidgetName[6]=(PlayerName="LPlayerName0",Rank="LRank0",Score="LScore0",TeamPoints="LTeamPoints0",Kills="LKills0",Deaths="LDeaths0",Objectives="LObjectives0",Position="LPosition0")
    m_PlayerWidgetName[7]=(PlayerName="LPlayerName1",Rank="LRank1",Score="LScore1",TeamPoints="LTeamPoints1",Kills="LKills1",Deaths="LDeaths1",Objectives="LObjectives1",Position="LPosition1")
    m_PlayerWidgetName[8]=(PlayerName="LPlayerName2",Rank="LRank2",Score="LScore2",TeamPoints="LTeamPoints2",Kills="LKills2",Deaths="LDeaths2",Objectives="LObjectives2",Position="LPosition2")
    m_PlayerWidgetName[9]=(PlayerName="LPlayerName3",Rank="LRank3",Score="LScore3",TeamPoints="LTeamPoints3",Kills="LKills3",Deaths="LDeaths3",Objectives="LObjectives3",Position="LPosition3")
    m_PlayerWidgetName[10]=(PlayerName="LPlayerName4",Rank="LRank4",Score="LScore4",TeamPoints="LTeamPoints4",Kills="LKills4",Deaths="LDeaths4",Objectives="LObjectives4",Position="LPosition4")
    m_PlayerWidgetName[11]=(PlayerName="LPlayerName5",Rank="LRank5",Score="LScore5",TeamPoints="LTeamPoints5",Kills="LKills5",Deaths="LDeaths5",Objectives="LObjectives5",Position="LPosition5")
    m_InGamePanelWidgetName="EndRoundPanel"
    m_EndMatchPanelWidgetName="EndMatchPanel"
    m_KickPlayerPanelWidgetName="KickPlayerConfirm"
    m_KickPlayerPanelPCWidgetName="KickPlayerConfirmPC"
    m_AllyTeamScoreNameWidgetName="TeamScoreA_label"
    m_AllyTeamScoreValueWidgetName="TeamScoreA"
    m_AllyRoundNameWidgetName="RoundScoreA_label"
    m_AllyRoundValueWidgetName="RoundScoreA"
    m_AxisTeamScoreNameWidgetName="TeamScoreB_label"
    m_AxisTeamScoreValueWidgetName="TeamScoreB"
    m_AxisRoundNameWidgetName="RoundScoreB_label"
    m_AxisRoundValueWidgetName="RoundScoreB"
    m_AxisSmallTeamFlagWidgetName="AxisFlag"
    m_AxisLargeTeamFlagWidgetName="AxisFlag_Winner"
    m_AllySmallTeamFlagWidgetName="AlliedFlag"
    m_AllyLargeTeamFlagWidgetName="AlliedFlag_Winner"
    m_MoreAlliesPanelWidgetName="Line3"
    m_BalancedTeamsPanelWidgetName="Line2"
    m_MoreAxisPanelWidgetName="Line1"
    m_BackBtnWidgetName="backBtn"
    m_CloseBtnWidgetName="CloseBtn"
    m_CloseImageWidgetName="360_B-bttn"
    m_CloseLabelWidgetName="Close"
    m_BackLabelWidgetName="BackLabel"
    m_AllyRankImages[0]="<Images:UI_TX_Rank.Rank_Allied_Recruit>"
    m_AllyRankImages[1]="<Images:UI_TX_Rank.Rank_Allied_Private>"
    m_AllyRankImages[2]="<Images:UI_TX_Rank.Rank_Allied_PFC>"
    m_AllyRankImages[3]="<Images:UI_TX_Rank.Rank_Allied_Corporal>"
    m_AllyRankImages[4]="<Images:UI_TX_Rank.Rank_Allied_Sergeant>"
    m_AllyRankImages[5]="<Images:UI_TX_Rank.Rank_Allied_SSergeant>"
    m_AllyRankImages[6]="<Images:UI_TX_Rank.Rank_Allied_SergeantFC>"
    m_AllyRankImages[7]="<Images:UI_TX_Rank.Rank_Allied_MSergeant>"
    m_AllyRankImages[8]="<Images:UI_TX_Rank.Rank_Allied_FSergeant>"
    m_AllyRankImages[9]="<Images:UI_TX_Rank.Rank_Allied_SecndLieut>"
    m_AllyRankImages[10]="<Images:UI_TX_Rank.Rank_Allied_FirstLieut>"
    m_AllyRankImages[11]="<Images:UI_TX_Rank.Rank_Allied_Captain>"
    m_AllyRankImages[12]="<Images:UI_TX_Rank.Rank_Allied_Major>"
    m_AllyRankImages[13]="<Images:UI_TX_Rank.Rank_Allied_LieutCol>"
    m_AllyRankImages[14]="<Images:UI_TX_Rank.Rank_Allied_Colonel>"
    m_AllyRankImages[15]="<Images:UI_TX_Rank.Rank_Allied_BrigGen>"
    m_AllyRankImages[16]="<Images:UI_TX_Rank.Rank_Allied_MajorGen>"
    m_AllyRankImages[17]="<Images:UI_TX_Rank.Rank_Allied_LieutGen>"
    m_AllyRankImages[18]="<Images:UI_TX_Rank.Rank_Allied_Gen>"
    m_AllyRankImages[19]="<Images:UI_TX_Rank.Rank_Allied_GenOfArmy>"
    m_AxisRankImages[0]="<Images:UI_TX_Rank.Rank_Axis_Recruit>"
    m_AxisRankImages[1]="<Images:UI_TX_Rank.Rank_Axis_Private>"
    m_AxisRankImages[2]="<Images:UI_TX_Rank.Rank_Axis_PFC>"
    m_AxisRankImages[3]="<Images:UI_TX_Rank.Rank_Axis_Corporal>"
    m_AxisRankImages[4]="<Images:UI_TX_Rank.Rank_Axis_Sergeant>"
    m_AxisRankImages[5]="<Images:UI_TX_Rank.Rank_Axis_SSergeant>"
    m_AxisRankImages[6]="<Images:UI_TX_Rank.Rank_Axis_SergeantFC>"
    m_AxisRankImages[7]="<Images:UI_TX_Rank.Rank_Axis_MSergeant>"
    m_AxisRankImages[8]="<Images:UI_TX_Rank.Rank_Axis_FSergeant>"
    m_AxisRankImages[9]="<Images:UI_TX_Rank.Rank_Axis_SecndLieut>"
    m_AxisRankImages[10]="<Images:UI_TX_Rank.Rank_Axis_FirstLieut>"
    m_AxisRankImages[11]="<Images:UI_TX_Rank.Rank_Axis_Captain>"
    m_AxisRankImages[12]="<Images:UI_TX_Rank.Rank_Axis_Major>"
    m_AxisRankImages[13]="<Images:UI_TX_Rank.Rank_Axis_LieutCol>"
    m_AxisRankImages[14]="<Images:UI_TX_Rank.Rank_Axis_Colonel>"
    m_AxisRankImages[15]="<Images:UI_TX_Rank.Rank_Axis_BrigGen>"
    m_AxisRankImages[16]="<Images:UI_TX_Rank.Rank_Axis_MajorGen>"
    m_AxisRankImages[17]="<Images:UI_TX_Rank.Rank_Axis_LieutGen>"
    m_AxisRankImages[18]="<Images:UI_TX_Rank.Rank_Axis_Gen>"
    m_AxisRankImages[19]="<Images:UI_TX_Rank.Rank_Axis_GenOfArmy>"
    m_MatchAwardsScene=UIScene_MPMatchAwards'MP_Scoreboard.MPMatchAwards'
    // Reference: UIComp_Event'Default__UIScene_MPScoreboard.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}