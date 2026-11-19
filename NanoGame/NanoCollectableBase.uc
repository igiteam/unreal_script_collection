/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCollectableBase extends NanoAbsorbOrb
	abstract
	notplaceable;

// normal      Pale Goldenrod  	238-232-170  ColorForOrb=(X=0.933,Y=0.909,Z=0.666)
// rare        Light Goldenrod  238-221-130  ColorForOrb=(X=0.933,Y=0.866,Z=0.509)
// ultra rare  Gold  	        255-215-0    ColorForOrb=(X=1.000,Y=0.843,Z=0.000)
// mobile      Goldenrod  	    218-165-32   ColorForOrb=(X=0.854,Y=0.647,Z=0.125)
// flee        Dark Goldenrod  	184-134-11   ColorForOrb=(X=0.721,Y=0.525,Z=0.043)


/** Always playing this sound **/
var SoundCue LoopingSound;
var transient AudioComponent AC_LoopingSound;



simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	AC_LoopingSound = new(self) class'AudioComponent';
	if( AC_LoopingSound != None )
	{
		AC_LoopingSound.SoundCue = LoopingSound;
		AC_LoopingSound.FadeIn( 1.0f, 1.0f );
		AttachComponent( AC_LoopingSound );
	}
}


simulated event Destroyed()
{
	Super.Destroyed();

	if( AC_LoopingSound != None )
	{
		AC_LoopingSound.FadeOut( 0.5f, 0.0f	);
		AC_LoopingSound = None;
	}
}


/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted()
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC().GetPRI().AwardCollectibleAbsorbed( 1, "Collectible Absorbed" );
	NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_CollectibleAbsorbed );
	
}

defaultproperties
{
	Begin Object Name=ParticleSystemComponent0
		Template=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Collectible_01'
		Translation=(X=0,Y=0,Z=32)
	End Object
	Components.Add(ParticleSystemComponent0)

	Begin Object Name=UIIconComponent0
		MiniMap=(bShown=FALSE,bShownEvenIfClamped=FALSE,DistancesToDrawIcon=(X=0,Y=0),Icon=Texture2D'UI_HUD.MiniMap.SimpleCollectible_01',IconScale=0.125f,AboveBelowIconScale=0.1f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=TRUE)
	End Object

	Begin Object Name=InteractableComponent0
	    InteractDistance=384.0f
	End Object

	//ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Collectible_01' now has a scalar param Derez

	LoopingSound=SoundCue'Enemy_TechTick.TechTick.TechTick_Base_Cue'
}
