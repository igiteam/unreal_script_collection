class SinglePlayerMI extends MenuMI
	editinlinenew
	placeable
	native; 

var(SinglePlayerMI) ECampaign	Campaign;
var(SinglePlayerMI)	bool		bHideHudOnStart;
var()				int			StartingWeaponSlot;  // Which weapon slot (1 through 4) the player will start the map with

// Playerview hand skin
var string DefaultHandsTextureName;
var Texture HandsTexture;

// Load based on class
enum ELoadoutClass
{
	CLASS_Soldier,
	CLASS_Sniper,
	CLASS_HeavyWeapons,
	CLASS_Scout,
	CLASS_Demolitions,
};
var(LoadoutClass) ELoadoutClass LoadoutClass;

// Ammo dropped by AI upon violent termination.
var class<Pickup> LevelAmmoPickupClass[8];
var float LevelAmmoPickupProbability[8];  // Sum of these should be 1.00
var float LevelAmmoPickupBinUpperLim[8]; 
var int LevelAmmoPickupAmount[8];
var int LastAmmoDropSlot;
var int	MaxAmmoPickupTypes;
var ZombiePlayerPawn LastKillerPlayer;
var float PreferredAmmoThreshhold[4];  // Varies based on level of difficulty.
var int HealthAssistThreshhold[4];     // Varies based on level of difficulty.
var float TimeOfLastHealthDrop;
var float MinHealthDropInterval;
var int PickupsDropped;
var int TotalPickupDropInquiries;

// Carryover
var(SinglePlayerMI)	bool		bCarryLoadoutFromPrevLevel;
var()				int			CarryoverHealthBoost[4]; // Function of LOD, max boost in health at level load

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function int GetCPI() 
{
	InitCarryover();
	
	return PlayerCarryover.CPI;
}

event RestartPlayer(Pawn aPawn)
{
	local PlayerController PC; 
	//local string currMap, destMap;

//	Level.Game.GameDifficulty = 0; // MAT 3/17/04 DEBUG
//	Log(" ######### DEBUG: FORCING LEVEL.GAME.GAMEDIFFICULTY TO "$ Level.Game.GameDifficulty $" ###########"); // MAT 3/17/04 DEBUG

//	log("SinglePlayerMI.RestartPlayer    aPawn:"$aPawn  $"########################" );
//	if( ZombiePlayerPawn(aPawn) != None )
//		Log("   aPawn StartingWeapSlot:"$ZombiePlayerPawn(aPawn).StartingWeapSlot  );
	PC = PlayerController(aPawn.Controller); 
	if (PC == None && !PC.bIsPlayer)
		return;
		
	if(bHideHudOnStart)
	{
		BasicHud(PC.myHUD).HideHud(true);
	}

	SetLevelHandsTexture();

	InitCarryover();

	log("CARRYOVER: SinglePlayerMI.RestartPlayer: CPI: " $ PlayerCarryover.CPI); 

	if (PlayerCarryover.CPI > 0)	
	{
//		LogCarryover();
		
		// Load health, weapons and ammo based on carryover
		// (and take care of any slots that have been overridden for this level)

		// Health
		aPawn.Health = Min( PlayerCarryOver.PH + CarryoverHealthBoost[Level.Game.GameDifficulty], 100 );

		// Weapons and ammo
		LoadBasedOnCarryOver(aPawn);
	}
	else
	{
		// Load weapons and ammo based on loadout class (soldier, sniper, etc...)
		LoadBasedOnClass(aPawn);
	}

	// Prepare NPC ammo drop probability data for use
	ProcessPickupProbabilities();
	
	// Done with carried-over loadout.

	SetPlayerForAmmoDrop(aPawn);

	ClearLinkerTables(true);

//	log("SinglePlayerMI.RestartPlayer    aPawn:"$aPawn $"  end of function! :-) ########################" );
}

// DEBUG code: Prints the player's inventory and NPC ammo drop info to the log.
/*
function DebugDump( Pawn aPawn )
{
	local inventory inv;
	local int inx;
return;
	if( ZombiePlayerPawn(aPawn) != None )
		Log("   aPawn StartingWeapSlot:"$ZombiePlayerPawn(aPawn).StartingWeapSlot  );

	// Log pawn's inventory
	inv = aPawn.Inventory;
	if( inv != None )
	{
		Log("     ## Printing player inventory (at end of SinglePlayerMI.RestartPlayer):   ");
		do
		{
			if( Ammunition(inv) != None )
				Log("          inv:"$inv $"        state:"$inv.GetStateName() $"  ammo amount:"$Ammunition(inv).AmmoAmount );
			else
				Log("          inv:"$inv $"        state:"$inv.GetStateName() );
			inv = inv.Inventory;
		}until( inv == None )
	}
	else
	{
		Log("     ## Player has no inventory   (at end of SinglePlayerMI.RestartPlayer)");
	}

	// Log ammo pickup data
	Log("     ## Ammo pickup info:   MaxAmmoPickupTypes:"$MaxAmmoPickupTypes );
	for( inx = 0; inx < 4 ; inx++ )
		Log("       ["$inx $"]   prob:"$LevelAmmoPickupProbability[inx] $"  bin UL:"$LevelAmmoPickupBinUpperLim[inx] $"  pu amt:"$LevelAmmoPickupAmount[inx] $"    ammo:"$LevelAmmoPickupClass[inx] );

}
*/


