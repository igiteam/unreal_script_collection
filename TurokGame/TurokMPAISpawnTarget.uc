class TurokMPAISpawnTarget extends TurokMPSpawnTarget
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;
var(Multiplayer) private bool mEnabled;
var private bool mEnabledCurrent;
var(Multiplayer) private const byte mTeamIndex;
var(Multiplayer) private const byte mNumToSpawn;
var(Multiplayer) private const byte mNumWaves;
var private byte mNumSpawned;
var private byte mNumDead;
var private byte mNumWavesCompleted;
var private const array mSpawnPointsEnabled;
var private array mSpawnPoints;
var private int mNumSpawnPoints;
var private transient bool mMigrationRestore;

// Export UTurokMPAISpawnTarget::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    mEnabledCurrent = mEnabled;
    BuildListOfSpawnPoints();
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x6B
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x33
        if(!mEnabledCurrent)
        {
            GotoState('Disabled');
            return;
        }
        // End:0x5D
        if((int(mNumToSpawn) == 0) || mNumSpawnPoints == 0)
        {
            GotoState('Disabled');
            return;
        }
        GotoState('Enabled');
    }
    //return;    
}

event PostSaveGameRestore()
{
    mMigrationRestore = true;
    SetInitialState();
    //return;    
}

function Reset()
{
    super(Actor).Reset();
    mEnabledCurrent = mEnabled;
    mNumSpawned = 0;
    mNumDead = 0;
    mNumWavesCompleted = 0;
    SetInitialState();
    //return;    
}

private final function BuildListOfSpawnPoints()
{
    local @NULL P;

    mNumSpawnPoints = 0;
    // End:0x68
    foreach WorldInfo.AllNavigationPoints(Class'TurokMPAISpawnPoint', P)
    {
        // End:0x67
        if(P.mSpawnTarget == self)
        {
            // End:0x4F
            if(P.mPawnClass == none)
            {
                continue;                
            }
            mSpawnPoints[mNumSpawnPoints] = P;
            ++mNumSpawnPoints;
        }        
    }    
    //return;    
}

function NotifyKilled(@NULL Killed, @NULL Killer)
{
    // End:0x17
    if(int(mNumWaves) == 0)
    {
        --mNumSpawned;        
    }
    else
    {
        ++mNumDead;
    }
    TriggerEventClass(Class'TurokSeqEvent_MPAIKilled', self);
    // End:0x9C
    if((int(mNumWaves) != 0) && int(mNumDead) == int(mNumToSpawn))
    {
        mNumDead = 0;
        // End:0x8A
        if(int(mNumWavesCompleted) < int(mNumWaves))
        {
            mNumSpawned = 0;
            TriggerEventClass(Class'TurokSeqEvent_MPAIWaveDead', self, 0);            
        }
        else
        {
            TriggerEventClass(Class'TurokSeqEvent_MPAIWaveDead', self, 1);
        }
    }
    //return;    
}

private final function bool IsAreaBlocked(@NULL SpawnPoint)
{
    local @NULL P;
    local float Radius;

    // DebugMode: 0
    assert((SpawnPoint.mSpawnTarget == self) && SpawnPoint.mPawnClass != none);
    Radius = SpawnPoint.mPawnClass.default.CylinderComponent.CollisionRadius;
    // End:0x79
    foreach CollidingActors(Class'Engine.Pawn', P, Radius, SpawnPoint.Location)
    {        
        return true;        
    }    
    return false;
    //return ReturnValue;    
}

private final function float RateAISpawnPoint(@NULL P)
{
    // End:0x2D
    if(!P.mEnabled || IsAreaBlocked(P))
    {
        return -1.0000000;        
    }
    else
    {
        return 1.0000000 * FRand();
    }
    //return ReturnValue;    
}

