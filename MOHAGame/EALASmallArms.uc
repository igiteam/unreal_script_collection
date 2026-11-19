class EALASmallArms extends EALAWeapon
    abstract
    native
    config(Weapon)
    hidecategories(Navigation);

var(Tuning_Accuracy) export editinline WeaponAccuracyComponent AccuracyComponent;
var(Tuning_Accuracy) export editinline WeaponAccuracyComponent IronsightsAccuracyComponent;
var(Tuning_Accuracy) config AccuracyTuning AccuracyParams;
var(Tuning_Accuracy) config AccuracyTuning IronsightsAccuracyParams;
var(Tuning_Animations) name AlternateFireModeInAnim;
var(Tuning_Animations) name AlternateFireModeOutAnim;
var(Tuning_Animations) name ScopeModeInAnim;
var(Tuning_Animations) name ScopeModeOutAnim;
var(Tuning_Animations) float AlternateFireModeInTime;
var(Tuning_Animations) float AlternateFireModeOutTime;
var(Tuning_Animations) config float ScopeModeInTime;
var(Tuning_Animations) config float ScopeModeOutTime;
var(Tuning_Animations) config name WeaponRechamberAnim;
var(Tuning_Animations) config name IronsightRechamberAnim;
var(DepthOfField) float fDOFRestoreForce;
var(Tuning_Reload) config array<config float> ReloadInterval;
var(Tuning_Reload) config array<config float> ReloadClipFullInterval;
var(Tuning_Reload) config array<config float> RechamberInterval;
var(Tuning_Reload) config array<config float> RechamberDoneInterval;
var(Tuning_Reload) bool CanRechamberInIronsight;
var() bool bScopeEnabled;
var bool bTrueTriggerEnabled;
var bool bPendingReload;
var bool bNeedToRechamber;
var(Tuning_Viewkick) export editinline WeaponKickComponent KickComponent;
var(Tuning_Viewkick) export editinline WeaponKickComponent IronsightsKickComponent;
var(Tuning_Viewkick) config ViewKickTuning KickParams;
var(Tuning_Viewkick) config ViewKickTuning IronsightsKickParams;
var() config float RefireCheckTime;
var() config float IronsightRefireCheckTime;
var() export editinline WeaponScopeComponent ScopeComponent;
var() config float minBurstTime;
var export editinline WeaponTrueTriggerComponent TrueTriggerComponent;
var export editinline AudioComponent BreathingAudioComponent;
var export editinline WhizSenderComponent WhizComponent;
var float fCurrentFocusDist;
var transient int iRechamberFireMode;
var transient bool bViewKickActive;
var transient bool bPendingScopeChange;
var transient bool bPendingAltFireChange;
var transient bool bClipFilled;

// Export UEALASmallArms::execProcessViewRotationNative(FFrame&, void* const)
native simulated function ProcessViewRotationNative(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot);

// Export UEALASmallArms::execGetViewKick(FFrame&, void* const)
native simulated function WeaponKickComponent GetViewKick();

// Export UEALASmallArms::execGetAccuracy(FFrame&, void* const)
native simulated function WeaponAccuracyComponent GetAccuracy();

// Export UEALASmallArms::execInAlternateFireMode(FFrame&, void* const)
native simulated function bool InAlternateFireMode();

simulated function ToggleAlternateFireMode()
{
    //return;    
}

simulated function EnableAlternateFireToggle()
{
    bEnableAlternateFireToggle = true;
    //return;    
}

simulated function DisableAlternateFireToggle()
{
    bEnableAlternateFireToggle = false;
    //return;    
}

simulated function UpdateKick()
{
    KickComponent.UpdateParams();
    IronsightsKickComponent.UpdateParams();
    //return;    
}

simulated function UpdateAccuracy()
{
    AccuracyComponent.UpdateAccuracy();
    IronsightsAccuracyComponent.UpdateAccuracy();
    //return;    
}

simulated function UpdateWeapon()
{
    UpdateWeaponVars();
    UpdateKick();
    UpdateAccuracy();
    //return;    
}

simulated function ResetKick()
{
    UpdateKick();
    //return;    
}

simulated function float GetIronsightsTargetWorldFOV()
{
    // End:0x23
    if(bAlternateFireMode && AltFireIronsightsTargetWorldFOV != 0.0000000)
    {
        return AltFireIronsightsTargetWorldFOV;        
    }
    else
    {
        // End:0x47
        if(IsScopeEnabled())
        {
            return ScopeComponent.GetFOV();            
        }
        else
        {
            return IronsightsTargetWorldFOV;
        }
    }
    //return ReturnValue;    
}

simulated function float AdjustFOVAngle(float FOVAngle)
{
    // End:0x3F
    if(((ScopeComponent != none) && bScopeEnabled) && int(IronsightsState) == int(3))
    {
        return ScopeComponent.GetFOV();        
    }
    else
    {
        return super.AdjustFOVAngle(FOVAngle);
    }
    //return ReturnValue;    
}

simulated function PutDownWeapon()
{
    super.PutDownWeapon();
    // End:0x26
    if(IsScopeEnabled())
    {
        ScopeComponent.EndSniperZoom();
    }
    //return;    
}

simulated function PlayerPawnDied()
{
    super.PlayerPawnDied();
    WorldInfo.ToggleDOF(false);
    // End:0x3A
    if(IsScopeEnabled())
    {
        ScopeComponent.EndSniperZoom();
    }
    bAlternateFireMode = false;
    ClearTimer('RefireCheckTimer');
    //return;    
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact)
{
    local MOHAMultiplayerController mmc;
    local MOHAMultiplayerPawn HitMPPawn;
    local ClaimHitInfo HitInfo;
    local bool bAddHitStat;

    // End:0x2D9
    if(Impact.HitActor != none)
    {
        // End:0x45
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            ApplyDamage(FiringMode, Impact);            
        }
        else
        {
            // End:0x132
            if(int(WorldInfo.NetMode) == int(NM_Client))
            {
                // End:0x12F
                if(MOHAMultiplayerPawn(Impact.HitActor) != none)
                {
                    mmc = MOHAMultiplayerController(Instigator.Controller);
                    // End:0xFA
                    if(Impact.HitActor.IsA('MOHAMultiplayerPawn') && !Impact.HitActor.IsInState('Dying'))
                    {
                        MOHAHUD(mmc.myHUD).OnNotifyWeaponHit();
                    }
                    mmc.ImpactToClaim(Impact, HitInfo);
                    mmc.ServerClaimInstantHit(HitInfo);
                }                
            }
            else
            {
                // End:0x257
                if(Instigator.IsLocallyControlled())
                {
                    mmc = MOHAMultiplayerController(Instigator.Controller);
                    HitMPPawn = MOHAMultiplayerPawn(Impact.HitActor);
                    bAddHitStat = ((HitMPPawn != none) && MOHAPlayerReplicationInfo(mmc.PlayerReplicationInfo).Team.TeamIndex != HitMPPawn.GetTeamIndex()) && !HitMPPawn.IsInState('Dying');
                    ApplyDamage(FiringMode, Impact);
                    // End:0x254
                    if(bAddHitStat)
                    {
                        MOHAHUD(mmc.myHUD).OnNotifyWeaponHit();
                        mmc.m_MPPlayerStats.StatAddHitLocation(HitMPPawn.m_oHealthInfo.LastHitLocation);
                    }                    
                }
            }
        }
        // End:0x2D9
        if(((ShouldFireWeaponAttachment()) && !Impact.HitActor.IsA('Trigger')) && !Impact.HitActor.IsA('TriggerVolume'))
        {
            GetWeaponAttachment().PlayImpactEffectsWithImpactInfo(Impact,, InstantHitDamageTypes[int(FiringMode)]);
        }
    }
    //return;    
}

