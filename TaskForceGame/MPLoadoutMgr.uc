class MPLoadoutMgr extends object
	abstract;

var MPLoadout TerroristLoadout;
var MPLoadout SFLoadout;

static function MPLoadout GetLoadout(bool bTerrorist)
{
	if (bTerrorist)
		return default.TerroristLoadout;
	else
		return default.SFLoadout;
}

static function string GetPistolWeaponClassName(bool bTerrorist)
{
	return GetLoadout(bTerrorist).PistolWeapon;
}

static function string GetClassWeaponClassName(bool bTerrorist, class<MPClass> playerClass)
{
	return GetLoadout(bTerrorist).ClassWeapons[playerClass.default.WeapListIndex];
}

static function string GetExplosiveWeaponClassName(bool bTerrorist, class<MPClass> playerClass)
{
	return GetLoadout(bTerrorist).ExplosiveWeapons[playerClass.default.WeapListIndex];
}


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: MPLoadout'MPLoadoutMgr.Loadout0'
    begin object name=Loadout0 class=Class'MPLoadout'
        PistolWeapon="Weapons.WeapUSP"
        ClassWeapons[0]="Weapons.WeapM4"
        ClassWeapons[1]="Weapons.WeapM82A1"
        ClassWeapons[2]="Weapons.WeapMk43"
        ClassWeapons[3]="Weapons.WeapShotgun"
        ClassWeapons[4]="Weapons.WeapMP5"
        ExplosiveWeapons[0]="Weapons.WeapM203"
        ExplosiveWeapons[1]="Weapons.WeapHEGrenade"
        ExplosiveWeapons[2]="Weapons.WeapHEGrenade"
        ExplosiveWeapons[3]="Weapons.WeapHEGrenade"
        ExplosiveWeapons[4]="Weapons.WeapC4"
    end object
    TerroristLoadout=Loadout0
    // Reference: MPLoadout'MPLoadoutMgr.Loadout1'
    begin object name=Loadout1 class=Class'MPLoadout'
        PistolWeapon="Weapons.WeapUSP"
        ClassWeapons[0]="Weapons.WeapM4"
        ClassWeapons[1]="Weapons.WeapM82A1"
        ClassWeapons[2]="Weapons.WeapMk43"
        ClassWeapons[3]="Weapons.WeapShotgun"
        ClassWeapons[4]="Weapons.WeapMP5"
        ExplosiveWeapons[0]="Weapons.WeapM203"
        ExplosiveWeapons[1]="Weapons.WeapHEGrenade"
        ExplosiveWeapons[2]="Weapons.WeapHEGrenade"
        ExplosiveWeapons[3]="Weapons.WeapHEGrenade"
        ExplosiveWeapons[4]="Weapons.WeapC4"
    end object
    SFLoadout=Loadout1
}