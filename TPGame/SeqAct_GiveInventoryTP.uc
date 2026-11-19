class SeqAct_GiveInventoryTP extends SequenceAction
	native;

struct native WeaponInfo
{
	var() nopersistentconv class<Inventory> WeaponType;
	var() int AmmoToGive;
};
var() array<WeaponInfo>	WeaponList;
var() bool bGiveAmmoIfHasWeaponAlready;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