// Export UEALASmallArms::execApplyDamage(FFrame&, void* const)
native function ApplyDamage(byte FiringMode, ImpactInfo Impact);

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    local Vector myPos;
    local name FireAnimName;

    FireAnimName = GetFireAnimName(FireModeNum);
    // End:0x49
    if(FireAnimName != 'None')
    {
        PlayWeaponAnimation(FireAnimName, GetFireInterval(FireModeNum));
    }
    SmallArmsAttachment(GetWeaponAttachment()).UpdateTracerData(HitLocation, Instigator.FiringMode);
    // End:0xC7
    if(WhizComponent.bEnabled)
    {
        myPos = Instigator.GetWeaponStartTraceLocation();
        WhizComponent.SendWhizEvent(myPos, HitLocation, 1 | 2);
    }
    //return;    
}

simulated function TimeWeaponFiring(byte FireModeNum)
{
    // End:0x41
    if(int(IronsightsState) == int(3))
    {
        // End:0x33
        if(float(0) != IronsightRefireCheckTime)
        {
            SetTimer(IronsightRefireCheckTime, true, 'RefireCheckTimer');
            return;
        }
        super(Weapon).TimeWeaponFiring(FireModeNum);        
    }
    else
    {
        // End:0x64
        if(float(0) != RefireCheckTime)
        {
            SetTimer(RefireCheckTime, true, 'RefireCheckTimer');
            return;
        }
        super(Weapon).TimeWeaponFiring(FireModeNum);
    }
    //return;    
}

simulated function float GetEffectiveFireRate(bool bIronsights)
{
    // End:0x28
    if(bIronsights)
    {
        return ((IronsightRefireCheckTime != 0.0000000) ? IronsightRefireCheckTime : IronsightsFireTime);        
    }
    else
    {
        return ((RefireCheckTime != 0.0000000) ? RefireCheckTime : FireInterval[0]);
    }
    //return ReturnValue;    
}

simulated function FireAmmunition()
{
    // End:0xCC
    if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
    {
        MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        // End:0x67
        if(int(IronsightsState) == int(3))
        {
            MOHAPlayerPawn(Instigator).Weapon_IronsightsFireEvent();            
        }
        else
        {
            MOHAPlayerPawn(Instigator).Weapon_FireEvent();
        }
        MOHAPlayerController(Instigator.Controller).playerStats.OnWeaponFire(WeaponType, WeaponClass);
        GetViewKick().OnShotFiredKick();
    }
    // End:0xEC
    if(IsTrueTriggerEnabled())
    {
        TrueTriggerComponent.OnShotFired();
    }
    super.FireAmmunition();
    //return;    
}

simulated event ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    ProcessViewRotationNative(DeltaTime, out_ViewRotation, out_DeltaRot);
    //return;    
}

simulated function ProcessViewPush(out Vector out_CamLoc, Rotator out_CamRot, float DeltaTime)
{
    GetViewKick().ApplyPush(out_CamLoc, out_CamRot, DeltaTime);
    //return;    
}

simulated function Rotator AddSpread(Rotator BaseAim)
{
    return GetAccuracy().AddSpread(BaseAim);
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos, out int foundBase)
{
    super(Weapon).DisplayDebug(HUD, out_YL, out_YPos, foundBase);
    // End:0x27
    if(foundBase == 0)
    {
        return;
    }
    AccuracyComponent.DisplayDebug(HUD, out_YL, out_YPos, foundBase);
    //return;    
}

simulated function float GetFireInterval(byte FireModeNum)
{
    // End:0x19
    if(int(IronsightsState) == int(3))
    {
        return IronsightsFireTime;        
    }
    else
    {
        return super(Weapon).GetFireInterval(FireModeNum);
    }
    //return ReturnValue;    
}

simulated function float GetReloadInterval()
{
    local byte ReloadModeNum;

    ReloadModeNum = byte(GetReloadMode());
    // End:0x4C
    if((int(ReloadModeNum) < ReloadInterval.Length) && ReloadInterval[int(ReloadModeNum)] > float(0))
    {
        return ReloadInterval[int(ReloadModeNum)];        
    }
    else
    {
        return 0.0100000;
    }
    //return ReturnValue;    
}

simulated function float GetReloadClipFullInterval()
{
    local byte ReloadModeNum;

    ReloadModeNum = byte(GetReloadMode());
    // End:0x4C
    if((int(ReloadModeNum) < ReloadClipFullInterval.Length) && ReloadClipFullInterval[int(ReloadModeNum)] > float(0))
    {
        return ReloadClipFullInterval[int(ReloadModeNum)];        
    }
    else
    {
        return 0.0100000;
    }
    //return ReturnValue;    
}

simulated function int GetReloadMode()
{
    return ((bAlternateFireMode) ? 1 : 0);
    //return ReturnValue;    
}

simulated function TimeWeaponReload()
{
    // End:0x2E
    if(!IsTimerActive('EndReloadTimer'))
    {
        SetTimer(GetReloadInterval(), true, 'EndReloadTimer');
    }
    //return;    
}

simulated function TimeWeaponReloadClipFull()
{
    // End:0x2E
    if(!IsTimerActive('ReloadClipFullTimer'))
    {
        SetTimer(GetReloadClipFullInterval(), true, 'ReloadClipFullTimer');
    }
    //return;    
}

