class SkyPawn_Watcher extends SkyNPC
    abstract
    native
    config(Pawn);

enum WatcherMode
{
    WMode_Spawning,                 // 0
    WMode_Active,                   // 1
    WMode_Stunned,                  // 2
    WMode_Despawning,               // 3
    WMode_Killed,                   // 4
    WMode_MAX                       // 5
};

enum WatcherAttackState
{
    WAS_None,                       // 0
    WAS_Swipe,                      // 1
    WAS_PounceLeapTowards,          // 2
    WAS_PounceStrike,               // 3
    WAS_PounceLeapAway,             // 4
    WAS_MAX                         // 5
};

enum WatcherCamoState
{
    WCS_NotHidden,                  // 0
    WCS_TurningHidden,              // 1
    WCS_TurningNotHidden,           // 2
    WCS_Hidden,                     // 3
    WCS_FlashNotHidden,             // 4
    WCS_MAX                         // 5
};

var protected transient SkyPawn_Watcher.WatcherMode CurrentMode;
var protected transient SkyPawn_Watcher.WatcherAttackState CurrentAttackState;
var protected transient SkyPawn_Watcher.WatcherCamoState CurrentCamoState;
var(Watcher) float HealthThresholdStunned;
var(Watcher) float ReachedEnemyTolerance;
var export editinline ParticleSystemComponent StunnedEffects;
var(Watcher) ParticleSystem StunnedEffectTemplate;
var(Watcher) ParticleSystem SwipeHitEffectTemplate;
var(Watcher) ParticleSystem PounceHitEffectTemplate;
var(Watcher) MaterialInterface Material_Camo;
var(Watcher) MaterialInterface Material_NonCamo;
var(Watcher) float Swipe_OverrideDamage;
var(Watcher) editinline ForceFeedbackWaveform Swipe_FFeedback;
var(Watcher) editinline ViewShakeInfo Swipe_ViewShake;
var(Watcher) float Pounce_OverrideDamage;
var(Watcher) editinline ForceFeedbackWaveform Pounce_FFeedback;
var(Watcher) editinline ViewShakeInfo Pounce_ViewShake;
var(Watcher) float Pounce_JumpAwayDist;
var(Watcher) float HorizontalJumpSpeed;
var(Camouflage) float CamoPhaseOutDuration;
var(Camouflage) float CamoPhaseInDuration;
var(Camouflage) float CamoFlashCycleDuration;
var transient float CurrentCamoTimer;
var transient float CurrentCamoBlendValue;
var protected MaterialInstanceConstant CamoMatInst;
var(Camouflage) protected name CamoFadeParamName;
var transient bool bPounceHitTarget;
var transient bool bShouldTriggerPounceLandingSound;
var transient bool bPounceAttackCausedDamage;
var(WatcherSounds) export editinline AudioComponent PounceLaunchSound;
var(WatcherSounds) export editinline AudioComponent PounceHitTargetSound;
var(WatcherSounds) export editinline AudioComponent PounceLandingSound;
var(WatcherAnim) array<name> PounceSockets;
var transient Actor PrePounce_Base;
var export editinline transient LightEnvironmentComponent PrePounce_LightEnvironment;
var export editinline transient PrimitiveComponent PrePounce_ShadowParent;
var transient Pawn DuringPounce_AttachedTo;
var transient name DuringPounce_AttachedSocket;

// Export USkyPawn_Watcher::execGetCurrentMode(FFrame&, void* const)
native final function SkyPawn_Watcher.WatcherMode GetCurrentMode();

protected final function SetCurrentMode(SkyPawn_Watcher.WatcherMode NewMode)
{
    // End:0x98
    if(int(NewMode) != int(CurrentMode))
    {
        // End:0x6D
        if(int(NewMode) == int(2))
        {
            // End:0x44
            if(int(GetCoverState()) != int(0))
            {
                SetCoverState(0);
            }
            StunnedEffects.SetTemplate(StunnedEffectTemplate);
            StunnedEffects.ActivateSystem();            
        }
        else
        {
            // End:0x8D
            if(int(CurrentMode) == int(2))
            {
                StunnedEffects.DeactivateSystem();
            }
        }
        CurrentMode = NewMode;
    }
    //return;    
}

// Export USkyPawn_Watcher::execIsSwiping(FFrame&, void* const)
native final function bool IsSwiping();

// Export USkyPawn_Watcher::execIsPouncing(FFrame&, void* const)
native final function bool IsPouncing();

