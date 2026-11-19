class TurokGameInfo extends TurokGameLoader
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

struct native transient SavedGameInfo
{
    var init const float GameTime;
    var init const int GameLen;
    var init const array GameData;

    structdefaultproperties
    {
        GameTime=0.0000000
        GameLen=0
        GameData=none
    }
};

struct native transient SavedPlayerInfo
{
    var init const @NULL Id;
    var init const byte CharacterIndex;
    var init const int ControllerLen;
    var init const array ControllerData;
    var init const int PRILen;
    var init const array PRIData;
    var init const int PawnLen;
    var init const array PawnData;

    structdefaultproperties
    {
        Id=(Uid=0,Uid[1]=0,Uid[2]=0,Uid[3]=0,Uid[4]=0,Uid[5]=0,Uid[6]=0,Uid[7]=0)
        CharacterIndex=0
        ControllerLen=0
        ControllerData=none
        PRILen=0
        PRIData=none
        PawnLen=0
        PawnData=none
    }
};

struct native transient SavedPendingPlayer
{
    var init @NULL Controller;
    var init @NULL Pawn;

    structdefaultproperties
    {
        Controller=none
        Pawn=none
    }
};

struct native WeaponPreloadInfo
{
    var const string ClassName;
    var const string PreloadPackage;

    structdefaultproperties
    {
        ClassName=""
        PreloadPackage=""
    }
};

struct native InventoryPreloadInfo
{
    var const string ClassName;
    var const string PreloadPackage;

    structdefaultproperties
    {
        ClassName=""
        PreloadPackage=""
    }
};

var protected const config array WeaponPreloads;
var protected const config array InventoryPreloads;
var private const config string DefaultPawnPreloadPackage;
var private const config string DefaultPawnClassName;
var private const config array DefaultPlayerWeapons;
var protected array mPendingSavedPlayers;
var const class<Class> mStatsReplicationClass;
var @NULL mStatTracker;
var @NULL mFirstInterestPoint;
var bool mAllowFriendlyFire;

// Export UTurokGameInfo::execRestoreSavedPlayer(FFrame&, void* const)
protected native function bool RestoreSavedPlayer(const out @NULL NetId, out @NULL PC);

// Export UTurokGameInfo::execRemoveSavedPlayer(FFrame&, void* const)
protected native function bool RemoveSavedPlayer(@NULL PC);

// Export UTurokGameInfo::execRestoreSavedPlayerPawn(FFrame&, void* const)
protected native function bool RestoreSavedPlayerPawn(@NULL PC);

// Export UTurokGameInfo::execGetPlayerTeam(FFrame&, void* const)
protected native function int GetPlayerTeam(const @NULL InPlayerId);

// Export UTurokGameInfo::execAddInterestPoint(FFrame&, void* const)
native final function AddInterestPoint(@NULL InterestPoint);

// Export UTurokGameInfo::execStepGameSimulation(FFrame&, void* const)
protected native function StepGameSimulation(bool resume);

// Export UTurokGameInfo::execLoadCheckpoint(FFrame&, void* const)
native function bool LoadCheckpoint();

// Export UTurokGameInfo::execLoadChapterpoint(FFrame&, void* const)
native function bool LoadChapterpoint();

exec function StepSimulation()
{
    StepGameSimulation(false);
    //return;    
}

exec function ResumeSimulation()
{
    StepGameSimulation(true);
    //return;    
}

function SetPlayerDefaults(@NULL PlayerPawn)
{
    //return;    
}

event PreBeginPlay()
{
    super(GameInfo).PreBeginPlay();
    mStatTracker = __NFUN_278__(Class'TurokStatTracker', self);
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    super(GameInfo).InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "GameDifficulty");
    // End:0x41
    if(InOpt != "")
    {
    }
    // End:0x56
    if(!bMultiplayerGame)
    {
        LoadSinglePlayerClasses();
    }
    //return;    
}

