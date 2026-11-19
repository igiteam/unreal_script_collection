class SkyVehicleFactory extends SkyNavigationPoint
    native
    nativereplication;

var() SkyVehicle VehicleArchetype;
var() float BlockedDelayTime;
var() float MaxDistForRespawn;
var() float RespawnDelayTime;
var transient SkyGameVehicle SpawnedVehicle;
var export editinline SkeletalMeshComponent VehicleMesh;
var() bool WaitForDeathToRespawn;
var() bool InvulnerableUntilDriven;
var() bool bMayReverseSpawnDirection;
var() bool bStartNeutral;
var bool bHasLockedVehicle;
var() bool bAllowFriendlyUsurp;
var deprecated bool bSnapToGround;
var() bool bDisabled;
var deprecated bool bUpsideDown;
var deprecated bool bRespawnVehicleForCheckpoint;
var deprecated class<SkyGameVehicle> VehicleClass;
var SkyGameVehicle ChildVehicle;
var float RespawnProgress;
var float RespawnRateModifier;
var SkyGameObjective ReverseObjective;
var() int TeamNum;
var Vector HUDLocation;
var private transient MaterialInstanceConstant HUDMaterialInstance;
var() array<Rotator> InitialGunRotations;
var() SkyInteractor_AirVehicleToAAGun AirToAAGunInteractor;
var() SkyVehicleFactory LinkedVehicleFactoryLeft;
var() SkyVehicleFactory LinkedVehicleFactoryRight;
var() Actor ExitLocationActor;
var(Sound) array<Actor> AssociatedSoundActors;
var() Surface AAGunHUDImage;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        bHasLockedVehicle;
}

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    // End:0x6B
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x57
        if(SkyGame(WorldInfo.Game) != none)
        {
            SkyGame(WorldInfo.Game).ActivateVehicleFactory(self);            
        }
        else
        {
            bStartNeutral = true;
            Activate(255);
        }
    }
    //return;    
}

simulated function AddToClosestObjective()
{
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    //return;    
}

simulated function SetHUDLocation(Vector NewHUDLocation)
{
    HUDLocation = NewHUDLocation;
    //return;    
}

function Activate(byte T)
{
    // End:0x19
    if(!bDisabled)
    {
        GotoState('Active');
    }
    //return;    
}

event Deactivate()
{
    local Vector HitLocation, HitNormal;

    GotoState('None');
    // End:0x11D
    if(((ChildVehicle != none) && !ChildVehicle.bDeleteMe) && ChildVehicle.bTeamLocked)
    {
        // End:0x110
        if(SkyGame(WorldInfo.Game).MatchIsInProgress())
        {
            HitLocation = Location;
            ChildVehicle.Health = -2 * ChildVehicle.default.Health;
            ChildVehicle.TearOffMomentum = vect(0.0000000, 0.0000000, 1.0000000);
            TraceComponent(HitLocation, HitNormal, ChildVehicle.Mesh, ChildVehicle.Location, Location);
            ChildVehicle.Died(none, Class'SkyDmgType_SmallExplosives', HitLocation);            
        }
        else
        {
            ChildVehicle.Destroy();
        }
    }
    //return;    
}

function VehicleTaken()
{
    bHasLockedVehicle = false;
    ExtraCost = 0;
    //return;    
}

function VehicleDestroyed(SkyGameVehicle V)
{
    ChildVehicle = none;
    bHasLockedVehicle = false;
    ExtraCost = 0;
    //return;    
}

simulated function byte GetTeamNum()
{
    return byte(TeamNum);
    //return ReturnValue;    
}

event SpawnVehicle()
{
    //return;    
}

// Export USkyVehicleFactory::execAddVehicleToNextCheckpoint(FFrame&, void* const)
native function AddVehicleToNextCheckpoint(SkyGameVehicle Spawned);

function TriggerSpawnedEvent()
{
    AddVehicleToNextCheckpoint(ChildVehicle);
    //return;    
}

