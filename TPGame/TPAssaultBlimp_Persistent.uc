class TPAssaultBlimp_Persistent extends TPBaseVehicle
    notplaceable
	native;

enum ABS_Side   {ABS_Left, ABS_Right};
enum AB_Action {AB_Idle, AB_Attack, AB_Rappel, AB_Gunner};

var SecBlimpGunner                BlimpGunner;
var SecBlimpGunner                MountedGunnerL;

// Enemies to spawn that are to be attached to the blimp
var array<WehrmachtPawn>         WehrmachtL;
var array<WehrmachtPawn>         WehrmachtR;

var array<TPAIController>         WehrmachtConL;
var array<TPAIController>         WehrmachtConR;

// Enemy states 
// var array<AB_Action>             WehrmachtStatesL;
// var array<AB_Action>             WehrmachtStatesR;

// Used to keep track of which enemies have had their state modified in
// a single kismet action.  These would be arrays of booleans but setting
// a local array of booleans to reference it in a function causes a crash!
// var array<AB_Action>             ModifiedL;
// var array<AB_Action>             ModifiedR;

// Socket names where enemies will attach to
var array<Name>                  HangarSocketsL;
var array<Name>                  HangarSocketsR;

var array<SkeletalMeshComponent> RopesL;
var array<SkeletalMeshComponent> RopesR;

var array<Name>                  RopeSocketsL;
var array<Name>                  RopeSocketsR;

var SkeletalMeshComponent          MountedGunL;

var ParticleSystem               ParticleFlightTemplate;
var EmitterSpawnable             ParticleSmokeEmitter;

var() float                      BlimpGunnerOffset;
var() float                      MountedGunnerOffset;

var const int                    GunnerNumL;
var const int                    GunnerNumR;

var SkeletalMeshSocket			 Spotlight_LSocket;
var SkeletalMeshSocket			 Spotlight_RSocket;
var SkeletalMeshSocket			 Gun1_Socket;
var SkeletalMeshSocket			 MountedGunMuzzleL_Socket;
var SkeletalMeshSocket			 MuzzleFlash_Socket;



var SpotLightComponent			 Spotlight_L;
var SpotLightComponent			 Spotlight_R;
var PointLightComponent			 SourceLight_L;
var PointLightComponent			 SourceLight_R;

var TPNaziAttractorCone			 Attractor_L;
var TPNaziAttractorCone			 Attractor_R;
var SpotlightInterpActor		 SpotlightCone_L;
var SpotlightInterpActor		 SpotlightCone_R;

enum ESpotlightBehavior {
	Spotlight_NONE,
	Spotlight_SWEEP,
	Spotlight_SEEK
};

var() ESpotlightBehavior		 SpotlightBehavior;

var () float						m_SpotlightRememberPlayerTime;

var () float						m_SpotlightSearchSpeed;
var () float						m_SpotlightSeekSpeed;


// data points for Riding Nazis
var () float					m_HowOfftenToUpdateRidingNazis;
var () float					m_NPCWeaponDamageIncrease;
var () float					m_NPCChanceToGoDown;
var () float					m_NPCChanceToSwitchPosturesWhenHit;
var () float					m_NPCChanceToEjectBackWardsWhenKilled;


var Emitter	SpotlightFlareEmitter_L;
var Emitter	SpotlightFlareEmitter_R;
var ParticleSystem	SpotlightFlareTemplate;

struct native BlimpParticleSystems
{
    var() ParticleSystem Rear_Lift_Turbine_L;
    var() ParticleSystem Rear_Lift_Turbine_R;
    var() ParticleSystem Thrust_Turbine_L;
    var() ParticleSystem Thrust_Turbine_R;
    var() ParticleSystem Rear_Lift_Turbine_Damage_L;
    
    structdefaultproperties
    {

    }
};

var() BlimpParticleSystems AssaultBlimpParticleSystems;
var() bool            bPreviewDamage;
//var int NumMuzzles;
//var array<ParticleSystemComponent>	MuzzleFlashPSC;
var ParticleSystemComponent		MuzzleFlashPSC;
var ParticleSystem				MuzzleFlashPSCTemplate;
var class<TPProjectile>			ProjectileClass;
//var array<name> MuzzleFlashSocketName;
var TPSkelControlPlayerYaw GunRotateControl;


