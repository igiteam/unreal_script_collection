class TPDroppedPickup extends DroppedPickup
								placeable
								nativereplication
								native;

var transient ActorComponent    ActorComp;
var CylinderComponent CylinderComp;
var() int AmmoCount;

var() SoundCue PickupSound;
var	  SoundCue DroppedSound;
var() float RespawnTime;		// If RespawnTime == 0, then the pickup doesnt respawn.

var native const RigidBodyState RBState;
var	native const float			AngErrorAccumulator;
var class<Inventory> TPSPInventoryClass;

var bool bPlacedInLevel;
var bool bSoundPlayed;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
	if ( Role == ROLE_Authority )
		RBState;
}

function Reset()
{
	if (!bPlacedInLevel)
		Destroy();
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	
	if (WorldInfo.NetMode == NM_Standalone)
	{
		if (Role == Role_Authority && AmmoCount > 0)
		{
			//`log("SPAWNED "@self);
			Inventory = Spawn(TPSPInventoryClass);
			TPWeapon(Inventory).AmmoCount = AmmoCount;

			if(AmmoCount > TPWeapon(Inventory).AmmoInMagazine)
				TPWeapon(Inventory).AmmoInMagazine = TPWeapon(Inventory).MagazineSize;
			else
				TPWeapon(Inventory).AmmoInMagazine = AmmoCount;

			TPWeapon(Inventory).AmmoCount -= TPWeapon(Inventory).AmmoInMagazine;
		}
		else
		{
			if (Instigator == none)
			{
				//`log("No Ammo for placed item: "@self@".  Destroying Placed Pickup");
				Destroy();
			}
		}
	}
}

simulated function name GetPickupName ( );

function RespawnWeapon()
{
	SetCollision(true, true);
	SetHidden(false);
}

/**
 * Set Pickup mesh to use.
 *
 * NOTE:
 *    This function does NOT set the pickup mesh anymore since each weapon has a specific dropped
 *    pickup class (and mesh) associated with it.  Rather, it now just sets the pickup to go to
 *    rigid body physics.
 *
 * Replicated through InventoryClass to remote clients using Inventory.DroppedPickup component as default mesh.
 */
simulated event SetPickupMesh(PrimitiveComponent PickupMesh)
{
	local ActorComponent Comp;

    // @todo Eventually NO dropped pickup should be using a skeletal mesh
    //       so this first if block should eventually go away
    if (SkeletalMeshComponent(ActorComp) != None && PickupMesh != None)
    {
		// Detach Old Mesh
		DetachComponent(ActorComp);

		//Comp = ActorComponent(PickupMesh.Clone(Self)); //SPARK MAY CODEDROP
		Comp = new(self) PickupMesh.Class(PickupMesh);
		
		AttachComponent(Comp);

		SetTimer(1.0f, TRUE, 'CheckForRigidBodySleepState');

		SetCollision(true, false);
		SkeletalMeshComponent(Comp).SetRBCollidesWithChannel(RBCC_Default, true);
        SkeletalMeshComponent(Comp).SetBlockRigidBody(true);
        SetPhysics(PHYS_RigidBody);
        SkeletalMeshComponent(Comp).SetPhysicsWeight(1.0f);
        SkeletalMeshComponent(Comp).SetHasPhysicsAssetInstance(true);
        SkeletalMeshComponent(Comp).WakeRigidBody();
		SkeletalMeshComponent(Comp).SetNotifyRigidBodyCollision(true);
		SkeletalMeshComponent(Comp).ScriptRigidBodyCollisionThreshold=150.0f;

        CylinderComp = CylinderComponent(CollisionComponent);

        // Force collision component to be physics asset
        CollisionComponent = PrimitiveComponent(Comp);
		ActorComp = Comp;
    }
    else
    {
        SetTimer(1.0f, TRUE, 'CheckForRigidBodySleepState');

	    SetCollision(true, false);
        CollisionComponent = PrimitiveComponent(ActorComp);
        PrimitiveComponent(ActorComp).SetBlockRigidBody(true);
        PrimitiveComponent(ActorComp).SetNotifyRigidBodyCollision(true);
        PrimitiveComponent(ActorComp).ScriptRigidBodyCollisionThreshold=150.0f;

        if (WorldInfo.NetMode == NM_Standalone)
            SetPhysics(PHYS_RigidBody);
        else
    		SetPhysics(PHYS_Falling);
            // Used to be SetPhysics(PHYS_RigidBody), but clients would have weapons stuck in mid air.  Falling seems to be working, don't know if there will be
		    // Any unintended side-effects.

        PrimitiveComponent(ActorComp).WakeRigidBody();
    }

	bPlacedInLevel = FALSE;
}

