class WehrmachtPawn extends TPPawn
    dependson(TPGear)
	placeable
	native
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 11

//***********************************************************************
// DEFINES
//***********************************************************************



var() eWehrmachtStartStates StartState;


var(Squad) eTPSquad_Enemy SquadAssignment;

var config float DefaultMovementTypeGroundSpeed;


var SkeletalMesh HelmetMesh;
var bool bHideHelmetMesh;
var PhysicsAsset HelmetPhysics; 
var int HelmetGearIndex;
 
var StaticMesh KnifeMesh;
var Name KnifeSocket;

var StaticMesh CanteenMesh;
var Name CanteenSocket;

var StaticMesh GasMaskMesh;
var Name GasMaskSocket;

var StaticMesh LugerHolsterMesh;
var Name LugerHolsterSocket;

var StaticMesh AmmoPackMesh;
var Name AmmoPackSocket;

var SkelControlSingleBone HatControl;
var config int GrenadeChance;
var config int CanteenChance;

// Used for weapon notify firing to accurately aim at the player
var bool bAccuratePerformanceFire;

var bool bCannotGrapple;
var bool bAlwaysBreaksGrapple;
var bool bNoHumanShield;

native function	TargetDown();


//-----------------------------------------------------------------------
// Function:
// Description:	Each Pawn type should override this.
//				Returns the index to the Pawn's SPTeamInfo pre-defined
//				squad names array.
//				This index is then passed into
//				SPTeamInfo.GetPreDefinedSquadName() function to get the
//				actual name string.
//-----------------------------------------------------------------------
function int GetSquadNameIndex()
{
	local int squadNameIdx;

	squadNameIdx = SquadAssignment;
	return squadNameIdx;
}



function Name GetStartStateName()
{
	local string statename;
	if( StartStateName == 'None' )
	{
		//Get the name directly from the enum...
		statename = statename $ StartState;
		StartStateName = name(statename);
	}

	//Removing TPPatrol!
	if( StartStateName == 'TPPatrol' )
	{
		StartStateName = 'Idle';
	}


	return StartStateName;
}

function DetachHat()
{
	if( Gear.Length > HelmetGearIndex )
	{
		Gear[HelmetGearIndex].Hide(false);
        HatControl.BoneScale = 0.0;
        Gear[HelmetGearIndex].DetachNow(self);
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local int i;
	local float Time;

	bReplicateMovement = false;
	bTearOff = true;
	//Velocity += TearOffMomentum;
	//SetPhysics(PHYS_Falling);
	TurnOffHitReaction();
	bPlayedDeath = true; // this is what triggers TPAnimNodeDeadOrAlive

	for(i = 0; i < Gear.Length; i++) 
	{
		// Don't remove hat yet
		if( i == HelmetGearIndex )
			continue;

		Gear[i].DetachNow(self);
	}

	/* moving death anim/ragdoll to the anim tree
	if (DamageType != class'TPDamageTypeImpact')
	{
		Time = frand();
		SetTimer(Time,,'DetachHat');
		GotoState('Dying');
	}
	else
	{
		DetachHat();
		KilledByExplosion();
	}
	*/

	if( Controller != None )
	{
		if (!TPSoldierAIController(Controller).GrappleKilled())
		{
			Time = frand();
			SetTimer(Time,,'DetachHat');
		}
	}

	GotoState('Dying');

}

/* moving death anim/ragdoll to the anim tree
function KilledByExplosion()
{
	local int i;

	if ( Controller != None )
	{
		if ( Controller.bIsPlayer )
		{
			CopyCoverInfo();
			DetachFromController();
		}
		else
		{
			Controller.Destroy();
		}
	}

	for (i = 0; i < Attached.length; i++)
		if (Attached[i] != None)
			Attached[i].PawnBaseDied();

	TurnOffHitReaction();
	Mesh.SetBlockRigidBody(true);
	SetCollision(false,true);
	InitRagdoll();
	LifeSpan = 20;

	//Mesh.SetAnimTreeTemplate(None); // @hack Prevent skirt jitter
}
*/
event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation,
						Vector momentum, class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (Controller != None && TPSoldierAIController(Controller).IsInState('Grapple_v2') && damageType != class'TPDamageTypeGrapple')
        return;  // Don't allow hit reaction, dying, etc... if grappling

    Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser);
}


