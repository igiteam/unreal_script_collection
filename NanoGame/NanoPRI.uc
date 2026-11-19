/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPRI extends PlayerReplicationInfo
	config(Pawn)
	native;

///////// PROFILE SETTINGS ///////////
/** This will determine whether or not we show gore.  This will be set from the Player' ProfileSettings. **/
var transient bool bShowGore;
/** Determines if we show the tooltip pictograms */
var bool bShowPictograms;



///// Variables that we need to store off into the DB /////
// We protectedwrite all such vars and then when they get updated we update the MCP cache
// TODO:  figure out if we just want the MCP cache to be authoritative and have it write to here 
//        to replicate out the info


/** Available XP */
var protectedwrite transient int AvailableXP;
var private transient int PreviousXP;

/** How many ticks have we absorbed**/
var protectedwrite transient int TicksAbsorbed;

var protectedwrite transient int CollectiblesAbsorbed;

/** This is the amount of currency this pawn has **/
var protectedwrite transient int AmountOfCurrencyOwned;




/** One plan in our inventory */
struct native NanoPlanInfo
{
	/** Plan class */
	var class<NanoPlan> Plan;
	/** If this plan is 'unlocked' and can be used */
	var bool            bUnlocked;
};

/** Set of all plans we own, locked and unlocked.  This us for both weapons and weapon mods and any item we can generate from our hand forge */
var transient array<NanoPlanInfo> OwnedPlans;

/** Plan currently in gun slot */
var transient class<NanoPlan_WeaponBase>    GunPlan;
/** Plan currently in melee slot e.g. sword */
var transient class<NanoPlan_WeaponBase>    MeleePlan;


/** Plan currently in utility slot e.g. moon */
var transient class<NanoPlan>    UtilityPlan;

/** List of plans quick-bound to d-pad (up, down, left, right) */
var transient class<NanoPlan>    QuickBindPlans[4];

/** 
 *  Struct that stores the way we currently are modifying a weapon.  We have a set of possible mods that are plans we own and then this the actual
 * configuration and level of mod that we are utilizing.  
 **/
struct native WeaponModifierItem
{
	var class<NanoWeapon>			WpnClassToMod;

	/** We can have only one ammo mod **/
    var class<NanoAmmoModifier>		AmmoModClass;
	var int							AmmoModLevel;
	/** We can have only one chasis mod **/
	var class<NanoChasisModifier>	ChasisModClass;
	var int							ChasisModLevel;
};
var() transient editinline array<WeaponModifierItem> WpnMods;


var() config array<int> XPPerLevel;


