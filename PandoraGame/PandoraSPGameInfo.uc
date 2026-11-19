class PandoraSPGameInfo extends PandoraGameInfo
    native
    config(Game);

enum ESPSinglePlayerTeam
{
    SPTEAM_UNKNOWN,                 // 0
    SPTEAM_HUMANALLY,               // 1
    SPTEAM_HUMANENEMY,              // 2
    SPTEAM_WEREWOLF,                // 3
    SPTEAM_GRIFFON,                 // 4
    SPTEAM_CIVILIAN,                // 5
    SPTEAM_NEUTRAL,                 // 6
    SPTEAM_GORGON,                  // 7
    SPTEAM_BLOODTICK,               // 8
    SPTEAM_FIREDRAKE,               // 9
    SPTEAM_NARI,                    // 10
    SPTEAM_TENTACLE,                // 11
    SPTEAM_KRAKEN,                  // 12
    SPTEAM_BULLETGENERATOR,         // 13
    SPTEAM_MAXIMUS,                 // 14
    SPTEAM_MAX                      // 15
};

var array<TeamSpawnInfo> m_teamSPSpawnInfo;

function StartOnlineGame()
{
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    // End:0x35
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // DebugMode: 0
        assert(int(WorldInfo.NetMode) == int(NM_Standalone));
    }
    super.InitGame(Options, ErrorMessage);
    //return;    
}

function LocalPlayerDeath(PandoraPlayerController Controller)
{
    local PandoraGameViewportClient vpc;
    local PandoraCheckpoint cp;

    Controller.Pawn = none;
    vpc = PandoraGameViewportClient(Controller.GetViewportClient());
    // End:0x70
    foreach AllActors(Class'PandoraCheckpoint', cp)
    {
        // End:0x6F
        if((cp != none) && cp.Name == vpc.CurrCheckpointName)
        {
            // End:0x70
            break;
        }        
    }    
    // End:0xC4
    if((cp != none) && vpc != none)
    {
        Controller.SPCM.CurrCheckpoint = cp;
        vpc.OpenLoadLastCheckpointMenu(Controller);        
    }
    else
    {
        Controller.RestartLevel();
    }
    //return;    
}

function ReduceDamage(out int Damage, Pawn injured, Controller instigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
    local bool doNoDamage;
    local SPPawn spInjuredPawn;
    local SPAIController spInjuredController, spInstigatorController;

    // End:0x12
    if(ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse'))
    {
        return;
    }
    doNoDamage = false;
    spInjuredPawn = SPPawn(injured);
    // End:0xB9
    if(spInjuredPawn != none)
    {
        spInjuredController = SPAIController(spInjuredPawn.Controller);
        // End:0xB9
        if(spInjuredController != none)
        {
            spInstigatorController = SPAIController(instigatedBy);
            // End:0xB9
            if(spInstigatorController != none)
            {
                // End:0xB9
                if(!spInstigatorController.IsTargettable(spInjuredController) || spInjuredController.IsFriendly(spInstigatorController))
                {
                    doNoDamage = true;
                }
            }
        }
    }
    // End:0x154
    if(((injured != none) && instigatedBy != none) && doNoDamage || WorldInfo.GRI.OnSameTeam(injured.Controller, instigatedBy) && (injured.Controller != instigatedBy) || PandoraPlayerController(injured.Controller) == none)
    {
        Damage = 0;        
    }
    else
    {
        // End:0x19E
        if((spInjuredController != none) && spInjuredController.m_squad != none)
        {
            spInjuredController.m_squad.NotifyDamagedReceived(spInjuredController, instigatedBy);
        }
        // End:0x1E8
        if((spInstigatorController != none) && spInstigatorController.m_squad != none)
        {
            spInstigatorController.m_squad.NotifyDamageGiven(spInjuredController, instigatedBy);
        }
        super(GameInfo).ReduceDamage(Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
    }
    //return;    
}

final function InitializeTeams()
{
    local int Idx;
    local PandoraSPGameInfo.ESPSinglePlayerTeam maxIdx;

    maxIdx = 14;
    // End:0x1A
    if(m_teamSPSpawnInfo.Length != int(maxIdx))
    {
    }
    Idx = 0;
    J0x21:

    // End:0x86 [Loop If]
    if(Idx < m_teamSPSpawnInfo.Length)
    {
        m_teams[Idx] = Spawn(m_teamSPSpawnInfo[Idx].teamClass, self);
        m_teams[Idx].TeamIndex = Idx;
        Idx++;
        // [Loop Continue]
        goto J0x21;
    }
    //return;    
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
    local SPPawn SPPawn;
    local PandoraSPGameInfo.ESPSinglePlayerTeam teamIdx;

    // End:0x17
    if(m_teams.Length < m_teamSPSpawnInfo.Length)
    {
        InitializeTeams();
    }
    // End:0xD7
    if(Other != none)
    {
        teamIdx = 0;
        // End:0x8C
        if(Other.Pawn != none)
        {
            SPPawn = SPPawn(Other.Pawn);
            // End:0x79
            if(SPPawn != none)
            {
                teamIdx = SPPawn.TeamAssignment;
            }
            // End:0x89
            if(int(teamIdx) == int(0))
            {
            }            
        }
        else
        {
            // End:0xAC
            if(Other.IsA('PandoraPlayerController'))
            {
                teamIdx = 1;
            }
        }
        // End:0xBC
        if(int(teamIdx) == int(0))
        {
        }
        // End:0xD7
        if(DoTeamChange(Other, int(teamIdx)))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function RestartPlayer(Controller NewPlayer)
{
    PandoraPlayerController(NewPlayer).CleanupWeapons();
    super.RestartPlayer(NewPlayer);
    //return;    
}
