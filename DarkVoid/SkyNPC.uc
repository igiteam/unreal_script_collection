class SkyNPC extends SkyPawnCoverUser
    native
    config(Pawn);

var bool bLastWeaponMeleeHitSuccessful;
var bool bFadeMatInstOut;
var() bool bDoGroundAlignment;
var float LightFadeTime;
var float LightFadeValue;
var MaterialInstanceConstant MatInst;
var int MatInstIndex;
var export editinline AudioComponent FallingScreamComp;
var() float FallingScreamPossibleTime;
var export editinline AudioComponent BotTauntComp;
var(Headshot) float HeadShotDeathDelayMin;
var(Headshot) float HeadShotDeathDelayMax;
var(Weapon) float MuzzleSocketAlignDegrees;
var export editinline AudioComponent AISoundEventComp;
var() float GroundAlignBodyOffset;
var() float GroundAlignSpeed;
var transient float GroundAlignCurrentPitch;
var transient float GroundAlignCurrentRoll;
var transient float GroundAlignCurrentHeight;

simulated function PostBeginPlay()
{
    local SkyPawnSoundGroup SPSGroup;

    super.PostBeginPlay();
    MatInst = new (Outer) Class'Engine.MaterialInstanceConstant';
    MatInst.SetParent(Mesh.GetMaterial(MatInstIndex));
    Mesh.SetMaterial(MatInstIndex, MatInst);
    MatInst.SetScalarParameterValue('DeathFade', LightFadeValue);
    SPSGroup = SkyPawnSoundGroup(SoundGroup);
    // End:0xCE
    if((SPSGroup != none) && FallingScreamComp != none)
    {
        FallingScreamComp.SoundCue = SPSGroup.DeathScreamSound;
    }
    //return;    
}

event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    bFadeMatInstOut = true;
    // End:0x2B
    if(AISoundEventComp.bWasPlaying)
    {
        AISoundEventComp.Stop();
    }
    return super(SkyPawn).Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

// Export USkyNPC::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyNPC::execSpecialBoneDamageEffectLogic(FFrame&, void* const)
native function bool SpecialBoneDamageEffectLogic(Pawn.EBoneType BoneType);

simulated function StartMelee()
{
    Weapon.EndFire(0);
    Weapon.EndFire(1);
    StopSecondaryItemFire(0);
    //return;    
}

simulated function StopMelee()
{
    Mesh.RootMotionMode = 2;
    Weapon.EndFire(0);
    Weapon.EndFire(1);
    StopSecondaryItemFire(0);
    //return;    
}

simulated function OnAILedges(SkySeqAct_AILedges inAction)
{
    // End:0x30
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).OnAILedges(inAction);
        return;
    }
    //return;    
}