simulated function PlayWeaponReload()
{
    local WeaponAttachment WeapAttachment;
    local name ReloadAnimName;

    ReloadAnimName = GetWeaponReloadAnim();
    // End:0x3E
    if(ReloadAnimName != 'None')
    {
        PlayWeaponAnimation(ReloadAnimName, GetReloadInterval());
    }
    WeapAttachment = GetWeaponAttachment();
    // End:0x6C
    if(WeapAttachment != none)
    {
        WeapAttachment.WeaponBeingReloaded();
    }
    //return;    
}

simulated function name GetWeaponReloadAnim()
{
    return WeaponReloadAnim[GetReloadMode()];
    //return ReturnValue;    
}

simulated function name GetScopeInAnim()
{
    return ScopeModeInAnim;
    //return ReturnValue;    
}

simulated function name GetScopeOutAnim()
{
    return ScopeModeOutAnim;
    //return ReturnValue;    
}

simulated function TimeWeaponRechamber(byte FireModeNum)
{
    // End:0x33
    if(!IsTimerActive('EndRechamberTimer'))
    {
        SetTimer(GetRechamberInterval(FireModeNum), true, 'EndRechamberTimer');
    }
    //return;    
}

simulated function TimeWeaponRechamberDone(byte FireModeNum)
{
    // End:0x33
    if(!IsTimerActive('RechamberDoneTimer'))
    {
        SetTimer(GetRechamberDoneInterval(FireModeNum), true, 'RechamberDoneTimer');
    }
    //return;    
}

simulated function PlayWeaponRechamber(byte FireModeNum)
{
    // End:0x53
    if(((int(IronsightsState) == int(3)) && CanRechamberInIronsight) && IronsightRechamberAnim != 'None')
    {
        PlayWeaponAnimation(IronsightRechamberAnim, GetRechamberInterval(FireModeNum));        
    }
    else
    {
        // End:0x86
        if(WeaponRechamberAnim != 'None')
        {
            PlayWeaponAnimation(WeaponRechamberAnim, GetRechamberInterval(FireModeNum));
        }
    }
    //return;    
}

simulated function float GetRechamberInterval(byte FireModeNum)
{
    local MOHAAIPawn NpcInstigator;

    // End:0x44
    if(Instigator.IsA('MOHAAIPawn'))
    {
        NpcInstigator = MOHAAIPawn(Instigator);
        return MOHAScriptAIController(NpcInstigator.Controller).fSingleShotRechamberInterval;
    }
    return ((RechamberInterval[int(FireModeNum)] > float(0)) ? RechamberInterval[int(FireModeNum)] : 0.0100000);
    //return ReturnValue;    
}

simulated function float GetRechamberDoneInterval(byte FireModeNum)
{
    return ((RechamberDoneInterval[int(FireModeNum)] > float(0)) ? RechamberDoneInterval[int(FireModeNum)] : 0.0100000);
    //return ReturnValue;    
}

simulated function EndRechamberTimer()
{
    //return;    
}

simulated function TimeIronsightsIn()
{
    // End:0x29
    if(!IsTimerActive('EndIronsightsInTimer'))
    {
        SetTimer(IronsightsInTime, true, 'EndIronsightsInTimer');
    }
    //return;    
}

simulated function TimeIronsightsOut()
{
    // End:0x29
    if(!IsTimerActive('EndIronsightsOutTimer'))
    {
        SetTimer(IronsightsOutTime, true, 'EndIronsightsOutTimer');
    }
    //return;    
}

simulated function TimeState(float state_time)
{
    // End:0x18
    if(state_time == float(0))
    {
        state_time = 0.0100000;
    }
    // End:0x41
    if(!IsTimerActive('StateTimer'))
    {
        SetTimer(state_time, true, 'StateTimer');
    }
    //return;    
}

simulated function PendingScopeChange()
{
    bPendingScopeChange = true;
    //return;    
}

simulated function StateTick(float DeltaTime)
{
    //return;    
}

simulated function SmallArmsBeginFire(byte FireModeNum)
{
    // End:0x114
    if(!bDeleteMe && Instigator != none)
    {
        // End:0x3D
        if(int(FireModeNum) == 1)
        {
            // End:0x3B
            if(bEnableAlternateFireToggle == true)
            {
                ToggleAlternateFireMode();
            }
            return;
        }
        // End:0x6B
        if(int(FireModeNum) == 2)
        {
            // End:0x59
            if(bMeleeWeapon == false)
            {
                return;
            }
            // End:0x6B
            if(int(IronsightsState) != int(0))
            {
                return;
            }
        }
        // End:0x8E
        if((int(FireModeNum) == 0) && bAlternateFireMode == true)
        {
            FireModeNum = 1;
        }
        global.BeginFire(FireModeNum);
        // End:0x114
        if(PendingFire(int(FireModeNum)))
        {
            // End:0xEC
            if((HasAmmo(FireModeNum)) || !FiringRequiresAmmo(FireModeNum))
            {
                SendToFiringState(FireModeNum);                
            }
            else
            {
                // End:0x10A
                if(HasReserveAmmo())
                {
                    GotoState('WeaponReload');                    
                }
                else
                {
                    WeaponEmpty();
                }
            }
        }
    }
    //return;    
}

simulated function BurstOver()
{
    GetWeaponAttachment().StopFiring(true);
    //return;    
}

simulated function ForceBeamOff()
{
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0xFC
    if((Instigator != none) && Instigator.IsHumanControlled())
    {
        AccuracyComponent.Tick(DeltaTime);
        IronsightsAccuracyComponent.Tick(DeltaTime);
        KickComponent.Tick(DeltaTime);
        IronsightsKickComponent.Tick(DeltaTime);
        // End:0xAF
        if(IsTrueTriggerEnabled())
        {
            TrueTriggerComponent.Tick(DeltaTime);
        }
        // End:0xD7
        if(IsScopeEnabled())
        {
            ScopeComponent.Tick(DeltaTime);            
        }
        else
        {
            // End:0xFC
            if(WorldInfo.IsDOFEnabled())
            {
                UpdateIronsightDOF(DeltaTime);
            }
        }
    }
    StateTick(DeltaTime);
    //return;    
}

