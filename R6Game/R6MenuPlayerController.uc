class R6MenuPlayerController extends R6PlayerController
    native
    config(Game)
    hidecategories(lighting);

// Export UR6MenuPlayerController::execUpdateRotation(FFrame&, void* const)
native function UpdateRotation(float fDeltaTime);

simulated function UpdateShootInputAction()
{
    return;
}

exec function RoFBut()
{
    return;
}

exec function ReloadBut()
{
    return;
}

exec function RateOfFireButton()
{
    return;
}

exec function SetVisionModeBut()
{
    return;
}

exec function NightVisionButton()
{
    return;
}

exec function HeatVisionButton()
{
    return;
}

exec function PIPBut()
{
    return;
}

exec function WeaponsMenu()
{
    return;
}

exec function WeaponOptionsMenu()
{
    return;
}

exec function VisionModeMenu()
{
    return;
}

exec function UseGadgetButOff()
{
    return;
}

exec function RoFButOff()
{
    return;
}

exec function ReloadButOff()
{
    return;
}

exec function SetVisionModeButOff()
{
    return;
}

state PlayerWalking
{    stop;
}

state Dead
{
    ignores KilledBy, ReloadButOff, NextScope, TagEnemyBut, SwitchWeaponButHeld, ReloadButHeld, 
	    TagEnemyButOff, TagEnemyButHeldOff, UseGadgetButOff, SetVisionModeBut, SetVisionModeButOff, 
	    VisionModeButHeld, NightVisionButton, HeatVisionButton, SendOrderTeam, GiveOrderUp, 
	    GiveOrderDown, GiveOrderLeft, GiveOrderRight, BeginState, EndState, 
	    TimerEnterObserverMode;
    stop;
}

defaultproperties
{
    m_bFiringInputEnabled=false
    bIgnoreMoveInput=1
    InputClass=Class'R6MenuPlayerInput'
    m_SelectedVisionMode=1
}