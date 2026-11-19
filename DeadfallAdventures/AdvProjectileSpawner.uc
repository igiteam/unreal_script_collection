class AdvProjectileSpawner extends Actor
    placeable
    hidecategories(Navigation);

var() float SpawnVelocityMin;
var() float SpawnVelocityMax;
var() float SpawnDelayMin;
var() float SpawnDelayMax;
var() float CustomGravityScaling;
var() int ProjectileCount;
var() Actor EndTarget;
var() bool bAutoAim;
var() bool bIgnoreZComponentDirection;
var float NextSpawnTime;
var int SpawnedProjectileCount;
var() ParticleSystem OverrideProjFlightTemplate;
var() class<EvilProjectile_Base> ProjectileClass;
var() ParticleSystem SpawnParticle;
var() SoundCue SpawnSound;
var() int DamageVSPawns;
var() int DamageVSPlayer;
var() float DamageVSPlayerDistance;
var export editinline ArrowComponent ArrowComp;
var() float YawMod;
var() float PitchMod;
var() float ProjectileScale;
var Controller DamageInstigator;

function DrawDebug()
{
    local Color C;
    local float AngleX, AngleY;

    C.R = 255;
    C.G = 128;
    C.B = 16;
    C.A = 255;
    AngleX = YawMod * 0.0174533;
    AngleY = PitchMod * 0.0174533;
    DrawDebugCone(Location, Vector(Rotation), 1200.0000000, AngleX, AngleY, 100, C);
    //return;    
}

simulated function Spawn_T()
{
    local int I;
    local EvilProjectile_Base Proj;
    local Vector Dir, TargetLocation;
    local Rotator DirMod;
    local array<EvilPawn> Targets;
    local EvilPawn PTarget, PNearestTarget;
    local float MinDistanceSQ, DistSq, fScalingTargetVelocity;

    // End:0x11
    if(ProjectileClass == none)
    {
        return;
    }
    Proj = Spawn(ProjectileClass,,, Location);
    Proj.SetDrawScale(ProjectileScale);
    Proj.DamageVSPlayer = DamageVSPlayer;
    Proj.Damage = float(DamageVSPawns);
    Proj.DamageVSPlayerDistance = DamageVSPlayerDistance;
    Proj.InstigatorController = DamageInstigator;
    // End:0x15C
    if(OverrideProjFlightTemplate != none)
    {
        Proj.ProjFlightTemplate = OverrideProjFlightTemplate;
        Proj.ReSpawnFlightEffects();
    }
    Proj.Speed = RandRange(SpawnVelocityMin, SpawnVelocityMax);
    Proj.CustomGravityScaling = CustomGravityScaling;
    Dir = Vector(Rotation);
    // End:0x218
    if(EndTarget != none)
    {
        Dir = Normal(EndTarget.Location - Location);
    }
    // End:0x2D9
    if(!bAutoAim)
    {
        DirMod.Yaw = int(RandRange(-YawMod, YawMod) * 182.0444000);
        DirMod.Pitch = int(RandRange(-PitchMod, PitchMod) * 182.0444000);
        Dir = TransformVectorByRotation(DirMod, Dir);        
    }
    else
    {
        // End:0x38A
        foreach CollidingActors(Class'EvilGame.EvilPawn', PTarget, 1200.0000000)
        {
            // End:0x389
            if(PTarget.IsAliveAndWell() && Acos(Dir Dot Normal(PTarget.Location - Location)) < (0.0174533 * YawMod))
            {
                Targets.AddItem(PTarget);                
            }            
        }        
        // End:0x59C
        if(Targets.Length > 0)
        {
            PNearestTarget = Targets[0];
            MinDistanceSQ = VSizeSq(PNearestTarget.Location - Location);
            I = 1;
            J0x3F0:

            // End:0x49C [Loop If]
            if(I < Targets.Length)
            {
                DistSq = VSizeSq(Targets[I].Location - Location);
                // End:0x48E
                if(DistSq < MinDistanceSQ)
                {
                    MinDistanceSQ = DistSq;
                    PNearestTarget = Targets[I];
                }
                I++;
                // [Loop Continue]
                goto J0x3F0;
            }
            TargetLocation = PNearestTarget.Location;
            // End:0x50A
            if(bIgnoreZComponentDirection)
            {
                TargetLocation.Z = Location.Z;
            }
            fScalingTargetVelocity = VSize((TargetLocation + PNearestTarget.Velocity) - Location) / 1200.0000000;
            Dir = Normal(((PNearestTarget.Velocity * fScalingTargetVelocity) + TargetLocation) - Location);
        }
    }
    Proj.Init(Dir);
    SpawnedProjectileCount++;
    // End:0x631
    if(SpawnParticle != none)
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(SpawnParticle, Location, Rotation);
    }
    // End:0x660
    if(SpawnSound != none)
    {
        PlaySound(SpawnSound,,,, Location);
    }
    // End:0x6A4
    if(ProjectileCount != SpawnedProjectileCount)
    {
        SetTimer(RandRange(SpawnDelayMin, SpawnDelayMax), false, 'Spawn_T');        
    }
    else
    {
        // End:0x6D2
        if(ProjectileCount == SpawnedProjectileCount)
        {
            TriggerEventClass(Class'EvilGame.SeqEvent_ProjectileSpawnCompleted', self);
        }
    }
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x17
    if(bDebug)
    {
        DrawDebug();
    }
    super.Tick(DeltaTime);
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x77
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x62
        if(IsTimerActive('Spawn_T'))
        {
            ClearTimer('Spawn_T');
        }
        SpawnedProjectileCount = 0;
        Spawn_T();
    }
    // End:0xD9
    if(Action.InputLinks[1].bHasImpulse)
    {
        // End:0xD9
        if(IsTimerActive('Spawn_T'))
        {
            ClearTimer('Spawn_T');
        }
    }
    //return;    
}

defaultproperties
{
    SpawnVelocityMin=500.0000000
    SpawnVelocityMax=500.0000000
    SpawnDelayMin=1.0000000
    SpawnDelayMax=1.0000000
    ProjectileCount=1
    DamageVSPlayerDistance=500.0000000
    ProjectileScale=1.0000000
    Components[0]=none
    Components[1]=none
    SupportedEvents=/* Array type was not detected. */
}