simulated function UpdateIronsightDOF(float DeltaTime)
{
    local Vector vStart, vEnd, vHit, vHitNormal;
    local float fDesiredFocusDist;
    local Actor HitActor;

    // End:0x0F
    if(IsUpgradeSequenceActive())
    {
        return;
    }
    vStart = Instigator.GetWeaponStartTraceLocation();
    vEnd = vStart + (Vector(GetAdjustedAim(vStart)) * (GetTraceRange()));
    HitActor = Trace(vHit, vHitNormal, vEnd, vStart, true);
    fDesiredFocusDist = VSize(vHit - vStart);
    // End:0xD4
    if(HitActor != none)
    {
        fCurrentFocusDist = Class'MOHAUtilities'.static.LagValue(fCurrentFocusDist, fDesiredFocusDist, fDOFRestoreForce, DeltaTime);
        WorldInfo.GameModified_DOF_FocusDistance = fCurrentFocusDist;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    AccuracyComponent.mWeapon = self;
    AccuracyComponent.UpdateAccuracy();
    IronsightsAccuracyComponent.mWeapon = self;
    IronsightsAccuracyComponent.UpdateAccuracy();
    KickComponent.mWeapon = self;
    KickComponent.UpdateParams();
    IronsightsKickComponent.mWeapon = self;
    IronsightsKickComponent.UpdateParams();
    // End:0xAB
    if(ScopeComponent != none)
    {
        ScopeComponent.Init(self);
    }
    // End:0xCA
    if(TrueTriggerComponent != none)
    {
        TrueTriggerComponent.Init(self);
    }
    ClearPendingFire(0);
    ClearPendingFire(1);
    super.PostBeginPlay();
    //return;    
}

simulated function UpdateWeaponVars()
{
    super.UpdateWeaponVars();
    AccuracyComponent.AccuracyParams = AccuracyParams;
    IronsightsAccuracyComponent.AccuracyParams = IronsightsAccuracyParams;
    KickComponent.KickParams = KickParams;
    IronsightsKickComponent.KickParams = IronsightsKickParams;
    // End:0xC8
    if(KickParams.ConstantPitchReturn && KickParams.PitchDistance != float(0))
    {
        KickComponent.KickParams.PitchDistance = KickParams.PitchDistance + (KickParams.PitchRecenterRate * (GetEffectiveFireRate(false)));
    }
    // End:0x13A
    if(KickParams.ConstantPushReturn && KickParams.PushDistance != float(0))
    {
        KickComponent.KickParams.PushDistance = KickParams.PushDistance + (KickParams.PushRecenterRate * (GetEffectiveFireRate(false)));
    }
    // End:0x1AC
    if(IronsightsKickParams.ConstantPitchReturn && IronsightsKickParams.PitchDistance != float(0))
    {
        IronsightsKickComponent.KickParams.PitchDistance = IronsightsKickParams.PitchDistance + (IronsightsKickParams.PitchRecenterRate * (GetEffectiveFireRate(true)));
    }
    // End:0x21E
    if(IronsightsKickParams.ConstantPushReturn && IronsightsKickParams.PushDistance != float(0))
    {
        IronsightsKickComponent.KickParams.PushDistance = IronsightsKickParams.PushDistance + (IronsightsKickParams.PushRecenterRate * (GetEffectiveFireRate(true)));
    }
    //return;    
}

exec function PCZoomIn()
{
    // End:0x1E
    if(ScopeComponent != none)
    {
        ScopeComponent.PCZoomIn();
    }
    //return;    
}

exec function PCZoomOut()
{
    // End:0x1E
    if(ScopeComponent != none)
    {
        ScopeComponent.PCZoomOut();
    }
    //return;    
}

simulated function PCZoomDone()
{
    // End:0x1E
    if(ScopeComponent != none)
    {
        ScopeComponent.PCZoomDone();
    }
    //return;    
}

simulated exec function ZoomInDown()
{
    // End:0x1E
    if(ScopeComponent != none)
    {
        ScopeComponent.ZoomInDown();
    }
    //return;    
}

simulated exec function ZoomInRelease()
{
    // End:0x1E
    if(ScopeComponent != none)
    {
        ScopeComponent.ZoomInRelease();
    }
    //return;    
}

simulated exec function ZoomOutDown()
{
    // End:0x1E
    if(ScopeComponent != none)
    {
        ScopeComponent.ZoomOutDown();
    }
    //return;    
}

simulated exec function ZoomOutRelease()
{
    // End:0x1E
    if(ScopeComponent != none)
    {
        ScopeComponent.ZoomOutRelease();
    }
    //return;    
}

simulated exec function DiscreteZoomPress()
{
    // End:0x1E
    if(ScopeComponent != none)
    {
        ScopeComponent.DiscreteZoomPress();
    }
    //return;    
}

simulated exec function PCTrueTriggerDown()
{
    // End:0x1E
    if(TrueTriggerComponent != none)
    {
        TrueTriggerComponent.PCTrueTriggerDown();
    }
    //return;    
}

simulated exec function PCTrueTriggerRelease()
{
    // End:0x1E
    if(TrueTriggerComponent != none)
    {
        TrueTriggerComponent.PCTrueTriggerRelease();
    }
    //return;    
}

simulated function EALAWeapon.EIronsightsState GetIronsightsState()
{
    return IronsightsState;
    //return ReturnValue;    
}

simulated function RenderWeaponAndArms(bool bRender)
{
    WeaponSkeletalMesh.SetOwnerNoSee(!bRender);
    // End:0x4C
    if(MOHAPlayerPawn(Instigator) != none)
    {
        MOHAPlayerPawn(Instigator).FPArms.SetOwnerNoSee(!bRender);
    }
    //return;    
}

simulated function ActiveRenderOverlays(HUD H)
{
    // End:0x23
    if(ScopeComponent != none)
    {
        ScopeComponent.ActiveRenderOverlays(H);
    }
    //return;    
}

simulated event bool IsScopeEnabled()
{
    return bScopeEnabled && ScopeComponent != none;
    //return ReturnValue;    
}

simulated function bool IsTrueTriggerEnabled()
{
    return ((bTrueTriggerEnabled && !bAlternateFireMode) && TrueTriggerComponent != none) && int(IronsightsState) != int(0);
    //return ReturnValue;    
}

simulated function bool IsScopeActive()
{
    return (bScopeEnabled && ScopeComponent != none) && ScopeComponent.bEnabled;
    //return ReturnValue;    
}

simulated event bool ShowTrueTriggerMeter()
{
    return (IsTrueTriggerEnabled()) && IsScopeActive();
    //return ReturnValue;    
}

simulated function ScopeEnabled(bool bEnable)
{
    bScopeEnabled = bEnable;
    //return;    
}

event GetCurrentTriggerScalarAndTime(out float fTriggerScalar, out float fTimeInTrueTrigger)
{
    // End:0x38
    if(IsTrueTriggerEnabled())
    {
        fTriggerScalar = TrueTriggerComponent.fCurrentTrueTriggerScalar;
        fTimeInTrueTrigger = TrueTriggerComponent.TimeInTrueTriggerZone;        
    }
    else
    {
        fTriggerScalar = 0.0000000;
        fTimeInTrueTrigger = 0.0000000;
    }
    //return;    
}

simulated function TrueTriggerEnabled(bool bEnable)
{
    bTrueTriggerEnabled = bEnable;
    //return;    
}

simulated function StartFire(byte FireModeNum)
{
    super.StartFire(FireModeNum);
    // End:0x2E
    if(TrueTriggerComponent != none)
    {
        TrueTriggerComponent.StartFire(FireModeNum);
    }
    //return;    
}

simulated function StopFire(byte FireModeNum)
{
    super.StopFire(FireModeNum);
    // End:0x2E
    if(TrueTriggerComponent != none)
    {
        TrueTriggerComponent.StopFire(FireModeNum);
    }
    //return;    
}

simulated function ScopeStartFire(byte FireModeNum)
{
    global.StartFire(FireModeNum);
    // End:0x32
    if(TrueTriggerComponent != none)
    {
        TrueTriggerComponent.StartFire(FireModeNum);
    }
    //return;    
}

simulated function ScopeStopFire(byte FireModeNum)
{
    global.StopFire(FireModeNum);
    // End:0x32
    if(TrueTriggerComponent != none)
    {
        TrueTriggerComponent.StopFire(FireModeNum);
    }
    //return;    
}

simulated function Projectile AltFireGrenadeProjectileFire(MOHAProj_Explosive SpawnedExplosive, float FuseTime, Rotator DirectionOffset)
{
    local Vector pawnVelocity;

    SpawnedExplosive.InitRotator(GrenadeStartDirection(SpawnedExplosive, DirectionOffset));
    SpawnedExplosive.SetFuseTime(FuseTime);
    // End:0x6B
    if(Instigator.IsA('MOHAPlayerPawn'))
    {
        SpawnedExplosive.Velocity += pawnVelocity;
    }
    return SpawnedExplosive;
    //return ReturnValue;    
}

simulated function Rotator GrenadeStartDirection(MOHAProj_Explosive SpawnedExplosive, Rotator DirectionOffset)
{
    local Rotator startDirection;

    startDirection = SpawnedExplosive.Rotation;
    startDirection.Yaw += DirectionOffset.Yaw;
    startDirection.Roll += DirectionOffset.Roll;
    // End:0x83
    if(startDirection.Pitch > 32768)
    {
        startDirection.Pitch -= 65536;
    }
    // End:0xB0
    if(float(startDirection.Pitch) > SpawnedExplosive.PitchClamp)
    {
        return startDirection;        
    }
    else
    {
        // End:0x108
        if(float(startDirection.Pitch + DirectionOffset.Pitch) > SpawnedExplosive.PitchClamp)
        {
            startDirection.Pitch = int(SpawnedExplosive.PitchClamp);            
        }
        else
        {
            startDirection.Pitch += DirectionOffset.Pitch;
        }
    }
    return startDirection;
    //return ReturnValue;    
}

simulated function bool WeaponSupportsDOF()
{
    return ((ScopeComponent != none) && bScopeEnabled) && !ScopeComponent.bBlurDisabled;
    //return ReturnValue;    
}

event MOHAIncludeClass.TapedMagazineMode GetTapedMagazineMode()
{
    return 0;
    //return ReturnValue;    
}

event MOHAIncludeClass.HellBoxIdleMode GetHellBoxIdleMode()
{
    return 0;
    //return ReturnValue;    
}

simulated function ExitIronSights()
{
    // End:0x32
    if((WeaponSupportsDOF()) && !IsUpgradeSequenceActive())
    {
        WorldInfo.ToggleDOF(false);
    }
    // End:0x50
    if(ScopeComponent != none)
    {
        ScopeComponent.EndSniperZoom();
    }
    super.ExitIronSights();
    //return;    
}

simulated function bool IsUpgradeSequenceActive()
{
    return (MOHAPlayerPawn(Instigator) != none) && MOHAPlayerPawn(Instigator).IsUpgradeSequenceActive();
    //return ReturnValue;    
}

simulated state Active
{
    simulated function BeginFire(byte FireModeNum)
    {
        SmallArmsBeginFire(FireModeNum);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x19
        if(bNeedToRechamber)
        {
            GotoState('WeaponRechamber');
            return;
        }
        // End:0x36
        if(bPendingScopeChange)
        {
            bPendingScopeChange = false;
            PendingScopeChange();
            return;
        }
        // End:0x53
        if(bPendingAltFireChange)
        {
            bPendingAltFireChange = false;
            ToggleAlternateFireMode();
            return;
        }
        // End:0x9A
        if(!HasAnyAmmo())
        {
            // End:0x82
            if(HasReserveAmmo())
            {
                GotoState('WeaponReload');
                return;                
            }
            else
            {
                // End:0x9A
                if(bAlternateFireMode == true)
                {
                    ToggleAlternateFireMode();
                    return;
                }
            }
        }
        // End:0xCA
        if(bPendingReload && CanManualReload())
        {
            bPendingReload = false;
            GotoState('WeaponReload');
            return;
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function PendingScopeChange()
    {
        // End:0x1C
        if(!bScopeEnabled)
        {
            GotoState('ScopeModeIn');            
        }
        else
        {
            GotoState('ScopeModeOut');
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }

    simulated function StateTick(float DeltaTime)
    {
        // End:0x24
        if((Instigator == none) || false == Instigator.IsHumanControlled())
        {
            return;
        }
        // End:0x63
        if(((IronsightsButtonDown()) && int(IronsightsState) == int(0)) && CanIronsight())
        {
            GotoState('IronsightsIn');            
        }
        else
        {
            // End:0x92
            if(!IronsightsButtonDown() && int(IronsightsState) == int(3))
            {
                GotoState('IronsightsOut');
            }
        }
        //return;        
    }

    simulated function ToggleAlternateFireMode()
    {
        // End:0x2C
        if((bAlternateFireMode == false) && HasSecondaryAmmo())
        {
            GotoState('AlternateFireModeIn');            
        }
        else
        {
            // End:0x46
            if(bAlternateFireMode == true)
            {
                GotoState('AlternateFireModeOut');
            }
        }
        //return;        
    }

    simulated function bool CanManualReload()
    {
        return (!HasFullClip() && HasReserveAmmo()) && GameplayAllowsReload();
        //return ReturnValue;        
    }

    simulated function StartReload(byte FireModeNum)
    {
        super(EALAWeapon).StartReload(FireModeNum);
        // End:0x4F
        if(CanManualReload())
        {
            // End:0x41
            if(int(IronsightsState) == int(3))
            {
                bPendingReload = true;
                GotoState('IronsightsOut');                
            }
            else
            {
                GotoState('WeaponReload');
            }
        }
        //return;        
    }
    stop;    
}

simulated state IronsightsIn
{
    simulated function BeginState(name PreviousStateName)
    {
        TimeIronsightsIn();
        StartIronsightsZoom();
        // End:0x43
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_IronsightsInEvent();
        }
        //return;        
    }

    simulated function EndIronsightsInTimer()
    {
        // End:0x26
        if(IronsightsButtonDown())
        {
            IronsightsState = 3;
            GotoState('WeaponIronsights');            
        }
        else
        {
            GotoState('IronsightsOut');
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        // End:0x66
        if((WeaponSupportsDOF()) && Instigator.Controller != none)
        {
            WorldInfo.ToggleDOF(true);
        }
        ClearTimer('EndIronsightsInTimer');
        GetWeaponAttachment().UpdateVFXAttachments();
        //return;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        // End:0x1B
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            return;
        }
        super(EALASmallArms).StartFire(FireModeNum);
        //return;        
    }
    stop;    
}

simulated state IronsightsOut
{
    simulated function BeginState(name PreviousStateName)
    {
        TimeIronsightsOut();
        EndIronsightsZoom();
        // End:0x4B
        if((WeaponSupportsDOF()) && Instigator.Controller != none)
        {
            WorldInfo.ToggleDOF(false);
        }
        // End:0x7A
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_IronsightsOutEvent();
        }
        // End:0x98
        if(ScopeComponent != none)
        {
            ScopeComponent.EndSniperZoom();
        }
        //return;        
    }

    simulated function EndIronsightsOutTimer()
    {
        IronsightsState = 0;
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        ClearTimer('EndIronsightsOutTimer');
        GetWeaponAttachment().UpdateVFXAttachments();
        //return;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        // End:0x1B
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            return;
        }
        super(EALASmallArms).StartFire(FireModeNum);
        //return;        
    }
    stop;    
}

simulated state WeaponIronsights extends Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        // End:0x5D
        if((((bNeedToRechamber || bWeaponPutDown) || bPendingScopeChange) || bPendingAltFireChange) || !HasAnyAmmo() && HasReserveAmmo())
        {
            GotoState('IronsightsOut');
            return;            
        }
        else
        {
            // End:0xBC
            if(!IsTrueTriggerEnabled())
            {
                I = 0;
                J0x73:

                // End:0xBC [Loop If]
                if(I < InvManager.PendingFire.Length)
                {
                    // End:0xB2
                    if(PendingFire(I))
                    {
                        BeginFire(byte(I));
                        // [Explicit Break]
                        goto J0xBC;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x73;
                }
            }
        }
        J0xBC:

        // End:0xEB
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_IronsightsIdleEvent();
        }
        // End:0x10B
        if(IsScopeEnabled())
        {
            ScopeComponent.BeginSniperZoom();
        }
        // End:0x130
        if(IsTrueTriggerEnabled())
        {
            TrueTriggerComponent.IronsightsBeginState(PreviousStateName);
        }
        //return;        
    }

    simulated function PendingScopeChange()
    {
        bPendingScopeChange = true;
        GotoState('IronsightsOut');
        //return;        
    }

    simulated function ToggleAlternateFireMode()
    {
        GotoState('IronsightsOut');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x3A
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        // End:0x5F
        if(IsTrueTriggerEnabled())
        {
            TrueTriggerComponent.IronsightsEndState(NextStateName);
        }
        //return;        
    }

    simulated function bool TryPutDown()
    {
        bWeaponPutDown = true;
        GotoState('IronsightsOut');
        return true;
        //return ReturnValue;        
    }

    simulated event ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        global.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        // End:0x48
        if(IsTrueTriggerEnabled())
        {
            TrueTriggerComponent.InternalProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        }
        //return;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        // End:0x0F
        if(IsTrueTriggerEnabled())
        {
            return;
        }
        super(EALASmallArms).StartFire(FireModeNum);
        //return;        
    }

    simulated function StopFire(byte FireModeNum)
    {
        // End:0x0F
        if(IsTrueTriggerEnabled())
        {
            return;
        }
        super(EALASmallArms).StopFire(FireModeNum);
        //return;        
    }
    stop;    
}

