
class M14 extends TPWeapon;

var MaterialInstanceConstant SniperOverlayMaterialInstance;
var MaterialInstanceConstant SniperOverlayMaterialWideInstance;

simulated function MaterialInstanceConstant GetScopeView()
{
    return SniperOverlayMaterialInstance;
}

simulated function MaterialInstanceConstant GetScopeViewWide()
{
    return SniperOverlayMaterialWideInstance;
}

simulated function ToggleAimDownSight(TPPlayerController TPController)
{
    Super.ToggleAimDownSight(TPController);

    TpHUD(TPController.myHUD).bDrawSniperView=bToggleAimDownSight;
    TPController.Pawn.Weapon.Mesh.SetHidden(bToggleAimDownSight);
    TPController.Pawn.Mesh.SetHidden(bToggleAimDownSight);

    PlayerPawn(TPController.Pawn).EnableDistortionEffect(bToggleAimDownSight);

    // Override parent's smooth fov
	if (bToggleAimDownSight)
		TPController.SetDesiredFOV (AimDownFOV,,false);
    else
		TPController.SetDesiredFOV (TPController.DefaultFOV,,false);
}

