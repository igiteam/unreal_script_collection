class SkyVehicle_Luminaire_Bike extends SkyVehicle
    native
    config(Game);

struct native BrakeSoundInfo
{
    var name MaterialType;
    var SoundCue BrakeSound;
    var SoundCue HandBrakeSound;

    structdefaultproperties
    {
        MaterialType="None"
        BrakeSound=none
        HandBrakeSound=none
    }
};

struct SoundInfo
{
    var name MaterialType;
    var SoundCue Sound;

    structdefaultproperties
    {
        MaterialType="None"
        Sound=none
    }
};

var int TreadMaterialIndex;
var name TreadMaterialParameter;
var MaterialInstanceConstant TreadMatInst;
var name BrakeLightParameterName;
var float BrakeLightOnValue;
var bool bBrakeLightOn;
var bool bHeadlightsOn;
var bool bOnGround;
var name HeadLightParameterName;
var float HeadlightOnValue;
var MaterialInterface ExplosionDecal;
var float ExpDecalWidth;
var float ExpDecalHeight;
var() float ThrowAngle;
var() float ThrowMagnitude;
var() Vector AdditionalThrowVel;
var float ReturnToUpBias;
var float SteeringBias;
var() Vector COMForwardOffset;
var() Vector COMBackOffset;
var float LastCOMOffset;
var() float AirControlTorque;
var() float TurningTorque;
var(Sounds) array<SoundInfo> ImpactSounds;
var(Sounds) SoundCue DefaultImpactSound;
var(Sounds) export editinline array<export editinline AudioComponent> EngineSoundsPerGear;
var(Sounds) export editinline AudioComponent AirEngineSound;
var(Sounds) array<BrakeSoundInfo> BrakeSounds;
var(Sounds) const editconst SoundCue DefaultBrakeSound;
var(Sounds) const editconst SoundCue DefaultHandBrakeSound;
var(Sounds) const editconst export editinline AudioComponent BrakeAudioComponent;
var(Sounds) const editconst export editinline AudioComponent HandBrakeAudioComponent;
var float BrakeSoundContinuity;
var float HandBrakeSoundContinuity;
var(Sounds) float MinBrakeSoundSpeed;
var ParticleSystem LightImpactEffect;
var ParticleSystem HeavyImpactEffect;
var(Effects) float LightImpactThreshold;
var(Effects) float HeavyImpactThreshold;
var export editinline ParticleSystemComponent ImpactEffectPSC;
var float TimeLeftGround;
var float LandSoundTime;
var(Sounds) SoundCue DefaultLandSound;
var(Sounds) SoundCue LightLandSound;

event SelectEngineSoundByGear(int oldGear, int newGear)
{
    // End:0xAE
    if(Seats[0].StoragePawn != none)
    {
        // End:0x36
        if(EngineSoundsPerGear.Length == 0)
        {
            super.SelectEngineSoundByGear(oldGear, newGear);
            return;
        }
        oldGear = Clamp(oldGear - 1, 0, EngineSoundsPerGear.Length - 1);
        newGear = Clamp(newGear - 1, 0, EngineSoundsPerGear.Length - 1);
        EngineSoundsPerGear[oldGear].Stop();
        EngineSoundsPerGear[newGear].bShouldRemainActiveIfDropped = true;
        EngineSoundsPerGear[newGear].Play();
    }
    //return;    
}

simulated function StartEngineSound()
{
    super(SVehicle).StartEngineSound();
    //return;    
}

simulated function StopEngineSound()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x37 [Loop If]
    if(I < EngineSoundsPerGear.Length)
    {
        EngineSoundsPerGear[I].Stop();
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    super(SVehicle).StopEngineSound();
    //return;    
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
    Throttle = InForward;
    Steering = InStrafe;
    // End:0x70
    if((PlayerController(Controller) != none) && PlayerController(Controller).PlayerInput != none)
    {
        Rise = InUp / PlayerController(Controller).PlayerInput.MoveStrafeSpeed;        
    }
    else
    {
        Rise = InUp;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0xE6
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bDeleteMe)
    {
        TreadMatInst = new (Outer) Class'Engine.MaterialInstanceConstant';
        TreadMatInst.SetParent(Mesh.GetMaterial(TreadMaterialIndex));
        Mesh.SetMaterial(TreadMaterialIndex, TreadMatInst);
        TreadMatInst.SetScalarParameterValue(TreadMaterialParameter, 0.0000000);
        VehicleMaterialInst.SetScalarParameterValue(BrakeLightParameterName, 0.0000000);
        VehicleMaterialInst.SetScalarParameterValue(HeadLightParameterName, 0.0000000);
    }
    //return;    
}

