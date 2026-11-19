//class TPBaseVehicle extends SVehicle
class TPBaseVehicle extends KynapseSVehicle
					abstract
					native;

var(DestructComponent) const editconst SPActorDestructComponent	DestructComponent;

var() const editconst LightEnvironmentComponent LightEnvironment;

var(AI) bool bTargettable;					// Whether or not this vehicle can be targetted
var     bool bSpawnVehicleFeeler;           // Whether or not to spawn a vehicle feeler for this vehicle
var VehicleFeeler Feeler;					// Feeler for the Vehicle to check for stopping if someone is in the way.
var vector FeelerOffset;					// Offset for the Feeler to be placed at

var() bool bCanBePlayerDriven;

struct native VehicleEffect
{
	var name SocketName;					// Name of the Socket for the Exhaust to attach to
	var	ParticleSystem EffectTemplate;		// Template for the Emitter
	var ParticleSystemComponent EffectRef;	// Particle System Component
};

var array<VehicleEffect> VehicleEffects;



// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native noexport function AddAnimSets( array<AnimSet> AnimSets);

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

    if (bSpawnVehicleFeeler)
    {
	    Feeler = spawn(class'VehicleFeeler',self,,Location+(FeelerOffset >> Rotation), Rotation);
	    Feeler.SetBase(self);
	    Feeler.SetHardAttach(true);
    }

	if (DestructComponent != none)
		Health = DestructComponent.HitPoints;

	AttachEffects();
}

function AttachEffects()
{
	local int i;
	local EmitterSpawnable E;
	for (i = 0; i < VehicleEffects.Length; i++)
	{
		E = spawn(class'EmitterSpawnable');
		E.SetTemplate( VehicleEffects[i].EffectTemplate, false);
		VehicleEffects[i].EffectRef = E.ParticleSystemComponent;
		
		Mesh.AttachComponentToSocket(VehicleEffects[i].EffectRef, VehicleEffects[i].SocketName);
	}
}

// Make it impossible for Human Players to get inside of the vehicles if !bCanBePlayerDriven
// Only AI players can get in. 
function bool DriverEnter(Pawn P)
{
	if( PlayerController(P.Controller) != None && !bCanBePlayerDriven)
		return false;
	
	super.DriverEnter(P);

	return true;
}

event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local bool CanDamage;
    local TPPlayerController TPPC;
	
	
	if (DestructComponent != None)
	{
		CanDamage = DestructComponent.CanDoDamageType(damageType);
	}
	else
	{
		CanDamage = true;
	}
	
	if (IsA('TPAssaultBlimp_Persistent') && bTargettable)
	{
		CanDamage = true;
	}

	if (CanDamage)
	{
        TPPC = TPPlayerController(InstigatedBy);
        if (TPPC != None)
            TPHUD(TPPC.myHUD).ReticleIndicationUpdate();

		//`log("vech damage: before super.TakeDamage" @ Health @ Damage);
		super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
		//`log("vech damage: after super.TakeDamage" @ Health @ Damage);
	}
}

function OnPlaySceneAnimation(SeqAct_PlaySceneAnimation action)
{
	local TPAnimSceneTemplateNode sceneNode;
	
	sceneNode = TPAnimSceneTemplateNode(Mesh.Animations.FindAnimNode('SceneTemplateNode'));
	if (sceneNode == None)
	{
		;
		return;
	}

	SetPhysics(PHYS_None);
	Mesh.bForceDiscardRootMotion = false;
	sceneNode.PlayNewScene(action.m_animSeqName, action.m_playCount, action, 0.25/*SP_DEFAULT_BLENDTIME*/);
	//Mesh.PlayAnim(action.m_animSeqName);
}

function OnEndSceneAnimation(SeqAct_EndSceneAnimation action)
{
	Mesh.bForceDiscardRootMotion = true;
	SetPhysics(PHYS_RigidBody);
}

//----------------------------------------------------------------------
// KISMET
// Description: Toggles enemy targeting on pawns
//---------------------------------------------------------------------

function onTargettable(SeqAct_Targettable action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
        bTargettable = true;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bTargettable = false;
	}
	else
	{
	    bTargettable = !bTargettable;
	}
}

// Added to not damage players when touched
function bool EncroachingOn(Actor Other)
{
	local controller InstigatorController;
	local Pawn P;
	local vector PushVelocity;
	
	if (Health <= 0)
	{
		P = Pawn(Other);
		if ( P == None )
			return false;

		if ( Other == Instigator || (Vehicle(Other) != None) || Other.Role != ROLE_Authority || (!Other.bCollideActors && !Other.bBlockActors)
			|| VSize(Velocity) < MinCrushSpeed )
		{
			if ( (P.Velocity Dot (Location - P.Location)) > 0 )
			{
				// push away other pawn
				PushVelocity = Normal(P.Location - Location) * 200;
				PushVelocity.Z = 100;
				P.AddVelocity(PushVelocity, Location, CrushedDamageType);
			}
			return false;
		}

		// If its a non-vehicle pawn, do lots of damage.
		InstigatorController = Controller;
		if ( (InstigatorController == None) && (Instigator != None) )
			InstigatorController = Instigator.Controller;

		//SPARK CODEDROP - no more Mass in actor?
		//Other.TakeDamage(10000, InstigatorController, Other.Location, Velocity * Other.Mass, CrushedDamageType);
		Other.TakeDamage(10000, InstigatorController, Other.Location, Velocity , CrushedDamageType);
	}
		return false;
	}