// ----------------------------------------------------------------------------------------------------
// CarryOver-based loadout

function LoadBasedOnCarryOver(Pawn aPawn)
{
	local ZombiePlayerPawn SFPP;

//	Log("  ############### SinglePlayerMI.LoadBasedOnCarryOver   ");
	SFPP = ZombiePlayerPawn(aPawn);

	// Load weapons and take care of ammo in weapon and ammo pickups to be dropped by NPCs
	// (Also takes care of any slots that are being overridden)
	LoadCarryOverWeapons( SFPP );
//	SFPP.AddWeapon("Weapons.weapSOFLAM");

	// Add ammo from carryover
	LoadCarryoverAmmo( SFPP );

	// Select the weapon the player had on the last level
	if( PlayerCarryOver.CWS >= 0 && PlayerCarryOver.CWS <= 3 )
	{
		SFPP.StartingWeapSlot = PlayerCarryOver.CWS;
	}

//	Log("  ############### SinglePlayerMI.LoadBasedOnCarryOver   end");
}

// Loads weapons from the carryover data.
// If a given slot is set to be overridden (as specified in this map info), then this 
// function will load that weapon instead
function LoadCarryoverWeapons( ZombiePlayerPawn SFPP)
{
	local int inx;
	local int AmmoDropCtr;  // Keeps track of how many slots are used (some may be empty)
	local class<ZombieWeapon> CurrWeaponClass;	//pointer to the currently loading weapon class.

//	Log("     --  SingleplayerMI.LoadCarryoverWeapons    MaxAmmoPickupTypes:"$MaxAmmoPickupTypes );

	// Load weapons and take care of ammo in weapon and ammo pickups to be dropped by NPCs
	for( inx = 0 ; inx < 4 ; inx++ )
	{
		if( PlayerCarryOver.W[inx] != "None" )  // Check if this slot is not blank in the carryover data
		{
		//	Log("        LoadCarryoverWeapons: weap slot:"$inx $"  path 2 load weapon from carryover");

			// Load weapon from carryover
			CurrWeaponClass = class<ZombieWeapon>(DynamicLoadObject(PlayerCarryOver.W[inx],class'class'));
			SFPP.AddWeaponToSlot(inx,  CurrWeaponClass);

			// Adjust ammo in the weapon
			AdjustAmmoInCarryoverWeapon( SFPP.Weapons[inx], inx );

			// Set ammo pickup for that weapon (for ammo dropped by NPC's)

			if( CurrWeaponClass.default.AmmoName != None )
			{
				LevelAmmoPickupClass[AmmoDropCtr] = CurrWeaponClass.default.AmmoName.default.PickupClass;
				LevelAmmoPickupProbability[AmmoDropCtr]=class<AmmoPickup>(LevelAmmoPickupClass[AmmoDropCtr]).default.NominalProbability;
				LevelAmmoPickupAmount[AmmoDropCtr] = CurrWeaponClass.default.ReloadCount;
			//	Log("        ////LevelAmmoPickupClass["$AmmoDropCtr$"]:"$LevelAmmoPickupClass[AmmoDropCtr] $"    weap:"$PlayerCarryover.W[inx] 
			//		$"  prob:"$LevelAmmoPickupProbability[AmmoDropCtr] );
			}
			AmmoDropCtr++;
		}	
		else
		{
		//	Log("        LoadCarryoverWeapons: weap slot:"$inx $"  path 3 empty slot");

			// Set a blank ammo pickup slot
			LevelAmmoPickupProbability[AmmoDropCtr] = 0;
		//	Log("   ////LevelAmmoPickupClass["$AmmoDropCtr$"]:None  "
		//			$"  prob:"$LevelAmmoPickupProbability[AmmoDropCtr] );
			AmmoDropCtr++;
		}
	}
	MaxAmmoPickupTypes=AmmoDropCtr;
//	Log("     --  SingleplayerMI.LoadCarryoverWeapons  Weapons loaded.  MaxAmmoPickupTypes:"$MaxAmmoPickupTypes );
}

// Sets ammo amounts inside a weapon based on the carryover data
function AdjustAmmoInCarryoverWeapon( ZombieWeapon Weap, int Slot )
{
	if( PlayerCarryOver.WAA[Slot] >= 0 )
	{
		if( Level.Game.GameDifficulty == 0 )  // On easy, reload weapon
		{
			Weap.ReloadCount     = Weap.default.ReloadCount;
		}
		else
		{
			Weap.ReloadCount     = PlayerCarryover.WAA[Slot];
		}
	}
}

