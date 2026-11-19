class SFRMInventoryWeapon extends ZombieWeapon;

var Weapon OldWeapon;
var ZombieUseTrigger TriggeredBy;

function TriggeredUse( ZombieUseTrigger useTrigger )
{
	OldWeapon = Pawn(Owner).Weapon;
	TriggeredBy = useTrigger;
}

// Find the previous weapon (using the Inventory group)
simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if ( Inventory == None )
		return CurrentChoice;
	else
		return Inventory.PrevWeapon(CurrentChoice,CurrentWeapon);
}

// Find the next weapon (using the Inventory group)
simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if ( Inventory == None )
		return CurrentChoice;
	else
		return Inventory.NextWeapon(CurrentChoice,CurrentWeapon);
}
