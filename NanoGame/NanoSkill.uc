/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill extends Object
	native(Pawn)
	config(Pawn);

/** Each NanoSkill base type should have a unique entry in the ENanoSkills enum (see NanoTypes.uc).  Used as the index into the Skills array, and governs replication and remote activation */
var const ENanoSkills SkillType;

/** If TRUE, the skill will not be replicated via the ServerActivateSkill / ReplicatedSkillStatus */
var const bool bSkipReplication;

/** PRI owner of this skill object */
var transient NanoPRI PRIOwner;

/** NanoPawn owner of this skill object, only valid if active */
var transient NanoPawn PawnOwner;

/** Is this skill currently active on a NanoPawn? */
var transient bool bActive;

/** Last time this skill was activated */
var transient float LastActivateTime;

/** Last time this skill was deactivated */
var transient float LastDeactivateTime;

/** Information for a skill dependency for progressing this skill */
struct native SkillDependency
{
	var class<NanoSkill>	DependentSkill;
	var int					DependentSkillLevel;
};

/** Information for each level of this skill */
struct native SkillLevelInfo
{
	var string					SkillName;
	var string					SkillDescription;
	var int						XPToNextLevel;
	//var array<SkillDependency>	SkillDependencies;
	var float					InitialNanoCost;
	var float					NanoCostPerSecond;
};
var config array<SkillLevelInfo>	SkillLevels;

/** Currently attained skill level */
var int SkillLevel;

/** Current active skill level (dash levels, etc) */
var int ActiveSkillLevel;

/** If TRUE, do not draw on skills UI 
 * Some of our skills we do not want to show in the skill list (even tho we have them).  You can't upgrade them so they just are clutter 
 **/
var bool bHideFromSkillUI;

/** Texture to use for icon for this skill */
var texture2D	SkillIconTexture;
/** Origin (top left corner) of icon on this texture (in pixels) */
var	vector2D	SkillIconOrigin;
/** Dimensions of this icon on the texture (in pixels) */
var vector2D	SkillIconSize;

cpptext
{
	virtual void Tick(FLOAT DeltaTime);
}

simulated final event NanoPC GetPC()
{
	return NanoPC(PawnOwner.Controller);
}

simulated function RegisterSkill( NanoPawn NewOwner )
{
	PawnOwner = NewOwner;
	PRIOwner  = NanoPRI(NewOwner.PlayerReplicationInfo);
}

simulated function bool SetSkillLevel(optional bool bSkipXP, optional int DesiredSkillLevel)
{
	local int EXP_Spent;

	DesiredSkillLevel = FClamp(DesiredSkillLevel, 0, SkillLevels.Length-1); 

	if (CanSetSkill(bSkipXP, DesiredSkillLevel))
	{
		if (!bSkipXP)
		{
			// check to see if we are going up or down
			if( DesiredSkillLevel > SkillLevel )
			{
				EXP_Spent = SkillLevels[SkillLevel].XPToNextLevel;
			}
			else
			{
				EXP_Spent = -SkillLevels[Max(SkillLevel-1,0)].XPToNextLevel;
			}

			NanoGRI(PawnOwner.WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.EXP_Spent, EXP_Spent );

			//`log( `showvar(EXP_Spent) );

		}
		
		SkillLevel = DesiredSkillLevel;

		SkillLevelJustModified();
		return TRUE;
	}

	return FALSE;
}


/** When a skill level is modified this function is called to allow the skill to do any work it needs to do (e.g. setting some vars) **/
simulated function SkillLevelJustModified();

simulated function bool CanSetSkill(optional bool bSkipXP, optional int DesiredSkillLevel)
{
	local NanoPRI PRI;
	local int ExpAvail;

	if( PawnOwner != None )
	{
		PRI = NanoPRI(PawnOwner.PlayerReplicationInfo);

		ExpAvail = PRI.GetAvailEXP();

		return ( ( (DesiredSkillLevel != SkillLevel) 
			&& (DesiredSkillLevel >= 0) 
			&& (DesiredSkillLevel < SkillLevels.Length) 
			&& (bSkipXP || ExpAvail >= SkillLevels[SkillLevel].XPToNextLevel)
			)
			|| ( DesiredSkillLevel < SkillLevel ) // always allow downgrading
			);
	}
	return FALSE;
}

simulated function bool ShouldConsumeNanoPower()
{
	return SkillLevels[SkillLevel].NanoCostPerSecond > 0.f;
}

