class Mothership_Persistent extends TPBaseVehicle
    notplaceable;

var int NumMuzzles;
var array<ParticleSystemComponent>	MuzzleFlashPSC;
var ParticleSystem			MuzzleFlashPSCTemplate;
var class<TPProjectile>		ProjectileClass;
var array<name> MuzzleFlashSocketName;
var array<TPSkelControlPlayerYaw> GunRotateControl;

var ParticleSystem TurbineExhTemplate;
var EmitterSpawnable TurbineExh_FL,TurbineExh_FR,TurbineExh_RL,TurbineExh_RR;

var() SoundCue FireEffectSound;

simulated event PostBeginPlay()
{
	local int i;

	super.PostBeginPlay();

	for (i = 0; i < NumMuzzles; i++)
	{
		if (MuzzleFlashPSCTemplate != none)
		{
			MuzzleFlashPSC[i] = new(Outer) class'ParticleSystemComponent';
			MuzzleFlashPSC[i].SetTemplate(MuzzleFlashPSCTemplate);
			Mesh.AttachComponentToSocket(MuzzleFlashPSC[i], MuzzleFlashSocketName[i]);
			MuzzleFlashPSC[i].DeactivateSystem();
		}
	}

	GunRotateControl[0] = TPSkelControlPlayerYaw(Mesh.FindSkelControl('FrontGunTurret'));
	GunRotateControl[1] = TPSkelControlPlayerYaw(Mesh.FindSkelControl('RightGunTurret'));
	GunRotateControl[2] = TPSkelControlPlayerYaw(Mesh.FindSkelControl('LeftGunTurret'));
	//GunRotateControl[3] = TPSkelControlPlayerYaw(Mesh.FindSkelControl('RearGun1Turret'));
	//GunRotateControl[4] = TPSkelControlPlayerYaw(Mesh.FindSkelControl('RearGun2Turret'));

	GunRotateControl[0].SetSkelControlActive(true);
	GunRotateControl[1].SetSkelControlActive(true);
	GunRotateControl[2].SetSkelControlActive(true);
	//GunRotateControl[3].SetSkelControlActive(true);
	//GunRotateControl[4].SetSkelControlActive(true);

	if (TurbineExhTemplate != None)
	{
		TurbineExh_FL = spawn(class'EmitterSpawnable');
		TurbineExh_FL.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_FL.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(TurbineExh_FL.ParticleSystemComponent,'FrontL_Exh');
		TurbineExh_FL.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_FL.SetDrawScale(5.0f);
		TurbineExh_FL.ParticleSystemComponent.ActivateSystem();

		TurbineExh_FR = spawn(class'EmitterSpawnable');
		TurbineExh_FR.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_FR.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(TurbineExh_FR.ParticleSystemComponent,'FrontR_Exh');
		TurbineExh_FR.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_FR.ParticleSystemComponent.ActivateSystem();

		TurbineExh_RL = spawn(class'EmitterSpawnable');
		TurbineExh_RL.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_RL.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(TurbineExh_RL.ParticleSystemComponent,'RearL_Exh');
		TurbineExh_RL.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_RL.ParticleSystemComponent.ActivateSystem();

		TurbineExh_RR = spawn(class'EmitterSpawnable');
		TurbineExh_RR.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_RR.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(TurbineExh_RR.ParticleSystemComponent,'RearR_Exh');
		TurbineExh_RR.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_RR.ParticleSystemComponent.ActivateSystem();
	}

	if ( Controller == None )
	{
    	if ( ControllerClass != None )
	    	Controller = Spawn(ControllerClass);

    	if ( Controller != None )
	       	Controller.Possess( Self, false );
	}
}

