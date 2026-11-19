/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Suitcase extends NanoWeapon
	config(Weapon);

var bool bDeployed;
var Name DeployAnimName;

var AnimNodePlayCustomAnim AnimNode;

simulated state Active
{
	simulated function BeginFire(byte FireModeNum)
	{
		if (!bDeployed)
		{
			`log("deploying suitcase");
			GotoState('Deploying');
		}
		else
		{
			Super.BeginFire(FireModeNum);
		}
	}
}

function FinishedTransition();

state Deploying
{
	function BeginState(Name PrevStateName)
	{
		if (AnimNode == None)
		{
			AnimNode = AnimNodePlayCustomAnim(SkeletalMeshComponent(Mesh).FindAnimNode('CustomAnim'));
		}
		if (AnimNode != None)
		{
			SetTimer(AnimNode.PlayCustomAnim(DeployAnimName,1.f,0.1f,-1.f,FALSE,TRUE),FALSE,nameof(FinishedTransition));
		}
		else
		{
			SetTimer(1.f,FALSE,nameof(FinishedTransition));
		}
		Instigator.GotoState('UsingSuitcase');
	}

	function FinishedTransition()
	{
		bDeployed = TRUE;
		GotoState('Active');
	}
}

state Undeploying
{
	function BeginState(Name PrevStateName)
	{
		if (bDeployed)
		{
			if (AnimNode == None)
			{
				AnimNode = AnimNodePlayCustomAnim(SkeletalMeshComponent(Mesh).FindAnimNode('CustomAnim'));
			}
			if (AnimNode != None)
			{
				SetTimer(AnimNode.PlayCustomAnim('Closed',1.f,1.f,0.f,FALSE,TRUE),FALSE,nameof(FinishedTransition));
			}
			else
			{
				SetTimer(1.f,FALSE,nameof(FinishedTransition));
			}
			Instigator.GotoState('');
		}
		else
		{
			EndFire(CurrentFireMode);
		}
	}

	function FinishedTransition()
	{
		bDeployed = FALSE;
		EndFire(CurrentFireMode);
		GotoState('Active');
	}
}

defaultproperties
{
	// muzzle flash emitter
	Begin Object Name=PSC_WeaponMuzzleMuzFlashComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_MuzzleEffect'
	End Object
	MuzFlashEmitter=PSC_WeaponMuzzleMuzFlashComp


	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'MET_Liquidator.SK_MET_Liquidator'
		PhysicsAsset=PhysicsAsset'MET_Liquidator.SK_MET_Liquidator_Physics'
		AnimTreeTemplate=AnimTree'MET_Liquidator.AT_MET_Liquidator'
		AnimSets(0)=AnimSet'MET_Liquidator.AS_MET_Liquidator'
	End Object
	Mesh=WeaponMeshComp


	Spread(0)=0.5
	FireInterval(0)=+0.05f

	FiringStatesArray(1)="Undeploying"
	WeaponFireTypes(1)=EWFT_InstantHit	// this is not actually a firing mode, but this avoids an access None log spam

	FireSound=SoundCue'Weapon_Pistol.Pistol.Pistol_FireEnemy_Cue'
	FireSound_Player=SoundCue'Weapon_Pistol.Pistol.Pistol_FirePlayer_Cue'
	
	// shell case ejection emitter
	Begin Object Class=NanoParticleSystemComponent Name=PSC_WeaponShellCaseComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_SpawnShellCasing'
	    bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp

	DeployAnimName="L_Deploy"

	bInfiniteSpareAmmo=TRUE

	//SummonEffect=ParticleSystem'Nano_FX.Effects.P_Nano_SMG_Spawn_2'
	SummonEffectSocketName="RightHand"
	SummonAnimName="NW_Summon_SMG"
	ThrowAwayAnimName="SMG_Throw_Away"
	TimeToSummonWeapon=1.3
	SummonCue=SoundCue'Weapon_Pistol.Pistol.Pistol_Summon_Cue'
	DismissCue=SoundCue'Weapon_Pistol.Pistol.Pistol_Dismiss_Cue'
	UnholsterCue=SoundCue'Weapon_Pistol.Pistol.Pistol_Dismiss_Cue'
	
}