var ParticleSystem               TurbineExhTemplate;
var ParticleSystem				 FrontExhTemplate;
var ParticleSystem				 SideExhTemplate;
var EmitterSpawnable             TurbineExh_L, TurbineExh_R, SideExh_L, SideExh_R, FrontExh_L, FrontExh_R;

var ParticleSystem				 DeathExplTemplate, DeathFireTemplate;
var SoundCue					 DeathExplSound;

var AnimTree					 PerfAnimTree;

var SoundCue					 FireEffectSound, GunSound, AlarmSound;

var() bool                       bNoDeleteOnDeath;

function NotifyRappel(WehrmachtPawn wehr);
function NotifyDescent(WehrmachtPawn wehr);
function NotifyLand (WehrmachtPawn wehr);

simulated event PostBeginPlay()
{
	//local int i;

    super.PostBeginPlay();

 //   ParticleSmokeEmitter = Spawn(class'EmitterSpawnable');
	//ParticleSmokeEmitter.SetTemplate(ParticleFlightTemplate);
 //   Mesh.AttachComponentToSocket(ParticleSmokeEmitter.ParticleSystemComponent, 'Hangar1');
	//ParticleSmokeEmitter.LifeSpan = 999.0f;

    //@todo major code cleanup
    if (bPreviewDamage)
    {
        ParticleSmokeEmitter = Spawn(class'EmitterSpawnable');
	    ParticleSmokeEmitter.SetTemplate(AssaultBlimpParticleSystems.Rear_Lift_Turbine_L);
        Mesh.AttachComponentToSocket(ParticleSmokeEmitter.ParticleSystemComponent, 'Rear_Lift_Turbine_L');
	    ParticleSmokeEmitter.LifeSpan = 999.0f;

        ParticleSmokeEmitter = Spawn(class'EmitterSpawnable');
	    ParticleSmokeEmitter.SetTemplate(AssaultBlimpParticleSystems.Rear_Lift_Turbine_R);
        Mesh.AttachComponentToSocket(ParticleSmokeEmitter.ParticleSystemComponent, 'Rear_Lift_Turbine_R');
	    ParticleSmokeEmitter.LifeSpan = 999.0f;

        ParticleSmokeEmitter = Spawn(class'EmitterSpawnable');
	    ParticleSmokeEmitter.SetTemplate(AssaultBlimpParticleSystems.Thrust_Turbine_L);
        Mesh.AttachComponentToSocket(ParticleSmokeEmitter.ParticleSystemComponent, 'Thrust_Turbine_L');
	    ParticleSmokeEmitter.LifeSpan = 999.0f;

        ParticleSmokeEmitter = Spawn(class'EmitterSpawnable');
	    ParticleSmokeEmitter.SetTemplate(AssaultBlimpParticleSystems.Thrust_Turbine_R);
        Mesh.AttachComponentToSocket(ParticleSmokeEmitter.ParticleSystemComponent, 'Thrust_Turbine_R');
	    ParticleSmokeEmitter.LifeSpan = 999.0f;

        ParticleSmokeEmitter = Spawn(class'EmitterSpawnable');
	    ParticleSmokeEmitter.SetTemplate(AssaultBlimpParticleSystems.Rear_Lift_Turbine_Damage_L);
        Mesh.AttachComponentToSocket(ParticleSmokeEmitter.ParticleSystemComponent, 'Rear_Lift_Turbine_Damage_L');
	    ParticleSmokeEmitter.LifeSpan = 999.0f;
    }

	if ( Controller == None )
	{
    	if ( ControllerClass != None )
	    	Controller = Spawn(ControllerClass);

    	if ( Controller != None )
	       	Controller.Possess( Self, false );
	}

    BlimpGunner    = Spawn(class'SecBlimpGunner');
    MountedGunnerL = Spawn(class'SecBlimpGunner');

    BlimpGunner.SetPhysics(PHYS_None);
    BlimpGunner.SetHardAttach(true);
    BlimpGunner.SetBase(self, , Mesh, 'gun1');

    Mesh.AttachComponentToSocket(MountedGunL, 'MountedGun1');
	SkelControlLookAt(MountedGunL.FindSkelControl('Pivot_Latitude')).SetSkelControlActive(false);
	SkelControlLookAt(MountedGunL.FindSkelControl('Pivot_Longitude')).SetSkelControlActive(false);
	GunRotateControl = TPSkelControlPlayerYaw(MountedGunL.FindSkelControl('RootRotate'));
	GunRotateControl.SetSkelControlActive(true);

	Gun1_Socket = Mesh.GetSocketByName('gun1');

    MountedGunnerL.SetPhysics(PHYS_None);
    MountedGunnerL.SetHardAttach(true);
    MountedGunnerL.SetBase(self, , Mesh, 'MountedGunMuzzleL');

	MountedGunMuzzleL_Socket = Mesh.GetSocketByName('MountedGunMuzzleL');

	// always attach this stuff even if it's not being used, but only enable it by default if it is being used.
	// LEFT SPOTLIGHT
	Mesh.AttachComponentToSocket(Spotlight_L,'Spotlight_L');
	Mesh.AttachComponentToSocket(Sourcelight_L,'Spotlight_L');

	Spotlight_LSocket = Mesh.GetSocketByName('Spotlight_L');
	
	// attach nazi attractor
	Attractor_L = Spawn(class'TPNaziAttractorCone', self);
	if (Attractor_L != None)
	{
		Attractor_L.SetBase(self,, Mesh, 'Spotlight_L');
		Attractor_L.SetAngle(Spotlight_L.OuterConeAngle - 1.0f);
		Attractor_L.SetRadius(Spotlight_L.Radius);
		Attractor_L.bCheckSight = true;
		Attractor_L.SetEnabled(false);
	}

	SpotlightCone_L = Spawn(class'SpotlightInterpActor');
	SpotlightCone_L.SetBase(self,, Mesh, 'Spotlight_L');
	SpotlightCone_L.StaticMeshComponent.SetHidden(true);

	if (SpotlightFlareTemplate != None)
	{
		SpotlightFlareEmitter_L = spawn(class'EmitterSpawnable');
		SpotlightFlareEmitter_L.ParticleSystemComponent.bAutoActivate = false;
		SpotlightFlareEmitter_L.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(SpotlightFlareEmitter_L.ParticleSystemComponent,'Spotlight_L');

		SpotlightFlareEmitter_L.SetTemplate(SpotlightFlareTemplate, false);
	
	}

	// RIGHT SPOTLIGHT
	Mesh.AttachComponentToSocket(Spotlight_R,'Spotlight_R');
	Mesh.AttachComponentToSocket(Sourcelight_R,'Spotlight_R');

	Spotlight_RSocket = Mesh.GetSocketByName('Spotlight_R');

	// attach nazi attractor
	Attractor_R = Spawn(class'TPNaziAttractorCone', self);
	if (Attractor_R != None)
	{
		Attractor_R.SetBase(self,, Mesh, 'Spotlight_R');
		Attractor_R.SetAngle(Spotlight_R.OuterConeAngle - 1.0f);
		Attractor_R.SetRadius(Spotlight_R.Radius);
		Attractor_R.bCheckSight = true;
		Attractor_R.SetEnabled(false);
	}

	SpotlightCone_R = Spawn(class'SpotlightInterpActor');
	SpotlightCone_R.SetBase(self,, Mesh, 'Spotlight_R');
	SpotlightCone_R.StaticMeshComponent.SetHidden(true);

	if (SpotlightFlareTemplate != None)
	{
		SpotlightFlareEmitter_R = spawn(class'EmitterSpawnable');
		SpotlightFlareEmitter_R.ParticleSystemComponent.bAutoActivate = false;
		SpotlightFlareEmitter_R.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(SpotlightFlareEmitter_R.ParticleSystemComponent,'Spotlight_R');

		SpotlightFlareEmitter_R.SetTemplate(SpotlightFlareTemplate, false);
		
	}

	SetNewSpotlightBehavior(SpotlightBehavior);

// 	for (i = 0; i < NumMuzzles; i++)
// 	{
	if (MuzzleFlashPSCTemplate != none)
	{
		MuzzleFlashPSC  = new(Outer) class'ParticleSystemComponent';
		//MuzzleFlashPSC[i] = new(Outer) class'ParticleSystemComponent';
		MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplate);
		//MuzzleFlashPSC[i].SetTemplate(MuzzleFlashPSCTemplate);
		//MountedGunL.AttachComponentToSocket(MuzzleFlashPSC[i], MuzzleFlashSocketName[i]);
		MountedGunL.AttachComponentToSocket(MuzzleFlashPSC, 'Muzzle');

		//MuzzleFlashPSC[i].SetDepthPriorityGroup(SDPG_World);
		MuzzleFlashPSC.SetDepthPriorityGroup(SDPG_World);

		//MuzzleFlashPSC[i].DeactivateSystem();
		MuzzleFlashPSC.DeactivateSystem();
	}
	//}

	MuzzleFlash_Socket = MountedGunL.GetSocketByName('Muzzle');

	if (TurbineExhTemplate != None)
	{
		TurbineExh_L = spawn(class'EmitterSpawnable');
		TurbineExh_L.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_L.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(TurbineExh_L.ParticleSystemComponent,'Thrust_Turbine_L');
		TurbineExh_L.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_L.ParticleSystemComponent.ActivateSystem();

		TurbineExh_R = spawn(class'EmitterSpawnable');
		TurbineExh_R.ParticleSystemComponent.bAutoActivate = false;
		TurbineExh_R.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(TurbineExh_R.ParticleSystemComponent,'Thrust_Turbine_R');
		TurbineExh_R.SetTemplate(TurbineExhTemplate, false);
		TurbineExh_R.ParticleSystemComponent.ActivateSystem();
	}

	if (SideExhTemplate != None)
	{
		SideExh_L = spawn(class'EmitterSpawnable');
		SideExh_L.ParticleSystemComponent.bAutoActivate = false;
		SideExh_L.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(SideExh_L.ParticleSystemComponent,'Rear_Lift_Turbine_L');
		SideExh_L.SetTemplate(SideExhTemplate, false);
		SideExh_L.ParticleSystemComponent.ActivateSystem();

		SideExh_R = spawn(class'EmitterSpawnable');
		SideExh_R.ParticleSystemComponent.bAutoActivate = false;
		SideExh_R.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(SideExh_R.ParticleSystemComponent,'Rear_Lift_Turbine_R');
		SideExh_R.SetTemplate(SideExhTemplate, false);
		SideExh_R.ParticleSystemComponent.ActivateSystem();
	}

	if (FrontExhTemplate != None)
	{
		FrontExh_L = spawn(class'EmitterSpawnable');
		FrontExh_L.ParticleSystemComponent.bAutoActivate = false;
		FrontExh_L.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(FrontExh_L.ParticleSystemComponent,'Front_Lift_Turbine_L');
		FrontExh_L.SetTemplate(FrontExhTemplate, false);
		FrontExh_L.ParticleSystemComponent.ActivateSystem();

		FrontExh_R = spawn(class'EmitterSpawnable');
		FrontExh_R.ParticleSystemComponent.bAutoActivate = false;
		FrontExh_R.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(FrontExh_R.ParticleSystemComponent,'Front_Lift_Turbine_R');
		FrontExh_R.SetTemplate(FrontExhTemplate, false);
		FrontExh_R.ParticleSystemComponent.ActivateSystem();
	}
}

