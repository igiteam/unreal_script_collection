/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NPMP_Rebels_PlaceHolderMesh extends NanoProceduralMissionPartBase
		implements( NanoInterface_Interact, NanoInterface_Objective );


var MaterialInstanceConstant MIC_ProcMission;

var StaticMesh StaticMeshToSpawn;

var transient DynamicSMActor_Spawnable SMActor_Spawnable;

var InteractableComponent InteractableComp;

/** Our UIIconComponent for easy access. **/
var UIIconComponent UIComponent;


simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	InteractableComp.Tick( DeltaTime );
}


simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	if( InteractableComp.BeingAbsorbedBy != None )
	{
		return "Dealing with Proc Mission";
	}

	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';

	if( InteractableComp.bCanAbsorb == TRUE )
	{
		return "to complete Proc Mission";
	}
	else
	{
		return "Cannot interact";
	}	

}



/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return InteractableComp;
}

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted()
{
	if( InteractableComp.TimeSpentAbsorbing > InteractableComp.AbsorbTime )
	{
		if( NanoGRI(WorldInfo.GRI).GetNanoPC().CanGainEXP() == TRUE )
		{
			NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumProcMissionsCompleted, 1 );
		}

		TriggerChaos();
	}

	NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_CompletedAProcMission );	
}

simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	return InteractableComp.CanInteract( NP, Type );
}


simulated function DoInteract( NanoPawn NP, ENanoInteractType Type )
{
	InteractableComp.DoInteract( NP, Type );
}



function vector GetObjectiveLocation()
{
	return Location;
}


/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return UIComponent;
}



simulated function TriggerChaos()
{
	local NanoCausingChaosValueDatum Chaos;
	local int Amount;


	Amount = 100;

	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;
	Chaos.ChaosAmount.Values[Chaos.ChaosAmount.Values.length] = Amount;

	Chaos.ChaosDesc = "Proc Mission";

	NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().ModifyChaosLevel( NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn, Chaos );

}




function AttemptToStartMissionPart()
{
	local MaterialInstanceConstant MIC;

	SMActor_Spawnable = Spawn( class'DynamicSMActor_Spawnable', WorldInfo,, MissionLocation+vect(0,0,0),,, TRUE );

	SMActor_Spawnable.SetStaticMesh( StaticMeshToSpawn );
	SMActor_Spawnable.SetCollision( FALSE, FALSE );

	if( Mission.ProcMissionTexture != None )
	{
		MIC = SMActor_Spawnable.StaticMeshComponent.CreateAndSetMaterialInstanceConstant( 0 );
		MIC.SetTextureParameterValue( 'ProceduralMissionTexture', Mission.ProcMissionTexture );
	}

	//`log( `showvar(MissionLocation) @ `showvar(location) );

	//DrawDebugCoordinateSystem(MissionLocation,rot(0,0,0),25.f,TRUE);

	NanoGRI(WorldInfo.GRI).NPMM.AddMissionManagerObjectives( self );

	bCompleted = TRUE;
}



event Destroyed()
{
	Super.Destroyed();

	NanoGRI(WorldInfo.GRI).NPMM.RemoveMissionManagerObjectives( self );

	SMActor_Spawnable.Destroy();
}



defaultproperties
{
	MIC_ProcMission=MaterialInstanceConstant'LD_DC_Events_Placeholder.MIC_ProcMission'

	StaticMeshToSpawn=StaticMesh'LD_DC_Events_Placeholder.Event_Placeholder_Mesh'


	Begin Object Class=InteractableComponent Name=InteractableComponent0
	   InteractDistance=768.0f
	   bCanGrab=FALSE
	   bCanAbsorb=TRUE
	   AbsorbTime=3.0f
	End Object
	CollisionComponent=InteractableComponent0
	InteractableComp=InteractableComponent0
	Components.Add( InteractableComponent0 )


	Begin Object Class=UIIconComponent Name=UIIconComponent0
	   MiniMap=(bShown=TRUE,bShownEvenIfClamped=TRUE,DistancesToDrawIcon=(X=0,Y=0),Icon=Texture2D'UI_HUD.Minimap.MissionProc',IconScale=0.125f,AboveBelowIconScale=0.1f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=TRUE)
	End Object
	UIComponent=UIIconComponent0
	Components.Add(UIIconComponent0)


	bCollideActors=TRUE // this is needed to put into the octree

}