simulated function PostBeginPlay()
{
	local class<NanoPlan> GunClass;

	Super.PostBeginPlay();

	AvailableXP = 0;
	AmountOfCurrencyOwned = 0;

	//// Give plans for starting loadout
// 	GiveNanoPlan(class'NanoPlan_Sword', TRUE);
// 	EquipNanoPlan(class'NanoPlan_Sword');

	GiveNanoPlan(class'NanoPlan_Knife', TRUE);
	EquipNanoPlan(class'NanoPlan_Knife');

	GunClass = class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HeavyRevolver", class'Class'));
	GiveNanoPlan( GunClass, TRUE );
 	EquipNanoPlan(GunClass);

	// give the four guns we can d-pad to
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HoldOutPistol", class'Class')), TRUE );
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_SemiAutoPistol", class'Class')), TRUE );
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HeavyRevolver", class'Class')), TRUE );
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HandCannon", class'Class')), TRUE );



	GiveNanoPlan(class'NanoPlan_RebelHandPrint', TRUE);
	GiveNanoPlan(class'NanoPlan_AmmoCrate', TRUE);


	//// DEBUG ATM  These need to be turned to FALSE
	GiveNanoPlan( class'NanoPlan_ButterflyBullets', TRUE );
	GiveNanoPlan( class'NanoPlan_DenseBullets', TRUE );
	GiveNanoPlan( class'NanoPlan_ExplosiveBullets', TRUE );
	GiveNanoPlan( class'NanoPlan_QuickReload', TRUE );


	//// Give plans that are available at the store
	// Right now how we do that is give them to the player locked and then the store will unlock them if you have enough cash
	//GiveNanoPlan(class'NanoPlan_Sword', FALSE);
	//GiveNanoPlan(class'NanoPlan_SwordUpgraded', FALSE);



	//GiveNanoPlan( class'NanoPlan_ForgeRockets', FALSE );
	//GiveNanoPlan( class'NanoPlan_ForgeRockets_Homing', FALSE );
	//GiveNanoPlan( class'NanoPlan_Boulder', FALSE );



	// populate the "store"
	GiveNanoPlan(class'NanoPlan_Staff', FALSE);
	GiveNanoPlan(class'NanoPlan_StaffUpgraded', FALSE);

	//GiveNanoPlan(class'NanoPlan_SwordUpgraded', FALSE);

//	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_RebelSuperBomb", class'Class')), TRUE );
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_RebelAntenna", class'Class')), FALSE );
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_HealthTotem", class'Class')), FALSE );

	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_BulletMagnet", class'Class')), FALSE );

	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Thruster", class'Class')), FALSE );

	


	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_Boulder", class'Class')), FALSE );
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGame.NanoPlan_ForgeRockets_Homing", class'Class')), FALSE );

	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Attractor", class'Class')), FALSE );
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Orbitals", class'Class')), FALSE );
	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_ShieldWall", class'Class')), FALSE );



//	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_SentryTurret", class'Class')), TRUE );

// 	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Orbitals", class'Class')), FALSE );
// 
// 	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Mine", class'Class')), FALSE );
// 
// 	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Attractor", class'Class')), FALSE );
// 
// 	GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_ShieldWall", class'Class')), FALSE );

	

	//GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Cannon", class'Class')), TRUE );



	//GiveNanoPlan( class<NanoPlan>(DynamicLoadObject("NanoGameContent.NanoPlan_Suitcase", class'Class')), TRUE );
	
	//GiveNanoPlan(class'NanoPlan_RicochetMoon', true);
	//SetNanoPlanToSlot(class'NanoPlan_RicochetMoon');
	//GiveNanoPlan(class'NanoPlan_Orbitals', true);
	//SetNanoPlanToSlot(class'NanoPlan_Orbitals');


	bShowGore = TRUE;
}

// update our stored vars from the MCP

function UpdateValuesFromMCP()
{
	local int TempInt;

	NanoGRI(WorldInfo.GRI).MCP.FindIntValue( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.Currency, TempInt);
	//AwardCurrency( TempInt );
	AmountOfCurrencyOwned = TempInt;
	UpdateHUD( AmountOfCurrencyOwned, "Currency from MCP" );

	NanoGRI(WorldInfo.GRI).MCP.FindIntValue( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.EXP, TempInt);
	//AwardXP( TempInt );
	AvailableXP = TempInt;
	UpdateHUD( AvailableXP, "EXP from MCP" );

	NanoGRI(WorldInfo.GRI).MCP.FindIntValue( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumCollectiblesAbsorbed, TempInt);
	//AwardTickAbsorbed( TempInt );
	TicksAbsorbed = TempInt;
	UpdateHUD( TicksAbsorbed, "TicksAbsorbed from MCP" );
}




function ModifyWeaponModifications( class<NanoWeapon> WpnClass, class<NanoWeaponModifier> WeaponModClass, optional int ModLvl )
{

	if( ClassIsChildOf( WeaponModClass, class'NanoAmmoModifier' ) == TRUE )
	{
		ModifyWeaponAmmo( WpnClass, class<NanoAmmoModifier>(WeaponModClass), ModLvl );
	}
	else if( ClassIsChildOf( WeaponModClass, class'NanoChasisModifier' ) == TRUE )
	{
		ModifyWeaponChasis( WpnClass, class<NanoChasisModifier>(WeaponModClass), ModLvl );
	}
}


function ModifyWeaponAmmo( class<NanoWeapon> WpnClass, class<NanoAmmoModifier> AmmoModClass, optional int ModLvl )
{
	local int Idx; 

	Idx = WpnMods.Find( 'WpnClassToMod', WpnClass );
	if( Idx == INDEX_NONE )
	{
		Idx = WpnMods.Length;
		WpnMods.Length = Idx + 1;
		WpnMods[Idx].WpnClassToMod = WpnClass;
	}
	WpnMods[Idx].AmmoModClass = AmmoModClass;
	WpnMods[Idx].AmmoModLevel = ((AmmoModClass==None) ? -1 : Clamp( ModLvl, -1, AmmoModClass.static.GetMaxModLevel() ) );
}