simulated function SetNewSpotlightBehavior(ESpotlightBehavior NewSpotlightBehavior)
{
	SpotlightBehavior = NewSpotlightBehavior;

	if (SpotlightBehavior != Spotlight_NONE)
	{	
		Spotlight_L.SetEnabled(true);
		Sourcelight_L.SetEnabled(true);
		Attractor_L.SetEnabled(true);
		SpotlightCone_L.StaticMeshComponent.SetHidden(false);
		SpotlightFlareEmitter_L.ParticleSystemComponent.ActivateSystem();
		
		Spotlight_R.SetEnabled(true);
		Sourcelight_R.SetEnabled(true);
		Attractor_R.SetEnabled(true);
		SpotlightCone_R.StaticMeshComponent.SetHidden(false);
		SpotlightFlareEmitter_R.ParticleSystemComponent.ActivateSystem();
	}
	else
	{
		Spotlight_L.SetEnabled(false);
		Sourcelight_L.SetEnabled(false);
		Attractor_L.SetEnabled(false);
		SpotlightCone_L.StaticMeshComponent.SetHidden(true);
		SpotlightFlareEmitter_L.ParticleSystemComponent.DeactivateSystem();
		
		Spotlight_R.SetEnabled(false);
		Sourcelight_R.SetEnabled(false);
		Attractor_R.SetEnabled(false);
		SpotlightCone_R.StaticMeshComponent.SetHidden(true);
		SpotlightFlareEmitter_R.ParticleSystemComponent.DeactivateSystem();
	}

	TPAssaultBlimpController(Controller).SetSpotlightSkelControls(SpotlightBehavior);
}

