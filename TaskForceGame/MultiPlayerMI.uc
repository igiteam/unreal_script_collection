
class MultiPlayerMI extends MapInfo
	editinlinenew
	placeable; 

var class<MPLoadoutMgr> loadoutClass;

function AddWeaponToPawnSlotByName(Pawn aPawn,int slot,string WeaponClassName)
{
	local class<ZombieWeapon>			WeaponClass; 

	WeaponClass = class<ZombieWeapon>(DynamicLoadObject(WeaponClassName,class'Class'));
	ZombiePlayerPawn(aPawn).AddWeaponToSlot(slot, WeaponClass);

	if( ZombiePlayerPawn(aPawn).Weapons[slot] != None )
		ZombiePlayerPawn(aPawn).Weapons[slot].ClientPlayerViewWeapon();
}

event RestartPlayer(Pawn aPawn)
{
	local SFRMPlayerController PC; 
	local ZombiePlayerPawn SFPP;
	
//SysLinkSPAM	log("MultiplayerMI RestartPlayer: " $ aPawn);

	// special handling for bots
	if ( ZombieMPBot ( aPawn.Controller ) != None )
	{
		ZombieMPBot ( aPawn.Controller ).InitializeBot ( );
		return;
	}
	
	PC = SFRMPlayerController(aPawn.Controller); 
	if ((PC == None) || !PC.bIsPlayer)
	{
//SPAM	log("Multiplayer MI: NOT RestartPlayer: " $ PC @ PC.bIsPlayer);
		return;
	}
	
//SysLinkSPAM	log("Multiplayer MI: RestartPlayer: " $ PC @ PC.GetMPClass());
	
	AddWeaponToPawnSlotByName(aPawn,0,loadoutClass.static.GetPistolWeaponClassName(PC.PlayerReplicationInfo.bTerrorist));
	AddWeaponToPawnSlotByName(aPawn,3,"Weapons.WeapKnife");
	
	if (!PC.GetMPClass().default.bVIP)
	{
		AddWeaponToPawnSlotByName(aPawn,2,loadoutClass.static.GetExplosiveWeaponClassName(PC.PlayerReplicationInfo.bTerrorist,PC.GetMPClass()));
		AddWeaponToPawnSlotByName(aPawn,1,loadoutClass.static.GetClassWeaponClassName(PC.PlayerReplicationInfo.bTerrorist,PC.GetMPClass()));
	}

	// Ensure pawn starts with correct weapon
	SFPP = ZombiePlayerPawn(aPawn);
	if( SFPP != None )
	{
//SPAM		Log("Multiplayer MI: RestartPlayer:  SFPP.StartingWeapSlot:"$ SFPP.StartingWeapSlot $"  SFPP.bStartedWithWeap:"$ SFPP.bStartedWithWeap );
		Log("Multiplayer MI: RestartPlayer:  SFPP.StartingWeapSlot:"$ SFPP.StartingWeapSlot $"  SFPP.bStartedWithWeap:"$ SFPP.bStartedWithWeap );
		SFPP.StartingWeapSlot = 1;
		SFPP.PickAndSetStartingWeapon();
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    LoadoutClass=Class'MPLoadoutMgr'
    HandsTexture=Texture'CBT_DYN_Weapons.hands.pv_hands'
}