class SkyVehicle_FloatingMine extends SkyVehicle
    native
    config(Game);

enum EFloatingMineOffsetType
{
    EFMOT_Wave,                     // 0
    EFMOT_Spiral,                   // 1
    EFMOT_MAX                       // 2
};

enum EFloatingMineState
{
    EFMS_Rising,                    // 0
    EFMS_Bobbing,                   // 1
    EFMS_Homing,                    // 2
    EFMS_MAX                        // 3
};

var(Mine) SkyAIFloatingMine MineControllerArchetype;
var(Mine) float DetonationTime;
var(Mine) SkyVehicle_FloatingMine.EFloatingMineState StartingState;
var SkyVehicle_FloatingMine.EFloatingMineState CurrState;
var(MineMagnetism) SkyVehicle_FloatingMine.EFloatingMineOffsetType OffsetType;
var float DetonationTimer;
var(MineRising) float RisingSpeed;
var(MineRising) float RestingDistance;
var(MineRising) Actor RisingTarget;
var(MineBobbing) float BobHeight;
var(MineBobbing) float BobRate;
var(MineSpinning) Rotator spinRate;
var Vector BobBaseLoc;
var float BobStartTime;
var(MineMagnetism) float MagnetismDistFocus;
var(MineMagnetism) float DetonateDistance;
var(MineMagnetism) float MagnetismDistOther;
var(MineMagnetism) float MagnetismAccelRate;
var(MineMagnetism) float MagnetismMaxSpeed;
var(MineMagnetism) float MagnetismOffsetPeriod;
var(MineMagnetism) float MagnetismOffsetLength;
var(MineMagnetism) bool bMagnetismOffsetLooping;
var bool bMagnetismSpiralClockwise;
var bool bForceDetonate;
var(MineMagnetism) float MagnetismSpiralGrowTime;
var Actor MagnetismTarget;
var Vector MagnetismBaseLocation;
var float MagnetismStartTime;
var(HUD) Actor RadarActor;
var(MineMagnetism) float HomeBlendTime;
var transient float CurrentHomeBlendTime;

// Export USkyVehicle_FloatingMine::execChangeState(FFrame&, void* const)
native function ChangeState(SkyVehicle_FloatingMine.EFloatingMineState NewState);

simulated function PostBeginPlay()
{
    local Controller NewController;

    super.PostBeginPlay();
    SetPhysics(0);
    // End:0x64
    if(MineControllerArchetype != none)
    {
        NewController = Spawn(MineControllerArchetype.Class, self,, Location, Rotation, MineControllerArchetype);
        // End:0x64
        if(NewController != none)
        {
            NewController.Possess(self, true);
        }
    }
    ChangeState(StartingState);
    DetonationTimer = DetonationTime;
    Mesh.AttachComponent(EngineSound, 'j_root');
    //return;    
}

simulated function bool CanEnterVehicle(Pawn P)
{
    // End:0x12
    if(SkyPawnPlayerCharacter(P) != none)
    {
        return false;
    }
    return super.CanEnterVehicle(P);
    //return ReturnValue;    
}

function int GetClosestSeat(Pawn P)
{
    // End:0x15
    if(Seats.Length == 0)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    //return ReturnValue;    
}

simulated function EntryAnnouncement(Controller C)
{
    //return;    
}

// Export USkyVehicle_FloatingMine::execGetAdjustedAimFor(FFrame&, void* const)
native simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc);

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    //return;    
}

event Rotator GetWeaponRotation()
{
    //return ReturnValue;    
}

// Export USkyVehicle_FloatingMine::execTakeDamage(FFrame&, void* const)
native simulated function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyVehicle_FloatingMine::execGetWeaponAim(FFrame&, void* const)
native function Rotator GetWeaponAim(SkyVehicleWeapon VWeapon);

simulated function OnSetRadarActor(SkySeqAct_SetRadarActor inAction)
{
    RadarActor = inAction.RadarActor;
    //return;    
}

function OnSetMineVars(SkySeqAct_SetMineVars inAction)
{
    // End:0x64
    if(inAction.MoveToTarget != none)
    {
        RisingTarget = inAction.MoveToTarget;
        // End:0x58
        if(inAction.MoveToSpeed > 0.0000000)
        {
            RisingSpeed = inAction.MoveToSpeed;
        }
        ChangeState(0);
    }
    // End:0x8E
    if(inAction.ChaseTarget != none)
    {
        MagnetismTarget = inAction.ChaseTarget;
    }
    //return;    
}