State Dying
{

	//SPMIRROR - overriding BeginState to eliminate destroy timer, just destroy right away.
	function BeginState(Name PreviousStateName)
	{
		local int i;

		if ( Controller != None )
		{
            if (Controller.IsInState('Rappelling') && TPAssaultBlimp_Persistent(Blimp) != None)
            {
                // Ensure rope gets pulled back up
                TPAssaultBlimp_Persistent(Blimp).NotifyLand(self);
            }

			if ( Controller.bIsPlayer )
			{
				CopyCoverInfo();
				DetachFromController();
			}
			else
			{
				Controller.Destroy();
			}
		}

		for (i = 0; i < Attached.length; i++)
			if (Attached[i] != None)
				Attached[i].PawnBaseDied();

		Mesh.StopFaceFXAnim();
		TargetDown();
	}

Begin:
    // force these to finish
	if (IsPlayingPerformance())
	{
		FinishPerformance();
		HatControl = SkelControlSingleBone(Mesh.FindSkelControl('HatControl'));
	}

	FinishSceneAnimation(0.0);

    if (FreezeTime > 0)
    {
        Sleep(FreezeTime);

        Mesh.bUpdateKinematicBonesFromAnimation=false;
	    Mesh.bUpdateJointsFromAnimation=false;
        Mesh.bPauseAnims=TRUE;

        SetPhysics(PHYS_None);
    }

	Sleep(DestroyTime - FreezeTime);
	if( Gear.Length > HelmetGearIndex )
		Gear[HelmetGearIndex].DestroyMe(); // Ensure cleanup
	Destroy ( );
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().WehrmachtMoveData );

    HatControl = SkelControlSingleBone(Mesh.FindSkelControl('HatControl'));
}


function InitGear()
{
	InitStaticGear();
	InitDroppableGear();
}


function InitStaticGear()
{
	local int gearSet;
    local int gearIndex;
    local TPGear.GearInfoType Gi;

    gearIndex = Gear.Length;



	//randomize between 3 sets for now...
	gearSet = Rand(3);

	//`log(self @ "Picking Gear set" @ gearSet);

	switch(gearSet)
	{
		case 0:
			Gi.StaticMeshName = KnifeMesh;
			Gi.SocketName = KnifeSocket;
			Gi.DetachUponDeath = false;
			Gear[gearIndex] = Spawn(class'TPGear');
			Gear[gearIndex].AttachTo(self, Gi);
			gearIndex++;


			Gi.StaticMeshName = GasMaskMesh;
			Gi.SocketName = GasMaskSocket;
			Gi.DetachUponDeath = false;
			Gear[gearIndex] = Spawn(class'TPGear');
			Gear[gearIndex].AttachTo(self, Gi);
			gearIndex++;

			Gi.StaticMeshName = LugerHolsterMesh;
			Gi.SocketName = LugerHolsterSocket;
			Gi.DetachUponDeath = false;
			Gear[gearIndex] = Spawn(class'TPGear');
			Gear[gearIndex].AttachTo(self, Gi);
			gearIndex++;

			break;

		case 1:
			Gi.StaticMeshName = KnifeMesh;
			Gi.SocketName = KnifeSocket;
			Gi.DetachUponDeath = false;
			Gear[gearIndex] = Spawn(class'TPGear');
			Gear[gearIndex].AttachTo(self, Gi);
			gearIndex++;

			Gi.StaticMeshName = LugerHolsterMesh;
			Gi.SocketName = LugerHolsterSocket;
			Gi.DetachUponDeath = false;
			Gear[gearIndex] = Spawn(class'TPGear');
			Gear[gearIndex].AttachTo(self, Gi);
			gearIndex++;

			break;

		case 2:
			Gi.StaticMeshName = AmmoPackMesh;
			Gi.SocketName = AmmoPackSocket;
			Gi.DetachUponDeath = false;
			Gear[gearIndex] = Spawn(class'TPGear');
			Gear[gearIndex].AttachTo(self, Gi);
			gearIndex++;

			Gi.StaticMeshName = GasMaskMesh;
			Gi.SocketName = GasMaskSocket;
			Gi.DetachUponDeath = false;
			Gear[gearIndex] = Spawn(class'TPGear');
			Gear[gearIndex].AttachTo(self, Gi);
			gearIndex++;

			break;
	}

}