simulated event Destroyed()
{
    local int i;
    for(i = 0; i < WehrmachtL.Length; i++)
	{
		if (WehrmachtL[i] != None)
			WehrmachtL[i].Destroy();
	}

    for(i = 0; i < WehrmachtR.Length; i++)
	{
		if (WehrmachtR[i] != None)
			WehrmachtR[i].Destroy();
	}

	if (BlimpGunner != None)
		BlimpGunner.Destroy();

	if (MountedGunnerL != None)
		MountedGunnerL.Destroy();

	if (Attractor_L != None)
	{
		Attractor_L.Destroy();
		SpotlightCone_L.Destroy();
		Spotlight_L.SetEnabled(false);
		Sourcelight_L.SetEnabled(false);
		SpotlightFlareEmitter_L.ParticleSystemComponent.DeactivateSystem();
		SpotlightFlareEmitter_L.ParticleSystemComponent.KillParticlesForced();
		SpotlightFlareEmitter_L.Destroy();
	}

	if (Attractor_R != None)
	{
		Attractor_R.Destroy();
		SpotlightCone_R.Destroy();
		Spotlight_R.SetEnabled(false);
		Sourcelight_R.SetEnabled(false);
		SpotlightFlareEmitter_R.ParticleSystemComponent.DeactivateSystem();
		SpotlightFlareEmitter_R.ParticleSystemComponent.KillParticlesForced();
		SpotlightFlareEmitter_R.Destroy();
	}
	
	if (GunRotateControl != None)
	{
		GunRotateControl.SetSkelControlActive(false);
		GunRotateControl = None;
	}
	
	if (MountedGunL != None)
	{
		MountedGunL = None;
	}

    super.Destroyed();
}