// Loads ammo into the pawn's inventory based on carryover data
function LoadCarryoverAmmo( ZombiePlayerPawn SFPP )
{
	local int inx, jnx;
	local Inventory Inv;
	local class<Ammunition> CurrAmmoClass;		//pointer to the currently loading ammo class.

//	Log("      SinglePlayerMI.LoadCarryoverAmmo   ");
	Inv = SFPP.Inventory;
	while( Inv != None )
	{
		// If this item from the pawn's inventory is ammunition
		if( ClassIsChildOf(Inv.class, class'Ammunition') )
		{
			// Go through each ammo item in the carryover data
			for( inx = 0 ; inx < 8 ; inx++ )
			{
//				Log("      SPMI.LCoA  inx:"$ inx $"   PlayerCarryOver.A[inx]:"$ PlayerCarryOver.A[inx] );
				// If this ammo item in the carryover data is not blank
				if( PlayerCarryOver.A[inx] != "None")
				{
					// See if it matches the item (from the pawn's inventory) that we're currently checking
					CurrAmmoClass = class<Ammunition>(DynamicLoadObject(PlayerCarryOver.A[inx],class'Class'));
					if(	Inv.IsA( CurrAmmoClass.name ) )
					{
						if( Level.Game.GameDifficulty == 0 )
						{
							// On easy, give player full load (4 clips):
							// Check each weapon to see if this ammo belongs to it
							for( jnx = 0; jnx < 4; jnx++ )
							{
								// If it does, set it to the right amount
//								if( SFPP.Weapons[jnx] != None )
//								{
//									Log("      SPMI.LCoA     jnx:"$ jnx $"   a:"$ SFPP.Weapons[jnx].ReloadCount * 4 $"  b:"$ PlayerCarryOver.AA[inx] );
//									Log("      SPMI.LCoA     SFPP.Weapons[jnx].AmmoName:"$ SFPP.Weapons[jnx].AmmoName $"  CurrAmmoClass:"$ CurrAmmoClass );
//								}
//								else
//									Log("      SPMI.LCoA     jnx:"$ jnx $"   a: n/a   b:"$ PlayerCarryOver.AA[inx] );

							//	if( SFPP.Weapons[jnx].AmmoType.IsA( CurrAmmoClass.name ) )
								if( SFPP.Weapons[jnx] != None && SFPP.Weapons[jnx].AmmoName == CurrAmmoClass )
								{
									//Ammunition(Inv).AmmoAmount = Max(SFPP.Weapons[jnx].ReloadCount * 4, PlayerCarryOver.AA[inx]);
									Ammunition(Inv).AmmoAmount = PlayerCarryOver.AA[inx];
								}
//								Log("      SPMI.LCoA     endof jnx" $jnx );
							}
						}
						else
						{
							// For all other game difficulties, just set ammo amount directly from carryover data
							Ammunition(Inv).AmmoAmount = PlayerCarryOver.AA[inx];
						}
//						Log("   Match:  Inv:"$Inv.class $"  Saved ammo:"$PlayerCarryOver.AA[inx] );
					}
				}
//				Log("      SPMI.LCoA  endof inx:"$ inx );
			}
		}
		Inv = Inv.Inventory;  // Iterate to next item in pawn's inventory
	}
}

event SetCheckpoint(int checkpointIndex)
{
	local controller C;
//	log("CARRYOVER: SetCheckpoint: " $ checkpointIndex @ PlayerCarryover.CPI);
	if (checkpointIndex > PlayerCarryover.CPI)
	{
		PlayerCarryover.CPI = checkpointIndex;
		CachePlayerInvInfo(Level.GetLocalURL());
		
		for( C=Level.ControllerList;C!=None;C=C.NextController )
	    {
			if( SFRMPlayerController(C) != None )
			{
				BasicHUD(SFRMPlayerController(C).MyHud).NewCheckpoint();
			}
		}

		
//		LogCarryover();
	}
}

event ClearCheckpoints() 
{
	InitCarryover();

	log("CARRYOVER: Clearing checkpoints");

	PlayerCarryover.CPI = -1;
	PlayerCarryover.SaveConfig();
}