function ModifyWeaponChasis( class<NanoWeapon> WpnClass, class<NanoChasisModifier> ChasisModClass, optional int ModLvl )
{
	local int Idx; 

	Idx = WpnMods.Find( 'WpnClassToMod', WpnClass );
	if( Idx == INDEX_NONE )
	{
		Idx = WpnMods.Length;
		WpnMods.Length = Idx + 1;
		WpnMods[Idx].WpnClassToMod = WpnClass;
	}
	WpnMods[Idx].ChasisModClass = ChasisModClass;
	WpnMods[Idx].ChasisModLevel = ((ChasisModClass==None) ? -1 : Clamp( ModLvl, -1, ChasisModClass.static.GetMaxModLevel() ) );
}


function class<NanoWeaponModifier> GetModClass( class<NanoWeapon> WpnClass, class<NanoWeaponModifier> WeaponModClass, out int ModLvl )
{
	if( ClassIsChildOf( WeaponModClass, class'NanoAmmoModifier' ) == TRUE )
	{
		return GetAmmoModClass( WpnClass, ModLvl );
	}
	else if( ClassIsChildOf( WeaponModClass, class'NanoChasisModifier' ) == TRUE )
	{
		return GetChasisModClass( WpnClass, ModLvl );
	}

	return none;
}


function class<NanoAmmoModifier> GetAmmoModClass( class<NanoWeapon> WpnClass, out int out_ModLvl )
{
	local int Idx; 
	Idx = WpnMods.Find( 'WpnClassToMod', WpnClass );
	if( Idx != INDEX_NONE )
	{
		if( WpnMods[Idx].AmmoModClass != None )
		{
			out_ModLvl = WpnMods[Idx].AmmoModLevel;
			return WpnMods[Idx].AmmoModClass;
		}
	}
	return None;
}


function class<NanoChasisModifier> GetChasisModClass( class<NanoWeapon> WpnClass, out int out_ModLvl )
{
	local int Idx; 
	Idx = WpnMods.Find( 'WpnClassToMod', WpnClass );
	if( Idx != INDEX_NONE )
	{
		if( WpnMods[Idx].ChasisModClass != None )
		{
			out_ModLvl = WpnMods[Idx].ChasisModLevel;
			return WpnMods[Idx].ChasisModClass;
		}
	}
	return None;
}


///////////////////////////////////////////////////////////////////
// PLANS

/** Look to see if we have a particular plan */
simulated function int FindNanoPlan(class<NanoPlan> Plan)
{
	return OwnedPlans.Find('Plan', Plan);
}

simulated function bool PlanIsAvailableForUse(class<NanoPlan> Plan)
{
	local int Idx;
	Idx = FindNanoPlan(Plan);
	if (Idx != INDEX_NONE)
	{
		return OwnedPlans[Idx].bUnlocked;
	}

	return FALSE;
}

/** Give a plan, and possibly unlock it as well */
simulated function GiveNanoPlan(class<NanoPlan> Plan, bool bUnlock)
{
	local NanoPlanInfo NewInfo;
	local int PlanIndex;

	//`log( "GiveNanoPlan" @ `showvar(Plan) @ `showvar(bUnlock) );

	PlanIndex = FindNanoPlan(Plan);

	// Only add if we don't already have it
	if ( (Plan != None) && PlanIndex == INDEX_NONE )
	{
		NewInfo.Plan = Plan;
		NewInfo.bUnlocked = bUnlock;
		OwnedPlans[OwnedPlans.Length] = NewInfo;
	}

	// if we found the plan and we wanted to unlock it
	if( ( PlanIndex != INDEX_NONE ) && ( bUnlock == TRUE ) )
	{
		// unlock it
		OwnedPlans[PlanIndex].bUnlocked = bUnlock;
	}
}


/** Remove a Plan */
simulated function RemoveNanoPlan(class<NanoPlan> Plan )
{
	local int PlanIndex;

	//`log( "GiveNanoPlan" @ `showvar(Plan) @ `showvar(bUnlock) );

	PlanIndex = FindNanoPlan(Plan);
	
	// if we found the plan and we wanted to unlock it
	if( PlanIndex != INDEX_NONE )
	{
		// remove the plan
		OwnedPlans.Remove( PlanIndex, 1 );
	}
}