function TriggerDeathEvent(AB_Action action)
{
    switch(action)
    {
        case AB_Idle:
        case AB_Attack:
            TriggerEventClass(class'SeqEvent_BlimpNaziDeath', self, 0);
            break;
        case AB_Rappel:
            TriggerEventClass(class'SeqEvent_BlimpNaziDeath', self, 1);
            break;
        case AB_Gunner:
            TriggerEventClass(class'SeqEvent_BlimpNaziDeath', self, 2);
            break;
    }
}

// Have to do this because AttachComponentToSocket behaves funny and
// may not work correctly if this vehicle is Matinee'ed (read on UDN)
function Tick (float DeltaTime)
{
    //local vector  Pos;
    //local rotator Rot;
    local int     i;

    for (i=0; i < WehrmachtL.Length; i++)
    {
        if (WehrmachtL[i] != None && !WehrmachtL[i].IsInState('Dying'))
        {
            //Mesh.GetSocketWorldLocationAndRotation(HangarSocketsL[i],Pos, Rot);
            //WehrmachtL[i].SetLocation(Pos);
            //WehrmachtL[i].SetRotation(Rot);
        }
        else
        {
            WehrmachtL[i] = None;
			WehrmachtConL[i] = None;
        }
    }
    
    for (i=0; i < WehrmachtR.Length; i++)
    {
        if (WehrmachtR[i] != None && !WehrmachtR[i].IsInState('Dying'))
        {
            //Mesh.GetSocketWorldLocationAndRotation(HangarSocketsR[i],Pos, Rot);
            //WehrmachtR[i].SetLocation(Pos);
            //WehrmachtR[i].SetRotation(Rot);
        }
        else
        {
            WehrmachtR[i] = None;
			WehrmachtConR[i] = None;
        }
    }

    //if (!BlimpGunner.IsInState('Idle'))
    //{
    //    Mesh.GetSocketWorldLocationAndRotation('gun1',Pos, Rot);
    //    BlimpGunner.SetLocation(Pos);
    //    BlimpGunner.SetRotation(Rot);
    //}

    //// @temporary since socket will eventually belong to the gunner mesh
    //// and NOT the blimp
    //if (!MountedGunnerL.IsInState('Idle'))
    //{
    //    Mesh.GetSocketWorldLocationAndRotation('MountedGunMuzzleL',Pos, Rot);
    //    MountedGunnerL.SetLocation(Pos);
    //    MountedGunnerL.SetRotation(Rot);
    //}
}