function LoadSinglePlayerClasses()
{
    DefaultPawnClass = class<Pawn>(FindObject(DefaultPawnClassName, Class'Core.Class'));
    //return;    
}

event GameEnding()
{
    local @NULL C;

    // End:0x3E
    if(!bGameEnded)
    {
        // End:0x3D
        foreach WorldInfo.AllControllers(Class'Engine.AIController', C)
        {
            C.GameHasEnded();            
        }        
    }
    // End:0x6F
    if(mStatTracker != none)
    {
        mStatTracker.WriteStatsToFile();
        mStatTracker.Destroy();
        mStatTracker = none;
    }
    super(GameInfo).GameEnding();
    //return;    
}

function Reset()
{
    WorldInfo.ResetGameTemporaries();
    super(GameInfo).Reset();
    //return;    
}

function EndGame(@NULL Winner, string Reason)
{
    local @NULL P;
    local bool GameCompleted;

    super(GameInfo).EndGame(Winner, Reason);
    // End:0xE3
    if(bGameEnded && mStatTracker != none)
    {
        GameCompleted = true;
        // End:0x48
        if(Reason == "logout")
        {
            GameCompleted = false;
        }
        // End:0xE2
        foreach WorldInfo.AllControllers(Class'TurokPlayerController', P)
        {
            // End:0x9F
            if(Winner != none)
            {
                P.RecordMatchEnded(Controller(Winner.Owner), self, GameCompleted);                
            }
            else
            {
                P.RecordMatchEnded(none, self, GameCompleted);
            }
            P.RecordStat(17, float(GameReplicationInfo.ElapsedTime), 1);            
        }        
    }
    //return;    
}

event PreSaveGameRestore()
{
    bDelayedStart = true;
    bWaitingToStartMatch = true;
    //return;    
}

event PostSaveGameRestore()
{
    StartMatch();
    //return;    
}

function StartSpectating(@NULL Player)
{
    local @NULL TPC;

    TPC = TurokPlayerController(Player);
    // DebugMode: 0
    assert(TPC != none);
    super(GameInfo).StartSpectating(TPC);
    TPC.StartSpectating();
    //return;    
}

function StopSpectating(@NULL Player)
{
    local @NULL TPC;

    TPC = TurokPlayerController(Player);
    // DebugMode: 0
    assert(TPC != none);
    super(GameInfo).StopSpectating(TPC);
    TPC.StopSpectating();
    //return;    
}

protected event @NULL GetMatchStartPoint(byte PlayerTeamIndex)
{
    return none;
    //return ReturnValue;    
}

protected event @NULL GetMatchEndFocus(byte WinningTeamIndex)
{
    return none;
    //return ReturnValue;    
}

event @NULL Login(@NULL NewPlayerId, string Portal, string Options, out string ErrorMessage)
{
    local @NULL StartSpot, NewPlayer;
    local string InName, inCharacter;
    local byte InTeam;
    local bool bSpectator;

    // End:0x1D
    if(RestoreSavedPlayer(NewPlayerId, NewPlayer))
    {
        return NewPlayer;
    }
    Options = StripColor(Options);
    bSpectator = (ParseOption(Options, "SpectatorOnly")) ~= "1";
    // End:0x85
    if(AtCapacity(bSpectator))
    {
        ErrorMessage = GameMessageClass.default.MaxedOutMessage;
        return none;
    }
    InName = Left(ParseOption(Options, "Name"), 20);
    InTeam = byte(GetIntOption(Options, "Team", 255));
    // End:0xE8
    if(int(InTeam) == 255)
    {
        InTeam = byte(GetPlayerTeam(NewPlayerId));
    }
    InTeam = PickTeam(InTeam, none);
    // End:0x11F
    if(Portal == "")
    {
        StartSpot = GetMatchStartPoint(InTeam);
    }
    // End:0x145
    if(StartSpot == none)
    {
        StartSpot = FindPlayerStart(none, InTeam, Portal);
    }
    // End:0x166
    if(StartSpot == none)
    {
        ErrorMessage = GameMessageClass.default.FailedPlaceMessage;
        return none;
    }
    NewPlayer = __NFUN_278__(PlayerControllerClass,,, StartSpot.Location, StartSpot.Rotation);
    // End:0x1B5
    if(NewPlayer == none)
    {
        ErrorMessage = GameMessageClass.default.FailedSpawnMessage;
        return none;
    }
    NumPlayers++;
    NewPlayer.StartSpot = StartSpot;
    NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;
    NewPlayer.PlayerReplicationInfo.SetUniqueId(NewPlayerId);
    // End:0x275
    if(NewPlayer.PlayerReplicationInfo.PlayerName == "")
    {
        // End:0x260
        if(InName == "")
        {
            InName = DefaultPlayerName $ string(NewPlayer.PlayerReplicationInfo.PlayerID);
        }
        ChangeName(NewPlayer, InName, false);
    }
    inCharacter = ParseOption(Options, "Character");
    NewPlayer.SetCharacter(inCharacter);
    // End:0x30E
    if(bSpectator || !ChangeTeam(NewPlayer, int(InTeam), false))
    {
        NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
        NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
        return NewPlayer;
    }
    // End:0x334
    if(bDelayedStart)
    {
        NewPlayer.GotoState('PlayerWaiting');
        return NewPlayer;
    }
    return NewPlayer;
    //return ReturnValue;    
}