/** Util to get contents of specific slot */
simulated function class<NanoPlan> GetPlanInSlot(ENanoPlanSlot Slot)
{
	if(Slot == EPS_Gun)
	{
		return GunPlan;
	}
	else if(Slot == EPS_Melee)
	{
		return MeleePlan;
	}
	else if(Slot == EPS_Utility)
	{
		return UtilityPlan;
	}
	
	return none;
}

/** Util to see if a plan is equipped */
simulated function bool PlanIsEquipped(class<NanoPlan> Plan)
{
	return(Plan == GunPlan || Plan == MeleePlan || Plan == UtilityPlan);
}

/** See if a plan can be put into a particular slot. If returns FALSE, ErrorString will contain the problem. */
simulated function bool PlanCanBeEquippedInSlot(class<NanoPlan> Plan, ENanoPlanSlot Slot, out string ErrorString)
{
	local int PlanIdx;
	
	// First check we own this plan
	PlanIdx = FindNanoPlan(Plan);
	if(PlanIdx == INDEX_NONE)
	{
		ErrorString = (Plan@"is not owned!");
		return FALSE;
	}
	
	// Then check it is unlocked
	if(OwnedPlans[PlanIdx].bUnlocked == FALSE)
	{
		ErrorString = (Plan@"is not unlocked!");
		return FALSE;	
	}
	
	// Check its not already equipped 
	if(Plan == GetPlanInSlot(Slot))
	{
		ErrorString = (Plan@"already equipped in slot"@Slot@"!");
		return false;
	}
	
	return TRUE;
}