function OnSetSpotlightLookTargets(SeqAct_SetSpotlightLookTargets Action)
{
	local array<Object> RightTarget, LeftTarget;
	Action.GetObjectVars(RightTarget,"Right Look Target");
	Action.GetObjectVars(LeftTarget,"Left Look Target");

	if (RightTarget.Length > 0)
	{
		//`log("Setting RightTarget to"@RightTarget[0]);
		if (RightTarget[0].IsA('Controller'))
			RightTarget[0] = Controller(RightTarget[0]).Pawn;
		TPAssaultBlimpController(Controller).Spotlight_R_LookTarget = Actor(RightTarget[0]);
	}

	if (LeftTarget.Length > 0)
	{
		//`log("Setting LeftTarget to"@LeftTarget[0]);
		if (LeftTarget[0].IsA('Controller'))
			LeftTarget[0] = Controller(LeftTarget[0]).Pawn;
		TPAssaultBlimpController(Controller).Spotlight_L_LookTarget = Actor(LeftTarget[0]);
	}
}

function OnSetSpotlightAttackTargets(SeqAct_SetSpotlightAttackTargets Action)
{
	local array<Object> RightTarget, LeftTarget;
	Action.GetObjectVars(RightTarget,"Right Attack Target");
	Action.GetObjectVars(LeftTarget,"Left Attack Target");

	if (RightTarget.Length > 0)
	{
		//`log("Setting RightTarget to"@RightTarget[0]);
		if (RightTarget[0].IsA('Controller'))
			RightTarget[0] = Controller(RightTarget[0]).Pawn;
		Attractor_R.Target = Actor(RightTarget[0]);
	}

	if (LeftTarget.Length > 0)
	{
		//`log("Setting LeftTarget to"@LeftTarget[0]);
		if (LeftTarget[0].IsA('Controller'))
			LeftTarget[0] = Controller(LeftTarget[0]).Pawn;
		Attractor_L.Target = Actor(LeftTarget[0]);
	}
}

function OnSetSpotlightBehavior(SeqAct_SetSpotlightBehavior Action)
{
	SetNewSpotlightBehavior(Action.NewSpotlightBehavior);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	//`log("OMG I'M DYINGGGG!");
	bReplicateMovement = false;
	bTearOff = true;
	bPlayedDeath = true;
	GotoState('Dying');
}

function OnSetSpotlightSpeed(SeqAct_SetSpotlightSpeed Action)
{
	m_SpotlightSearchSpeed=Action.SearchSpeed;
	m_SpotlightSeekSpeed=Action.SeekSpeed;
}

