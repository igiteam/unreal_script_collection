class AdvWeap_ShogeHook_Base extends EvilWeap_Melee_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var() name BeamSocket;
var ParticleSystem BeamTemplate;
var export editinline ParticleSystemComponent BeamEmitter;
var Actor Victim;
var Actor LinkedTo;
var name VictimBoneName;
var name EndPointParamName;
var export editinline PrimitiveComponent LinkedComponent;
var name BeamPreFireAnim;
var name BeamFireAnim;
var name BeamPostFireAnim;
var Vector ShotDir;
var Vector EndPointEmitterLocation;
var float FlyingSpeed;
var export editinline EvilShogeLinkToComponent LinkToComponent;
var AdvProjectile_ShogeHook SpawnedProjectile;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    EvilPawn(Owner).MeleeWeapon = self;
    //return;    
}

simulated function DoMeleeDamage(float DamageScale, optional Actor Target = none, optional Vector HitLocaltion = vect(0.0000000, 0.0000000, 0.0000000))
{
    local Vector StartTrace, EndTrace, HitLocation, HitNormal;
    local bool TraceActors;

    // End:0x39
    if(int(CurrentFireMode) == int(1))
    {
        TraceActors = true;        
    }
    else
    {
        TraceActors = false;
    }
    SpawnedProjectile = AdvProjectile_ShogeHook(ProjectileFire());
    SpawnedProjectile.AddBeamEmitter(SkeletalMeshComponent(Mesh));
    SpawnedProjectile.ShogeWeapon = self;
    StartTrace = InstantFireStartTrace();
    EndTrace = InstantFireEndTrace(StartTrace);
    Trace(HitLocation, HitNormal, EndTrace, StartTrace, TraceActors,,, 1);
    //return;    
}

simulated function TimeWeaponFiring(byte FireModeNum)
{
    //return;    
}

simulated function HandleFinishedFiring()
{
    ScriptTrace();
    StopFire(CurrentFireMode);
    // End:0x3D
    if(!bSelectable)
    {
        GotoState('WeaponHookFlying');        
    }
    else
    {
        super.HandleFinishedFiring();
    }
    //return;    
}

simulated function HookHit()
{
    GotoState('WeaponHookPull');
    //return;    
}

simulated function Pull()
{
    SpawnedProjectile.InteractWithLinkedToActor();
    //return;    
}

simulated function float GetFireInterval(byte FireModeNum)
{
    return 0.0000000;
    //return ReturnValue;    
}

simulated state WeaponFiring
{
    ignores EndState;
    stop;    
}

simulated state WeaponEquipping
{
    ignores BeginFire, Activate;
    stop;    
}

simulated state WeaponPuttingDown
{
    ignores BeginFire, Activate;
    stop;    
}

simulated state WeaponHookFlying
{
    ignores EndState, BeginFire, Activate;

    simulated function BeginState(name PreviousStateName)
    {
        PlayWeaponAnim('WeaponHookLoop', 0.0000000, 0.2000000, 0.2000000, true, true);
        //return;        
    }
End:

    stop;                
}

simulated state WeaponHookPull
{
    ignores BeginFire, Activate;

    simulated function BeginState(name PreviousStateName)
    {
        local UTPlayerController PC;

        PC = UTPlayerController(EvilPawn(Owner).Controller);
        // End:0x147
        if((((PC != none) && PC.CameraAnimPlayer == none) || (PC.CameraAnimPlayer != none) && PC.CameraAnimPlayer.bFinished) || PC.CameraAnimPlayer.CamAnim != CameraAnim'an_CameraAnims.Anim.CA_ShogeHook_Draw')
        {
            PC.PlayCameraAnim(CameraAnim'an_CameraAnims.Anim.CA_ShogeHook_Draw',,, 0.1000000, 0.1000000, false);
        }
        PlayWeaponAnim('WeaponHookPull', 0.0000000, 0.2000000, 0.2000000, false, true);
        //return;        
    }

    simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        PutDownWeapon();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearFlashCountEvil(true);
        ClearFlashLocationArray(true);
        SetCurrentFireMode(0);
        EvilPawn(Instigator).EndMelee();
        //return;        
    }
    stop;    
}

defaultproperties
{
    BeamSocket="MuzzleFlashSocket"
    BeamTemplate=ParticleSystem'wp_shogehook_01.Effects.P_WP_Linkgun_Altbeam'
    EndPointParamName="LinkBeamEnd"
    BeamPreFireAnim="WeaponEquip"
    BeamFireAnim="WeaponFire"
    BeamPostFireAnim="WeaponPutDown"
    FlyingSpeed=50000.0000000
    LockerAmmoCount=14
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_ShogeHook_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__AdvWeap_ShogeHook_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_ShogeHook_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    AmmoCount=14
    WeaponProjectiles=/* Array type was not detected. */
    FireInterval=/* Array type was not detected. */
    InstantHitDamage=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.2000000
    PutDownTime=0.2000000
    WeaponRange=16384.0000000
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_ShogeHook_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_ShogeHook_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}