class MOHAFuelContainer extends MOHAShootableActor
    hidecategories(Navigation);

var() SoundCue SoundExplode;
var() SoundCue SoundLeaking;
var() SoundCue SoundBurning;
var() ParticleSystem ExplosionTemplate;
var() ParticleSystem BurningPuddleTemplate;
var() ParticleSystem LeakingTemplate;
var() ParticleSystem ImpactFireTemplate;
var() float ExplosionDamageRadius;
var() float ExplosionDamage;
var export editinline transient PointLightComponent ExplosionLight;
var() bool bUseExplosionLight;
var() Color LightColor;
var() float LightRadius;
var() float LightLifespan;
var() float LightBrightness;
var() float LightFalloffSpeed;
var() float LightFalloffExponent;
var() float LightCreationDelay;
var() float DamageThresholdAccumulative;
var() float DamageThresholdInstant;
var const int MaxSmallFires;
var const float BurnToExplodeTime;
var() float ExplosionImpulse;
var() StaticMesh DestroyedStaticMesh;
var() Vector ExplosionOffset;
var() array<Vector> PuddleOffsets;
var() float PuddleRadius;
var() int LeaksPerPuddle;
var StaticMesh PuddleMesh;
var transient Emitter ExplosionEmitter;
var export editinline transient AudioComponent explodeAudioComponent;
var export editinline transient AudioComponent LeakingAudioComponent;
var export editinline transient AudioComponent BurningAudioComponent;
var transient Emitter BurningEmitter;
var transient array<Emitter> Leaks;
var transient array<Emitter> SmallFires;
var transient array<MOHAFuelPuddle> Puddles;
var transient array<Vector> PuddleLocations;
var transient array<int> LeakCount;
var transient Vector ExplosionLocation;
var transient bool bCanLeak;

function OnSetFinalState(SeqAct_SetFinalState inAction)
{
    GotoState('Final');
    //return;    
}

function PuddleDamaged(MOHAFuelPuddle puddle)
{
    //return;    
}

function PropogateFlame(MOHAFuelPuddle puddle, Vector Loc)
{
    //return;    
}

function int FindClosestPuddleIndex(Vector leakLocation)
{
    local int I, closestDistance, closestPuddleIndex;
    local Vector Delta;
    local float Distance;

    // End:0x15
    if(PuddleRadius <= 0.0000000)
    {
        return -1;
    }
    closestDistance = 999999;
    closestPuddleIndex = -1;
    I = 0;
    J0x32:

    // End:0xAF [Loop If]
    if(I < PuddleLocations.Length)
    {
        Delta = PuddleLocations[I] - leakLocation;
        Distance = VSize2D(Delta);
        // End:0xA5
        if((Distance <= PuddleRadius) && Distance < float(closestDistance))
        {
            closestDistance = int(Distance);
            closestPuddleIndex = I;
        }
        ++I;
        // [Loop Continue]
        goto J0x32;
    }
    return closestPuddleIndex;
    //return ReturnValue;    
}

function IgniteNearbyFuelPuddles(MOHAFuelPuddle igniter, Vector Loc)
{
    local int I;
    local Vector Delta;
    local float Radius, Height;

    // End:0x0D
    if(igniter == none)
    {
        return;
    }
    igniter.GetBoundingCylinder(Radius, Height);
    I = 0;
    J0x31:

    // End:0xD7 [Loop If]
    if(I < Puddles.Length)
    {
        // End:0x6C
        if((Puddles[I] == none) || Puddles[I] == igniter)
        {
            // [Explicit Continue]
            goto J0xCD;
        }
        Delta = PuddleLocations[I] - Loc;
        // End:0xCD
        if(VSize2D(Delta) < (Radius * 2.0000000))
        {
            Puddles[I].Ignite(Puddles[I].Location);
        }
        J0xCD:

        ++I;
        // [Loop Continue]
        goto J0x31;
    }
    //return;    
}