simulated state AlternateFireModeIn
{
    simulated function BeginState(name PreviousStateName)
    {
        bAlternateFireMode = true;
        bPendingAltFireChange = false;
        CurrentFireMode = 1;
        TimeState(AlternateFireModeInTime);
        PlayInAnimation();
        // End:0x51
        if(AmmoCount[1] > 0)
        {
            AddAmmo(-AmmoCount[1]);
        }
        GetWeaponAttachment().UpdateVFXAttachments();
        //return;        
    }

    simulated function PlayInAnimation()
    {
        PlayWeaponAnimation(AlternateFireModeInAnim, AlternateFireModeInTime);
        // End:0x45
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_EnterAlternateFireEvent();
        }
        //return;        
    }

    simulated function StateTimer()
    {
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        ClearTimer('StateTimer');
        //return;        
    }
    stop;    
}

simulated state AlternateFireModeOut
{
    simulated function BeginState(name PreviousStateName)
    {
        TimeState(AlternateFireModeOutTime);
        PlayOutAnimation();
        //return;        
    }

    simulated function PlayOutAnimation()
    {
        PlayWeaponAnimation(AlternateFireModeOutAnim, AlternateFireModeOutTime);
        // End:0x45
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_LeaveAlternateFireEvent();
        }
        //return;        
    }

    simulated function StateTimer()
    {
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        bAlternateFireMode = false;
        CurrentFireMode = 0;
        // End:0x3F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        ClearTimer('StateTimer');
        GetWeaponAttachment().UpdateVFXAttachments();
        //return;        
    }
    stop;    
}

