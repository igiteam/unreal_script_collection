class PanzerStrike extends TPWeapon;

var MaterialInstanceConstant PanzerOverlayMaterialInstance;
var MaterialInstanceConstant PanzerOverlayMaterialWideInstance;

//var Array<SoundCue>		Sound_Fire_NPC_Variety;

simulated function MaterialInstanceConstant GetScopeView()
{
    return PanzerOverlayMaterialInstance;
}

simulated function MaterialInstanceConstant GetScopeViewWide()
{
    return PanzerOverlayMaterialWideInstance;
}

simulated function float FireRecoilProcess (float Percent, float FireAngle)
{
    FireAngle = Super.FireRecoilProcess (Percent, FireAngle);
    return FireAngle / Percent;
}


simulated event PostBeginPlay()
{
	//Randomize the NPC fire sound
	//Sound_Fire_NPC[0] = Sound_Fire_NPC_Variety[ Rand(Sound_Fire_NPC_Variety.Length) ];


	super.PostBeginPlay();
}

simulated function ToggleAimDownSight(TPPlayerController TPController)
{
    Super.ToggleAimDownSight(TPController);

    TpHUD(TPController.myHUD).bDrawSniperView=bToggleAimDownSight;
    TPController.Pawn.Weapon.Mesh.SetHidden(bToggleAimDownSight);
    TPController.Pawn.Mesh.SetHidden(bToggleAimDownSight);

    // Override parent's smooth fov
	if (bToggleAimDownSight)
		TPController.SetDesiredFOV (AimDownFOV,,false);
    else
		TPController.SetDesiredFOV (TPController.DefaultFOV,,false);
}

function GivenTo(Pawn ThisPawn, optional bool bDoNotActivate)
{
    local PlayerPawn Player;

    Player = PlayerPawn(ThisPawn);
    if (Player != None)
    {
        Player.SetDistortionEffect();
    }

    if (WehrmachtPawn(ThisPawn) != None)
    {
        WehrmachtPawn(ThisPawn).bCannotGrapple = true;
    }

    Super.GivenTo(ThisPawn, bDoNotActivate);
}