function OnToggle(SeqAct_Toggle Action)
{
    local SkyGameObjective Objective;

    // End:0x2B
    if(Action.InputLinks[0].bHasImpulse)
    {
        bDisabled = false;        
    }
    else
    {
        // End:0x56
        if(Action.InputLinks[1].bHasImpulse)
        {
            bDisabled = true;            
        }
        else
        {
            bDisabled = !bDisabled;
        }
    }
    // End:0x7B
    if(bDisabled)
    {
        Deactivate();        
    }
    else
    {
        // End:0xD7
        foreach WorldInfo.AllNavigationPoints(Class'SkyGameObjective', Objective)
        {
            // End:0xD6
            if(Objective.VehicleFactories.Find(self) != -1)
            {
                Activate(Objective.GetTeamNum());
                // End:0xD7
                break;
            }            
        }        
    }
    //return;    
}

function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
{
    // End:0x4F
    if((SpawnedVehicle != none) && SkyAIController(SpawnedVehicle.Controller) != none)
    {
        SkyAIController(SpawnedVehicle.Controller).OnAIFreeze(FreezeAction);
    }
    //return;    
}

function bool IsBlocked()
{
    return false;
    //return ReturnValue;    
}

event AssociateVehicleToFactory(SkyGameVehicle Veh, Rotator SpawnRot)
{
    local Rotator TurretRot;
    local int I;
    local SkyVehicle SV;
    local SkyVehicle_AAGun_Gatling AAGun;

    // End:0x341
    if(Veh != none)
    {
        ChildVehicle = Veh;
        SpawnedVehicle = ChildVehicle;
        // End:0x82
        if(TeamNum != 255)
        {
            ChildVehicle.SetTeamNum(byte(TeamNum));
            // End:0x82
            if(ChildVehicle.Controller != none)
            {
                ChildVehicle.Controller.SetTeamNum(byte(TeamNum));
            }
        }
        ChildVehicle.ParentFactory = self;
        // End:0xB1
        if(bStartNeutral)
        {
            ChildVehicle.bTeamLocked = false;            
        }
        else
        {
            // End:0xCC
            if(ChildVehicle.bTeamLocked)
            {
                bHasLockedVehicle = true;
            }
        }
        ChildVehicle.Mesh.WakeRigidBody();
        SV = SkyVehicle(ChildVehicle);
        // End:0x145
        if(SV != none)
        {
            SV.InvulnerableUntilDriven = InvulnerableUntilDriven;
            SV.bIsInvulnerable = InvulnerableUntilDriven;
            SV.ExitLocationActor = ExitLocationActor;
        }
        AAGun = SkyVehicle_AAGun_Gatling(ChildVehicle);
        // End:0x1D4
        if(AAGun != none)
        {
            AAGun.AirToAAGunInteractor = AirToAAGunInteractor;
            AAGun.LinkedVehicleFactoryLeft = LinkedVehicleFactoryLeft;
            AAGun.LinkedVehicleFactoryRight = LinkedVehicleFactoryRight;
            AAGun.AssociatedSoundActors = AssociatedSoundActors;
            // End:0x1D4
            if(AAGunHUDImage != none)
            {
                AAGun.HUDImage = AAGunHUDImage;
            }
        }
        I = 0;
        J0x1DB:

        // End:0x296 [Loop If]
        if(I < ChildVehicle.Seats.Length)
        {
            // End:0x263
            if(I < InitialGunRotations.Length)
            {
                TurretRot = InitialGunRotations[I];
                // End:0x260
                if((bMayReverseSpawnDirection && ReverseObjective != none) && int(ReverseObjective.DefenderTeamIndex) == TeamNum)
                {
                    TurretRot.Yaw += 32768;
                }                
            }
            else
            {
                TurretRot = SpawnRot;
            }
            ChildVehicle.ForceWeaponRotation(I, TurretRot);
            I++;
            // [Loop Continue]
            goto J0x1DB;
        }
        // End:0x2D0
        if(SkyGame(WorldInfo.Game).MatchIsInProgress())
        {
            ChildVehicle.PlaySpawnEffect();
        }
        // End:0x2F9
        if(WorldInfo.bStartup)
        {
            SetTimer(0.1000000, false, 'TriggerSpawnedEvent');            
        }
        else
        {
            TriggerSpawnedEvent();
        }
        PostSpawn();
        // End:0x341
        if((SV != none) && SV.bSnapToGroundAfterFactorySpawn)
        {
            SV.SnapToGround();
        }
    }
    //return;    
}