function CreateExplosionEffects()
{
    // End:0x117
    if(ExplosionTemplate != none)
    {
        ExplosionEmitter = __NFUN_278__(Class'MOHAExplodeEmitter', self,, ExplosionLocation);
        // End:0x117
        if(ExplosionEmitter != none)
        {
            ExplosionEmitter.LifeSpan = 0.0000000;
            ExplosionEmitter.SetTemplate(ExplosionTemplate, true);
            // End:0x117
            if(bUseExplosionLight)
            {
                ExplosionLight = new Class'Engine.PointLightComponent';
                ExplosionLight.SetLightProperties(LightBrightness, LightColor);
                ExplosionLight.Radius = LightRadius;
                ExplosionLight.CastDynamicShadows = false;
                ExplosionLight.SetEnabled(false);
                ExplosionLight.FalloffExponent = LightFalloffExponent;
                MOHAExplodeEmitter(ExplosionEmitter).SetLight(ExplosionLight, LightLifespan, LightCreationDelay);
                MOHAExplodeEmitter(ExplosionEmitter).FalloffSpeed = LightFalloffSpeed;
            }
        }
    }
    // End:0x17A
    if(SoundExplode != none)
    {
        explodeAudioComponent = WorldInfo.CreateAudioComponent(SoundExplode, true, true, true, ExplosionLocation);
        explodeAudioComponent.bUseOwnerLocation = false;
        explodeAudioComponent.Location = ExplosionLocation;
        explodeAudioComponent.bAutoDestroy = true;
    }
    //return;    
}

function bool IsPlayerInstigator(Controller InstigatedBy)
{
    local MOHAPlayerPawn MOHAPlayerInstigator;

    // End:0x24
    if(InstigatedBy != none)
    {
        MOHAPlayerInstigator = MOHAPlayerPawn(InstigatedBy.Pawn);
    }
    return MOHAPlayerInstigator != none;
    //return ReturnValue;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local bool bLeakRequested, bPlayerInstigated;
    local TraceHitInfo tempHitInfo;

    // End:0x15
    if(float(Damage) <= 0.0000000)
    {
        return;
    }
    bLeakRequested = bCanLeak;
    bPlayerInstigated = IsPlayerInstigator(InstigatedBy);
    // End:0x1CB
    if(bPlayerInstigated || MOHAFuelContainer(DamageCauser) != none)
    {
        // End:0x1CB
        if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType') || bPlayerInstigated && VSize(InstigatedBy.Pawn.Location - Location) < float(10000))
        {
            // End:0x140
            if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType') && Puddles.Length == 1)
            {
                // End:0x140
                if((Puddles[0] != none) && VSize(Puddles[0].Location - Location) < 100.0000000)
                {
                    tempHitInfo = HitInfo;
                    tempHitInfo.HitComponent = none;
                    Puddles[0].TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, tempHitInfo, DamageCauser);
                }
            }
            // End:0x182
            if((DamageThresholdInstant > 0.0000000) && float(Damage) >= DamageThresholdInstant)
            {
                bLeakRequested = false;
                DamageThresholdInstant = 0.0000000;
                Killed();                
            }
            else
            {
                // End:0x1CB
                if(DamageThresholdAccumulative > 0.0000000)
                {
                    DamageThresholdAccumulative -= float(Damage);
                    // End:0x1CB
                    if(DamageThresholdAccumulative <= 0.0000000)
                    {
                        bLeakRequested = false;
                        DamageThresholdAccumulative = 0.0000000;
                        Killed();
                    }
                }
            }
        }
    }
    // End:0x1F7
    if(bLeakRequested)
    {
        CreateLeak(HitLocation, Momentum, HitInfo.HitComponent);
    }
    //return;    
}

function Killed()
{
    GotoState('Exploding');
    //return;    
}

