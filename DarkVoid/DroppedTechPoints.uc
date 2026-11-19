class DroppedTechPoints extends SkyPickup
    native;

enum ETechPointOffsetType
{
    ETPOT_Wave,                     // 0
    ETPOT_Spiral,                   // 1
    ETPOT_MAX                       // 2
};

enum ETechPointScaleState
{
    ETPSS_Growing,                  // 0
    ETPSS_Shrinking,                // 1
    ETPSS_MAX                       // 2
};

enum ETechPointState
{
    ETPS_Falling,                   // 0
    ETPS_WaitToBob,                 // 1
    ETPS_Bobbing,                   // 2
    ETPS_Homing,                    // 3
    ETPS_Dormant,                   // 4
    ETPS_MAX                        // 5
};

var(Effects) ParticleSystem TechPointParticleSystem;
var(Effects) name TechPointParticleSocket;
var export editinline ParticleSystemComponent TechPointPSC;
var(TechPoint) int MinPoints;
var(TechPoint) int MaxPoints;
var(TechPoint) DroppedTechPoints.ETechPointState StartingState;
var DroppedTechPoints.ETechPointState CurrState;
var(TechPointMagnetism) DroppedTechPoints.ETechPointOffsetType OffsetType;
var DroppedTechPoints.ETechPointScaleState ScaleState;
var int Points;
var(TechPointInitialLaunch) float InitialSpeedMin;
var(TechPointInitialLaunch) float InitialSpeedMax;
var(TechPointInitialLaunch) float InitialUpwardSpeedMin;
var(TechPointInitialLaunch) float InitialUpwardSpeedMax;
var(TechPointInitialLaunch) float VelocityLostPerBounce;
var(TechPointInitialLaunch) float RestingSpeed;
var(TechPointInitialLaunch) float SpinRateMin;
var(TechPointInitialLaunch) float SpinRateMax;
var(TechPointBobbing) float RotateToZeroTime;
var(TechPointBobbing) float DelayBeforeBob;
var(TechPointBobbing) float BobHeight;
var(TechPointBobbing) float BobRate;
var(TechPointBobbing) Rotator BobRotationRate;
var(TechPointBobbing) Rotator BobRotationFadeRate;
var Vector BobBaseLoc;
var float BobStartTime;
var Rotator BobInitialRotation;
var(TechPointMagnetism) float MagnetismDistWalking;
var(TechPointMagnetism) float MagnetismDistFlying;
var(TechPointMagnetism) float MagnetismDistAAGun;
var(TechPointMagnetism) float MagnetismAccelRate;
var(TechPointMagnetism) float MagnetismOffsetPeriod;
var(TechPointMagnetism) float MagnetismOffsetLength;
var(TechPointMagnetism) bool bMagnetismOffsetLooping;
var bool bMagnetismSpiralClockwise;
var(TechPointMagnetism) float MagnetismSpiralGrowTime;
var(TechPointMagnetism) name MagnetismSocket;
var(TechPointMagnetism) array<SVisualEffectParams> CollectionEffects;
var Vector MagnetismBaseLocation;
var float MagnetismStartTime;
var(TechPointScaling) float SpawnScaleMin;
var(TechPointScaling) float SpawnScaleMax;
var(TechPointScaling) float SpawnScaleUpTime;
var float SpawnScaleUpTimer;
var(TechPointScaling) float CollectScaleMin;
var(TechPointScaling) float ScaleDownDistStart;
var(TechPointScaling) float ScaleDownDistEnd;
var(TechPointMagnetism) editinline ForceFeedbackWaveform CollectionRumble;
var(Sounds) SoundCue PickupSound;

// Export UDroppedTechPoints::execChangeState(FFrame&, void* const)
native function ChangeState(DroppedTechPoints.ETechPointState NewState);

