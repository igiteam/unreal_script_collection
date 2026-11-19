
class G47Sniper extends TPWeapon;

var Emitter				ConeLightEmitter;

var	private DrawConeComponent		ConeRenderComponent;
var private G47ConeInterpActor		ConeActor;

var ParticleSystem		ConeLightTemplate;
var PointLightComponent		UVPointLight;
//var	private DrawSphereComponent		SphereRenderComponent;

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


simulated function float FireRecoilProcess (float Percent, float FireAngle)
{
    FireAngle = Super.FireRecoilProcess (Percent, FireAngle);
    return FireAngle / Percent;
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

function GivenTo(Pawn ThisPawn, optional bool bDoNotActivate)
{
    local PlayerPawn Player;

    Player = PlayerPawn(ThisPawn);
    if (Player != None)
    {
        Player.SetDistortionEffect();

		ConeActor.StaticMeshComponent.SetHidden(true);
		ConeLightEmitter.ParticleSystemComponent.DeactivateSystem();
		ConeLightEmitter.ParticleSystemComponent.KillParticlesForced();
		UVPointLight.SetEnabled(false);
    }

    Super.GivenTo(ThisPawn, bDoNotActivate);
}

simulated function ToggleUVLight(bool flag)
{
	if (!Owner.IsA('PlayerPawn'))
	{
		//`log("Turning on UV light"@Owner);
		ConeActor.StaticMeshComponent.SetHidden(!flag);

		if (ConeLightEmitter != None)
		{
			if (flag)
			{
				ConeLightEmitter.ParticleSystemComponent.ActivateSystem();
				UVPointLight.SetEnabled(true);
			}
			else
			{
				ConeLightEmitter.ParticleSystemComponent.DeactivateSystem();
				ConeLightEmitter.ParticleSystemComponent.KillParticlesForced();
				UVPointLight.SetEnabled(false);
			}
		}
	}
}

simulated event PostBeginPlay()
{
	local vector uvoff;
	//Randomize the NPC fire sound
	//Sound_Fire_NPC[0] = Sound_Fire_NPC_Variety[ Rand(Sound_Fire_NPC_Variety.Length) ];


	super.PostBeginPlay();

	//SkeletalMeshComponent(Mesh).AttachComponentToSocket(ConeRenderComponent,'UVLight');
	ConeActor = Spawn(class'G47ConeInterpActor');
	//We can't use set base because the weapon's base doesn't get set when it's picked up by a pawn
	//ConeActor.SetBase(self,, SkeletalMeshComponent(Mesh), 'UVLight');
	SkeletalMeshComponent(Mesh).AttachComponentToSocket(ConeActor.StaticMeshComponent,'UVLight');
	ConeActor.StaticMeshComponent.SetHidden(true);

	if (ConeLightTemplate != None)
	{
		ConeLightEmitter = spawn(class'EmitterSpawnable');
		ConeLightEmitter.ParticleSystemComponent.bAutoActivate = false;
		ConeLightEmitter.bDestroyOnSystemFinish = false;
		if (SkeletalMeshComponent(Mesh) != none)
		{
			SkeletalMeshComponent(Mesh).AttachComponentToSocket(ConeLightEmitter.ParticleSystemComponent,'UVLight');
		}

		ConeLightEmitter.SetTemplate(ConeLightTemplate, false);
	}

	uvoff = vect(0.0f, -135.0f,-80.0f);
	SkeletalMeshComponent(Mesh).AttachComponent(UVPointLight,'JO_Handle', uvoff);
	//SkeletalMeshComponent(Mesh).AttachComponent(SphereRenderComponent,'JO_Handle', uvoff);
	//UVPointLight.SetEnabled(true);

}

simulated event Destroyed()
{
	if (ConeActor != None)
		ConeActor.Destroy();
}

simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	super.PlayFireEffects(FireModeNum, HitLocation);
}