state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        GetWeaponAttachment().StartFiring(false);
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        // End:0x58
        if((GetWeaponAttachment()) != none)
        {
            GetWeaponAttachment().StopFiring(false);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state WeaponBurstFire extends WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x47
        if(IsTimerActive('BurstOver'))
        {
            ClearTimer('BurstOver');
            GetWeaponAttachment().StopFiring(true);
        }
        GetWeaponAttachment().StartFiring(true);
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        // End:0x70
        if((Instigator != none) && Instigator.IsHumanControlled())
        {
            // End:0x3F
            if(bWeaponPutDown || bPendingScopeChange)
            {
                GoToActiveState();
                return;
            }
            // End:0x70
            if(!IronsightsButtonDown() && int(IronsightsState) == int(3))
            {
                GotoState('IronsightsOut');
                return;
            }
        }
        // End:0x89
        if(ShouldRefire())
        {
            FireAmmunition();
            return;
        }
        // End:0x12F
        if((Instigator != none) && Instigator.IsHumanControlled())
        {
            // End:0xD2
            if(!HasAnyAmmo() && !HasReserveAmmo())
            {
                WeaponEmpty();
            }
            // End:0x122
            if(!HasAnyAmmo() && HasReserveAmmo())
            {
                // End:0x111
                if(int(IronsightsState) == int(3))
                {
                    GotoState('IronsightsOut');                    
                }
                else
                {
                    GotoState('WeaponReload');
                }                
            }
            else
            {
                GoToActiveState();
            }            
        }
        else
        {
            GoToActiveState();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local SmallArmsAttachment WeaponAttachment;

        WeaponAttachment = SmallArmsAttachment(GetWeaponAttachment());
        ForceBeamOff();
        // End:0x58
        if((WeaponAttachment != none) && WeaponAttachment.ShotsFiredThisBurstCount < 2)
        {
            SetTimer(minBurstTime, false, 'BurstOver');            
        }
        else
        {
            // End:0x72
            if((GetWeaponAttachment()) != none)
            {
                BurstOver();
            }
        }
        super.EndState(NextStateName);
        //return;        
    }

    simulated function GoToActiveState()
    {
        // End:0x21
        if(int(IronsightsState) == int(3))
        {
            GotoState('WeaponIronsights');            
        }
        else
        {
            GotoState('Active');
        }
        //return;        
    }
    stop;    
}