function PostSpawn()
{
    //return;    
}

state Active
{
    function VehicleDestroyed(SkyGameVehicle V)
    {
        local SeqEvent_Destroyed destEvent;
        local int Idx;

        global.VehicleDestroyed(V);
        RespawnProgress = RespawnDelayTime;
        Idx = 0;
        J0x21:

        // End:0x79 [Loop If]
        if(Idx < GeneratedEvents.Length)
        {
            destEvent = SeqEvent_Destroyed(GeneratedEvents[Idx]);
            // End:0x6F
            if(destEvent != none)
            {
                destEvent.CheckActivate(V, V);
            }
            Idx++;
            // [Loop Continue]
            goto J0x21;
        }
        //return;        
    }

    event SpawnVehicle()
    {
        local Pawn P;
        local bool bIsBlocked;
        local Rotator SpawnRot;
        local Actor A;
        local SkyVehicle SV;

        // End:0x76
        if(((!WaitForDeathToRespawn && ChildVehicle != none) && ChildVehicle.Driver != none) && VSizeSq(ChildVehicle.Location - Location) > (MaxDistForRespawn * MaxDistForRespawn))
        {
            ChildVehicle.ParentFactory = none;
            ChildVehicle = none;
        }
        // End:0x9A
        if((ChildVehicle != none) && !ChildVehicle.bDeleteMe)
        {
            return;
        }
        ExtraCost = int(FMax(float(ExtraCost), 5000.0000000));
        // End:0xDA
        foreach CollidingActors(Class'Engine.Pawn', P, VehicleArchetype.SpawnRadius)
        {
            bIsBlocked = true;            
        }        
        // End:0xF7
        if(!bIsBlocked)
        {
            bIsBlocked = IsBlocked();
        }
        // End:0x1D0
        if(!bIsBlocked)
        {
            // End:0x1CF
            foreach VisibleCollidingActors(VehicleArchetype.Class, A, VehicleArchetype.SpawnRadius * 4.0000000)
            {
                SV = SkyVehicle(A);
                // End:0x1CE
                if(SV.ParentFactory == none)
                {
                    // End:0x1CE
                    if(SV.Health >= SV.default.Health)
                    {
                        // End:0x1CE
                        if(SV.Driver == none)
                        {
                            // End:0x1CE
                            if(VSize(SV.Location - Location) < (VehicleArchetype.SpawnRadius * 4.0000000))
                            {
                                bIsBlocked = true;
                            }
                        }
                    }
                }                
            }            
        }
        // End:0x1EF
        if(bIsBlocked)
        {
            SetTimer(BlockedDelayTime, true, 'SpawnVehicle');            
        }
        else
        {
            SpawnRot = Rotation;
            // End:0x244
            if((bMayReverseSpawnDirection && ReverseObjective != none) && int(ReverseObjective.DefenderTeamIndex) == TeamNum)
            {
                SpawnRot.Yaw += 32768;
            }
            ChildVehicle = Spawn(VehicleArchetype.Class,,, Location, SpawnRot, VehicleArchetype, true);
            AssociateVehicleToFactory(ChildVehicle, SpawnRot);
        }
        //return;        
    }

    function Activate(byte T)
    {
        // End:0x6F
        if(ChildVehicle != none)
        {
            // End:0x6C
            if(TeamNum != 255)
            {
                ChildVehicle.SetTeamNum(byte(TeamNum));
                // End:0x6C
                if(ChildVehicle.Controller != none)
                {
                    ChildVehicle.Controller.SetTeamNum(byte(TeamNum));
                }
            }            
        }
        else
        {
            RespawnProgress = 0.0000000;
            ClearTimer('SpawnVehicle');
            SpawnVehicle();
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x4D
        if(SkyGame(WorldInfo.Game).MatchIsInProgress())
        {
            RespawnProgress = RespawnDelayTime;
            // End:0x4A
            if(RespawnProgress <= 0.0000000)
            {
                SpawnVehicle();
            }            
        }
        else
        {
            RespawnProgress = 0.0000000;
            SpawnVehicle();
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        RespawnProgress = 0.0000000;
        ClearTimer('SpawnVehicle');
        //return;        
    }
    stop;    
}
