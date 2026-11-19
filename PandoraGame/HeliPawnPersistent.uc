class HeliPawnPersistent extends SPVehiclePawnPersistent
    abstract
    config(Game);

struct native HeliDamageSoundInfo
{
    var float Percent;
    var SoundCue PlayerSoundCue;
    var SoundCue NonPlayerSoundCue;
    var export editinline AudioComponent AudioComponent;

    structdefaultproperties
    {
        Percent=0.0000000
        PlayerSoundCue=none
        NonPlayerSoundCue=none
        AudioComponent=none
    }
};

struct native HeliSoundsInfo
{
    var int numSounds;
    var int currIndex;
    var HeliDamageSoundInfo damageSoundInfo[5];

    structdefaultproperties
    {
        numSounds=0
        currIndex=0
        damageSoundInfo[0]=(Percent=0.0000000,PlayerSoundCue=none,NonPlayerSoundCue=none,AudioComponent=none)
        damageSoundInfo[1]=(Percent=0.0000000,PlayerSoundCue=none,NonPlayerSoundCue=none,AudioComponent=none)
        damageSoundInfo[2]=(Percent=0.0000000,PlayerSoundCue=none,NonPlayerSoundCue=none,AudioComponent=none)
        damageSoundInfo[3]=(Percent=0.0000000,PlayerSoundCue=none,NonPlayerSoundCue=none,AudioComponent=none)
        damageSoundInfo[4]=(Percent=0.0000000,PlayerSoundCue=none,NonPlayerSoundCue=none,AudioComponent=none)
    }
};

var float HitYawOffset;
var PlayerPawn MountedPlayer;
/** use a struct? */
var(DoorState) bool OpenLeftDoor;
var(DoorState) bool OpenLeftWindow;
var(DoorState) bool OpenLeftWindow_2;
var(DoorState) bool OpenRightDoor;
var(DoorState) bool OpenRightWindow;
var(DoorState) bool OpenRightWindow_2;
var() bool LightEnabled;
var bool LightRampDir;
var export editinline PointLightComponent HeliLight;
var() float LightRampUp;
var() float LightRampDown;
var() float LightHold;
var() float LightRadius;
var() Color LightColor;
var float LightHoldTimer;
var transient HeliSoundsInfo heliSounds;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    TrueRotation = Rotation;
    // End:0x3A
    if(Mesh != none)
    {
        Mesh.AttachComponentToSocket(HeliLight, 'Light');
    }
    Health = HealthMax;
    InitHeliSounds();
    //return;    
}

simulated function Tick(float Time)
{
    super.Tick(Time);
    ServerTick_HeliPawn(Time);
    //return;    
}

final function ServerTick_HeliPawn(float Time)
{
    local float dps, Brightness;

    SetDoorState('ldoor', OpenLeftDoor);
    SetDoorState('rdoor', OpenRightDoor);
    SetDoorState('lwin1', OpenLeftWindow);
    SetDoorState('lwin2', OpenLeftWindow_2);
    SetDoorState('rwin1', OpenRightWindow);
    SetDoorState('rwin2', OpenRightWindow_2);
    // End:0xD9
    if(ImpactCurStrength > 0.0100000)
    {
        dps = ImpactStrength / impactTime;
        ImpactCurStrength -= (dps * Time);
        ImpactCurTime += Time;        
    }
    else
    {
        ImpactCurStrength = 0.0000000;
    }
    HeliLight.SetEnabled(LightEnabled);
    HeliLight.Radius = LightRadius;
    HeliLight.SetLightProperties(HeliLight.Brightness, LightColor, HeliLight.Function);
    // End:0x15E
    if(LightHoldTimer > float(0))
    {
        LightHoldTimer -= Time;        
    }
    else
    {
        LightHoldTimer = 0.0000000;
        // End:0x213
        if(LightRampDir)
        {
            Brightness = HeliLight.Brightness;
            // End:0x1B0
            if(LightRampUp > 0.0000000)
            {
                Brightness += ((1.0000000 / LightRampUp) * Time);
            }
            // End:0x1DD
            if(Brightness >= 1.0000000)
            {
                LightRampDir = false;
                Brightness = 1.0000000;
                LightHoldTimer = LightHold;
            }
            HeliLight.SetLightProperties(Brightness, HeliLight.LightColor, HeliLight.Function);            
        }
        else
        {
            Brightness = HeliLight.Brightness;
            // End:0x251
            if(LightRampDown > 0.0000000)
            {
                Brightness -= ((1.0000000 / LightRampDown) * Time);
            }
            // End:0x273
            if(Brightness <= 0.0000000)
            {
                LightRampDir = true;
                Brightness = 0.0000000;
            }
            HeliLight.SetLightProperties(Brightness, HeliLight.LightColor, HeliLight.Function);
        }
    }
    UpdateSound();
    //return;    
}

