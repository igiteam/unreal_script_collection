/**
 * Base class for all placeable city signs
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSign_ChaosLevel extends NanoSignage
	implements( NanoInterface_CanAffectChaos )
	placeable;

var		StaticMeshComponent			BaseMeshComp;

var		ParticleSystemComponent		PSC_BaseEffect;
var		vector						OldBaseColor;
var		vector						BaseColor;

var		ParticleSystemComponent		PSC_ThreatIcon[2];
var		int							OldThreatIconIndex;
var		int							CurrentThreatIconIndex;

var		int							CurrentChaosLevel;

var		ParticleSystem				ChaosTierPS[5];
var		vector						ChaosTierColor[5];

var		float						InterpTimeRemaining;
var()	float						InterpTime;

var()	InterpCurveFloat			IconScaleInterpIn;
var()	InterpCurveVector			IconPosInterpIn;

var()	InterpCurveFloat			IconScaleInterpOut;
var()	InterpCurveVector			IconPosInterpOut;


/** This is the current Chaos Zone this is in **/
var transient NanoVolume_ChaosZone CurrChaosZone;


event PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(1.0, TRUE, nameof(CheckChaosLevel));

	// Init into peaceful
	CurrentChaosLevel = 0;

	// Set base color
	BaseColor = ChaosTierColor[0];
	OldBaseColor = BaseColor;
	PSC_BaseEffect.SetVectorParameter('ThreatColor_Aura', BaseColor);
	PSC_BaseEffect.SetVectorParameter('ThreatColor', BaseColor);

	// Turn on 'peace' level icon
	PSC_ThreatIcon[0].SetTemplate(ChaosTierPS[0]);
	PSC_ThreatIcon[0].ActivateSystem();

	// Indicate which system to use next.
	CurrentThreatIconIndex = 0;
	OldThreatIconIndex = 1;

	SetWhichChaosZoneThisIsWithin();
}

/** This will determine and set which ChaosZone this sign is within **/
simulated function SetWhichChaosZoneThisIsWithin()
{
	local NanoVolume_ChaosZone CZ;

    // since these are not ever spawned we do not get touch events it seems
	foreach AllActors( class'NanoVolume_ChaosZone', CZ )
	{
		if( CZ.Encompasses( self ) )
		{
			SetChaosZone( CZ );
			break;
		}
	}
}


/**  */
simulated event Tick(float DeltaTime)
{
	local float T, Scale;
	local Vector Pos, NewColor;

	Super.Tick(DeltaTime);

	// If we are interpolating
	if(InterpTimeRemaining > 0.0)
	{
		// Update interp time
		InterpTimeRemaining = FMax(InterpTimeRemaining - DeltaTime, 0.0);
		T = (InterpTime - InterpTimeRemaining);

		// Update base color
		NewColor = OldBaseColor + ((BaseColor - OldBaseColor) * (T/InterpTime));
		PSC_BaseEffect.SetVectorParameter('ThreatColor_Aura', NewColor);
		PSC_BaseEffect.SetVectorParameter('ThreatColor', NewColor);

		// Finished interp
		if(InterpTimeRemaining < 0.01)
		{
			// Kill old particle system
			PSC_ThreatIcon[OldThreatIconIndex].DeactivateSystem();
			PSC_ThreatIcon[OldThreatIconIndex].KillParticlesForced();
		}
		// Interp in process
		else
		{
			// Old is fading out
			Scale = EvalInterpCurveFloat(IconScaleInterpOut, T);
			PSC_ThreatIcon[OldThreatIconIndex].SetVectorParameter('ThreatScale', Scale*vect(1,1,1));

			Pos = EvalInterpCurveVector(IconPosInterpOut, T);
			PSC_ThreatIcon[OldThreatIconIndex].SetVectorParameter('ThreatLoc', Pos);


			// Current is fading in
			Scale = EvalInterpCurveFloat(IconScaleInterpIn, T);
			PSC_ThreatIcon[CurrentThreatIconIndex].SetVectorParameter('ThreatScale', Scale*vect(1,1,1));

			Pos = EvalInterpCurveVector(IconPosInterpIn, T);
			PSC_ThreatIcon[CurrentThreatIconIndex].SetVectorParameter('ThreatLoc', Pos);
		}
	}
}

