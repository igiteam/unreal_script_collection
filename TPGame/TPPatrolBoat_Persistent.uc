class TPPatrolBoat_Persistent extends TPBaseVehicle
	notplaceable;

var int NumMuzzles;
var array<ParticleSystemComponent>	MuzzleFlashPSC;
var ParticleSystem			MuzzleFlashPSCTemplate;
var array<name> MuzzleFlashSocketName;
var array<TPSkelControlPlayerYaw> GunRotateControl;
var array<TPSkelControlPlayerPitch> GunPitchControl;
var array<float> GunPitchDir;
var() SoundCue FireEffectSound;
var PointLightComponent	SourceLight_F, SourceLight_M, SourceLight_B;
var() float LightPulseTime;
var float CurrentLightTime;
var bool LightsOn;
var() float GrenadeDamage;
var() float PanzerDamage;

var Emitter BoatWakeEmitter;
var ParticleSystem BoatWakeTemplate;

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

	GunRotateControl[0] = TPSkelControlPlayerYaw(Mesh.FindSkelControl('FrontGunYaw'));
	GunRotateControl[1] = TPSkelControlPlayerYaw(Mesh.FindSkelControl('RearGunYaw'));
	
	GunRotateControl[0].SetSkelControlActive(true);
	GunRotateControl[1].SetSkelControlActive(true);

	GunPitchControl[0] = TPSkelControlPlayerPitch(Mesh.FindSkelControl('FrontGunPitch'));
	GunPitchControl[1] = TPSkelControlPlayerPitch(Mesh.FindSkelControl('RearGunPitch'));

	GunRotateControl[0].SetSkelControlActive(true);
	GunRotateControl[1].SetSkelControlActive(true);

	GunPitchDir[0] = 1.0f;
	GunPitchDir[1] = -1.0f;

	if ( Controller == None )
	{
    	if ( ControllerClass != None )
	    	Controller = Spawn(ControllerClass);

    	if ( Controller != None )
	       	Controller.Possess( Self, false );
	}

	Mesh.AttachComponentToSocket(SourceLight_F, 'Light_F');
	Mesh.AttachComponentToSocket(SourceLight_M, 'Light_M');
	Mesh.AttachComponentToSocket(SourceLight_B, 'Light_B');

	if (BoatWakeTemplate != None)
	{
		BoatWakeEmitter = spawn(class'EmitterSpawnable');
		BoatWakeEmitter.ParticleSystemComponent.bAutoActivate = false;
		BoatWakeEmitter.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(BoatWakeEmitter.ParticleSystemComponent,'wakeEmitA');

		BoatWakeEmitter.SetTemplate(BoatWakeTemplate, false);
		BoatWakeEmitter.ParticleSystemComponent.ActivateSystem();
	}
}

simulated event Destroyed()
{
	if (TPPatrolBoatController(Controller).FireEffectSoundCmpt.bWasPlaying)
		TPPatrolBoatController(Controller).FireEffectSoundCmpt.Stop();
	
	DetachFromController();
	SourceLight_F.SetEnabled(false);
	SourceLight_M.SetEnabled(false);
	SourceLight_B.SetEnabled(false);
}

function Tick (float DeltaTime)
{
	CurrentLightTime += DeltaTime;

	if (CurrentLightTime > LightPulseTime)
	{
		LightsOn = !LightsOn;
		SourceLight_F.SetEnabled(LightsOn);
		SourceLight_M.SetEnabled(LightsOn);
		SourceLight_B.SetEnabled(LightsOn);
		CurrentLightTime = 0;
	}
}

event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (damageType == class'TPDamageTypeImpactGrenade')
		Damage = GrenadeDamage;
	else if (damageType == class'TPDamageTypeImpactPanzer')
		Damage = PanzerDamage;

	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser);
}