/** Returns whether or not we should play effects for this skill.  By default, play effects if we're not a dedicated server (i.e. someone can actually see the pawn) */
simulated function bool ShouldPlayClientEffects()
{
	return ((PawnOwner != None) && (PawnOwner.WorldInfo.NetMode != NM_DedicatedServer));
}

simulated event Tick(float DeltaTime)
{
	local float NanoCost;

	if( PawnOwner.Health <= 0 )
	{
		DeactivateSkill();
	}

	// consume active nano power
	if (ShouldConsumeNanoPower())
	{
		NanoCost = DeltaTime * GetNanoCostPerSecond();

		// quick hack as this will play a sound but the ConsumeNanoPower currently will not and it is more painful to update that guy as it has
		// optional arguments already
		PawnOwner.HasEnoughNanoPower( NanoCost, TRUE );
		
		// Don't deactivate if NanoCost is < 0.f, because we're giving nano back to the player
		if( !PawnOwner.ConsumeNanoPower(NanoCost) && (NanoCost > 0.f))
		{
			// deactivate if we run out of juice
			DeactivateSkill();
		}
	}
}

simulated event bool ActivateSkill()
{
	if( SkillLevels[SkillLevel].InitialNanoCost > 0.f && !PawnOwner.ConsumeNanoPower(SkillLevels[SkillLevel].InitialNanoCost) )
	{
		PawnOwner.HasEnoughNanoPower( SkillLevels[SkillLevel].InitialNanoCost, FALSE ); // hack to play sound as ConsumeNanoPower doesn't play atm
		return FALSE;
	}
	PawnOwner.ActiveSkills.AddItem(self);

	ActiveSkillLevel = 0;
	LastActivateTime = PawnOwner.WorldInfo.TimeSeconds;
	bActive = TRUE;
	InternalActivated();

	if( !bSkipReplication )
	{
		if( PawnOwner.Role < ROLE_Authority )
		{
			PawnOwner.ServerSkillActivated(Class);
		}
		else
		{
			PawnOwner.SetReplicatedSkillStatus(SkillType, TRUE);
		}
	}

	return TRUE;
}

simulated event DeactivateSkill()
{
	if( bActive )
	{
		if( !bSkipReplication )
		{
			if( PawnOwner.Role < ROLE_Authority )
			{
				PawnOwner.ServerSkillDeactivated(Class);
			}
			else
			{
				PawnOwner.SetReplicatedSkillStatus(SkillType, FALSE);
			}
		}

		LastDeactivateTime = PawnOwner.WorldInfo.TimeSeconds;
		PawnOwner.ActiveSkills.RemoveItem(self);
		ActiveSkillLevel = -1;
		bActive = FALSE;
		InternalDeactivated();
	}
}

/** This should be overridden in the subclass to do any skill specific "activated" functionality **/
simulated protected function InternalActivated()
{
}

/** This should be overridden in the subclass to do any skill specific "deactivated" functionality **/
simulated protected function InternalDeactivated()
{
}

/** Function to get icon info for this skill */
simulated function Texture2D GetIconInfo(out vector2D Origin, out vector2D Size)
{
	Origin = SkillIconOrigin;
	Size = SkillIconSize;
	return SkillIconTexture;
}

/** Gets the name of the skill at the current level */
simulated function string GetCurrentSkillName()
{
	return SkillLevels[SkillLevel].SkillName;
}

/** Gets the current skill level in use */
simulated function int GetCurrentSkillLevelInUse()
{
	return -1;
}

/** Gets the nano cost per second for the current skill level */
simulated function float GetNanoCostPerSecond()
{
	return SkillLevels[SkillLevel].NanoCostPerSecond;
}

/** Called on active skills to allow them to modify the damage.  (e.g. you are shot and are Ghosting) */
function ModifyDamage( const Pawn Victim, out int Damage, const Controller InstigatedBy, const vector HitLocation, const vector Momentum, const class<DamageType> DamageType, const optional TraceHitInfo HitInfo, const optional Actor DamageCauser)
{
}

simulated function PreProcessInput( float DeltaTime, NanoPlayerInput_Base PlayerInput );
simulated function PostProcessInput( float DeltaTime, NanoPlayerInput_Base PlayerInput );



defaultproperties
{
	SkillType=NS_MAX
	SkillIconTexture=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_Menu_IconsA'
	ActiveSkillLevel=-1
}