// Saves the player's current loadout info
function CachePlayerInvInfo(string URL)
{
	local controller C;
	local inventory Inv;
	local int weapIndex, ammoIndex;
//	local class SOFLAMAmmoClass;
	local ZombiePlayerPawn SFPP;
	
//	Log("  ############### SinglePlayerMI.CachePlayerInvInfo   ");
//	SOFLAMAmmoClass = class<Ammunition>(DynamicLoadObject("Weapons.SOFLAMAmmo",class'Class'));
	
	for( C=Level.ControllerList;C!=None;C=C.NextController )
    {
		if( SFRMPlayerController(C) != None )
		{
			SFPP = ZombiePlayerPawn(C.Pawn);
			// Save weapon info (weapon class and how much ammo is in the weapon for each weapon mode)
			for( weapIndex = 0 ; weapIndex < 4 ; weapIndex++ )
			{
				if( SFPP.Weapons[weapIndex] == None )
					PlayerCarryover.W[weapIndex] = "None";
				else
				{
					// Save weapon class
					PlayerCarryover.W[weapIndex] = ""$SFPP.Weapons[weapIndex].class;		//convert class to string

					// Save ammo amt in weapon
					PlayerCarryover.WAA[weapIndex] = SFPP.Weapons[weapIndex].GetReloadCount();

					// If this is the current weapon, then note that observation
					if( SFPP.Weapons[weapIndex] == SFPP.Weapon )
						PlayerCarryover.CWS = weapIndex;
				}
			}

			// Save ammo info (ammo class and quantity)
			Inv = C.Pawn.Inventory;
			while( Inv != None )
			{
				if( ClassIsChildOf(Inv.class, class'Ammunition') ) //&& !Inv.IsA(SOFLAMAmmoClass.name) )
				{
					PlayerCarryover.A[ammoIndex] = ""$Ammunition(Inv).class;		//convert class to string
					PlayerCarryover.AA[ammoIndex] = Ammunition(Inv).AmmoAmount;
					ammoIndex++;
				}
				Inv = Inv.Inventory;  // Go to next item in list
			}
			
			while( ammoIndex < 8 )
			{
				PlayerCarryover.A[ammoIndex] = "None";
				PlayerCarryover.AA[ammoIndex] = 0;
				ammoIndex++;
			}	

			PlayerCarryover.PH = C.Pawn.Health;
			PlayerCarryover.CI = int(Campaign);
			PlayerCarryover.DURL = Left(URL,InStr(URL,"#"));
			
			PlayerCarryover.SaveConfig();
		}
	}
//	Log("  ############### SinglePlayerMI.CachePlayerInvInfo   end");
}
// END CarryOver-based loadout



// ----------------------------------------------------------------------------------------------------
// Class-based loadout
function LoadBasedOnClass(Pawn aPawn)
{
	local int classIdx;

	classIdx = GetClassIdx( LoadoutClass );

	AddWeaponFromString( aPawn, 0, class'MPLoadoutMgr'.static.GetLoadout(false).PistolWeapon );
	AddWeaponFromString( aPawn, 1, class'MPLoadoutMgr'.static.GetLoadout(false).ClassWeapons[classIdx] );
	AddWeaponFromString( aPawn, 2, class'MPLoadoutMgr'.static.GetLoadout(false).ExplosiveWeapons[classIdx] );
	AddWeaponFromString( aPawn, 3, "Weapons.WeapKnife" );
}
function int GetClassIdx( ELoadoutClass loadoutClassIn )
{
	local int classIdx;

	if( loadoutClassIn==CLASS_Soldier )
		classIdx=0;
	else if( loadoutClassIn==CLASS_Sniper )
		classIdx=1;
	else if( loadoutClassIn==CLASS_HeavyWeapons )
		classIdx=2;
	else if( loadoutClassIn==CLASS_Scout )
		classIdx=3;
	else if( loadoutClassIn==CLASS_Demolitions )
		classIdx=4;

	return classIdx;
}

function AddWeaponFromString( Pawn aPawn, byte Slot, String WeaponClassString )
{
	local class<ZombieWeapon> newWeapClass;

	newWeapClass = LoadWeaponClassFromString( WeaponClassString );

	if( newWeapClass != none )
	{
		ZombiePlayerPawn(aPawn).AddWeaponToSlot( Slot, newWeapClass );
		AddAmmoPickup( Slot, newWeapClass );
	}
}

function class<ZombieWeapon> LoadWeaponClassFromString( String WeaponClassString)
{
	return class<ZombieWeapon>(DynamicLoadObject(WeaponClassString,class'Class'));
}

function AddAmmoPickup( byte Slot, class<ZombieWeapon> weapClass )
{
	if( weapClass.default.AmmoName == None )
	{
		LevelAmmoPickupClass[Slot] = None;
		LevelAmmoPickupProbability[Slot] = 0;
		LevelAmmoPickupAmount[Slot] = 0;
	}
	else
	{
		LevelAmmoPickupClass[Slot] = weapClass.default.AmmoName.default.PickupClass;
		if( LevelAmmoPickupClass[Slot] != None )
		{
			LevelAmmoPickupProbability[Slot] = class<AmmoPickup>(LevelAmmoPickupClass[Slot]).default.NominalProbability;
			LevelAmmoPickupAmount[Slot] = weapClass.default.ReloadCount;
		}
		else
		{
			LevelAmmoPickupProbability[Slot] = 0;
			LevelAmmoPickupAmount[Slot] = 0;
		}
	}
}
// END Class-based loadout


// ----------------------------------------------------------------------------------------------------
// Ammo drop (Ammo pickups dropped by NPC's when they get killed)