// Export USkyPawn_Watcher::execIsPounceStriking(FFrame&, void* const)
native final function bool IsPounceStriking();

function name GetBestSocket(Pawn AttachToPawn)
{
    local int Idx;
    local Vector SocketLoc;
    local Rotator SocketRot;
    local float Dist, bestDist;
    local name BestSocket;

    BestSocket = 'None';
    bestDist = Square(999999.0000000);
    Idx = 0;
    J0x23:

    // End:0xAF [Loop If]
    if(Idx < PounceSockets.Length)
    {
        AttachToPawn.Mesh.GetSocketWorldLocationAndRotation(PounceSockets[Idx], SocketLoc, SocketRot);
        Dist = VSizeSq(SocketLoc - Location);
        // End:0xA5
        if(Dist < bestDist)
        {
            bestDist = Dist;
            BestSocket = PounceSockets[Idx];
        }
        ++Idx;
        // [Loop Continue]
        goto J0x23;
    }
    return BestSocket;
    //return ReturnValue;    
}

function SetPawnAttachment(Pawn AttachToPawn)
{
    local name NewSocket;

    PrePounce_Base = Base;
    SetPhysics(0);
    SetCollision(false, false);
    bCollideWorld = false;
    NewSocket = GetBestSocket(AttachToPawn);
    // End:0x102
    if(AttachToPawnAndSocket(AttachToPawn, NewSocket))
    {
        SetPhysics(0);
        // End:0xD9
        if(Mesh != none)
        {
            PrePounce_ShadowParent = Mesh.ShadowParent;
            PrePounce_LightEnvironment = Mesh.LightEnvironment;
            PrePounce_LightEnvironment.SetEnabled(false);
            Mesh.SetShadowParent(AttachToPawn.Mesh);
            Mesh.SetLightEnvironment(SkyPawn(AttachToPawn).LightEnvironment);
        }
        DuringPounce_AttachedTo = AttachToPawn;
        DuringPounce_AttachedSocket = NewSocket;
        SetTimer(3.0000000, false, 'FailsafeDetach');
    }
    //return;    
}

function FailsafeDetach()
{
    // End:0x15
    if(DuringPounce_AttachedTo != none)
    {
        ClearPawnAttachment();
    }
    //return;    
}

event ClearPawnAttachment()
{
    local Vector NewLoc;
    local Rotator NewRot;

    // End:0xB0
    if(DuringPounce_AttachedTo != none)
    {
        SetBase(PrePounce_Base);
        SetHardAttach(false);
        DuringPounce_AttachedTo.Mesh.GetSocketWorldLocationAndRotation(DuringPounce_AttachedSocket, NewLoc, NewRot);
        SetLocation(NewLoc);
        SetRotation(NewRot);
        bCollideWorld = true;
        // End:0xA4
        if(Mesh != none)
        {
            Mesh.SetShadowParent(PrePounce_ShadowParent);
            PrePounce_LightEnvironment.SetEnabled(true);
            Mesh.SetLightEnvironment(PrePounce_LightEnvironment);
        }
        SetPhysics(2);
        DuringPounce_AttachedTo = none;
    }
    //return;    
}

final function StartSwipeAttack()
{
    CurrentAttackState = 1;
    SetTimer(2.0000000, false, 'SwipeFailsafe');
    //return;    
}

final event StartPounceAttack()
{
    SetFallState(1);
    PounceLaunchSound.Play();
    SetTimer(0.2500000, false, 'PounceTakeoffCheck');
    CurrentAttackState = 2;
    bPounceAttackCausedDamage = false;
    //return;    
}

final function PounceTakeoffCheck()
{
    // End:0x18
    if(int(Physics) == int(1))
    {
        CurrentAttackState = 0;
    }
    //return;    
}

