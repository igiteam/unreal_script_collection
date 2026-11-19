// Deprecated - Blame Steve if it breaks!
class TPSearchLight extends Actor
	deprecated;
/*	placeable;


var SkeletalMeshComponent       Mesh;

var PlayerPawn                  Player;

var TPNaziAttractorCone         AttractorCone;
var SpotlightInterpActor        SpotLightInterpCone;
var SpotLightComponent			SpotLight;
var PointLightComponent			SourceLight; 

var Emitter	                    SpotlightFlareEmitter;
var ParticleSystem	            SpotlightFlareTemplate;

var TPSkelControlPlayerPitch    skel_SearchLightPitch;
var TPSkelControlPlayerYaw      skel_SearchLightYaw; 

var float					    SpotlightSeekSpeed;
var Actor                       CurrTarget;

var() bool                      bSearchLightActive;
var() int                       Health;

var   EmitterSpawnable          E;
var() ParticleSystem            DestroyedSparksParticle;



simulated function PostBeginPlay()
{    	
    super.PostBeginPlay();  
    
    skel_SearchLightPitch = TPSkelControlPlayerPitch(Mesh.FindSkelControl('SearchLightPitch'));
	skel_SearchLightPitch.SetSkelControlActive(true);
	skel_SearchLightPitch.ControlStrength = 1.0;

	skel_SearchLightYaw = TPSkelControlPlayerYaw(Mesh.FindSkelControl('SearchLightYaw'));
	skel_SearchLightYaw.SetSkelControlActive(true);
	skel_SearchLightYaw.ControlStrength = 1.0;

	Mesh.AttachComponentToSocket(SpotLight, 'SearchLightSocket');
	SpotLight.SetEnabled(true);
	Mesh.AttachComponentToSocket(Sourcelight, 'SearchLightSocket');
	Sourcelight.SetEnabled(true);
	
	// attach nazi attractor
	AttractorCone = Spawn(class'TPNaziAttractorCone', self);
	if (AttractorCone != None)
	{
		AttractorCone.SetBase(self,, Mesh, 'SearchLightSocket');
		AttractorCone.SetAngle(SpotLight.OuterConeAngle - 1.0f);
		AttractorCone.SetRadius(SpotLight.Radius);
		AttractorCone.bCheckSight = true;
	}

	SpotLightInterpCone = Spawn(class'SpotlightInterpActor');
	SpotLightInterpCone.SetBase(self,, Mesh, 'SearchLightSocket');
	if (SpotlightFlareTemplate != None)
	{
		SpotlightFlareEmitter = spawn(class'EmitterSpawnable');
		SpotlightFlareEmitter.ParticleSystemComponent.bAutoActivate = false;
		SpotlightFlareEmitter.bDestroyOnSystemFinish = false;
		Mesh.AttachComponentToSocket(SpotlightFlareEmitter.ParticleSystemComponent,'SearchLightSocket');

		SpotlightFlareEmitter.SetTemplate(SpotlightFlareTemplate, false);
		SpotlightFlareEmitter.ParticleSystemComponent.ActivateSystem();
	}    
}

// Toggles on/off spotlight
simulated function OnToggle(SeqAct_Toggle Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		SpotLight.SetEnabled(true);
		SourceLight.SetEnabled(true);
	}
	else if(Action.InputLinks[1].bHasImpulse)
	{
		SpotLight.SetEnabled(false);
		SourceLight.SetEnabled(false);
	}
}


function KismetTriggerAlertedEvent(Actor Target)
{
    self.TriggerEventClass(class'SeqEvent_SearchlightAcquiredTarget', Target, 0);
}

simulated function SpotlightSeekTargetBehavior(float DeltaTime)
{
	local Vector myLoc;
	local Rotator myRot;
	local Vector X, Y, Z;
	local Vector LookTarget;
	local float myAngle;
	local float myDir;
	local Rotator actualRot;
	local float Threshold;
	local Vector PlayerX, PlayerY, PlayerZ;
	local Rotator EyeRot;
	local float BlindAngle;

	Threshold = 0.05f;
	BlindAngle = -0.92f;

	//grab our current "look" vector
	Mesh.GetSocketWorldLocationAndRotation('SearchLightSocket', myLoc, actualRot);

	if (!AttractorCone.Encompasses(Player.Location))
	{
		if (CurrTarget == None)
			CurrTarget = Player;

		if (CurrTarget != None)
		{
			myRot = actualRot;
			myRot.Pitch = 0;
			GetAxes(myRot, X, Y, Z);
			//DrawDebugLine(myLoc, myLoc + X * 5000.0f, 0,255,0);

			//now construct a vector from me to the player
			LookTarget = Normal((CurrTarget.Location - myLoc)*(vect(1.0f, 1.0f, 0.0f)));
			//DrawDebugLine(myLoc, myLoc + LookTarget * 5000.0f, 255,0,0);
			
			myAngle = Y dot LookTarget;
			if (abs(myAngle) > Threshold)
			{
				if (myAngle < 0)
					myDir = -1.0f;
				else
					myDir = 1.0f;

				skel_SearchLightYaw.BoneRotation.Yaw += myDir*SpotlightSeekSpeed*DeltaTime;
			}

			//grab our current "look" vector
			myRot = actualRot;
			//myRot.Yaw = 0;
			GetAxes(myRot, X, Y, Z);
			//DrawDebugLine(myLoc, myLoc - X * 5000.0f, 0,255,0);

			//now construct a vector from me to the player
			LookTarget = Normal((CurrTarget.Location - myLoc)*(vect(1.0f, 1.0f, 1.0f)));
			//DrawDebugLine(myLoc, myLoc + LookTarget * 5000.0f, 255,0,0);

			myAngle = Z dot LookTarget;
			if (abs(myAngle) > Threshold)
			{
				if (myAngle > 0)
					myDir = 1.0f;
				else
					myDir = -1.0f;
				
				skel_SearchLightPitch.BoneRotation.Pitch += myDir*SpotlightSeekSpeed*DeltaTime;
			}
		}
	}
	else
	{
		if (Player != None && !Player.bPlayerBlinded)
		{
			myRot = actualRot;
			GetAxes(myRot, X, Y, Z);
			
			//check to see if we should flare the player
			PlayerController(Player.Controller).GetPlayerViewPoint(PlayerX, EyeRot);
			GetAxes(EyeRot, PlayerX, PlayerY, PlayerZ);
			myAngle = PlayerX dot X;
			if (myAngle < BlindAngle)
			{
				Player.TemporarilyBlindPlayer(myAngle);
			}
		}
		CurrTarget = Player;
	}
}

function FindPlayer()
{
    if (Player != None)
        return;  // Already found

    foreach AllActors(class'PlayerPawn', Player)
    {
        if (Player.IsA('PlayerPawn'))
            break;
        else
            Player=None;
    }
}

auto state SearchLightSweep
{
    function DestroyLightBeams()
    {
        if (AttractorCone != None)
	    {
		   AttractorCone.Destroy();
		   SpotLightInterpCone.Destroy();
		   SpotLight.SetEnabled(false);
		   SourceLight.SetEnabled(false);
		   SpotlightFlareEmitter.ParticleSystemComponent.DeactivateSystem();
		   SpotlightFlareEmitter.ParticleSystemComponent.KillParticlesForced();
		   SpotlightFlareEmitter.Destroy();
	    }
	}
    
    function SpawnDeathSparks()
    {
        local vector socketlocation;
	    if (DestroyedSparksParticle != none)
	    {
		   mesh.GetSocketWorldLocationAndRotation('SearchLightSocket', socketlocation);
           E = Spawn(class'EmitterSpawnable',,,socketlocation,rot(0,0,0));   //Location + vect(0.0f, 0.0f, 176.0f)
		   E.SetTemplate( DestroyedSparksParticle, true);
		   E.ParticleSystemComponent.ActivateSystem();
		   SetTimer(2.5,false,'StopDeathSparks');
		}
	}
	
	function StopDeathSparks()
	{
	    E.ParticleSystemComponent.DeactivateSystem();
	}
    
    event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
	   if(!bSearchLightActive && Health <= 0)
	       return;
	       
       Super(Actor).TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType,HitInfo,DamageCauser);
	   Health -= Damage;
	   if (Health <= 0)
	   {
		  Health = 0;
		  bSearchLightActive=false;
		  // activate death events
	      TriggerEventClass( class'SeqEvent_Death', self );
		  SpawnDeathSparks();
		  DestroyLightBeams();
	   }
    }
    
    function Tick (float DeltaTime)
    {
		if(bSearchLightActive && Health > 0)
		{            
            if(Player != none)
		        SpotlightSeekTargetBehavior(DeltaTime);
		    else
		        FindPlayer();
		}
    }    
}

function OnSetSearchLightLookTargets(SeqAct_SetSearchLightLookTargets Action)
{
	local array<Object> RightTarget;
	Action.GetObjectVars(RightTarget,"Look Target");

	if (Action.InputLinks[0].bHasImpulse)
    {
       bSearchLightActive = true;
       if (RightTarget.Length > 0)
	   {
		  //`log("Setting RightTarget to"@RightTarget[0]);
		  if (RightTarget[0].IsA('Controller'))
		      RightTarget[0] = Controller(RightTarget[0]).Pawn;
		  CurrTarget = Actor(RightTarget[0]);
	   }
	}
	else if(Action.InputLinks[1].bHasImpulse)
	{
	   bSearchLightActive = false;
	}
}

defaultproperties
{
    Health=10

	Begin Object Class=SkeletalMeshComponent Name=TPSearchLightMesh
	    SkeletalMesh=SkeletalMesh'PROP_searchlight.Mesh.PROP_searchlight'
		AnimTreeTemplate=AnimTree'PROP_searchlight.PROP_searchlight_AnimTree'
		PhysicsAsset=PhysicsAsset'PROP_searchlight.Mesh.PROP_searchlight_Physics'
		LightEnvironment=None
	End Object
	CollisionComponent=TPSearchLightMesh
	Mesh=TPSearchLightMesh
	Components.Add(TPSearchLightMesh)

	Begin Object Class=SpotLightComponent Name=SpotLightComponent0
		Begin Object Class=LightFunction Name=LightFunction0
		End Object
		Function=LightFunction0
        bEnabled=false
        Brightness=10
        InnerConeAngle=4
        OuterConeAngle=12
        Radius=5000
		FalloffExponent=8
    End Object
    SpotLight=SpotLightComponent0
    Components.Add(SpotLightComponent0)
	
	Begin Object Class=PointLightComponent Name=PointLightComponent0
		Brightness=20
		bEnabled=false
        Radius=50
		LightColor=(R=255,G=255,B=255,A=255)
    End Object
    SourceLight=PointLightComponent0
	Components.Add(PointLightComponent0)
	
	SpotlightFlareTemplate=ParticleSystem'FX_ENV_lghtBeam.Particle.FX_ENV_cneLightGlo'
	DestroyedSparksParticle=ParticleSystem'FX_ENV_elevatr_sprks.Particles.FX_ENV_fountain_sprksA_Single'
	
	SpotlightSeekSpeed=2500
	bSearchLightActive=true
	
	

}*/
