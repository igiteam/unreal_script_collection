class SFRMPickup extends WeaponPickup abstract; 

var int FadeOutTime;
var bool bHasAmmo; 
var bool MessageOn;
var bool bCanBePickedUp;

var localized string PickupName;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Precache the weapon's skeletal mesh 
	if( class<ZombieWeapon>(InventoryType) != None && class<ZombieWeapon>(InventoryType).default.PVMeshName != "" )
		Level.AddPrecacheSkeletalMesh( skeletalmesh(DynamicLoadObject( class<ZombieWeapon>(InventoryType).default.PVMeshName,class'skeletalmesh')) );
}

function float PlaySpawnEffect()
{
	//spawn( class 'EnhancedReSpawn',self,, Location ); //We don't have a respawn effect
	return 0.3;
}

function InitDroppedPickupFor(Inventory Inv)
{
	SetPhysics(PHYS_Falling);
	GotoState('FallingPickup');
	Inventory = Inv;
	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
    bDropped = true;
    LifeSpan = FadeOutTime;
	bIgnoreEncroachers=false; // handles case of dropping stuff on lifts etc
	SetCollisionSize( 8.0, 3.0 );
}

function inventory SpawnCopy(Pawn Other)
{
	local Inventory Copy;

	Copy = Super.SpawnCopy(Other);

	// FIXME - MOVE THIS TO ANNOUNCE PICKUP
	if ( Copy.Instigator.IsA('Bot') || Level.Game.bTeamGame || (Level.Game.NumBots > 4) )
		return Copy;

	return Copy;
}

event Landed(Vector HitNormal)
{
	Super.Landed( HitNormal );

	SetCollisionSize( default.CollisionRadius, default.CollisionHeight );
	bHidden = true;
}

state FallingPickup
{
	function Timer()
	{
		GotoState('FadeOut');
	}

	function BeginState()
	{
	    SetTimer(FadeOutTime, false);
	}
}

//=============================================================================
// Pickup state: this inventory item is sitting on the ground.

auto state Pickup
{
	// When touched by an actor.
	function AnnouncePickup( Pawn Receiver )
	{
		if (!Receiver.Controller.bIsPlayer)
			return; 

		Super.AnnouncePickup(Receiver); 
	}

	function bool ReadyToPickup(float MaxWait)
	{
		return true;
	}

	/* ValidTouch()
	 Validate touch (if valid return true to let other pick me up and trigger event).
	*/
	function bool ValidTouch( actor Other )
	{
		if( !bCanBePickedUp )
			return false;

		// make sure its a live player
		if ( (Pawn(Other) == None) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) )
			return false;

		// make sure not touching through wall
		if ( !FastTrace(Other.Location, Location) )
			return false;

		// make sure game will let player pick me up
		if( Level.Game.PickupQuery(Pawn(Other), self) )
		{
			TriggerEvent(Event, self, Pawn(Other));
			return true;
		}
		return false;
	}
	
	simulated function ClearNotifyMessage(Actor toucher)
	{
		if (MessageOn)
		{
			MessageOn=false;

			if((toucher != None) && (ZombiePlayerPawn(toucher) != None))
			{
				if (PlayerController(ZombiePlayerPawn(toucher).Controller) != none)
				{
					BasicHUD(PlayerController(ZombiePlayerPawn(toucher).Controller).myHUD).ClearLocalMessages(class'ZombieGame.ZombieWeaponMessage');
				}
			}
		}
	}
		
	// When touched by an actor.
	function Touch( actor Other )
	{
		// If touched by a player pawn, let him pick this up.
		if(ValidTouch(Other))
		{
			TakeAmmo(Pawn(Other));
			
			//
			if (ZombiePlayerPawn(Other) != none)
			{
				if (	(ZombiePlayerPawn(Other).Weapons[3] != none) &&
						(ZombiePlayerPawn(Other).Weapons[3].class != InventoryType)
					)
				{
					// If 4th slot (slot 3) is not empty, put up message that
					// asks user to confirm they want to swap that weapon
					Pawn(Other).ReceiveLocalizedMessage(MessageClass,,,,class);
					MessageOn = true;
				}
				else if( ZombiePlayerPawn(Other).Weapons[3] == none )
				{
					// If 4th slot (slot 3) is empty, pick up without any message
					// asking user for confirmation
					UsedBy( Pawn(Other) );
				}				
			}
			//
		}
	}

	function UnTouch( Actor Other )
	{
		if ((Pawn(Other) != none) && 
				(SFRMPlayerController(Pawn(Other).Controller) != none))
		{
			ClearNotifyMessage(other);
		}
	}

	// Make sure no pawn already touching (while touch was disabled in sleep).
	event CheckTouching()
	{
		local Pawn P;

		ForEach TouchingActors(class'Pawn', P)
			Touch(P);
	}

	function Timer()
	{
		if ( bDropped )
			GotoState('FadeOut');
	}

	function BeginState()
	{
		if ( bDropped )
        {
			AddToNavigation();
		    SetTimer(FadeOutTime, false);
		}
	}

	function EndState()
	{
		if ( bDropped )
			RemoveFromNavigation();
	}
	
	function UsedBy( Pawn user )
	{
	//	local Inventory Copy; 
		
		if (user.Controller.bIsPlayer && bCanBePickedUp )
		{
	//		Copy = SpawnCopy(user);  // Don't need this since the next line already causes a copy to be spawned
			
			user.HandlePickup(self);
			user.PlaySound( PickupSound,SLOT_Interact ); 
			
	//		SetRespawn(); 
	//		Copy.PickupFunction(user);	// Don't need to call this, since it did nothing anyways.
			
			ClearNotifyMessage(user);

			SetRespawn(); 
		}
	}
	
	function TakeAmmo(Pawn aPawn)
	{	
		// check to see if palyer has the weapon he's trying to pickup
		if (class<ZombieWeapon>(InventoryType) != None)
		{
			if ( bHasAmmo)
			{
				bHasAmmo=!class<ZombieWeapon>(InventoryType).Static.StaticGiveAmmo(aPawn);
			}
		}
	}

Begin:
	CheckTouching();
}



// Decompiled with UE Explorer.
defaultproperties
{
    FadeOutTime=10
    bHasAmmo=true
    PickupName="weapon"
    RespawnTime=0.0000000
    PickupSound=Sound'CBW_DYN_interface.HUD.pickup_weapon'
    Physics=0
    DrawType=8
    bOrientOnSlope=false
    CollisionRadius=24.0000000
    CollisionHeight=8.0000000
    MessageClass=Class'ZombieWeaponMessage'
}