/**
 * Copyright 2013 Red Barrels Inc. All Rights Reserved.
 */
class OLAIGroup extends Info
	native(AI);

var array<OLBot> Bots;

var OLBot AttackingBot;
var bool bTokenAvailable;

var float AttackTimer;

var const float MinTimeBetweenAttacks;
var const float MaxTimeBetweenAttacks;

cpptext
{
	void TickSpecial( float DeltaTime );
};

event AddBot(OLBot Bot)
{
	if (Bot.Group == None)
	{
		Bots.AddItem(Bot);
		Bot.Group = self;
	}
	else
	{
		`warn("Bot Already in Group.");
	}
}

event RemoveBot(OLBot Bot)
{
	Bot.Group = None;
	Bots.RemoveItem(Bot);

	if (Bots.length <= 0)
	{
		Destroy();
	}
}

event TriggerAudioDisturbance(OLBot Triggerer, vector DisturbanceLocation, optional bool bNewInvestigate, optional bool bNoTrim)
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		if (Bot != Triggerer)
		{
			Bot.TriggerAudioDisturbance(DisturbanceLocation, TRUE, bNewInvestigate, bNoTrim);
		}
	}
}

event TriggerVisualDisturbance(OLBot Triggerer, vector DisturbanceLocation)
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		if (Bot != Triggerer)
		{
			Bot.TriggerVisualDisturbance(DisturbanceLocation, TRUE);
		}
	}
}

function ToggleAIIgnorePlayer(bool bEnable)
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		Bot.ToggleAIIgnorePlayer(bEnable);
	}
}

function ToggleAIAlwaysSeePlayer(bool bEnable)
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		Bot.ToggleAIAlwaysSeePlayer(bEnable);
	}
}

event bool CanAnyoneSeeTarget()
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		if (Bot.SightComponent.CanSeeTarget && Bot.EnemyPawn.Modifiers.bShouldAttack)
		{
			return true;
		}
	}

	return false;
}

event bool DidAnyoneSeePlayerinLocker()
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		if (Bot.SightComponent.bSawPlayerEnterHidingSpot && Bot.EnemyPawn.Modifiers.bShouldAttack)
		{
			return true;
		}
	}

	return false;
}

event bool DidAnyoneSeePlayerInBed()
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		if (Bot.SightComponent.bSawPlayerEnterBed && Bot.EnemyPawn.Modifiers.bShouldAttack)
		{
			return true;
		}
	}

	return false;
}

event Recalculate()
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		Bot.Recalculate();
	}
}

native function bool CanAttack(OLBot Attacker);
native function TakeAttackToken(OLBot Attacker);
native function ReturnAttackToken(OLBot Attacker);

function NotifyOthersPathChanged(OLBot Notifier)
{
	local OLBot Bot;

	foreach Bots(Bot)
	{
		if (Bot != Notifier)
		{
			Bot.NotifyPathChanged();
		}
	}
}

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.AmmoPickup.T_Ammo_Coop_Only'
	End Object

	bTokenAvailable=true
	AttackTimer=0.0f

	MinTimeBetweenAttacks=1.0f
	MaxTimeBetweenAttacks=3.0f
}