private final function bool SpawnAI()
{
    local float NewRating, BestRating;
    local @NULL bestNode, SpawnPawn, SpawnController;
    local int I;

    // End:0x21
    if(!WorldInfo.Game.CanReserveTick(0))
    {
        return false;
    }
    // End:0x77
    if((WorldInfo.GRI != none) && (WorldInfo.GRI.bMatchHasBegun == false) || WorldInfo.GRI.bMatchIsOver == true)
    {
        return false;
    }
    BestRating = -1.0000000;
    I = 0;
    J0x89:

    // End:0xE4 [Loop If]
    if(I < mNumSpawnPoints)
    {
        NewRating = RateAISpawnPoint(mSpawnPoints[I]);
        // End:0xDA
        if(NewRating > BestRating)
        {
            BestRating = NewRating;
            bestNode = mSpawnPoints[I];
        }
        ++I;
        // [Loop Continue]
        goto J0x89;
    }
    // End:0x224
    if(bestNode != none)
    {
        SpawnPawn = bestNode.__NFUN_278__(bestNode.mPawnClass);
        // End:0x122
        if(SpawnPawn == none)
        {
            return false;
        }
        SpawnController = bestNode.__NFUN_278__(SpawnPawn.ControllerClass);
        // End:0x161
        if(SpawnController == none)
        {
            SpawnPawn.Destroy();
            return false;
        }
        WorldInfo.Game.ReserveTick(0);
        SpawnPawn.SetMPAISpawnInfo(self, bestNode);
        SpawnController.Possess(SpawnPawn, false);
        WorldInfo.Game.ChangeTeam(SpawnController, int(GetTeamNum()), false);
        WorldInfo.Game.AddDefaultInventory(SpawnPawn);
        ++mNumSpawned;
        bestNode.TriggerEventClass(Class'TurokSeqEvent_MPAISpawned', SpawnPawn);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnToggle(@NULL Action)
{
    local bool bNewEnabled;

    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        bNewEnabled = true;        
    }
    else
    {
        // End:0x52
        if(Action.InputLinks[1].bHasImpulse)
        {
            bNewEnabled = false;            
        }
        else
        {
            // End:0x80
            if(Action.InputLinks[2].bHasImpulse)
            {
                bNewEnabled = !mEnabledCurrent;
            }
        }
    }
    // End:0xA8
    if(bNewEnabled != mEnabledCurrent)
    {
        mEnabledCurrent = bNewEnabled;
        SetInitialState();
    }
    //return;    
}

function OnDestroyAiFromSpawnTarget(@NULL Action)
{
    local array SpawnedPawns;
    local @NULL P;
    local int I;

    // End:0x48
    foreach WorldInfo.AllPawns(Class'TurokPawn', P)
    {
        // End:0x47
        if(P.GetMPAISpawnTarget() == self)
        {
            SpawnedPawns[SpawnedPawns.Length] = P;
        }        
    }    
    I = 0;
    J0x50:

    // End:0x83 [Loop If]
    if(I < SpawnedPawns.Length)
    {
        SpawnedPawns[I].Suicide();
        ++I;
        // [Loop Continue]
        goto J0x50;
    }
    SpawnedPawns.Length = 0;
    mEnabledCurrent = false;
    SetInitialState();
    //return;    
}

auto state Disabled
{
    function BeginState(name PreviousStateName)
    {
        mEnabledCurrent = false;
        mMigrationRestore = false;
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x23
        if(!mMigrationRestore)
        {
            mNumSpawned = 0;
            mNumDead = 0;
            mNumWavesCompleted = 0;
        }
        //return;        
    }
    stop;    
}

state Enabled
{
    function BeginState(name PreviousStateName)
    {
        SetTimer(0.5000000 + FRand(), true);
        mMigrationRestore = false;
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer();
        //return;        
    }

    function Timer()
    {
        local int NumToSpawn;

        NumToSpawn = int(mNumToSpawn) - int(mNumSpawned);
        // End:0x50
        if(NumToSpawn != 0)
        {
            SpawnAI();
            // End:0x50
            if((int(mNumWaves) != 0) && int(mNumSpawned) == int(mNumToSpawn))
            {
                ++mNumWavesCompleted;
            }
        }
        // End:0x92
        if((int(mNumWaves) != 0) && int(mNumWaves) == int(mNumWavesCompleted))
        {
            TriggerEventClass(Class'TurokSeqEvent_MPAISpawnDepleted', self);
            GotoState('Disabled');
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPAISpawnTarget.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    mTeamIndex=255
    mNumToSpawn=1
    mNumWaves=1
    // Reference: CylinderComponent'Default__TurokMPAISpawnTarget.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPAISpawnTarget.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPAISpawnTarget.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bStatic=false
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPAISpawnTarget.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPAISpawnTarget.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}