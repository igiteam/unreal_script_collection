class UTVehicleFactory extends UDKVehicleFactory
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force);

var float SpawnZOffset;
var() bool bMayReverseSpawnDirection;
var() bool bStartNeutral;
var() bool bDisabled;
var() bool bKeyVehicle;
var() bool bForceAvoidReversing;
var EvilGameObjective ReverseObjective;
var() array<Rotator> InitialGunRotations;

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    // End:0xA7
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x8C
        if(EvilGame(WorldInfo.Game) != none)
        {
            EvilGame(WorldInfo.Game).ActivateVehicleFactory(self);            
        }
        else
        {
            bStartNeutral = true;
            Activate(255);
        }        
    }
    else
    {
        AddToClosestObjective();
    }
    //return;    
}

simulated function AddToClosestObjective()
{
    local EvilGameObjective O, Best;
    local float Distance, BestDistance;

    // End:0xB8
    foreach WorldInfo.AllNavigationPoints(Class'EvilGameObjective', O)
    {
        Distance = VSize(Location - O.Location);
        // End:0xB7
        if((Best == none) || Distance < BestDistance)
        {
            BestDistance = Distance;
            Best = O;
        }        
    }    
    // End:0x108
    if(Best != none)
    {
        Best.VehicleFactories[Best.VehicleFactories.Length] = self;
    }
    //return;    
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    //return;    
}

simulated function RenderMapIcon(UTMapInfo MP, Canvas Canvas, UTPlayerController PlayerOwner, LinearColor FinalColor)
{
    local LinearColor DrawColor;

    // End:0x11
    if(!bHasLockedVehicle)
    {
        return;
    }
    DrawColor = MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 0.6000000);
    MP.DrawRotatedTile(Canvas, Class'UTHUD'.default.IconHudTexture, HUDLocation, Rotation.Yaw + 16384, class<EvilVehicle_Base>(VehicleClass).default.MapSize * 1.0500000, class<EvilVehicle_Base>(VehicleClass).default.IconCoords, DrawColor);
    FinalColor.A = 0.6000000;
    MP.DrawRotatedTile(Canvas, Class'UTHUD'.default.IconHudTexture, HUDLocation, Rotation.Yaw + 16384, class<EvilVehicle_Base>(VehicleClass).default.MapSize, class<EvilVehicle_Base>(VehicleClass).default.IconCoords, FinalColor);
    //return;    
}

function Activate(byte T)
{
    // End:0x32
    if(!bDisabled)
    {
        TeamNum = int(T);
        GotoState('Active');
    }
    //return;    
}

