class R6DedicatedServerLocalPlayerController extends R6PlayerController
    native
    config(Game)
    hidecategories(lighting);

function PostBeginPlay()
{
    m_bDisableCameraInput = true;
    bIsPlayer = false;
    return;
}

function PlayerUpdate(float fDeltaTime)
{
    return;
}

function bool CanRestartPlayer()
{
    return false;
    return;
}

event bool IsDedicatedServerController()
{
    return true;
    return;
}

function ResetOriginalData()
{
    return;
}

event SetPlayerReady(bool bReady)
{
    return;
}

state Spectating
{
    ignores RestartLevel, Suicide, NextWeapon, PrevWeapon, SwitchToBestWeapon, ThrowWeapon, 
	    ReloadButOff, NextScope, SwitchWeaponButHeld, ReloadButHeld, TagEnemyBut, 
	    TagEnemyButOff, TagEnemyButHeldOff, UseGadgetButOff, SetVisionModeBut, SetVisionModeButOff, 
	    VisionModeButHeld, NightVisionButton, HeatVisionButton, SendOrderTeam, GiveOrderUp, 
	    GiveOrderDown, GiveOrderLeft, GiveOrderRight, BeginState, EndState, 
	    PlayerUpdate, ClientRestart, NotifyKilled, NextPlayer, PrevPlayer, 
	    ServerViewNextPlayer, ServerViewPrevPlayer, ServerRestartPlayer, ChangePOV, ReloadBut, 
	    RateOfFireButton, PlayerPressB, ShowRespawnScreen;

    simulated event bool CanPlayerAction()
    {
        return false;
        return;
    }

    function bool ShouldUpdateVisionModeNow()
    {
        return false;
        return;
    }
    stop;
}
