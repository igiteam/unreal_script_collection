class SASCheatManager extends CheatManager within PlayerController;


///////////////////////////////////////////////////////////////////////////////
// AllWeapons
// 
// Give all weapons to player.
exec function AllWeapons() 
{
	if ((Level.Netmode!=NM_Standalone) || (Pawn == None))
	{
		return;
	}

	// Primary weapons
	Pawn.GiveWeapon("SASWeapons.HK_MP5_Wpn");
	Pawn.GiveWeapon("SASWeapons.HK_MP5_LS_S_Wpn");
	Pawn.GiveWeapon("SASWeapons.AK47_Wpn");

	// Secondary weapons
	Pawn.GiveWeapon("SASWeapons.Browning_BDA_Wpn");

	// Knife
	Pawn.GiveWeapon("SASWeapons.CombatKnife_Wpn");

	// Grenades
	Pawn.GiveWeapon("SASWeapons.G60_Grenade_Wpn");
	Pawn.GiveWeapon("SASWeapons.L2A2_Grenade_Wpn");
	Pawn.GiveWeapon("SASWeapons.L13A1_Gas_Grenade_Wpn");
	Pawn.GiveWeapon("SASWeapons.Smoke_Grenade_Wpn");
}


///////////////////////////////////////////////////////////////////////////////
// ToggleInfiniteAmmo
// 
exec function ToggleInfiniteAmmo()
{
	if (Level.Netmode != NM_Standalone)
	{
		return;
	}

	SASPawn(Pawn).mInfiniteAmmoCheat = !SASPawn(Pawn).mInfiniteAmmoCheat;
}
