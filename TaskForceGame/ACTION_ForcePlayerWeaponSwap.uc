//
// This scripted action changes one of the player's current weapons
// The scripter specifies the following:
//  -The slot that holds the weapon to replace.  The slot can
//   be empty or already occupied by a weapon.
//  -The new weapon (which will replace the current weapon)
//	-Whether or not this weapon should be selected (default is true).
//  -What to set the ammo count to for this weapon (-1 means leave at default)
//
class ACTION_ForcePlayerWeaponSwap extends ScriptedAction;

var()	class<ZombieWeapon>	NewWeaponClass;

var()	enum EForceSwapWeaponSlot
{
	PistolSlot,
	RifleSlot,
	GrenadeSlot,
	SniperSlot
} WeaponSlot;

var()	bool				bSelectThisWeapon;

var()	int					AmmoAmount;

function DoPrecache(LevelInfo xLevel)
{
	xLevel.AddPrecacheSkeletalMesh( skeletalmesh(DynamicLoadObject( NewWeaponClass.default.PVMeshName,class'skeletalmesh')) );
	NewWeaponClass.static.PrecacheAssets(xLevel);
}

function bool InitActionFor(ScriptedController C)
{
	local ZombiePlayerPawn MyPlayer;
//	local class<ZombieWeapon> OldWeaponClass;

	//Log("AAAAA! ACTION_ForcePlayerWeaponSwap.InitActionFor  slot:"$WeaponSlot $"  new weap:"$NewWeaponClass );

	MyPlayer = ZombiePlayerPawn(C.GetMyPlayer());

	if( MyPlayer != None )
	{
		// If player's current weapon is zoomed, then make it unzoom
		if( ZombieWeapon(MyPlayer.Weapon).bZoomed )
			ZombieWeapon(MyPlayer.Weapon).UnZoomFaster();

		// Destroy old weapon (if any)
		if( MyPlayer.Weapons[WeaponSlot] != None )
		{
		//	OldWeaponClass = MyPlayer.Weapons[WeaponSlot].class;
			MyPlayer.Weapons[WeaponSlot].Destroy();
			MyPlayer.PendingWeapon = None;
		}

		// Give player new weapon
		MyPlayer.Weapons[WeaponSlot] = None;
		MyPlayer.AddWeaponToSlot(WeaponSlot, NewWeaponClass, true);

		// Check that it succeeded
		if( MyPlayer.Weapons[WeaponSlot] == None )
		{
			Log("Error!  ACTION_ForcePlayerWeaponSwap failed (unable to create new weapon in slot no. "$WeaponSlot $")" );
		}
		else if( !bSelectThisWeapon && MyPlayer.Weapon != MyPlayer.Weapons[WeaponSlot] )
		{
			// If it did succeed, but this weapon isn't going to be selected (either it's not
			// replacing the currently selected weapon or this action will not select the weapon)
			// then call the HUD's GotAmmo function so that the player knows they got something.
			BasicHud(PlayerController(MyPlayer.Controller).MyHud).GotAmmo(MyPlayer.Weapons[WeaponSlot]);
		}

		// Set the ammo amount (if required)
		if( AmmoAmount > -1 )
			SetAmmoAmount( MyPlayer.Weapons[WeaponSlot], AmmoAmount );

		// Select the weapon (if applicable)
		if( bSelectThisWeapon && MyPlayer.EquipWillBeValid(WeaponSlot) )
			MyPlayer.EquipWeapon(WeaponSlot);
	}
	else
		Log("Error!  ACTION_ForcePlayerWeaponSwap failed (could not find player).");

	return false;
}

function SetAmmoAmount( ZombieWeapon weap, int OverrideAmmoAmount )
{
	local Ammunition A;

	A = Ammunition(Pawn(weap.Owner).FindInventoryType(weap.AmmoName));
	if ( A != None )
	{
		A.AmmoAmount = OverrideAmmoAmount;
	}
}

function string GetActionString()
{
	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    bSelectThisWeapon=true
    AmmoAmount=-1
    ActionString="ForcePlayerWeaponSwap"
}