function Logout(@NULL Exiting)
{
    // End:0x30
    if(PlayerController(Exiting) != none)
    {
        // End:0x30
        if(!RemoveSavedPlayer(PlayerController(Exiting)))
        {
            --NumPlayers;
        }
    }
    //return;    
}

function bool AllowKillScoreUpdate(class<Class> DamageType)
{
    // End:0x11
    if(DamageType == Class'TurokDamageTypeLogout')
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function Killed(@NULL Killer, @NULL KilledPlayer, @NULL KilledPawn, class<Class> DamageType)
{
    // End:0x110
    if((AllowKillScoreUpdate(DamageType)) && KilledPlayer != none)
    {
        // End:0x82
        if((((TurokAIControllerRaptor(Killer) != none) || TurokAIControllerDilo(Killer) != none) && TurokAIControllerHumanNpc(KilledPlayer) != none) && TurokPawn(KilledPawn).mbHasHadFlareAttachedRecently == true)
        {
            Class'TurokAchievementTracker'.static.PredatorKilledMG();
        }
        // End:0xDE
        if((TurokPlayerController(Killer) != none) && TurokPawn(KilledPawn) != none)
        {
            TurokPlayerController(Killer).RecordKill(KilledPlayer, DamageType, TurokPawn(KilledPawn).GetHitInfo());
        }
        // End:0x110
        if(TurokPlayerController(KilledPlayer) != none)
        {
            TurokPlayerController(KilledPlayer).RecordDeath(Killer, DamageType);
        }
    }
    super(GameInfo).Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    //return;    
}

function bool PlayerCanRestartGame(@NULL aPlayer)
{
    return true;
    //return ReturnValue;    
}

function bool PlayerCanRestart(@NULL aPlayer)
{
    // End:0x3C
    if(bRestartLevel)
    {
        // End:0x3A
        if(!LoadCheckpoint())
        {
            // End:0x3A
            if(!LoadChapterpoint())
            {
                aPlayer.RestartLevel();
            }
        }
        return false;
    }
    return true;
    //return ReturnValue;    
}

function StartHumans()
{
    local @NULL P, SavedPlayer;

    // End:0x0B
    if(bGameEnded)
    {
        return;
    }
    // End:0x66
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
    {
        // End:0x40
        if(RestoreSavedPlayerPawn(P))
        {
            continue;            
            // End:0x65
            continue;
        }
        // End:0x65
        if(P.CanRestartPlayer())
        {
            RestartPlayer(P);
        }        
    }    
    J0x67:

    // End:0xAF [Loop If]
    if(mPendingSavedPlayers.Length != 0)
    {
        SavedPlayer = mPendingSavedPlayers[0];
        // DebugMode: 0
        assert(SavedPlayer.Controller != none);
        SavedPlayer.Controller.Destroy();
        // [Loop Continue]
        goto J0x67;
    }
    //return;    
}

function class<Class> GetDefaultPlayerClass(@NULL C)
{
    return GetPlayerPawnClass(C, C.GetTeamNum());
    //return ReturnValue;    
}

protected event class<Class> GetPlayerPawnClass(@NULL C, byte TeamNum)
{
    return DefaultPawnClass;
    //return ReturnValue;    
}

function AddDefaultWeapons(@NULL invMan)
{
    local int Index;
    local class<Class> WeaponType;

    invMan.mbDrawItemPickups = false;
    Index = 0;
    J0x18:

    // End:0x7A [Loop If]
    if(Index < DefaultPlayerWeapons.Length)
    {
        WeaponType = class<Inventory>(FindObject(DefaultPlayerWeapons[Index], Class'Core.Class'));
        // End:0x70
        if(WeaponType != none)
        {
            invMan.CreateInventory(WeaponType, true);
            // [Explicit Continue]
        }
        ++Index;
        // [Loop Continue]
        goto J0x18;
    }
    // End:0xA9
    if(!invMan.SetCurrentWeaponByType(10, true))
    {
        invMan.SwitchToBestWeapon();
    }
    invMan.mbDrawItemPickups = true;
    //return;    
}

function AddDefaultAmmoCommon(@NULL invMan)
{
    invMan.CreateAmmoPool(Class'TurokAmmoPoolArrow', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolHandgun', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolSmg', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolShotgun', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolSniperRifle', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolRailgun', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolChaingun', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolFlameThrower', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolRocket', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolStickyGun', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolRailGrenade', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolNapalmGrenade', -1, -1);
    invMan.CreateAmmoPool(Class'TurokAmmoPoolArrowExploding', -1, -1);
    //return;    
}

function AddDefaultAmmo(@NULL invMan)
{
    invMan.mbDrawItemPickups = false;
    AddDefaultAmmoCommon(invMan);
    invMan.mbDrawItemPickups = true;
    //return;    
}

function AddDefaultInventory(@NULL P)
{
    local @NULL invMan;

    invMan = TurokInventoryManager(TurokPawn(P).InvManager);
    // End:0x2B
    if(invMan == none)
    {
        return;
    }
    // End:0x62
    if(P.IsPlayerPawn())
    {
        AddDefaultAmmo(invMan);
        AddDefaultWeapons(invMan);        
    }
    else
    {
        P.AddDefaultInventory();
    }
    //return;    
}

function DiscardInventory(@NULL Other)
{
    // End:0x23
    if(!Other.IsPlayerPawn())
    {
        super(GameInfo).DiscardInventory(Other);
    }
    //return;    
}

function ReduceDamage(out int Damage, @NULL injured, @NULL InstigatedBy, @NULL HitLocation, out @NULL Momentum, class<Class> DamageType)
{
    local int restoreDamage;

    // End:0x65
    if(((InstigatedBy != none) && InstigatedBy.Pawn != none) && !InstigatedBy.Pawn.CanHurt(injured, DamageType) && !mAllowFriendlyFire)
    {
        Damage = 0;        
    }
    else
    {
        restoreDamage = Damage;
        super(GameInfo).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
        // End:0xC8
        if(injured.InGodMode())
        {
            Damage = Min(restoreDamage, injured.Health - 1);
        }
    }
    //return;    
}

defaultproperties
{
    mStatsReplicationClass=Class'TurokSPStatReplicationInfo'
    bRestartLevel=true
    HUDType=Class'TurokHud'
    MaxSpectatorsAllowed=0
    MaxPlayersAllowed=1
    PlayerControllerClass=Class'TurokPlayerController'
    PlayerReplicationInfoClass=Class'TurokPlayerReplicationInfo'
    GameReplicationInfoClass=Class'TurokGameReplicationInfo'
}