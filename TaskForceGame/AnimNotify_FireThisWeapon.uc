class AnimNotify_FireThisWeapon extends AnimNotify_Scripted;

// Used to make a weapon fire (Goes directly to the weapon,
// as opposed to notifying the weapon's owner).
event Notify( Actor ThisWeapon )
{
	if( ThisWeapon.IsA('Weapon') )
	{
		Weapon(ThisWeapon).Fire(0);
	//	Log("AnimNotify_FireWeapon:   ThisWeapon:"$ThisWeapon );
	}
	else
	{
		Log("Error: "$self$" should be used on Weapons. ");
	}
}