/** Checks the current chaos level, and changes sign if necessary */
simulated function CheckChaosLevel()
{
	local int ChaosLevel;
	local ChaosPacifismManager CM;

	CM = (GetChaosZone() != none) ? GetChaosZone().MyNanoChaosZoneInfo.ChaosManager : NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager();

    if( CM != none )
    {
    	ChaosLevel = CM.GetChaosTier();
		if(ChaosLevel != CurrentChaosLevel)
		{
			SetChaosLevelDisplay(ChaosLevel);
		}
    }
}

/** Begin change to new effect */
simulated function SetChaosLevelDisplay(int NewLevel)
{
	OldThreatIconIndex = CurrentThreatIconIndex;
	CurrentThreatIconIndex = (CurrentThreatIconIndex+1) % 2;

	InterpTimeRemaining = InterpTime;

	// Set base color
	OldBaseColor = BaseColor;
	BaseColor = ChaosTierColor[NewLevel];

	// Set up new icon emitter
	PSC_ThreatIcon[CurrentThreatIconIndex].SetTemplate(ChaosTierPS[NewLevel]);
	PSC_ThreatIcon[CurrentThreatIconIndex].ActivateSystem();

	// Update current chaose level we are showing
	CurrentChaosLevel = NewLevel;
}


simulated function NanoVolume_ChaosZone GetChaosZone()
{
	return CurrChaosZone;
}

simulated function SetChaosZone( const NanoVolume_ChaosZone InChaosZone )
{
	CurrChaosZone = InChaosZone;
}



defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=BaseSMC
		StaticMesh=StaticMesh'MET_Deco01.SM.Mesh.S_MET_Deco01_ThreatBase'
	End Object
	Components.Add(BaseSMC)
	BaseMeshComp=BaseSMC

	Begin Object Class=NanoParticleSystemComponent Name=ThreatPSC0
		bAutoActivate=FALSE
		Translation=(Z=160)
	End Object
	Components.Add(ThreatPSC0)
	PSC_ThreatIcon[0]=ThreatPSC0

	Begin Object Class=NanoParticleSystemComponent Name=ThreatPSC1
		bAutoActivate=FALSE
		Translation=(Z=160)
	End Object
	Components.Add(ThreatPSC1)
	PSC_ThreatIcon[1]=ThreatPSC1

	Begin Object Class=NanoParticleSystemComponent Name=BasePSC
		Template=ParticleSystem'MET_Deco01.SM.Effects.P_MET_Deco01_ThreatMeter_BaseEffect'
		bAutoActivate=TRUE
	End Object
	Components.Add(BasePSC)
	PSC_BaseEffect=BasePSC


	ChaosTierPS[0]=ParticleSystem'MET_Deco01.SM.Effects.P_MET_Deco01_ThreatMeter_LevelOne'
	ChaosTierColor[0]=(X=0.5,Y=2.0,Z=0.5) // green

	ChaosTierPS[1]=ParticleSystem'MET_Deco01.SM.Effects.P_MET_Deco01_ThreatMeter_LevelTwo'
	ChaosTierColor[1]=(X=0.5,Y=0.5,Z=2.0) // blue

	ChaosTierPS[2]=ParticleSystem'MET_Deco01.SM.Effects.P_MET_Deco01_ThreatMeter_LevelThree'
	ChaosTierColor[2]=(X=2.0,Y=1.5,Z=0.0) // yellow

	ChaosTierPS[3]=ParticleSystem'MET_Deco01.SM.Effects.P_MET_Deco01_ThreatMeter_LevelFour'
	ChaosTierColor[3]=(X=2.0,Y=0.5,Z=0.0) // orange

	ChaosTierPS[4]=ParticleSystem'MET_Deco01.SM.Effects.P_MET_Deco01_ThreatMeter_LevelFive'
	ChaosTierColor[4]=(X=2.0,Y=0.2,Z=0.2) // red 

	InterpTime=0.4

	IconScaleInterpIn=(Points=((InVal=0.0,OutVal=0.0),(InVal=0.1,OutVal=0.6),(InVal=0.3,OutVal=1.0)))
	IconPosInterpIn=(Points=((InVal=0.0,OutVal=(Z=-60.0)),(InVal=0.22,OutVal=(Z=3.0)),(InVal=0.3,OutVal=(Z=0.0))))

	IconScaleInterpOut=(Points=((InVal=0.0,OutVal=1.0),(InVal=0.1,OutVal=0.6),(InVal=0.15,OutVal=0.0)))
	IconPosInterpOut=(Points=((InVal=0.0,OutVal=(Z=0.0)),(InVal=0.04,OutVal=(Z=3.0)),(InVal=0.15,OutVal=(Z=-60.0))))
}