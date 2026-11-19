class HealthPickup extends Pickup
	abstract;

var int Amount;
var bool isValidTouch;

var() float DroppedPickupLifeSpan;

static function string GetLocalString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	return "Health +"$default.Amount;
}
/*
function PostNetBeginPlay()
{
	if( Level.Game.GameDifficulty == 0 && Level.NetMode == NM_Standalone )
		Amount *= 2;
	Log("HealthPickup.PostNetBeginPlay   Amount:"$Amount $"  Level.Game.GameDifficulty:"$Level.Game.GameDifficulty $"   Level.NetMode == NM_Standalone:"$Level.NetMode == NM_Standalone );
	Super.PostNetBeginPlay();
}
*/
function InitDroppedPickupFor(Inventory Inv)
{
	SetPhysics(PHYS_Falling);
//	GotoState('FallingPickup');
	Inventory = Inv;
	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
    bDropped = true;
    LifeSpan = default.DroppedPickupLifeSpan;
	bIgnoreEncroachers=false; // handles case of dropping stuff on lifts etc
}

function inventory SpawnCopy( pawn Other )
{
	local inventory Copy;

	if ( Inventory != None )
	{
		Copy = Inventory;
		Inventory = None;
	}
	else
		Copy = spawn(InventoryType,Other,,,rot(0,0,0));

	HealthInventory(copy).Amount = Amount;

	Copy.GiveTo( Other );
	if( Level.Game.ShouldRespawn(self) )
		StartSleeping();
	else
		Destroy();
	return Copy;
}

function AnnouncePickup( Pawn Receiver )
{
	if( ZombiePlayerPawn(Receiver) != None )
		BasicHud(PlayerController(Receiver.Controller).MyHud).GotHealth("Health +"$Amount);
	Super.AnnouncePickup( Receiver );
}

auto state Pickup
{
	// Hack!  But at the time this function was written, this was the only way to be absolutely sure
	// that the pickup gave the correct health amount on Easy.
	function AdjustForEasy()
	{
		if( Level.Game.GameDifficulty == 0 && Level.NetMode == NM_Standalone && Amount == default.Amount )
			Amount += 10;
	//	Log("HealthPickup.Pickup.AdjustForEasy Amount:"$Amount $"  Level.Game.GameDifficulty:"$Level.Game.GameDifficulty $"   Level.NetMode == NM_Standalone:"$Level.NetMode == NM_Standalone );
	}

	function bool ValidTouch( actor Other )
	{
		// Store return value of ValidTouch for later use 
		// (e.g. for determining if pickup message is needed)
		isValidTouch = Super.ValidTouch( Other );

		return isValidTouch;
	}

	function Touch( actor Other )
	{
		AdjustForEasy();
		Super.Touch( Other );

		// Send pickup message
	//	if( isValidTouch )
	//	{
	//		Pawn(Other).ReceiveLocalizedMessage(MessageClass,,,,class);
	//	}
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    InventoryType=Class'HealthInventory'
    PickupSound=Sound'CBW_DYN_interface.HUD.pickup_health'
    DrawType=8
    StaticMesh=StaticMesh'CBS_DYN.Pickup.HealthPack'
    bUseCylinderCollision=false
    MessageClass=Class'ZombiePickupMessage'
}