// Takes individual nominal probabilities for the ammo drop classes and creates an 
// array that can be used with FRand to determine which ammo to drop.
// In other words: it creates probability bins such that we can choose a discrete 
// outcome based on a random number from 0.0 to 1.0.
function ProcessPickupProbabilities()
{
	local int inx;
	local float sum;

	// Add up the individual raw nominal probabilities (this sum will be used
	// later to normalize the probabilities)
	for( inx = 0; inx < MaxAmmoPickupTypes ; inx++ )
	{
		sum += LevelAmmoPickupProbability[inx];
	}

	// The following code seperates outcomes 0 through 3 into probability bins so that
	// we can choose a discrete outcome based on a random number (0.0 to 1.0).
	// -The lower limit of the bin is found by summing the probabilities of the 
	//  previous outcomes.  e.g. if outcome 0 has prob 0.5 and outcome 1 has 
	//  prob 0.1, then outcome 2 bin lower limit is 0.5+0.1=0.6
	// -The upper limit of the bin is lower limit plus bin probability
	//
	// Example: 
	//   outcome probabilities: p0=0.4, p1=0.3, p2=0.2, p3=0.1 
	//   Bin 0: 0 to 0.4   (0 to p0),  
	//	 Bin 1: 0.4 to 0.7 (p0 to p0+p1),
	//   Bin 2: 0.7 to 0.9 (p0+p1 to p0+pi+p2)
	//	 Bin 3: 0.9 to 1.0 (p0+p1+p2 to p0+pi+p2+p3)
	//
	// We are only storing the upper bin limit, since the lower bin limit is simply
	// the upper bin limit of the previous bin.
	//
	// We are dividing by sum in order to ensure it is normalized (so we have values
	// that go from 0.0 to 1.0, and not, say, 0.0 to 28.9.
	//
	// Also, if a bin is empty, the upper and lower limit will be set to the same
	// value.

	// Normalize first probability to create first bin's upper limit
	LevelAmmoPickupBinUpperLim[0] = LevelAmmoPickupProbability[0] / sum;
//	Log("  Ammo pickup probabilities: [0]  "$LevelAmmoPickupProbability[0] $"  "$LevelAmmoPickupClass[0] );

	// For each subsequent probability, normalize that probability 
	// and use it to create the corresponding bin's upper limit
	for( inx = 1 ; inx < MaxAmmoPickupTypes ; inx++ )
	{
		LevelAmmoPickupBinUpperLim[inx] 
			=  LevelAmmoPickupBinUpperLim[inx-1]		// upper limit of previous bin
			 + (LevelAmmoPickupProbability[inx]/sum);	// probability of current bin (normalized to 1.0)
	//	Log("  Ammo pickup probabilities: ["$inx $"]  "$LevelAmmoPickupProbability[inx] $" ("$LevelAmmoPickupProbability[inx]/sum$")"
	//		$"   "$LevelAmmoPickupClass[inx] );
	}
}

// If one of the player's weapons is changed, this function will update the ammo pickup class
// and ammo pickup probabilities accordingly.
function NewAmmoPickupForSlot(class<ZombieWeapon> WeaponClass, int SlotID)
{
	if( WeaponClass != None && WeaponClass.default.AmmoName.default.PickupClass != None )
	{
		LevelAmmoPickupClass[SlotID]=WeaponClass.default.AmmoName.default.PickupClass;			
		LevelAmmoPickupProbability[SlotID]=class<AmmoPickup>(LevelAmmoPickupClass[SlotID]).default.NominalProbability;
		LevelAmmoPickupAmount[SlotID]=WeaponClass.default.ReloadCount;

		ProcessPickupProbabilities();
	}
}

// This sets which player for whom we will customize the ammo drops
//  -If the input pawn is None (i.e. bot blew itself up, or was killed by player's AI buddies),
//   then this code will continue to use the last known valid value.
//  -If the player has not killed any bots (NPC's, AI enemies) during the game, then this 
//   will be none until the player kills their first enemy bot.
function SetPlayerForAmmoDrop(Pawn aPawn)
{
	local ZombiePlayerPawn PP;

	PP = ZombiePlayerPawn(aPawn);
	
	if( PP != None )
	{
		LastKillerPlayer = PP;
	}
}