simulated event Destroyed()
{
	DetachFromController(true);

	if ( WorldInfo.NetMode == NM_Client )
		return;

	if ( InvManager != None )
		InvManager.Destroy();

	// Clear anchor to avoid checkpoint crash
	SetAnchor( None );

	Weapon = None;

	super.Destroyed();
	if (Driver != none)
		Destroyed_HandleDriver();
	if (Feeler != none)
		Feeler.Destroy();	
}

function OnVehicleSpeedModifier(SeqAct_VehicleSpeedModifier action)
{
	local int i;

	// Error check the speed modifier
	if (action.Speed <= 0)
	{
		;
		return;
	}
	// Loop through the Torque Variables
	for (i = 0; i < TPSVehicleSimCarTransmission(SimObj).TorqueCurve.Points.Length; i++)
	{
		TPSVehicleSimCarTransmission(SimObj).TorqueCurve.Points[i].InVal *= action.Speed;
		TPSVehicleSimCarTransmission(SimObj).TorqueCurve.Points[i].OutVal *= action.Speed;	
	}
	// Set the Max Speed to something ridiculously high to account for speed mods
	MaxSpeed = 5000;
}

function OnAttachNPCToAPC_Gun(SeqAct_AttachNPCToAPC_Gun Action)
{
	local int			idx;
	local Actor			Attachment;
	local TPAIController	tpNPCaiCon;
	local Array<Object> ObjVars;
	local TPNaziAPCMGController	apcCon;
	local TPPawn thepawn;

	Action.GetObjectVars(ObjVars,"Attachment");

    // SPARK CHANGE! Why 'Attachment == None' ?!
    //for( idx=0; idx<ObjVars.Length && Attachment == None; idx++ )
    for( idx=0; idx<ObjVars.Length; idx++ )
	{
		Attachment = Actor(ObjVars[idx]);

		// Attachment is the NPC now see if it is the pawn or the controler

		// If its a player variable, attach the Pawn, not the controller
		tpNPCaiCon = TPAIController(Attachment);

		if( tpNPCaiCon == None )
		{
			thepawn = TPPawn(Attachment);
			if( thepawn != None )
			{
				tpNPCaiCon = TPAIController(thepawn.Controller);
			}
		}
		else
		{
			thepawn = TPPawn(tpNPCaiCon.Pawn);
		}

		if( tpNPCaiCon != None && tpNPCaiCon.Pawn != None && TPPawn(tpNPCaiCon.Pawn) != None )
		{
			thepawn.m_bNPC_IsVehicleTurretGunner = true;
			tpNPCaiCon.DoToggleAI(false);
			//Attachment = C.Pawn;

			thepawn.SetPhysics(PHYS_None);

			thepawn.bTargettable = Action.bAllowTheGunnerToBeTargetedByOtherNPCs;

			if( Action.bHideNPCsWeapon )
			{
				thepawn.HideWeapon(true);
			}
		}
		else
		{
			//`log(" ChadAI - APC: " @ self @" Not able to make the Attachment into a TPAIController - it is a: " @ Attachment @ " --------------------------------------------------------------------------------------------");
		}

		apcCon = TPNaziAPCMGController(Controller);
		if( apcCon != None )
		{
			apcCon.m_APC.m_TurretSpeed=Action.TurretSpeed;
			apcCon.m_APC.m_TurretProjectileSpeed=Action.TurretProjectileSpeed;
			apcCon.m_APC.m_TurretProjectileDamage=Action.TurretProjectileDamage;
			apcCon.m_APC.m_TurretProjectileMomentum=Action.TurretProjectileMomentum;

			apcCon.m_FireCooldown=Action.FireCooldown;
			apcCon.m_OverheatTime=Action.OverheatTime;
			apcCon.m_APC.m_OverheatCoolDownTime=Action.OverheatCoolDownTime;
			apcCon.m_AimAccuracyOffset=Action.AimAccuracyOffset;
		}
		else
		{
			//`log(" ChadAI - APC: " @ self @" Not able to make the APC Controller into a TPNaziAPCMGController - it is a: " @ Controller @ " --------------------------------------------------------------------------------------------");
		}
	}

	Super.OnAttachToActor(Action);
}


