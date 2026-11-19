class combat_RPGDeath extends CoreTask within animscripts_combat;

state main
{
Begin:
	if (randomFloat(1) > 0.5)
		SetFlaggedAnimKnobAll('deathanim', 'RPG_stand_death', 'root', 1, 0.05, 1);
	else
		SetFlaggedAnimKnobAll('deathanim', 'RPG_stand_death_stagger', 'root', 1, 0.05, 1);

	animscripts_shared.DoNoteTracks('deathanim');
	animscripts_shared.DropAllAIWeapons();
}