simulated event bool IsShooting()
{
    // End:0xBF
    if(Controller != none)
    {
        // End:0x51
        if(PlayerController(Controller) != none)
        {
            // End:0x51
            if(!Weapon.HasAnyAmmo() || !Weapon.IsFiring())
            {
                return false;
            }
        }
        // End:0x60
        if(IsAimingSecondary())
        {
            return true;
        }
        // End:0x87
        if((Weapon == none) || Weapon.IsA('SkyWeap_MeleePunch'))
        {
            return false;
        }
        // End:0xBD
        if(!Weapon.HasAnyAmmo() || !Weapon.IsFiring())
        {
            return false;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool BotFireSecondary(bool bFinished)
{
    local SkyWeapon Weap;
    local SkyBotControllerBase Bot;

    Weap = SkyWeapon(SecondaryWeapon);
    // End:0x59
    if((Weap == none) || !Weap.ReadyToFire(bFinished) && !Weap.IsFiring())
    {
        return false;
    }
    Bot = SkyBotControllerBase(Controller);
    // End:0xAC
    if((Bot != none) && int(Bot.ScriptedFireMode) != int(255))
    {
        StartSecondaryItemFire(Bot.ScriptedFireMode);        
    }
    else
    {
        StartSecondaryItemFire(ChooseFireMode());
    }
    return true;
    //return ReturnValue;    
}

function bool IsFiring()
{
    local bool retval;

    // End:0x34
    if(Weapon != none)
    {
        retval = Weapon.IsFiring();
        // End:0x34
        if(retval == true)
        {
            return true;
        }
    }
    // End:0x5A
    if(SecondaryWeapon != none)
    {
        retval = SecondaryWeapon.IsFiring();
    }
    return retval;
    //return ReturnValue;    
}

function bool BotFire(bool bFinished)
{
    local SkyWeapon Weap;
    local bool bReadyToFire, bIsFiring;
    local Vector Loc;
    local Rotator Rot;
    local editinline SkeletalMeshComponent SkelMesh;
    local Vector vecOne, vec2;
    local float myDot;
    local Vector XAxis, YAxis, ZAxis;
    local int myFireMode;
    local SkyBot Bot;

    Weap = SkyWeapon(Weapon);
    // End:0x57
    if(Weap != none)
    {
        bReadyToFire = Weap.ReadyToFire(bFinished);
        bIsFiring = Weap.IsFiring();
    }
    // End:0x7E
    if((Weap == none) || !bReadyToFire && !bIsFiring)
    {
        return false;
    }
    // End:0x1C3
    if(CurrWeaponAttachment != none)
    {
        SkelMesh = SkeletalMeshComponent(CurrWeaponAttachment.Mesh);
        Bot = SkyBot(Controller);
        // End:0x1C3
        if(((SkelMesh != none) && Bot != none) && Bot.IsInState('Frozen') == false)
        {
            SkelMesh.GetSocketWorldLocationAndRotation(CurrWeaponAttachment.MuzzleFlashSocket, Loc, Rot);
            GetAxes(Rot, XAxis, YAxis, ZAxis);
            vecOne = ZAxis;
            // End:0x17E
            if(Bot.GetFireTarget() != none)
            {
                vec2 = Normal(Bot.GetFireTarget().Location - Location);                
            }
            else
            {
                vec2 = Vector(Controller.DesiredRotation);
            }
            myDot = vecOne Dot vec2;
            // End:0x1C3
            if(Abs(myDot) < Cos(MuzzleSocketAlignDegrees * 0.0174533))
            {
                return false;
            }
        }
    }
    myFireMode = int(ChooseFireMode());
    StartFire(byte(myFireMode));
    return true;
    //return ReturnValue;    
}

// Export USkyNPC::execCanPrimaryWeaponFire(FFrame&, void* const)
native function bool CanPrimaryWeaponFire(optional bool bIgnoreReload, optional bool bCheckingForTargeting);

event PlaySoundEvent(name Event, optional bool StopPlayingCurrent)
{
    local SoundCue EventCue;

    // End:0x23
    if(!StopPlayingCurrent && AISoundEventComp.bWasPlaying)
    {
        return;
    }
    // End:0x87
    if(SkyPawnSoundGroup(SoundGroup) != none)
    {
        EventCue = SkyPawnSoundGroup(SoundGroup).GetSoundEvent(Event);
        // End:0x87
        if(EventCue != none)
        {
            AISoundEventComp.SoundCue = EventCue;
            AISoundEventComp.Play();
        }
    }
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    local NavigationPoint RestorePoint;

    // End:0x19
    if(Anchor != none)
    {
        RestorePoint = Anchor;        
    }
    else
    {
        RestorePoint = LastAnchor;
    }
    // End:0xBA
    if((Health > 0) && RestorePoint != none)
    {
        SetLocationNoCheck(RestorePoint.Location);
        SetRotation(RestorePoint.Rotation);
        SetPhysics(1);
        // End:0xB7
        if(Controller != none)
        {
            Controller.SetRotation(RestorePoint.Rotation);
            Controller.ClientSetRotation(RestorePoint.Rotation);
        }        
    }
    else
    {
        super(SkyPawn).FellOutOfWorld(dmgType);
    }
    //return;    
}

simulated state Dying
{
    simulated function CheckFallingScream()
    {
        local SkyPawnSoundGroup SPSGroup;
        local float VelDir;

        SPSGroup = SkyPawnSoundGroup(SoundGroup);
        // End:0xAA
        if((SPSGroup != none) && VSizeSq(Velocity) > (SPSGroup.VelocityToPlayFallingScream * SPSGroup.VelocityToPlayFallingScream))
        {
            VelDir = Normal(Velocity) Dot vect(0.0000000, 0.0000000, -1.0000000);
            // End:0xA0
            if((VelDir > 0.8000000) && FRand() <= SPSGroup.ChanceToPlayFallingScream)
            {
                FallingScreamComp.Play();
            }
            ClearFallingScreamTimer();
        }
        //return;        
    }

    simulated function ClearFallingScreamTimer()
    {
        ClearTimer('CheckFallingScream');
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(0.2000000, true, 'CheckFallingScream');
        SetTimer(FallingScreamPossibleTime, false, 'ClearFallingScreamTimer');
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}