simulated event BotLaunchJump()
{
    local Vector JumpTarget;
    local float DistFromTarget, OldGroundSpeed;

    // End:0xE4
    if(int(CurrentAttackState) == int(2))
    {
        JumpTarget = Controller.Enemy.Location;
        // End:0x9A
        if(VSizeSq(Controller.Enemy.Velocity) > 0.1000000)
        {
            DistFromTarget = VSize(JumpTarget - Location);
            JumpTarget += ((Controller.Enemy.Velocity * DistFromTarget) / HorizontalJumpSpeed);
        }
        bShouldTriggerPounceLandingSound = true;
        OldGroundSpeed = GroundSpeed;
        GroundSpeed = HorizontalJumpSpeed;
        SuggestJumpVelocity(Velocity, JumpTarget, Location);
        GroundSpeed = OldGroundSpeed;
        SetPhysics(2);        
    }
    else
    {
        // End:0x190
        if(int(CurrentAttackState) == int(4))
        {
            JumpTarget = Normal(Location - DuringPounce_AttachedTo.Location);
            JumpTarget *= Pounce_JumpAwayDist;
            JumpTarget += Location;
            JumpTarget.Z = DuringPounce_AttachedTo.Location.Z;
            SuggestJumpVelocity(Velocity, JumpTarget, Location);
            ClearPawnAttachment();
            SetPhysics(2);
            SetTimer(0.2500000, false, 'RestoreCollisionPostPounce');
        }
    }
    super(SkyPawn).BotLaunchJump();
    //return;    
}

simulated function SwipeFailsafe()
{
    OnSwipeAnimCompleted();
    //return;    
}

event OnSwipeAnimCompleted()
{
    // End:0x22
    if(int(CurrentAttackState) == int(1))
    {
        DoSwipeAttackDamage();
        CurrentAttackState = 0;
    }
    //return;    
}

simulated function PounceFailsafe()
{
    OnPounceStrikeAnimCompleted();
    //return;    
}

event OnPounceStrikeAnimCompleted()
{
    // End:0x2C
    if(int(CurrentAttackState) == int(3))
    {
        bPounceAttackCausedDamage = true;
        CurrentAttackState = 4;
        SetFallState(1);
    }
    //return;    
}

function RestoreCollisionPostPounce()
{
    SetCollision(true, true, true);
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    // End:0x12
    if(int(FallState) == int(1))
    {
        return;
    }
    // End:0x5D
    if((int(CurrentAttackState) >= int(2)) && int(CurrentAttackState) <= int(4))
    {
        // End:0x55
        if(bShouldTriggerPounceLandingSound)
        {
            PounceLandingSound.Play();
            bShouldTriggerPounceLandingSound = false;
        }
        CurrentAttackState = 0;
    }
    super(SkyPawn).Landed(HitNormal, FloorActor);
    //return;    
}

function CrushedBy(Pawn OtherPawn)
{
    //return;    
}

event EncroachedBy(Actor Other)
{
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    // End:0xB2
    if(((Health > 0) && Controller != none) && int(CurrentAttackState) == int(2))
    {
        // End:0x99
        if(Other == Controller.Enemy)
        {
            CurrentAttackState = 3;
            DoPounceAttackDamage();
            PounceHitTargetSound.Play();
            SetPawnAttachment(SkyBot(Controller).CurrentEnemy);
            SetTimer(4.0000000, false, 'PounceFailsafe');            
        }
        else
        {
            CurrentAttackState = 0;
            SetFallState(3);
            SetPhysics(2);
        }
    }
    super(Actor).Bump(Other, OtherComp, HitNormal);
    //return;    
}

// Export USkyPawn_Watcher::execStartFadingCamouflageOn(FFrame&, void* const)
native final function StartFadingCamouflageOn();

// Export USkyPawn_Watcher::execStartFadingCamouflageOff(FFrame&, void* const)
native final function StartFadingCamouflageOff();

// Export USkyPawn_Watcher::execFlashCamouflageOff(FFrame&, void* const)
native final function FlashCamouflageOff();

// Export USkyPawn_Watcher::execIsCamouflaged(FFrame&, void* const)
native final function bool IsCamouflaged();

