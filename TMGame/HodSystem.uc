class HodSystem extends CoreSystem
	native(TG);

var HodLevel level;
var HodAnim anim;

var ShootEnemyWrapper_Normal gShootEnemyWrapper_Normal;

var float scr_ai_auto_fire_rate;

event PreBeginPlay()
{
	Super.PreBeginPlay();
	anim = HodAnim(NewObject(class'HodAnim'));
	level = HodLevel(NewObject(class'HodLevel'));

	gShootEnemyWrapper_Normal = new class'ShootEnemyWrapper_Normal';
}

function int GetTime()
{
	return WorldInfo.TimeSeconds * 1000;
}

function int FlagId(name iFlag)
{
	switch (iFlag)
	{
		
		





case 'player_is_invulnerable': return hod_flag_player_is_invulnerable;





















	

#linenumber 30;

	default: break;
	}

	return hod_flag_element_count;
}