// Determines whether or not a bot should drop a pickup.
// Instead of relying purely on FRand and the laws of probability, it keeps track
// of the recent drop frequency and will take appropriate action if the drop frequency
// gets too far away from the requested AmmoDropFrequency.
function bool ShouldDropAPickup( float AmmoDropFrequency )
{
	local float randNum, currDropFrequency;

	// Protect against drop frequency (actual drop percentage) getting too low or too high
	if( TotalPickupDropInquiries > 0 )
	{
		currDropFrequency = float(PickupsDropped)/float(TotalPickupDropInquiries);
		if( currDropFrequency < AmmoDropFrequency*0.5 || currDropFrequency < AmmoDropFrequency-0.02 )
		{
			// Frequency too low
//ammodrop			Log(" ** SinglePlayerMI.ShouldDropAPickup: ->Drop       currDropFrequency:"$currDropFrequency $" ("$ PickupsDropped $"/"$TotalPickupDropInquiries $")" $"  p:"$AmmoDropFrequency $"   currDropFrequency too low.  (< "$AmmoDropFrequency*0.5 $" or "$AmmoDropFrequency-0.02 $")" );
			if( TotalPickupDropInquiries >= 10 )
			{
				// If drop has been considered at least a certain number of times, 
				// then reset the currDropFrequency tracking
				PickupsDropped = 1;
				TotalPickupDropInquiries = 1;
			}
			else
			{
				// Otherwise, just update the counts used for finding drop frequency
				PickupsDropped++;
				TotalPickupDropInquiries++;
			}
			return true;
		}
		else if( currDropFrequency > AmmoDropFrequency+0.02 )
		{
			// Frequency too high
//ammodrop			Log(" ** SinglePlayerMI.ShouldDropAPickup: ->NO drop    currDropFrequency:"$currDropFrequency $" ("$ PickupsDropped $"/"$TotalPickupDropInquiries $")" $"  p:"$AmmoDropFrequency $"   currDropFrequency too high.  (> "$AmmoDropFrequency+0.02 $")" );
			TotalPickupDropInquiries++;
			return false;
		}
	}

	// If drop frequency isn't out of a good range, then pick randomly
	randNum = FRand();
	if( randNum > AmmoDropFrequency + 0.05 )
	{
//ammodrop		Log(" ** SinglePlayerMI.ShouldDropAPickup:   NO drop    currDropFrequency:"$currDropFrequency $" ("$ PickupsDropped $"/"$TotalPickupDropInquiries $")" $"  p:"$AmmoDropFrequency $"  randNum:"$randNum $"  (rn > p means no drop)");
		TotalPickupDropInquiries++;
		return false;
	}
	else
	{
//ammodrop		Log(" ** SinglePlayerMI.ShouldDropAPickup:   Drop       currDropFrequency:"$currDropFrequency $" ("$ PickupsDropped $"/"$TotalPickupDropInquiries $")" $"  p:"$AmmoDropFrequency $"  randNum:"$randNum $"  (rn <= p means drop)");
		if( TotalPickupDropInquiries >= 10 )
		{
			// If drop has been considered at least a certain number of times, then reset the currDropFrequency tracking
			PickupsDropped = 1;
			TotalPickupDropInquiries = 1;
		}
		else
		{
			// Otherwise, just update the counts used for finding drop frequency
			PickupsDropped++;
			TotalPickupDropInquiries++;
		}		
		return true;
	}
}

// If last killer player is below a certain health, this will return true
// Has a timer so that health pickups don't drop too often
function bool ShouldDropHealth()
{
	local ZombiePlayerPawn PP;

	PP = LastKillerPlayer;
	if( PP != None && PP.Health <= HealthAssistThreshhold[Level.Game.GameDifficulty] 
	 && Level.TimeSeconds > TimeOfLastHealthDrop+MinHealthDropInterval )
	{
		TimeOfLastHealthDrop=Level.TimeSeconds;
		return true;
	}
	else
		return false;
}

// Select preferred ammo drop slot based on what the player needs most.
// Will return -1 if player hasn't killed any pawns yet, or if all the player's 
// ammo amount percent is above the min threshhold for the current GameDifficulty.
function int CalcPreferredAmmoDrop()
{
	local ZombiePlayerPawn PP;
	local int inx, currPref;
	local float PlayerAmmoPct[4];
	local float MinAmmoPct;
	local ammunition currAmmo;
	local int PrefAmmoDropSlot;  // Current preferred slot for which to drop ammo

	PP = LastKillerPlayer; 

	PrefAmmoDropSlot = -1;

	if( PP != None )
	{
		MinAmmoPct = 2.00;
		for( inx = 0 ; inx < 4 ; inx++ )
		{
			if( PP.Weapons[inx] != None )
			{
			//	if( PlayerAmmoPct[inx] == MinAmmoPct )
			//		Log("  Pref ammo drop: tie-breaker needed  inx:"$inx $"  MinAmmoPct:"$MinAmmoPct );
				currAmmo = Ammunition(PP.FindInventoryType( PP.Weapons[inx].AmmoName ));
				if( SFRMAmmunition(currAmmo) != None && SFRMAmmunition(currAmmo).PickupClass !=None 
				 && class<AmmoPickup>(SFRMAmmunition(currAmmo).PickupClass).default.NominalProbability > 0.00 )
				{
					PlayerAmmoPct[inx] = float(currAmmo.AmmoAmount) / float(currAmmo.MaxAmmo);
				//	Log("  CalcPreferredAmmoDrop: ["$inx $"]  ammo pct:"$ PlayerAmmoPct[inx] $"  ( "$currAmmo.AmmoAmount $"/"$ currAmmo.MaxAmmo $") " );

					// See if current one is less than the last known min
					if( PlayerAmmoPct[inx] < MinAmmoPct )
					{
						MinAmmoPct = PlayerAmmoPct[inx];
						currPref = inx;
					}
					else if( PlayerAmmoPct[inx] == MinAmmoPct && FRand() > 0.5 )
					{
						// Or if the same amount as last known min, randomly 
						// decide whether to use this or the last one 
						MinAmmoPct = PlayerAmmoPct[inx];
						currPref = inx;
					}
				}
			}
		}

		if( PlayerAmmoPct[currPref] < PreferredAmmoThreshhold[Level.Game.GameDifficulty] )
			PrefAmmoDropSlot = currPref;
		else
			PrefAmmoDropSlot = -1;
	//	Log("  CalcPreferredAmmoDrop:   PrefAmmoDropSlot:   raw:"$currPref $"    w/pct check:"$PrefAmmoDropSlot );
	}

	return PrefAmmoDropSlot;
}

