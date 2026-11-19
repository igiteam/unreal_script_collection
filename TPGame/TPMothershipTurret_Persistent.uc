class TPMothershipTurret_Persistent extends TPBaseVehicle
	notplaceable;

var int NumMuzzles;
var array<ParticleSystemComponent>	MuzzleFlashPSC;
var ParticleSystem			MuzzleFlashPSCTemplate;
var array<name> MuzzleFlashSocketName;
var array<TPSkelControlPlayerYaw> GunRotateControl;
var array<TPSkelControlPlayerPitch> GunPitchControl;
var array<float> GunPitchDir;
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

	GunRotateControl[0] = TPSkelControlPlayerYaw(Mesh.FindSkelControl('GunYaw'));
	GunRotateControl[0].SetSkelControlActive(true);
	GunPitchControl[0] = TPSkelControlPlayerPitch(Mesh.FindSkelControl('GunPitch'));
	GunPitchControl[0].SetSkelControlActive(true);

	GunPitchDir[0] = 1.0f;

	if ( Controller == None )
	{
    	if ( ControllerClass != None )
	    	Controller = Spawn(ControllerClass);

    	if ( Controller != None )
	       	Controller.Possess( Self, false );
	}
}

simulated event Destroyed()
{
	//`log("I HAVE BEEN DESTROYED");
	if (TPMothershipTurretController(Controller).FireEffectSoundCmpt.bWasPlaying)
		TPMothershipTurretController(Controller).FireEffectSoundCmpt.Stop();
	
	DetachFromController();
}