state WeaponSingleFire extends WeaponFiring
{
    simulated function RefireCheckTimer()
    {
        // End:0x1E
        if(!IsTrueTriggerEnabled())
        {
            global.StopFire(CurrentFireMode);
        }
        // End:0x49
        if(!HasAnyAmmo() && HasReserveAmmo())
        {
            OutOfAmmo();            
        }
        else
        {
            // End:0xCE
            if((WeaponRechamberAnim != 'None') && !InAlternateFireMode())
            {
                bNeedToRechamber = true;
                iRechamberFireMode = int(CurrentFireMode);
                // End:0xBD
                if(int(IronsightsState) == int(3))
                {
                    // End:0xAC
                    if(CanRechamberInIronsight)
                    {
                        GotoState('IronsightWeaponRechamber');                        
                    }
                    else
                    {
                        GotoState('WeaponRechamberWait');
                    }                    
                }
                else
                {
                    GotoState('WeaponRechamber');
                }                
            }
            else
            {
                // End:0xEF
                if(int(IronsightsState) == int(3))
                {
                    GotoState('WeaponIronsights');                    
                }
                else
                {
                    GotoState('Active');
                }
            }
        }
        //return;        
    }

    simulated function OutOfAmmo()
    {
        // End:0x21
        if(int(IronsightsState) == int(3))
        {
            GotoState('IronsightsOut');            
        }
        else
        {
            GotoState('WeaponReload');
        }
        //return;        
    }
    stop;    
}

state WeaponRechamberWait
{
    simulated function BeginState(name PreviousStateName)
    {
        //return;        
    }

    simulated function ScopeStartFire(byte FireModeNum)
    {
        StopFire(CurrentFireMode);
        GotoState('IronsightsOut');
        //return;        
    }

    simulated function StateTick(float DeltaTime)
    {
        // End:0x24
        if((Instigator == none) || false == Instigator.IsHumanControlled())
        {
            return;
        }
        // End:0x41
        if(!IronsightsButtonDown())
        {
            GotoState('IronsightsOut');
        }
        //return;        
    }

    simulated event ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        global.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        // End:0x48
        if(IsTrueTriggerEnabled())
        {
            TrueTriggerComponent.InternalProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        }
        //return;        
    }
    stop;    
}

state WeaponRechamber
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x3C
        if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_RechamberEvent();
        }
        TimeWeaponRechamber(byte(iRechamberFireMode));
        TimeWeaponRechamberDone(byte(iRechamberFireMode));
        PlayWeaponRechamber(byte(iRechamberFireMode));
        //return;        
    }

    simulated function EndRechamberTimer()
    {
        bNeedToRechamber = false;
        // End:0x47
        if(((IronsightsButtonDown()) && int(IronsightsState) == int(0)) && CanIronsight())
        {
            GotoState('IronsightsIn');            
        }
        else
        {
            GotoState('Active');
        }
        //return;        
    }

    simulated function RechamberDoneTimer()
    {
        bNeedToRechamber = false;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        ClearTimer('EndRechamberTimer');
        ClearTimer('RechamberDoneTimer');
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x23
        if(IsMeleeFiringMode(int(FireModeNum)))
        {
            SmallArmsBeginFire(FireModeNum);
        }
        //return;        
    }
    stop;    
}

state IronsightWeaponRechamber extends WeaponRechamber
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x18
        if(IsTrueTriggerEnabled())
        {
            super.BeginFire(FireModeNum);
        }
        //return;        
    }

    simulated function EndRechamberTimer()
    {
        bNeedToRechamber = false;
        // End:0x26
        if(IronsightsButtonDown())
        {
            GotoState('WeaponIronsights');            
        }
        else
        {
            GotoState('IronsightsOut');
        }
        //return;        
    }

    simulated event ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        global.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        // End:0x48
        if(IsTrueTriggerEnabled())
        {
            TrueTriggerComponent.InternalProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        }
        //return;        
    }

    simulated function StateTick(float DeltaTime)
    {
        // End:0x24
        if((Instigator == none) || false == Instigator.IsHumanControlled())
        {
            return;
        }
        // End:0x6D
        if(!IronsightsButtonDown() && IsScopeEnabled())
        {
            PlayWeaponAnimation(GetIdleAnimName(0), 1.0000000, true);
            GotoState('IronsightsOut');
        }
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x3A
        if(!HasAnyAmmo() && HasReserveAmmo())
        {
            AddAmmo(MaxAmmoCount[0]);
        }
        //return;        
    }
    stop;    
}