function CreateLeak(Vector newLeakLocation, Vector Momentum, PrimitiveComponent HitComponent)
{
    local Emitter newLeak, newSmallFire;
    local int closestPuddleIndex;
    local Rotator newLeakRotation;
    local Vector TraceStart, TraceEnd, HitDirection, HitLocation, HitNormal;

    local Box Bounds;
    local bool bNeedToCalculateImpactRotation;

    bNeedToCalculateImpactRotation = true;
    // End:0x78
    if((LeakingAudioComponent == none) && SoundLeaking != none)
    {
        LeakingAudioComponent = WorldInfo.CreateAudioComponent(SoundLeaking, true, true, true, ExplosionLocation);
        LeakingAudioComponent.bUseOwnerLocation = false;
        LeakingAudioComponent.Location = ExplosionLocation;
        LeakingAudioComponent.bAutoDestroy = true;
    }
    // End:0x31F
    if((LeakingTemplate != none) || ImpactFireTemplate != none)
    {
        // End:0x133
        if(HitComponent == none)
        {
            GetComponentsBoundingBox(Bounds);
            TraceEnd = Bounds.Min + ((Bounds.Max - Bounds.Min) * 0.5000000);
            TraceStart = newLeakLocation;
            // End:0x133
            if(TraceComponent(HitLocation, HitNormal, StaticMeshComponent, TraceEnd, TraceStart))
            {
                newLeakLocation = HitLocation;
                newLeakRotation = Rotator(HitNormal);
                bNeedToCalculateImpactRotation = false;
            }
        }
        closestPuddleIndex = FindClosestPuddleIndex(newLeakLocation);
        // End:0x294
        if((closestPuddleIndex >= 0) && LeakingTemplate != none)
        {
            // End:0x17F
            if(closestPuddleIndex >= LeakCount.Length)
            {
                LeakCount.Length = closestPuddleIndex + 1;
            }
            // End:0x294
            if(LeakCount[closestPuddleIndex] < LeaksPerPuddle)
            {
                LeakCount[closestPuddleIndex]++;
                CreatePuddle(newLeakLocation, closestPuddleIndex);
                // End:0x22E
                if(bNeedToCalculateImpactRotation)
                {
                    HitDirection = Normal(Momentum);
                    TraceStart = newLeakLocation - (HitDirection * 32.0000000);
                    TraceEnd = newLeakLocation + (HitDirection * 32.0000000);
                    // End:0x22E
                    if(TraceComponent(HitLocation, HitNormal, HitComponent, TraceEnd, TraceStart))
                    {
                        newLeakRotation = Rotator(HitNormal);
                    }
                }
                newLeak = __NFUN_278__(Class'MOHAExplodeEmitter', self,, newLeakLocation, newLeakRotation);
                // End:0x282
                if(newLeak != none)
                {
                    newLeak.LifeSpan = 0.0000000;
                    newLeak.SetTemplate(LeakingTemplate, true);
                }
                Leaks[Leaks.Length] = newLeak;
            }
        }
        // End:0x31F
        if((SmallFires.Length < MaxSmallFires) && ImpactFireTemplate != none)
        {
            newSmallFire = __NFUN_278__(Class'MOHAExplodeEmitter', self,, newLeakLocation, rot(0, 0, 1));
            // End:0x30D
            if(newSmallFire != none)
            {
                newSmallFire.LifeSpan = 0.0000000;
                newSmallFire.SetTemplate(ImpactFireTemplate, true);
            }
            SmallFires[SmallFires.Length] = newSmallFire;
        }
    }
    //return;    
}

function CreatePuddle(Vector leakLocation, int puddleIndex)
{
    local MOHAFuelPuddle newPuddle;
    local Rotator NewRot;

    // End:0x1A
    if((puddleIndex < 0) || PuddleMesh == none)
    {
        return;
    }
    // End:0x39
    if(puddleIndex >= Puddles.Length)
    {
        Puddles.Length = puddleIndex + 1;
    }
    // End:0x13D
    if(Puddles[puddleIndex] == none)
    {
        newPuddle = __NFUN_278__(Class'MOHAFuelPuddle', self,, PuddleLocations[puddleIndex],,, true);
        // End:0x13D
        if(newPuddle != none)
        {
            newPuddle.StaticMeshComponent.SetStaticMesh(PuddleMesh);
            NewRot = newPuddle.Rotation;
            NewRot.Yaw = int(FRand() * float(65535));
            newPuddle.SetRotation(NewRot);
            newPuddle.SetDrawScale(PuddleRadius / 80.0000000);
            newPuddle.SetCollisionSize(PuddleRadius, newPuddle.default.CylinderComponent.CollisionHeight);
            newPuddle.Init(self);
            Puddles[puddleIndex] = newPuddle;            
        }
    }
    //return;    
}

auto state Active
{
    function BeginState(name PreviousStateName)
    {
        local int I;

        I = 0;
        J0x07:

        // End:0x47 [Loop If]
        if(I < PuddleOffsets.Length)
        {
            PuddleLocations[I] = Location + (PuddleOffsets[I] >> Rotation);
            ++I;
            // [Loop Continue]
            goto J0x07;
        }
        ExplosionLocation = Location + (ExplosionOffset >> Rotation);
        bCanLeak = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        bCanLeak = false;
        //return;        
    }

    function PuddleDamaged(MOHAFuelPuddle puddle)
    {
        GotoState('Burning');
        //return;        
    }
    stop;    
}

