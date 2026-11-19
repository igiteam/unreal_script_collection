class UIScene_MPMatchAwards extends UIScene_MPBase
    native
    hidecategories(Object,UIRoot,Object);

struct native MatchAwardPair
{
    var UILabelButton m_Name;
    var UILabel m_Score;
    var name m_NameWidgetName;
    var name m_ScoreWidgetName;
    var int m_AwardIndex;

    structdefaultproperties
    {
        m_Name=none
        m_Score=none
        m_NameWidgetName="None"
        m_ScoreWidgetName="None"
        m_AwardIndex=0
    }
};

struct native RivalryAwardPair
{
    var UILabelButton m_NameOne;
    var UILabelButton m_NameTwo;
    var name m_NameOneWidgetName;
    var name m_NameTwoWidgetName;
    var int m_RivalryOneAwardIndex;
    var int m_RivalryTwoAwardIndex;

    structdefaultproperties
    {
        m_NameOne=none
        m_NameTwo=none
        m_NameOneWidgetName="None"
        m_NameTwoWidgetName="None"
        m_RivalryOneAwardIndex=0
        m_RivalryTwoAwardIndex=0
    }
};

var MatchAwardPair m_MatchAwards[14];
var RivalryAwardPair m_RivalryAwards[2];
var int MATCHAWARDCOUNT;
var int RIVALRYAWARDCOUNT;
var bool m_bEndMatch;
var bool m_bCloseScene;

// Export UUIScene_MPMatchAwards::execGetPRIFromID(FFrame&, void* const)
native function PlayerReplicationInfo GetPRIFromID(int awardId);

// Export UUIScene_MPMatchAwards::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

// Export UUIScene_MPMatchAwards::execHandleInputKey(FFrame&, void* const)
native function bool HandleInputKey(int ControllerId, name Key, Object.EInputEvent Event, float AmountDepressed);