protected function bool ShouldDealMeleeDamageToEnemy()
{
    local Vector VectToEnemy;

    VectToEnemy = Controller.Enemy.Location - Location;
    // End:0x74
    if(VSize(VectToEnemy) > ((CylinderComponent.CollisionRadius + SkyBot(Controller).CurrentEnemy.CylinderComponent.CollisionRadius) * 2.5000000))
    {
        return false;
    }
    // End:0x90
    if((Normal(VectToEnemy) Dot Vector(Rotation)) < 0.0000000)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

protected function PlayHitEffects(ParticleSystem Template, Pawn EffectTarget, ForceFeedbackWaveform FFeedback, ViewShakeInfo ViewShake)
{
    local SkyEmitter HitEffect;
    local SkyPlayerController SPC;

    HitEffect = Spawn(Class'SkyEmitter', EffectTarget,, EffectTarget.Location, EffectTarget.Rotation);
    HitEffect.SetBase(EffectTarget);
    HitEffect.SetTemplate(Template, true);
    SPC = SkyPlayerController(EffectTarget.Controller);
    // End:0xBE
    if(SPC != none)
    {
        SPC.StartRumble(FFeedback);
        SPC.ShakeCamera(ViewShake);
    }
    //return;    
}

protected function DoPounceAttackDamage()
{
    local SkyWeap_WatcherMelee Wpn;

    bPounceHitTarget = false;
    // End:0xA2
    if(true)
    {
        Wpn = SkyWeap_WatcherMelee(Weapon);
        // End:0xA2
        if(Wpn != none)
        {
            bPounceHitTarget = true;
            Wpn.DoPounceDamage(Controller.Enemy, SkyBot(Controller).CurrentEnemy.Location, 1.0000000);
            PlayHitEffects(PounceHitEffectTemplate, SkyBot(Controller).CurrentEnemy, Pounce_FFeedback, Pounce_ViewShake);
        }
    }
    //return;    
}

protected function DoSwipeAttackDamage()
{
    local SkyWeap_WatcherMelee Wpn;

    // End:0x9B
    if(ShouldDealMeleeDamageToEnemy())
    {
        Wpn = SkyWeap_WatcherMelee(Weapon);
        // End:0x9B
        if(Wpn != none)
        {
            Wpn.DoSwipeDamage(Controller.Enemy, SkyBot(Controller).CurrentEnemy.Location, 1.0000000);
            PlayHitEffects(SwipeHitEffectTemplate, SkyBot(Controller).CurrentEnemy, Swipe_FFeedback, Swipe_ViewShake);
        }
    }
    //return;    
}

simulated event PostBeginPlay()
{
    local SkyWeap_WatcherMelee MeleeWpn;

    super.PostBeginPlay();
    SetCurrentMode(1);
    MeleeWpn = SkyWeap_WatcherMelee(Weapon);
    // End:0x71
    if(MeleeWpn != none)
    {
        // End:0x4D
        if(Swipe_OverrideDamage > 0.0000000)
        {
            MeleeWpn.SwipeDamage = Swipe_OverrideDamage;
        }
        // End:0x71
        if(Pounce_OverrideDamage > 0.0000000)
        {
            MeleeWpn.PounceDamage = Pounce_OverrideDamage;
        }
    }
    //return;    
}

function bool DoWallLeap(Actor Target)
{
    local Vector JumpVel;

    // End:0x71
    if((!bIsCrouched && !bWantsToCrouch) && (int(Physics) == int(1)) || int(Physics) == int(8))
    {
        SuggestJumpVelocity(JumpVel, Target.Location, Location);
        Velocity = JumpVel;
        SetPhysics(2);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp, optional int Item)
{
    super(Pawn).HitWall(HitNormal, Wall, WallComp);
    // End:0x47
    if(HitNormal.Z <= -WalkableFloorZ)
    {
        SetPhysics(8);
        SetBase(Wall, HitNormal);
    }
    //return;    
}

function bool SpecialMoveTo(NavigationPoint Start, NavigationPoint End, Actor Next)
{
    local ReachSpec CurrentPath;

    // End:0x11
    if(Start == End)
    {
        return false;
    }
    CurrentPath = Start.GetReachSpecTo(End);
    // End:0x97
    if(CurrentPath != none)
    {
        // End:0x69
        if(CurrentPath.IsA('WallTransReachSpec'))
        {
            return SpecialMoveTo_WallTrans(Start, End, true);            
        }
        else
        {
            // End:0x97
            if(CurrentPath.IsA('FloorToCeilingReachSpec'))
            {
                return SpecialMoveTo_CeilingTrans(Start, End, true);
            }
        }
    }
    return super(Pawn).SpecialMoveTo(Start, End, Next);
    //return ReturnValue;    
}

function bool SpecialMoveTo_WallTrans(NavigationPoint Start, NavigationPoint End, bool bDirect)
{
    DoWallLeap(End);
    Controller.bPreparingMove = true;
    return true;
    //return ReturnValue;    
}

function bool SpecialMoveTo_CeilingTrans(NavigationPoint Start, NavigationPoint End, bool bDirect)
{
    return true;
    //return ReturnValue;    
}

function NotifyStunFinished()
{
    SetCurrentMode(3);
    bIsInvulnerable = false;
    //return;    
}

event KilledByEhbenBlade(Pawn MyKiller)
{
    // End:0x20
    if(int(CurrentMode) == int(2))
    {
        SetCurrentMode(4);
        bIsInvulnerable = false;
    }
    //return;    
}