state WeaponReload
{
    simulated function BeginState(name PreviousStateName)
    {
        MOHAPawn(Instigator).AxonObserver.NotifyObservers('Reload');
        // End:0x62
        if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_ReloadEvent();
        }
        TimeWeaponReload();
        TimeWeaponReloadClipFull();
        PlayWeaponReload();
        bClipFilled = false;
        //return;        
    }

    simulated function bool TryPutDown()
    {
        // End:0x1A
        if(!bAlternateFireMode)
        {
            PutDownWeapon();
            return true;            
        }
        else
        {
            super(Weapon).TryPutDown();
        }
        //return ReturnValue;        
    }

    simulated function EndReloadTimer()
    {
        // End:0x8F
        if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
        {
            Class'Engine.JuiceSubsystem'.static.LevelEventD(3, 0, 5, "Gameplay", "WeaponReloaded", string(Class.Name), AmmoCount[int(CurrentFireMode)], float(InventoryId), "", MOHAPlayerPawn(Instigator).Location);
        }
        FillClip();
        // End:0xD8
        if(((IronsightsButtonDown()) && int(IronsightsState) == int(0)) && CanIronsight())
        {
            GotoState('IronsightsIn');            
        }
        else
        {
            GotoState('Active');
        }
        //return;        
    }

    simulated function ReloadClipFullTimer()
    {
        FillClip();
        //return;        
    }

    simulated function FillClip()
    {
        // End:0x2D
        if(!bClipFilled)
        {
            bClipFilled = true;
            AddAmmo(MaxAmmoCount[GetReloadMode()]);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        ClearTimer('EndReloadTimer');
        ClearTimer('ReloadClipFullTimer');
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x26
        if(IsMeleeFiringMode(int(FireModeNum)))
        {
            SmallArmsBeginFire(FireModeNum);            
        }
        else
        {
            // End:0x42
            if(!bAlternateFireMode)
            {
                SetPendingFire(int(FireModeNum));
            }
        }
        //return;        
    }
    stop;    
}

simulated state ScopeModeIn
{
    simulated function BeginState(name PreviousStateName)
    {
        ScopeEnabled(true);
        SetTimer(ScopeModeInTime, false, 'ScopeModeInTimer');
        PlayWeaponAnimation(GetScopeInAnim(), ScopeModeInTime);
        // End:0x69
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_ScopeModeInEvent();
        }
        //return;        
    }

    simulated function ScopeModeInTimer()
    {
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        ClearTimer('ScopeModeInTimer');
        //return;        
    }
    stop;    
}

simulated state ScopeModeOut
{
    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(ScopeModeOutTime, false, 'ScopeModeOutTimer');
        PlayWeaponAnimation(GetScopeOutAnim(), ScopeModeOutTime);
        // End:0x5E
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_ScopeModeOutEvent();
        }
        //return;        
    }

    simulated function ScopeModeOutTimer()
    {
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ScopeEnabled(false);
        // End:0x3A
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        ClearTimer('ScopeModeOutTimer');
        //return;        
    }
    stop;    
}

simulated state WeaponSimulation
{
    simulated event bool IsFiring()
    {
        local bool bIsFiring;

        // End:0x0D
        if(Instigator == none)
        {
            return false;
        }
        bIsFiring = (int(MOHAPlayerPawn(Instigator).CurrentActivity) == int(7)) || int(MOHAPlayerPawn(Instigator).CurrentActivity) == int(24);
        return bIsFiring;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    // Reference: WeaponAccuracyComponent'Default__EALASmallArms.WeaponAccuracy'
    begin object name=WeaponAccuracy class=Class'WeaponAccuracyComponent'
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__EALASmallArms.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy class=Class'WeaponAccuracyComponent'
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    AccuracyParams=(CrouchPenaltyMin=0.7500000,CrouchPenaltyMax=4.0000000,RunPenalty=8.0000000,JumpPenalty=10.0000000,TurnPenaltyMax=5.0000000,BasePenaltyMin=1.0000000,BasePenaltyMax=5.0000000,BasePenaltyRange=2.0000000,AccuracyDistance=50.0000000,AccuracyRecoveryScalar=8.0000000)
    IronsightsAccuracyParams=(CrouchPenaltyMin=0.7500000,CrouchPenaltyMax=4.0000000,RunPenalty=10.0000000,JumpPenalty=10.0000000,TurnPenaltyMax=5.0000000,BasePenaltyMin=0.0000000,BasePenaltyMax=0.0000000,BasePenaltyRange=2.0000000,AccuracyDistance=50.0000000,AccuracyRecoveryScalar=1.0000000)
    AlternateFireModeInTime=1.0000000
    AlternateFireModeOutTime=1.0000000
    fDOFRestoreForce=3.0000000
    ReloadInterval[0]=2.7500000
    ReloadInterval[1]=2.7500000
    ReloadClipFullInterval[0]=2.7500000
    ReloadClipFullInterval[1]=2.7500000
    RechamberInterval[0]=0.0000000
    RechamberInterval[1]=0.0000000
    RechamberDoneInterval[0]=0.0000000
    RechamberDoneInterval[1]=0.0000000
    // Reference: WeaponKickComponent'Default__EALASmallArms.WeaponKick'
    begin object name=WeaponKick class=Class'WeaponKickComponent'
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__EALASmallArms.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick class=Class'WeaponKickComponent'
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    KickParams=(PitchDistance=0.3000000,PitchRandomness=0.0000000,PitchCutoffDistance=25.0000000,PitchRecenterRate=15.0000000,YawDistance=0.1000000,YawRandomness=1.5000000,PushDistance=0.8000000,PushRecenterRate=20.0000000,PushCutoffDistance=5.0000000,PushRandomness=0.0000000,ConstantPitchReturn=true,ConstantPushReturn=false,KickTimePitchYaw=0.1000000,KickTimePush=0.0100000)
    IronsightsKickParams=(PitchDistance=0.0000000,PitchRandomness=0.0000000,PitchCutoffDistance=0.0000000,PitchRecenterRate=0.0000000,YawDistance=0.0000000,YawRandomness=0.0000000,PushDistance=0.0000000,PushRecenterRate=0.0000000,PushCutoffDistance=0.0000000,PushRandomness=0.0000000,ConstantPitchReturn=false,ConstantPushReturn=false,KickTimePitchYaw=0.1000000,KickTimePush=0.1000000)
    minBurstTime=0.0600000
    // Reference: WhizSenderComponent'Default__EALASmallArms.whiz'
    begin object name=whiz class=Class'WhizSenderComponent'
        Sound=SoundCue'Aud_GCm_FakeWAV.Bullets.Bullet_Whiz_BY'
    end object
    WhizComponent=whiz
    fCurrentFocusDist=10.0000000
    WeaponFireNoiseRadius=5500.0000000
    WeaponEquipNoiseRadius=1500.0000000
    WeaponReloadNoiseRadius=1500.0000000
    AmmoCount=10
    RequiresAmmo[0]=true
    RequiresAmmo[1]=true
    RequiresAmmo[2]=false
    WeaponFireTypes=/* Array type was not detected. */
    FiringStatesArray=/* Array type was not detected. */
    FireInterval=/* Array type was not detected. */
    // Reference: MOHASkeletalMeshComponent'Default__EALASmallArms.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
}