State Dying
{
	function BeginState(Name PreviousStateName)
	{
		//`log("Starting dying state!");
		DetachFromController();
		SpawnDeathExplosion();
		SetTimer(1, false, 'SpawnDeathExplosion');
		SetTimer(1.5, false, 'StartDeathFire');
		SetTimer(25, false, 'FinishDeath');
	
		if (Attractor_L != None)
		{
			Attractor_L.Destroy();
			SpotlightCone_L.Destroy();
			Spotlight_L.SetEnabled(false);
			Sourcelight_L.SetEnabled(false);
			SpotlightFlareEmitter_L.ParticleSystemComponent.DeactivateSystem();
			SpotlightFlareEmitter_L.ParticleSystemComponent.KillParticlesForced();
			SpotlightFlareEmitter_L.Destroy();
		}

		if (Attractor_R != None)
		{
			Attractor_R.Destroy();
			SpotlightCone_R.Destroy();
			Spotlight_R.SetEnabled(false);
			Sourcelight_R.SetEnabled(false);
			SpotlightFlareEmitter_R.ParticleSystemComponent.DeactivateSystem();
			SpotlightFlareEmitter_R.ParticleSystemComponent.KillParticlesForced();
			SpotlightFlareEmitter_R.Destroy();
		}
	}

	simulated function SpawnDeathExplosion()
	{
		local EmitterSpawnable emitter;
		local Vector explOffset;

		explOffset.X = rand(8000) / 10.0f;
		explOffset.Y = rand(8000) / 10.0f;
		explOffset.Z = rand(8000) / 10.0f;

		emitter = Spawn( class'EmitterSpawnable', , , Location + explOffset);
		emitter.SetTemplate( DeathExplTemplate, true );
		emitter.bDestroyOnSystemFinish = true;
		emitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0f;
		emitter.ParticleSystemComponent.ActivateSystem();
		PlaySound(DeathExplSound);
	}

	simulated function FinishDeath()
	{
		if(!bNoDeleteOnDeath)
            Destroy();
	}

	simulated function FinishExplosions()
	{
		ClearTimer('SpawnDeathExplosion');
	}

	simulated function StartDeathFire()
	{
		local EmitterSpawnable emitter;

		emitter = Spawn( class'EmitterSpawnable' );
		emitter.SetTemplate(DeathFireTemplate, true );
		Mesh.AttachComponentToSocket(emitter.ParticleSystemComponent,'Hangar_4L');
		emitter.bDestroyOnSystemFinish = true;
		emitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0f;
		emitter.ParticleSystemComponent.ActivateSystem();
		
		if (TurbineExh_L != None)
		{
			TurbineExh_L.ParticleSystemComponent.DeactivateSystem();
			TurbineExh_L.ParticleSystemComponent.KillParticlesForced();
			TurbineExh_L.Destroy();
		}

		if (TurbineExh_R != None)
		{
			TurbineExh_R.ParticleSystemComponent.DeactivateSystem();
			TurbineExh_R.ParticleSystemComponent.KillParticlesForced();
			TurbineExh_R.Destroy();
		}
		
		if (SideExh_L != None)
		{
			SideExh_L.ParticleSystemComponent.DeactivateSystem();
			SideExh_L.ParticleSystemComponent.KillParticlesForced();
			SideExh_L.Destroy();
		}

		if (FrontExh_L != None)
		{
			FrontExh_L.ParticleSystemComponent.DeactivateSystem();
			FrontExh_L.ParticleSystemComponent.KillParticlesForced();
			FrontExh_L.Destroy();
		}

		if (SideExh_R != None)
		{
			SideExh_R.ParticleSystemComponent.DeactivateSystem();
			SideExh_R.ParticleSystemComponent.KillParticlesForced();
			SideExh_R.Destroy();
		}

		if (FrontExh_R != None)
		{
			FrontExh_R.ParticleSystemComponent.DeactivateSystem();
			FrontExh_R.ParticleSystemComponent.KillParticlesForced();
			FrontExh_R.Destroy();
		}
	}
}