simulated function Init(Inventory Inv)
{
    local Vector NewAngularVelocity, InitialVelocity;
    local int SpinRateMinRot, SpinRateMaxRot;
    local DroppedTechPoints Arch;
    local editinline SkeletalMeshComponent SKMesh;

    super.Init(Inv);
    Arch = DroppedTechPoints(ObjectArchetype);
    ScaleState = 0;
    SpawnScaleUpTimer = 0.0000000;
    MeshComp.SetScale(SpawnScaleMin);
    DelayBeforeBob = Arch.DelayBeforeBob;
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    ChangeState(0);
    SetTimer(0.0100000, false, 'BeginStartingState');
    SpinRateMinRot = int((SpinRateMin / 360.0000000) * float(65536));
    SpinRateMaxRot = int((SpinRateMax / 360.0000000) * float(65536));
    Points = Rand((MaxPoints - MinPoints) + 1) + MinPoints;
    NewAngularVelocity.X = RandRange(float(SpinRateMinRot), float(SpinRateMaxRot)) * ((FRand() > 0.5000000) ? 1.0000000 : -1.0000000);
    NewAngularVelocity.Y = RandRange(float(SpinRateMinRot), float(SpinRateMaxRot)) * ((FRand() > 0.5000000) ? 1.0000000 : -1.0000000);
    NewAngularVelocity.Z = RandRange(float(SpinRateMinRot), float(SpinRateMaxRot)) * ((FRand() > 0.5000000) ? 1.0000000 : -1.0000000);
    MeshComp.SetRBAngularVelocity(NewAngularVelocity, false);
    InitialVelocity.X = InitialSpeedMin + ((FRand() * (InitialSpeedMax - InitialSpeedMin)) * ((FRand() > 0.5000000) ? -1.0000000 : 1.0000000));
    InitialVelocity.Y = InitialSpeedMin + ((FRand() * (InitialSpeedMax - InitialSpeedMin)) * ((FRand() > 0.5000000) ? -1.0000000 : 1.0000000));
    InitialVelocity.Z = InitialUpwardSpeedMin + (FRand() * (InitialUpwardSpeedMax - InitialUpwardSpeedMin));
    MeshComp.SetRBLinearVelocity(InitialVelocity, false);
    SKMesh = SkeletalMeshComponent(MeshComp);
    // End:0x30F
    if(SKMesh != none)
    {
        TechPointPSC = new (Outer) Class'SkyParticleSystemComponent';
        TechPointPSC.bPersistDynamicLight = true;
        SKMesh.AttachComponentToSocket(TechPointPSC, TechPointParticleSocket);
        TechPointPSC.SetTemplate(TechPointParticleSystem);
        TechPointPSC.ActivateSystem();
    }
    //return;    
}

function BeginStartingState()
{
    ChangeState(StartingState);
    //return;    
}

function PickedUpBy(Pawn P)
{
    Reset();
    //return;    
}

simulated function Reset()
{
    ChangeState(4);
    super.Reset();
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        // End:0x29
        if(SkyPawnBase(Other) != none)
        {
            return SkyPawnBase(Other).bCollectingTechPoints;            
        }
        else
        {
            // End:0x82
            if((SkyVehicle(Other) != none) && SkyPawnBase(SkyVehicle(Other).Driver) != none)
            {
                return SkyPawnBase(SkyVehicle(Other).Driver).bCollectingTechPoints;                
            }
            else
            {
                return super.ValidTouch(Other);
            }
        }
        //return ReturnValue;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;
        local SkyPlayerControllerBase C;
        local SkyPawn SP;
        local SkyPawn_MaxValenti Player;
        local SkyVehicle PlayerVeh;

        P = Pawn(Other);
        // End:0x35
        if(P != none)
        {
            C = SkyPlayerControllerBase(P.Controller);
        }
        // End:0x191
        if((C != none) && ValidTouch(P))
        {
            Class'SkyHUD'.static.OpenPickupTutorial('DroppedTechPoint', SkyPlayerController(C));
            C.AddTechPoints(Points);
            C.PlaySound(PickupSound);
            SP = SkyPawn(Other);
            // End:0xE4
            if(SP != none)
            {
                SP.AddEffectVisualEffect(CollectionEffects, self);
            }
            Player = SkyPawn_MaxValenti(Other);
            // End:0x134
            if(Player == none)
            {
                PlayerVeh = SkyVehicle(Other);
                // End:0x134
                if(PlayerVeh != none)
                {
                    Player = SkyPawn_MaxValenti(PlayerVeh.Driver);
                }
            }
            // End:0x155
            if(Player != none)
            {
                Player.TechPointsSinceLastCheckpoint += Points;
            }
            C.ClientPlayForceFeedbackWaveform(CollectionRumble);
            Inventory.Destroy();
            Inventory = none;
            PickedUpBy(P);
        }
        //return;        
    }
    stop;    
}