event SetupLabels()
{
    local int I;

    super.SetupLabels();
    I = 0;
    J0x0D:

    // End:0x94 [Loop If]
    if(I < MATCHAWARDCOUNT)
    {
        m_MatchAwards[I].m_Name = UILabelButton(FindChild(m_MatchAwards[I].m_NameWidgetName, true));
        m_MatchAwards[I].m_Score = UILabel(FindChild(m_MatchAwards[I].m_ScoreWidgetName, true));
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    I = 0;
    J0x9B:

    // End:0x122 [Loop If]
    if(I < RIVALRYAWARDCOUNT)
    {
        m_RivalryAwards[I].m_NameOne = UILabelButton(FindChild(m_RivalryAwards[I].m_NameOneWidgetName, true));
        m_RivalryAwards[I].m_NameTwo = UILabelButton(FindChild(m_RivalryAwards[I].m_NameTwoWidgetName, true));
        I++;
        // [Loop Continue]
        goto J0x9B;
    }
    __OnInputKey__Delegate = HandleInputKey;
    //return;    
}

function bool OnShowGamerCard(UIScreenObject obj)
{
    local UILabelButton localObj;
    local LocalPlayer playerObj;
    local GameReplicationInfo localGRI;
    local PlayerReplicationInfo LocalPRI, gcPRI;
    local int I;

    localGRI = GetWorldInfo().GRI;
    // End:0x290
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
        // End:0x290
        if((localObj != none) && playerObj != none)
        {
            I = 0;
            J0xF2:

            // End:0x181 [Loop If]
            if(I < MATCHAWARDCOUNT)
            {
                // End:0x177
                if(m_MatchAwards[I].m_Name == localObj)
                {
                    gcPRI = GetPRIFromID(m_MatchAwards[I].m_AwardIndex);
                    // End:0x177
                    if(gcPRI != none)
                    {
                        return ShowGamercard(playerObj.ControllerId, gcPRI.UniqueId);
                    }
                }
                I++;
                // [Loop Continue]
                goto J0xF2;
            }
            I = 0;
            J0x188:

            // End:0x28D [Loop If]
            if(I < RIVALRYAWARDCOUNT)
            {
                // End:0x20D
                if(m_RivalryAwards[I].m_NameOne == localObj)
                {
                    gcPRI = GetPRIFromID(m_RivalryAwards[I].m_RivalryOneAwardIndex);
                    // End:0x20D
                    if(gcPRI != none)
                    {
                        return ShowGamercard(playerObj.ControllerId, gcPRI.UniqueId);
                    }
                }
                // End:0x283
                if(m_RivalryAwards[I].m_NameTwo == localObj)
                {
                    gcPRI = GetPRIFromID(m_RivalryAwards[I].m_RivalryTwoAwardIndex);
                    // End:0x283
                    if(gcPRI != none)
                    {
                        return ShowGamercard(playerObj.ControllerId, gcPRI.UniqueId);
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x188;
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
    local PlayerReplicationInfo LocalPRI, playerPRI;
    local int I;

    localGRI = GetWorldInfo().GRI;
    // End:0x2AB
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
        // End:0x2AB
        if((localObj != none) && playerObj != none)
        {
            I = 0;
            J0xF2:

            // End:0x18A [Loop If]
            if(I < MATCHAWARDCOUNT)
            {
                // End:0x180
                if(m_MatchAwards[I].m_Name == localObj)
                {
                    playerPRI = GetPRIFromID(m_MatchAwards[I].m_AwardIndex);
                    // End:0x180
                    if(playerPRI != LocalPRI)
                    {
                        return LeaveFeedback(playerObj.ControllerId, MOHAPlayerReplicationInfo(playerPRI).xuid);
                    }
                }
                I++;
                // [Loop Continue]
                goto J0xF2;
            }
            I = 0;
            J0x191:

            // End:0x2A8 [Loop If]
            if(I < RIVALRYAWARDCOUNT)
            {
                // End:0x21F
                if(m_RivalryAwards[I].m_NameOne == localObj)
                {
                    playerPRI = GetPRIFromID(m_RivalryAwards[I].m_RivalryOneAwardIndex);
                    // End:0x21F
                    if(playerPRI != LocalPRI)
                    {
                        return LeaveFeedback(playerObj.ControllerId, MOHAPlayerReplicationInfo(playerPRI).xuid);
                    }
                }
                // End:0x29E
                if(m_RivalryAwards[I].m_NameTwo == localObj)
                {
                    playerPRI = GetPRIFromID(m_RivalryAwards[I].m_RivalryTwoAwardIndex);
                    // End:0x29E
                    if(playerPRI != LocalPRI)
                    {
                        return LeaveFeedback(playerObj.ControllerId, MOHAPlayerReplicationInfo(playerPRI).xuid);
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x191;
            }            
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    m_MatchAwards[0]=(m_Name=none,m_Score=none,m_NameWidgetName="MostAccurateName",m_ScoreWidgetName="MostAccurateScore",m_AwardIndex=0)
    m_MatchAwards[1]=(m_Name=none,m_Score=none,m_NameWidgetName="DeadliestName",m_ScoreWidgetName="DeadliestScore",m_AwardIndex=1)
    m_MatchAwards[2]=(m_Name=none,m_Score=none,m_NameWidgetName="HeadShotsName",m_ScoreWidgetName="HeadShotsScore",m_AwardIndex=2)
    m_MatchAwards[3]=(m_Name=none,m_Score=none,m_NameWidgetName="KillStreakName",m_ScoreWidgetName="KillStreakScore",m_AwardIndex=3)
    m_MatchAwards[4]=(m_Name=none,m_Score=none,m_NameWidgetName="ObjectiveName",m_ScoreWidgetName="ObjectiveScore",m_AwardIndex=12)
    m_MatchAwards[5]=(m_Name=none,m_Score=none,m_NameWidgetName="RifleName",m_ScoreWidgetName="RifleScore",m_AwardIndex=4)
    m_MatchAwards[6]=(m_Name=none,m_Score=none,m_NameWidgetName="SMGName",m_ScoreWidgetName="SMGScore",m_AwardIndex=5)
    m_MatchAwards[7]=(m_Name=none,m_Score=none,m_NameWidgetName="AutoRifleName",m_ScoreWidgetName="AutoRifleScore",m_AwardIndex=6)
    m_MatchAwards[8]=(m_Name=none,m_Score=none,m_NameWidgetName="SniperName",m_ScoreWidgetName="SniperScore",m_AwardIndex=7)
    m_MatchAwards[9]=(m_Name=none,m_Score=none,m_NameWidgetName="AntitankName",m_ScoreWidgetName="AntitankScore",m_AwardIndex=8)
    m_MatchAwards[10]=(m_Name=none,m_Score=none,m_NameWidgetName="MostUselessName",m_ScoreWidgetName="MostUselessScore",m_AwardIndex=20)
    m_MatchAwards[11]=(m_Name=none,m_Score=none,m_NameWidgetName="MostDeathsName",m_ScoreWidgetName="MostDeathsScore",m_AwardIndex=21)
    m_MatchAwards[12]=(m_Name=none,m_Score=none,m_NameWidgetName="DeathStreakName",m_ScoreWidgetName="DeathStreakScore",m_AwardIndex=22)
    m_MatchAwards[13]=(m_Name=none,m_Score=none,m_NameWidgetName="SuicidalName",m_ScoreWidgetName="SuicidalScore",m_AwardIndex=23)
    m_RivalryAwards[0]=(m_NameOne=none,m_NameTwo=none,m_NameOneWidgetName="MatchRivalryOne",m_NameTwoWidgetName="MatchRivalryTwo",m_RivalryOneAwardIndex=16,m_RivalryTwoAwardIndex=17)
    m_RivalryAwards[1]=(m_NameOne=none,m_NameTwo=none,m_NameOneWidgetName="PlayerRivalryOne",m_NameTwoWidgetName="PlayerRivalryTwo",m_RivalryOneAwardIndex=18,m_RivalryTwoAwardIndex=19)
    MATCHAWARDCOUNT=14
    RIVALRYAWARDCOUNT=2
    // Reference: UIComp_Event'Default__UIScene_MPMatchAwards.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}