state Burning
{
    function BeginState(name PreviousStateName)
    {
        local editinline StimulusComponent GrenadeStimulus;

        SetTimer(BurnToExplodeTime, false, 'BurnTimer');
        // End:0x84
        if((BurningAudioComponent == none) && SoundBurning != none)
        {
            BurningAudioComponent = WorldInfo.CreateAudioComponent(SoundBurning, true, true, true, ExplosionLocation);
            BurningAudioComponent.bUseOwnerLocation = false;
            BurningAudioComponent.Location = ExplosionLocation;
            BurningAudioComponent.bAutoDestroy = true;
        }
        DisableShootMeShader();
        GrenadeStimulus = new (self) Class'EAKynapse.StimulusComponent';
        AttachComponent(GrenadeStimulus);
        GrenadeStimulus.AttachSender('Grenade', 'Grenade', vect(0.0000000, 0.0000000, 100.0000000), rot(0, 0, 0));
        //return;        
    }

    function PropogateFlame(MOHAFuelPuddle puddle, Vector Loc)
    {
        IgniteNearbyFuelPuddles(puddle, Loc);
        //return;        
    }

    event BurnTimer()
    {
        GotoState('Exploding');
        //return;        
    }
    stop;    
}

state Exploding
{
    function BeginState(name PreviousStateName)
    {
        SetTimer(RandRange(0.0100000, 0.2000000), false, 'ExplodeTimer');
        //return;        
    }

    event ExplodeTimer()
    {
        local int I;

        TriggerEventClass(Class'Engine.SeqEvent_Death', self);
        CreateExplosionEffects();
        // End:0x36
        if(LeakingAudioComponent != none)
        {
            LeakingAudioComponent.Stop();
        }
        // End:0x50
        if(BurningAudioComponent != none)
        {
            BurningAudioComponent.Stop();
        }
        I = 0;
        J0x57:

        // End:0x94 [Loop If]
        if(I < Leaks.Length)
        {
            // End:0x8A
            if(Leaks[I] != none)
            {
                Leaks[I].Destroy();
            }
            ++I;
            // [Loop Continue]
            goto J0x57;
        }
        Leaks.Length = 0;
        I = 0;
        J0xA3:

        // End:0xE0 [Loop If]
        if(I < SmallFires.Length)
        {
            // End:0xD6
            if(SmallFires[I] != none)
            {
                SmallFires[I].Destroy();
            }
            ++I;
            // [Loop Continue]
            goto J0xA3;
        }
        SmallFires.Length = 0;
        I = 0;
        J0xEF:

        // End:0x12C [Loop If]
        if(I < Puddles.Length)
        {
            // End:0x122
            if(Puddles[I] != none)
            {
                Puddles[I].Destroy();
            }
            ++I;
            // [Loop Continue]
            goto J0xEF;
        }
        Puddles.Length = 0;
        HurtRadius(ExplosionDamage, ExplosionDamageRadius, Class'MOHAExplosiveDamageType', ExplosionImpulse, ExplosionLocation);
        GotoState('Final');
        //return;        
    }
    stop;    
}

state Final
{
    function BeginState(name PreviousStateName)
    {
        // End:0x2C
        if(DestroyedStaticMesh != none)
        {
            ClearShootMeMaterials();
            StaticMeshComponent.SetStaticMesh(DestroyedStaticMesh);            
        }
        else
        {
            Destroy();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    ExplosionDamageRadius=1000.0000000
    ExplosionDamage=400.0000000
    MaxSmallFires=12
    BurnToExplodeTime=4.0000000
    ExplosionImpulse=100.0000000
    ExplosionOffset=(X=0.0000000,Y=0.0000000,Z=25.0000000)
    PuddleOffsets[0]=none
    PuddleRadius=100.0000000
    LeaksPerPuddle=4
    // Reference: StaticMeshComponent'Default__MOHAFuelContainer.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAFuelContainer.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAFuelContainer.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
    SupportedEvents=/* Array type was not detected. */
}