/** Put a particular plan into a particular slot */
simulated function EquipNanoPlan(class<NanoPlan> Plan)
{
	local String Error;
	local ENanoPlanSlot Slot;

	Slot = Plan.default.PlanSlot;

	// See if we can do this
	if(!PlanCanBeEquippedInSlot(Plan, Slot, Error))
	{
		`log("SetNanoPlanToSlot:"@Error);
		return;
	}
	
	// We can!
	
	// Put new plan in correct slot
	if(Slot == EPS_Gun)
	{
		GunPlan = class<NanoPlan_WeaponBase>(Plan);
	}
	else if(Slot == EPS_Melee)
	{
		MeleePlan = class<NanoPlan_WeaponBase>(Plan);
	}
	else if(Slot == EPS_Utility)
	{
		UtilityPlan = Plan;	
	}
}


final function UpdateHUD( int Amount, string Label )
{
	local NanoHUD_Base HUD;
	local int Idx;

	HUD = NanoHUD_Base(PlayerController(Owner).myHUD);
	if (HUD != None)
	{
		Idx = HUD.XPMessages.Length;
		HUD.XPMessages.Length = Idx + 1;
		HUD.XPMessages[Idx].Label = Label;
		HUD.XPMessages[Idx].XPAmt = Amount;
		HUD.XPMessages[Idx].MessageTime = WorldInfo.TimeSeconds;
	}
}



function AwardCurrency( int Amount, string Label )
{
	AmountOfCurrencyOwned += Amount;
	Max( AmountOfCurrencyOwned, 0 ); // never go below 0 even if we tell it to
	UpdateHUD( Amount, Label );

	if( NanoPC(Owner).CanGainEXP() == TRUE )
	{
		NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.Currency, Amount );
	}

	NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_First1000Currency, Amount );
}


function AwardXP( int Amount, string Label )
{
	PreviousXP = AvailableXP;
	AvailableXP += Amount;
	UpdateHUD( Amount, Label );

	if( NanoPC(Owner).CanGainEXP() == TRUE )
	{
		NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.EXP, Amount );
	}

	NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_First1000EXP, Amount );

	// check to see if we leveled
	CheckToSeeIfWeLeveled();
}


// prob take the location of the tick
function AwardTickAbsorbed( int Amount, string Label )
{
	TicksAbsorbed += Amount;
	UpdateHUD( Amount, Label );

	if( NanoPC(Owner).CanGainEXP() == TRUE )
	{
		//NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumTicksAbsorbed, Amount );
	}
}


function AwardCollectibleAbsorbed( int Amount, string Label )
{
	CollectiblesAbsorbed += Amount;
	UpdateHUD( Amount, Label );

	if( NanoPC(Owner).CanGainEXP() == TRUE )
	{
		NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumCollectiblesAbsorbed, Amount );
	}
}


function ResetAllRewards()
{
	AwardTickAbsorbed( -TicksAbsorbed, "Reset" );
	AwardXP( -AvailableXP, "Reset" );
	AwardCurrency( -AmountOfCurrencyOwned, "Reset" );
}



/** Returns the amount of EXP the player has avail to spend. **/
function int GetAvailEXP()
{
	local NanoGRI NGRI;
	local string UserName;
	local int EXP;
	local int EXP_Spent;
	local int ExpAvail;

	// Grab the current selected skill
	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	UserName = class'NanoTypes'.static.GetLocalPlayerUserName();

	// check to see if we can afford this skill
	NGRI.MCP.FindIntValue( UserName, class'NanoMCPKeys'.default.EXP, EXP );
	NGRI.MCP.FindIntValue( UserName, class'NanoMCPKeys'.default.EXP_Spent, EXP_Spent );

	ExpAvail = EXP - EXP_Spent;


	return ExpAvail;
}



function CheckToSeeIfWeLeveled()
{
	local int Idx;
	local int LevelPre;
	local int LevelPost;

	// start at the top and work way down looking for the max level we could be
	for( Idx = XPPerLevel.Length-1; Idx > 0; --Idx )
	{
		if( PreviousXP > XPPerLevel[Idx] )
		{
			LevelPre = Idx;
			break;
		}
	}

	for( Idx = XPPerLevel.Length-1; Idx > 0; --Idx )
	{
		if( AvailableXP > XPPerLevel[Idx] )
		{
			LevelPost = Idx;
			break;
		}
	}


//	for( Idx = XPPerLevel.Length-1; Idx > 0; --Idx )
//	{
//		`log( `showvar(Idx) @ `showvar(XPPerLevel[Idx]) );
//	}

//	`log( `showvar(LevelPre) @ `showvar(LevelPost) );
	// we leveled
	if( LevelPost > LevelPre )
	{
		NanoHUD_Base(NanoGRI(WorldInfo.GRI).GetNanoPC().myHUD).SlideTextMessage( "Level Up To " @ LevelPost, 5.0f, class'Engine'.static.GetLargeFont(), SoundCue'UI_Temp.LevelUpDingCue' );
	}
}


function array< class<NanoWeaponModifier> > GetAllWeaponModifiers()
{
	local array< class<NanoWeaponModifier> > Retval;
	local NanoPlanInfo PlanInfo;

	foreach OwnedPlans(PlanInfo)
	{
		if( ( PlanInfo.Plan.default.WeaponModifierClass != none )
			&& ( Retval.Find(PlanInfo.Plan.default.WeaponModifierClass) == INDEX_NONE )  // only add if not already in list
			)
		{
			Retval.AddItem( PlanInfo.Plan.default.WeaponModifierClass );
		}
	}

	return Retval;
}


function array< class<NanoWeapon> > GetWeaponsWeHaveModifiersFor()
{
	local array< class<NanoWeapon> > Retval;
    local array< class<NanoWeaponModifier> > ListOfModfiers;
	local class<NanoWeaponModifier> WpnMod;
	local class<NanoWeapon> Wpn;

	ListOfModfiers = GetAllWeaponModifiers();

	foreach ListOfModfiers( WpnMod )
	{
		foreach WpnMod.default.WeaponsThisCanModify( Wpn )
		{
			if( Retval.Find(Wpn) == INDEX_NONE )  // only add if not already in list
			{
			    Retval.AddItem( Wpn );
			}
		}
	}

	return Retval;
}

/** Util to give max ammo for all weapons that we have unlocked */
function GiveMaxAmmoForUnlockedWeapons(NanoPawn NP)
{
	local NanoPRI NPRI;
	local NanoPlanInfo PlanInfo;
	local class<NanoPlan_WeaponBase> WeapPlan;

	//`log("GIVEMAXAMMOFORUNLOCKEDWEAPONS for"@NP);

	NPRI = NP.GetPRI();
	foreach NPRI.OwnedPlans( PlanInfo )
	{
		WeapPlan = class<NanoPlan_WeaponBase>(PlanInfo.Plan);
		if(PlanInfo.bUnlocked && (WeapPlan != None) && !WeapPlan.default.WeaponClass.default.bMeleeWeapon)
		{
			NP.GiveAmmo(WeapPlan.default.WeaponClass, WeapPlan.default.WeaponClass.default.WeaponMaxSpareAmmo, TRUE);
		}
	}
}

defaultproperties
{
	bShowPictograms=TRUE
}