function SetDoorState(name BoneName, bool State)
{
    local SkelControlSingleBone bone;

    return;
    // End:0x97
    if(Mesh != none)
    {
        bone = SkelControlSingleBone(Mesh.FindSkelControl(BoneName));
        // End:0x97
        if(bone != none)
        {
            // End:0x71
            if(State)
            {
                bone.ControlStrength = (0.9400000 * bone.ControlStrength) + 0.0600000;                
            }
            else
            {
                bone.ControlStrength = 0.9400000 * bone.ControlStrength;
            }
        }
    }
    //return;    
}

function OnSetHeliDoorState(SeqAct_SetHeliDoorState Action)
{
    OpenLeftDoor = Action.OpenLeftDoor;
    OpenRightDoor = Action.OpenRightDoor;
    OpenLeftWindow = Action.OpenLeftWindow;
    OpenLeftWindow_2 = Action.OpenLeftWindow_2;
    OpenRightWindow = Action.OpenRightWindow;
    OpenRightWindow_2 = Action.OpenRightWindow_2;
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector Dir, Hit;

    // End:0xA1
    if((m_bUseAIForAnimation == true) && SPHeliController(Controller).m_bAIDisabled == false)
    {
        Hit = Normal(HitLocation - (PrePivot + Location));
        Hit = Hit << Rotation;
        Dir = Normal(Momentum);
        ImpactVector = Normal(Hit Cross Dir);
        ImpactStrength = DamageAmount * float(40);
        ImpactCurStrength = ImpactStrength;
        impactTime = 2.0000000;
    }
    super(SPPawn).ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

simulated function Destroyed()
{
    local MiniGunPersistent G;

    // End:0x48
    foreach AllActors(Class'MiniGunPersistent', G)
    {
        // End:0x47
        if(G.Base != none)
        {
            // End:0x47
            if(G.Base == self)
            {
                G.Destroy();
            }
        }        
    }    
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    GotoState('Dying');
    bReplicateMovement = false;
    bTearOff = true;
    Velocity += TearOffMomentum;
    SetPhysics(2);
    bPlayedDeath = true;
    // End:0x56
    if(MountedPlayer != none)
    {
        MountedPlayer.DetachFromDeadHelicopter();
    }
    //return;    
}

private final function UpdateSound()
{
    local float percentHealth;
    local int Count;

    percentHealth = float(Health / HealthMax);
    Count = 0;
    J0x1B:

    // End:0x6D [Loop If]
    if(Count < heliSounds.numSounds)
    {
        // End:0x63
        if(percentHealth <= heliSounds.damageSoundInfo[Count].Percent)
        {
            // [Explicit Break]
            goto J0x6D;
        }
        Count++;
        // [Loop Continue]
        goto J0x1B;
    }
    J0x6D:

    // End:0x234
    if(Count != heliSounds.currIndex)
    {
        // End:0xD8
        if(heliSounds.currIndex != -1)
        {
            heliSounds.damageSoundInfo[heliSounds.currIndex].AudioComponent.Stop();
        }
        heliSounds.currIndex = Count;
        // End:0x160
        if(MountedPlayer != none)
        {
            heliSounds.damageSoundInfo[heliSounds.currIndex].AudioComponent = CreateAudioComponent(heliSounds.damageSoundInfo[heliSounds.currIndex].PlayerSoundCue, false, false);            
        }
        else
        {
            heliSounds.damageSoundInfo[heliSounds.currIndex].AudioComponent = CreateAudioComponent(heliSounds.damageSoundInfo[heliSounds.currIndex].NonPlayerSoundCue, false, false);
        }
        heliSounds.damageSoundInfo[heliSounds.currIndex].AudioComponent.bAutoDestroy = true;
        heliSounds.damageSoundInfo[heliSounds.currIndex].AudioComponent.Play();
    }
    //return;    
}

function InitHeliSounds()
{
    //return;    
}
