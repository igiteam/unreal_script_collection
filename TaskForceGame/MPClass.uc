class MPClass extends object
	abstract;

var int WeapListIndex;
//var string SFModelClassName;
//var string TerrModelClassName;

var string SFMeshName;
var string SFSkins[2];

var string TerrMeshName;
var string TerrSkins[2];

var float DamageAdjust;
var float AmmoAdjust[4];	//multiplier for standard ammo amount in this slot
var string MPClassName;
var int	MPClassIdx;
var bool bVIP;

var float GroundSpeed;

//HACK!!!
static function class<MPClass> GetClassFromIdx(int idx)
{
	switch(idx)
	{
		case 2:
			return class'ZombieGame.MPSniper';break;
		case 3:
			return class'ZombieGame.MPHeavyWeapons';break;
		case 4:
			return class'ZombieGame.MPScout';break;
		case 5: 
			return class'ZombieGame.MPDemolitions';break;
		case 6: 
			return class'ZombieGame.MPVip';break;
		case 1: default:
			return class'ZombieGame.MPSoldier';break;
	}
}

static function mesh GetMeshFromIdx(int idx, bool isTerr)
{
	local class<MPClass> retClass;
	
	//hack upon hack: set default
	retClass = GetClassFromIdx(idx);

	if (isTerr)
	{
		return mesh(DynamicLoadObject(retClass.default.TerrMeshName,class'mesh'));
	}

	return mesh(DynamicLoadObject(retClass.default.SFMeshName,class'mesh'));
}

static function material GetSkinFromIdx(int idx, bool isTerr, int skinNum)
{
	local class<MPClass> retClass;
	
	//hack upon hack: set default
	retClass = GetClassFromIdx(idx);

	if (isTerr)
	{
		return material(DynamicLoadObject(retClass.default.TerrSkins[skinNum],class'material'));
	}

	return material(DynamicLoadObject(retClass.default.SFSkins[skinNum],class'material'));
}

static function float GetSpeedFromIdx(int idx)
{
	local class<MPClass> retClass;
	
	//hack upon hack: set default
	retClass = GetClassFromIdx(idx);

	return retClass.default.GroundSpeed;
}


// Decompiled with UE Explorer.
defaultproperties
{
    SFMeshName="CBA_Characters.soldier_a"
    SFSkins[0]="CBT_DYN_Characters.soldier.soldier_a_head"
    SFSkins[1]="CBT_DYN_Characters.soldier.soldier_a_body"
    TerrMeshName="CBA_Characters.combat_enemy"
    TerrSkins[0]="CBT_DYN_Characters.Enemy.enemy_head"
    TerrSkins[1]="CBT_DYN_Characters.Enemy.enemy_body"
    DamageAdjust=1.0000000
    AmmoAdjust[0]=1.0000000
    AmmoAdjust[1]=1.0000000
    AmmoAdjust[2]=1.0000000
    AmmoAdjust[3]=1.0000000
    MPClassIdx=-1
    GroundSpeed=350.0000000
}