event WheelsLeaveGround()
{
    // End:0x47
    if(Seats[0].StoragePawn != none)
    {
        TimeLeftGround = WorldInfo.TimeSeconds;
        StopEngineSound();
        AirEngineSound.Play();
    }
    //return;    
}

event WheelsHitGround()
{
    // End:0x72
    if(Seats[0].StoragePawn != none)
    {
        // End:0x48
        if((WorldInfo.TimeSeconds - TimeLeftGround) > LandSoundTime)
        {
            PlaySound(DefaultLandSound);
        }
        PlaySound(LightLandSound);
        AirEngineSound.Stop();
        StartEngineSound();
    }
    //return;    
}

simulated function SoundCue GetCollideSound(name MaterialType)
{
    local int I;

    I = ImpactSounds.Find('MaterialType', MaterialType);
    // End:0x34
    if(I == -1)
    {
        return DefaultImpactSound;        
    }
    else
    {
        return ImpactSounds[I].Sound;
    }
    //return ReturnValue;    
}

simulated function UpdateBrakeSounds(name GroundMaterialType)
{
    local int I;

    I = BrakeSounds.Find('MaterialType', GroundMaterialType);
    // End:0x58
    if(I == -1)
    {
        BrakeAudioComponent.SoundCue = DefaultBrakeSound;
        HandBrakeAudioComponent.SoundCue = DefaultHandBrakeSound;        
    }
    else
    {
        BrakeAudioComponent.SoundCue = BrakeSounds[I].BrakeSound;
        HandBrakeAudioComponent.SoundCue = BrakeSounds[I].HandBrakeSound;
    }
    //return;    
}

event NewGroundMaterial(name MaterialType)
{
    UpdateBrakeSounds(MaterialType);
    //return;    
}

simulated event Vector2D ModifyAnimStickInput(Vector2D StickInput, name NameParam)
{
    // End:0x37
    if(SkyVehicleSim_Motorcycle(SimObj) != none)
    {
        return SkyVehicleSim_Motorcycle(SimObj).ModifyAnimStickInput(StickInput, NameParam);        
    }
    else
    {
        return StickInput;
    }
    //return ReturnValue;    
}

simulated function bool CanEnterVehicle(Pawn P)
{
    // End:0x37
    if(SkyPawn(P) != none)
    {
        // End:0x37
        if(SkyPawn(P).bCanUseBikes == true)
        {
            return super.CanEnterVehicle(P);
        }
    }
    return false;
    //return ReturnValue;    
}

function bool NeedToTurn(Vector targ)
{
    local Vector LookDir, AimDir;
    local float myDot;

    LookDir = Vector(Rotation);
    LookDir = Normal(LookDir);
    AimDir = targ - Location;
    AimDir = Normal(AimDir);
    myDot = LookDir Dot AimDir;
    return myDot < 0.9900000;
    //return ReturnValue;    
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
    //return;    
}

simulated function DisplaySupplementalDebug(HUD HUD, out float out_XPos, out float out_YL, out float out_YPos)
{
    super.DisplaySupplementalDebug(HUD, out_XPos, out_YL, out_YPos);
    //return;    
}

simulated state DyingVehicle
{
    simulated function BeginState(name PreviousStateName)
    {
        local Vector StartTrace, EndTrace, HitLocation, HitNormal;
        local Actor HitActor;

        super.BeginState(PreviousStateName);
        StartTrace = Location;
        EndTrace = Location;
        EndTrace.Z -= float(200);
        HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
        // End:0xDE
        if((HitActor != none) && ExplosionDecal != none)
        {
            HitActor.WorldInfo.MyDecalManager.SpawnDecal(ExplosionDecal, HitLocation, Rotator(-HitNormal), ExpDecalWidth, ExpDecalHeight, 10.0000000, false, 0.0000000, none, false, false, 'None', -1, -1);
        }
        //return;        
    }
    stop;    
}