/**
  * If this RB is asleep then we are going to turn off all collision on it.  This stops
  * the painfulness of trying to pick up a weapon and then your character kicking it out of the
  * way.
  *
 **/
simulated function CheckForRigidBodySleepState()
{
	local SkeletalMeshComponent SkelComp;

	//`log( "checking for CheckForRigidBodySleepState" );
	if( CollisionComponent.RigidBodyIsAwake() == FALSE )
	{
		//`log( "turning off RB collision" );
        SetPhysics(PHYS_None);
		CollisionComponent.SetNotifyRigidBodyCollision( FALSE );
		ClearTimer( 'CheckForRigidBodySleepState' );
		CollisionComponent.SetBlockRigidBody( FALSE );
		CollisionComponent.SetActorCollision( FALSE, FALSE );

		// Fix in place so nothing can move it.
		SkelComp = SkeletalMeshComponent(CollisionComponent);
		if(SkelComp != None && SkelComp.PhysicsAssetInstance != None)
		{
			SkelComp.PhysicsAssetInstance.SetAllBodiesFixed(TRUE);
			SkelComp.bUpdateKinematicBonesFromAnimation = FALSE;
		}
	}
}

auto state Pickup
{
	simulated function BeginState(Name PreviousStateName)
	{
		AddToNavigation();
		//SetTimer(LifeSpan - 1, false);
	}

	// Validate touch (if valid return true to let other pick me up and trigger event).
	function bool ValidTouch(Pawn Other)
	{
		// make sure its a live player
		if (Other == None || !Other.bCanPickupInventory || (Other.DrivenVehicle == None && Other.Controller == None))
		{
			return false;
		}

		// make sure thrower doesn't run over own weapon
		if ( (Physics == PHYS_Falling) && (Other == Instigator) && (Velocity.Z > 0) )
		{
			return false;
		}

		// make sure not touching through wall
/*		if ( !FastTrace(Other.Location, Location) )
		{
			SetTimer(0.5, false, 'RecheckValidTouch');
			return false;
		}*/

		// make sure game will let player pick me up
		if (WorldInfo.Game.PickupQuery(Other, Inventory.class, self))
		{
			return true;
		}
		return false;
	}

	event Touch( Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal )
	{
		local Pawn P;
		local TPInventoryManager PawnInvMgr;
        local TPPlayerController tppController;

		// If touched by a player pawn, let him pick this up.
		if(Other.IsA('Pawn'))
		{
            P = Pawn(Other);
            tppController = TPPlayerController(P.Controller);
        }

		if( P != None && ValidTouch(P) )
		{
			PawnInvMgr = TPInventoryManager(P.InvManager);
			
			// If we already have this weapon, but would like some more ammo,
			// or if we don't have anything yet, then pick this up.
			if (PawnInvMgr != None && PawnInvMgr.IsItemUseful(Inventory))
            {
                if (tppController != None && !tppController.DenyPickup(Inventory))
				    GiveTo(P);
            }
			else if (PawnInvMgr.FindInventoryType(Inventory.Class) == None)
			{
				// Otherwise, return to our regular programming.
			    PlayerPawn(P).PendingPickup = self;

                // Check for multiplayer spamming
				if (tppController != none)
				{
					if (tppController.myHUD != none)
						TpHUD(tppController.myHUD).PickupText=GetPickupName ( );
				}
			}
		}
	} 
	
	event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

		//if (Physics != PHYS_RigidBody)
  //      {
  //          bSoundPlayed = false;
		//	SetPickupMesh(TPSPInventoryClass.default.DroppedPickupMesh);
  //      }
		//PrimitiveComponent(ActorComp).AddForce(momentum*0.001, Location);
	}
}

simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
					const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	if (DroppedSound != None && !bSoundPlayed)
	{
		PlaySound(DroppedSound);
        bSoundPlayed = true;
	}
}