// Given a random number between 0.0 and 1.0, will return an ammo type index
function int GetRandomAmmoPickupSlot( float randNumb )
{
	local int ammoTypeIndex;

	if( randNumb <= LevelAmmoPickupBinUpperLim[0] )  // First bin is easy, since lower lim is 0.
	{
		ammoTypeIndex = 0;
	}
	else
	{
		for( ammoTypeIndex = 1; ammoTypeIndex < MaxAmmoPickupTypes ; ammoTypeIndex++ )
		{
			if( randNumb >  LevelAmmoPickupBinUpperLim[ammoTypeIndex-1]  // if we're above this bin's lower limit (same as previous bin's upper limit)
			 && randNumb <= LevelAmmoPickupBinUpperLim[ammoTypeIndex]    // and if we're at or below this bin's upper limit
			 && LevelAmmoPickupBinUpperLim[ammoTypeIndex-1] != LevelAmmoPickupBinUpperLim[ammoTypeIndex] )  // and this isn't an empty bin
				break;  // stop, we've found our bin
		}
	}

	return ammoTypeIndex;
}

function bool PickupSlotCanTakeAmmo( int pickupSlot )
{
	local Ammunition currAmmo;
	local ZombiePlayerPawn PP;

	PP = LastKillerPlayer;

	if( PP != None )
		currAmmo = Ammunition(PP.FindInventoryType( PP.Weapons[pickupSlot].AmmoName ));

	if( currAmmo == None )
		return false;
	else if( currAmmo.AmmoAmount < currAmmo.MaxAmmo )
		return true;
	else
		return false;
}

// Returns a pickup for a random ammo type consistent with the level loadout.
// Checks to see if a preferred kind of ammo drop should be used instead of random.
function class<Pickup> GetRandomAmmoPickupClass( optional bool bFullAmmoGivesNoPickup )
{
	local int ammoTypeIndex;
	local float randNumb;
	local int PrefAmmoDropSlot;  // Current preferred slot for which to drop ammo

//	Log("#### SinglePlayerMI.GetRandomAmmoPickupClass   LastKillerPlayer:"$LastKillerPlayer );

	// Check if there is a preferred ammo drop (based on player need)
	if( FRand() < 0.90 )
	{
//ammodrop		Log("   Checking CalcPreferredAmmoDrop");
		PrefAmmoDropSlot = CalcPreferredAmmoDrop();
	}
	else
	{
//ammodrop		Log("   Skipping CalcPreferredAmmoDrop");
		PrefAmmoDropSlot = -1;
	}

//	Log("  #### SinglePlayerMI.GetRandomAmmoPickupClass  PrefAmmoDropSlot:"$PrefAmmoDropSlot );

	// If there is a preferred ammo drop slot, return that ammo type
	if( PrefAmmoDropSlot > -1 && LastKillerPlayer != None )
	{
//ammodrop		Log(" **SPMI.GetRandomAmmoPickupClass  Using preferred ammo drop slot.  LevelAmmoPickupClass["$PrefAmmoDropSlot$"]:"$LevelAmmoPickupClass[PrefAmmoDropSlot] );
	//	LastKillerPlayer = None;
		LastAmmoDropSlot = PrefAmmoDropSlot;
		return LevelAmmoPickupClass[PrefAmmoDropSlot];
	}

	// Otherwise (no preferred ammo drop), pick randomly
	//  Get pseudo-random number
	randNumb = FRand();
	//  Get ammo type index based on that random number
	ammoTypeIndex = GetRandomAmmoPickupSlot( randNumb );

//ammodrop	Log("////SinglePlayerMI.GetRandomAmmoPickupClass  ammoTypeIndex:"$ammoTypeIndex $"   LevelAmmoPickupClass[ammoTypeIndex]:"$LevelAmmoPickupClass[ammoTypeIndex] );
//ammodrop	Log("  **SPMI.GetRandomAmmoPickupClass  Using random.   LevelAmmoPickupClass["$ammoTypeIndex$"]:"$LevelAmmoPickupClass[ammoTypeIndex] );
//	LastKillerPlayer = None;
	LastAmmoDropSlot = ammoTypeIndex;

	if( bFullAmmoGivesNoPickup && !PickupSlotCanTakeAmmo(LastAmmoDropSlot) )
	{
		return None;
	}
	else
	{
		return LevelAmmoPickupClass[LastAmmoDropSlot];
	}
}

