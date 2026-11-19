class R6GadgetGrenade extends R6GroupGadget
    abstract
    native
    config(GadgetsConfig)
    hidecategories(lighting);

var class<R6ProjectileGrenade> m_GrenadeProjectileClass;
var config int m_iDesiredPitch;
var bool m_bSetSpeed;
var bool m_bSetPitch;
var bool m_bCloseTarget;
var bool m_bProjectileThrowed;
var Vector m_vTargetLoc;
var int m_iPitchOverride;

// Export UR6GadgetGrenade::execGetGrenadeStartLoc(FFrame&, void* const)
native final function Vector GetGrenadeStartLoc(bool bApproximate, optional bool bUseParameter, optional Rotator rAimRot);

// Export UR6GadgetGrenade::execGetGrenadeStartRot(FFrame&, void* const)
native final function Rotator GetGrenadeStartRot();

// Export UR6GadgetGrenade::execInitializeThrow(FFrame&, void* const)
native final function InitializeThrow();

// Export UR6GadgetGrenade::execGetEffectMaxRadius(FFrame&, void* const)
native final function float GetEffectMaxRadius(class<R6Effect> EffectClass);

// Export UR6GadgetGrenade::execReleaseGrenade(FFrame&, void* const)
native final function ReleaseGrenade();

// Export UR6GadgetGrenade::execGetUseAnimTime(FFrame&, void* const)
native function float GetUseAnimTime();

// Export UR6GadgetGrenade::execGetThrowTime(FFrame&, void* const)
native function float GetThrowTime();

// Export UR6GadgetGrenade::execCommunicateGrenadeAmmoLeft(FFrame&, void* const)
native function CommunicateGrenadeAmmoLeft();

// Export UR6GadgetGrenade::execCanUseGadget(FFrame&, void* const)
native simulated function bool CanUseGadget();

// Export UR6GadgetGrenade::execGetTossInitialSpeed(FFrame&, void* const)
native simulated function float GetTossInitialSpeed();

simulated function name GetGadgetAttachSocket(bool bFPMesh)
{
    return 'R65_Grenade_LHand';
    return;
}

simulated event Vector GetPhysicalFireStartLoc()
{
    return GetGrenadeStartLoc(true);
    return;
}

auto state Ready
{
    simulated event UseGadget()
    {
        InitializeThrow();
        GotoState('Using');
        SetUseTimer();
        SetTimer(GetThrowTime(), false, 'ReleaseGrenade');
        return;
    }
    stop;
}

state Using
{
    simulated event bool CanUseGadget()
    {
        return false;
        return;
    }

    simulated function EndUseGadget()
    {
        DettachGadget();
        m_bProjectileThrowed = false;
        GotoState('Ready');
        EndUseGadget();
        return;
        return;
    }
    stop;
}

defaultproperties
{
    m_iAmmo=5
    m_eGadgetType=1
}