function InitHelmet()
{
    local TPGear.GearInfoType Gi;
    local int gearIndex;

    gearIndex = Gear.Length;


    Gi.SkeletalMeshName  = HelmetMesh;
    Gi.PhysicsAssetName  = HelmetPhysics;
    
    Gi.DetachUponDeath   = true;
    Gi.SocketName        = 'Helmet';

	HelmetGearIndex = gearIndex;
	
    Gear[gearIndex] = Spawn(class'TPGear');
    Gear[gearIndex].AttachTo(self, Gi);
    Gear[gearIndex].Hide(bHideHelmetMesh);


}

function InitDroppableGear()
{
	local int chance;
    local int gearIndex;
    local TPGear.GearInfoType Gi;
    local int i;

    gearIndex = Gear.Length;


	InitHelmet();
	
	

	//Grenades
    chance = Rand(GrenadeChance);
    
	if (chance == 0 )
	{
        // Detach anything on the knife socket since grenade occupies
		for(i=0; i<Gear.Length; i++)
		{
			if( Gear[i].SockName == KnifeSocket )
			{
				Mesh.DetachComponent( Gear[i].GetComponent() );
			}
		}		

		Gi.Inv             =  class<Weapon>(FindObject("TPGameContent.Grenade", class'Class'));; //SPLITSCRIPTS_TODO - this will be broken until pawns get split into content package
		Gi.SocketName      = 'Gear_grenade';
		Gi.DetachUponDeath = true;

		if (Gi.Inv != None)
		{
			Gear[gearIndex] = Spawn(class'TPGear');
			Gear[gearIndex].AttachTo(self, Gi);
		}
        
        gearIndex++;
	}

	//Canteen
    chance = Rand(CanteenChance);

   if (chance == 0 )
    {
        Gi.Inv             = class'TPHealthItemCanteen';
        Gi.SocketName      = 'Canteen';
        // Don't let the player snag our canteens!
        Gi.DetachUponDeath = false;

        Gear[gearIndex] = Spawn(class'TPGear');
        Gear[gearIndex].AttachTo(self, Gi);
        gearIndex++; 
    }
}

function OnSetGrappleable(SeqAct_SetGrappleable action)
{
    switch(action.Grappleable)
    {
    case NotGrappleable:
        bCannotGrapple       = true;
        bAlwaysBreaksGrapple = false;
        break;
    case AlwaysBreaks:
        bCannotGrapple       = false;
        bAlwaysBreaksGrapple = true;
        break;
    case Grappleable:
    default:
        bCannotGrapple       = false;
        bAlwaysBreaksGrapple = false;
        break;
    }

    bNoHumanShield = action.bNoHumanShield;
}

event TPPawn GetEnemyToPlayFFXOn()
{
	local	float			radius;
	local	vector			PlayerToEnemy;
	local	float			currDist;
	local	float			bestDist;
    local	PartisanPawn	currPawn;
    local	PartisanPawn	bestPawn;

	radius = class'TPTuneManager'.static.Get().GetTuneData().FaceFXTuneData.PlayOnOtherPawnMaxDist;

	bestDist	= radius;
	bestPawn	= None;

	ForEach VisibleActors( class'PartisanPawn', currPawn, radius )
    {
		if ( currPawn == self )
			continue;

		// Ensure that the pawn isn't without a controller (e.g. when manning a turret)
		if ( currPawn.Controller == None )
			continue;

		if ( currPawn.Health <= 0 )
			continue;

		if ( currPawn.Mesh == None )
			continue;

		PlayerToEnemy = currPawn.Location - Location;

		currDist = VSize(PlayerToEnemy);

		if ( currDist < bestDist )
		{
			bestDist	= currDist;
			bestPawn	= currPawn;
		}
	}

	return ( bestPawn );
}