// Returns a random ammo type consistent with the level loadout.
// Checks to see if a preferred kind of ammo drop should be used instead of random.
// This returns the ammo class, not the pickup class.  Call this one if you
// want random ammo from a searchable dead body, for example.
function class<Ammunition> GetAmmoClassForSearchableObject()
{
	local class<Pickup> pickupClass;

	pickupClass = GetRandomAmmoPickupClass(true);


	if( class<AmmoPickup>(pickupClass) != None )
	{
		return class<AmmoPickup>(pickupClass).default.AmmunitionClass;
	}
	else
	{
		return None;
	}
}

// Returns an ammo type for the specified weapon slot (1 - 4)
// If Slot is out of range, will return slot 1 by default.
function class<Pickup> GetAmmoPickupClass(int Slot)
{
	if( Slot >= 1 && Slot <= 4 )
		LastAmmoDropSlot = Slot - 1;
	else
		LastAmmoDropSlot = 1;

//ammodrop	Log(" **SPMI.GetAmmoPickupClass   LevelAmmoPickupClass["$LastAmmoDropSlot $"]:"$ LevelAmmoPickupClass[LastAmmoDropSlot] );
	return LevelAmmoPickupClass[LastAmmoDropSlot];
}

// Sets the clip size for the given input ammo pickup
// Works best if it is the last pickup dropped.
function SetAmmoDropClipSize(AmmoPickup P)
{
	local int inx, clipSize;

	if( P != None )
	{
	//	Log("##  P:"$P.class $" LevelAmmoPickupClass[LastAmmoDropSlot]:"$LevelAmmoPickupClass[LastAmmoDropSlot] $"  LevelAmmoPickupClass[LastAmmoDropSlot].name:"$LevelAmmoPickupClass[LastAmmoDropSlot].name );
		if( P.IsA( LevelAmmoPickupClass[LastAmmoDropSlot].name ) )
		{
		//	Log("##  Easy case!!");
			// Easy case: this matches the type of the last ammo dropped, 
			// so just use the info for the last slot
			clipSize = LevelAmmoPickupAmount[LastAmmoDropSlot];
		}
		else
		{
		//	Log("##  Backup case!!");
			// Backup case: this is not the last ammo dropped, so
			// have to find a matching slot (if any)
			for( inx = 0 ; inx < MaxAmmoPickupTypes ; inx++ )
			{
				if( P.IsA( LevelAmmoPickupClass[inx].name ) )
				{
					clipSize = LevelAmmoPickupAmount[LastAmmoDropSlot];
					break;  // If match was found, we can stop looking
				}
			}
		}

		if( clipSize > 1 )
			P.AmmoAmount = clipSize;
	}
}
// END Ammo drop



// ----------------------------------------------------------------------------------------------------
// Playerview weapon (hand) reskinning

simulated function SetLevelHandsTexture()
{
	Level.HandsTexture = texture(DynamicLoadObject(DefaultHandsTextureName,class'texture'));
}

function PlayerViewWeapon(Weapon newWeapon)
{
	local texture WeapSkin;
	local string WeapSkinName;

	assert( ZombieWeapon(newWeapon) == None || ZombieWeapon(newWeapon).HandsSkinIndex != 0 || ZombieWeapon(newWeapon).HandsSkinIndex != 1 );

	WeapSkinName = ZombieWeapon(newWeapon).GetCampaignWeapSkin(Campaign);
	if( WeapSkinName == "" )
		WeapSkin = None;
	else
		WeapSkin = texture(DynamicLoadObject(WeapSkinName,class'texture'));

	if( HandsTexture == None )
	{
		HandsTexture = texture(DynamicLoadObject(DefaultHandsTextureName,class'texture'));
	}
	ZombieWeapon(newWeapon).Reskin(HandsTexture, WeapSkin);
}
// END Playerview weapon (hand) reskinning



// ----------------------------------------------------------------------------------------------------


// Decompiled with UE Explorer.
defaultproperties
{
    StartingWeaponSlot=2
    DefaultHandsTextureName="CBT_DYN_Weapons.hands.pv_hands"
    MaxAmmoPickupTypes=4
    PreferredAmmoThreshhold[0]=0.5000000
    PreferredAmmoThreshhold[1]=0.3500000
    PreferredAmmoThreshhold[2]=0.1500000
    PreferredAmmoThreshhold[3]=0.1000000
    HealthAssistThreshhold[0]=-10
    HealthAssistThreshhold[1]=-10
    HealthAssistThreshhold[2]=-10
    HealthAssistThreshhold[3]=-10
    MinHealthDropInterval=20.0000000
    bCarryLoadoutFromPrevLevel=true
}