function Deactivate()
{
    local Vector HitLocation, HitNormal;

    GotoState('None');
    TeamNum = 255;
    // End:0x1C7
    if(((EvilVehicle_Base(ChildVehicle) != none) && !ChildVehicle.bDeleteMe) && EvilVehicle_Base(ChildVehicle).bTeamLocked)
    {
        // End:0x1AF
        if(EvilGame(WorldInfo.Game).MatchIsInProgress())
        {
            HitLocation = Location;
            ChildVehicle.Health = -2 * ChildVehicle.HealthMax;
            ChildVehicle.TearOffMomentum = vect(0.0000000, 0.0000000, 1.0000000);
            TraceComponent(HitLocation, HitNormal, ChildVehicle.Mesh, ChildVehicle.Location, Location);            
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
    TriggerEventClass(Class'UTSeqEvent_VehicleFactory', none, 1);
    bHasLockedVehicle = false;
    ExtraCost = 0;
    //return;    
}

function VehicleDestroyed(EvilVehicle_Base V)
{
    TriggerEventClass(Class'UTSeqEvent_VehicleFactory', none, 2);
    ChildVehicle = none;
    bHasLockedVehicle = false;
    ExtraCost = 0;
    //return;    
}

function TriggerSpawnedEvent()
{
    TriggerEventClass(Class'UTSeqEvent_VehicleFactory', none, 0);
    //return;    
}

function OnToggle(SeqAct_Toggle Action)
{
    local EvilGameObjective Objective;

    // End:0x46
    if(Action.InputLinks[0].bHasImpulse)
    {
        bDisabled = false;        
    }
    else
    {
        // End:0x8C
        if(Action.InputLinks[1].bHasImpulse)
        {
            bDisabled = true;            
        }
        else
        {
            bDisabled = !bDisabled;
        }
    }
    // End:0xBD
    if(bDisabled)
    {
        Deactivate();        
    }
    else
    {
        // End:0x164
        foreach WorldInfo.AllNavigationPoints(Class'EvilGameObjective', Objective)
        {
            // End:0x163
            if(Objective.VehicleFactories.Find(self) != )
            {                
                Activate(Objective.GetTeamNum());
                RespawnProgress = 0.0000000;
                SpawnVehicle();
                // End:0x164
                break;
            }            
        }        
    }
    //return;    
}

function Rotator GetSpawnRotation()
{
    local Rotator SpawnRot;

    SpawnRot = Rotation;
    // End:0x84
    if((bMayReverseSpawnDirection && ReverseObjective != none) && int(ReverseObjective.DefenderTeamIndex) == TeamNum)
    {
        SpawnRot.Yaw += 32768;
    }
    return SpawnRot;
    //return ReturnValue;    
}

state Active
{
    function VehicleDestroyed(EvilVehicle_Base V)
    {
        global.VehicleDestroyed(V);
        RespawnProgress = class<EvilVehicle_Base>(VehicleClass).default.RespawnTime - class<EvilVehicle_Base>(VehicleClass).default.SpawnInTime;
        //return;        
    }

    event SpawnVehicle()
    {
        local Pawn P;
        local bool bIsBlocked;
        local Rotator SpawnRot, TurretRot;
        local Vector SpawnLoc;
        local int I;
        local EvilGame G;
        local EvilVehicle_Base UTChildVehicle;

        // End:0x37
        if((ChildVehicle != none) && !ChildVehicle.bDeleteMe)
        {
            return;
        }
        ExtraCost = int(FMax(float(ExtraCost), 5000.0000000));
        // End:0x11D
        foreach CollidingActors(Class'Engine.Pawn', P, class<EvilVehicle_Base>(VehicleClass).default.SpawnRadius)
        {
            bIsBlocked = true;
            // End:0x11C
            if(PlayerController(P.Controller) != none)
            {
                PlayerController(P.Controller).ReceiveLocalizedMessage(Class'UTVehicleMessage', 2);
            }            
        }        
        // End:0x141
        if(bIsBlocked)
        {
            SetTimer(1.0000000, false, 'SpawnVehicle');            
        }
        else
        {
            SpawnRot = GetSpawnRotation();
            SpawnLoc = Location + (vect(0.0000000, 0.0000000, 1.0000000) * SpawnZOffset);
            ChildVehicle = Spawn(VehicleClass,,, SpawnLoc, SpawnRot);
            UTChildVehicle = EvilVehicle_Base(ChildVehicle);
            // End:0x598
            if(UTChildVehicle != none)
            {
                UTChildVehicle.SetTeamNum(byte(TeamNum));
                UTChildVehicle.ParentFactory = self;
                // End:0x25B
                if(bStartNeutral)
                {
                    UTChildVehicle.bTeamLocked = false;                    
                }
                else
                {
                    // End:0x289
                    if(UTChildVehicle.bTeamLocked)
                    {
                        bHasLockedVehicle = true;
                    }
                }
                // End:0x2D6
                if(bKeyVehicle)
                {
                    UTChildVehicle.SetKeyVehicle();
                    UTChildVehicle.AIPurpose = 0;
                }
                // End:0x304
                if(bForceAvoidReversing)
                {
                    UTChildVehicle.bAvoidReversing = true;
                }
                UTChildVehicle.Mesh.WakeRigidBody();
                I = 0;
                J0x344:

                // End:0x46C [Loop If]
                if(I < UTChildVehicle.Seats.Length)
                {
                    // End:0x41A
                    if(I < InitialGunRotations.Length)
                    {
                        TurretRot = InitialGunRotations[I];
                        // End:0x417
                        if((bMayReverseSpawnDirection && ReverseObjective != none) && int(ReverseObjective.DefenderTeamIndex) == TeamNum)
                        {
                            TurretRot.Yaw += 32768;
                        }                        
                    }
                    else
                    {
                        TurretRot = SpawnRot;
                    }
                    UTChildVehicle.ForceWeaponRotation(I, TurretRot);
                    I++;
                    // [Loop Continue]
                    goto J0x344;
                }
                G = EvilGame(WorldInfo.Game);
                // End:0x4DE
                if(G.MatchIsInProgress())
                {
                    UTChildVehicle.PlaySpawnEffect();
                }
                // End:0x516
                if(WorldInfo.bStartup)
                {
                    SetTimer(0.1000000, false, 'TriggerSpawnedEvent');                    
                }
                else
                {
                    TriggerSpawnedEvent();
                }
                // End:0x598
                if((G.bNecrisLocked && UTChildVehicle.bIsNecrisVehicle) && TeamNum == 1)
                {
                    UTChildVehicle.bEnteringUnlocks = false;
                }
            }
        }
        //return;        
    }

    function Activate(byte T)
    {
        TeamNum = int(T);
        // End:0x83
        if(ChildVehicle != none)
        {
            // End:0x80
            if(EvilVehicle_Base(ChildVehicle).bTeamLocked)
            {
                EvilVehicle_Base(ChildVehicle).SetTeamNum(T);
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
        // End:0xBA
        if(EvilGame(WorldInfo.Game).MatchIsInProgress())
        {
            RespawnProgress = class<EvilVehicle_Base>(VehicleClass).default.InitialSpawnDelay - class<EvilVehicle_Base>(VehicleClass).default.SpawnInTime;
            // End:0xB7
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

defaultproperties
{
    TeamNum=255
    bBlockable=true
    // Reference: CylinderComponent'Default__UTVehicleFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=CollisionCylinder
    Components[3]=none
    // Reference: DynamicLightEnvironmentComponent'Default__UTVehicleFactory.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[4]=MyLightEnvironment
    Components[5]=none
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bStatic=false
    bHidden=true
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=true
    NetUpdateFrequency=1.0000000
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}