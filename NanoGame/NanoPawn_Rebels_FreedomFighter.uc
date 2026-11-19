/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_Rebels_FreedomFighter extends NanoPawn_MetaCorp_RiotCop
	abstract;


var protected name ColorParamName;


function SetMaterialSkinColorFromMobile( String InColor )
{
	local LinearColor NewColor;

	if( InColor == "Green" )
	{
		NewColor = MakeLinearColor( 0, 1, 0, 255 );
	}
	else if( InColor == "Orange" )
	{
		NewColor = MakeLinearColor( 1, 0.5, 0, 255 );
	}
	else if( InColor == "Pink" )
	{
		NewColor = MakeLinearColor( 1, 0.6, 0.75, 255 );
	}
	else if( InColor == "White" )
	{
		NewColor = MakeLinearColor( 3, 3, 3, 255 );
	}
	// just set the current color
	else
	{
		MaterialInstanceConstant(Mesh.GetMaterial(0)).GetVectorParameterValue( ColorParamName, NewColor );
	}

	// make a new mic and set the color on it
	Mesh.CreateAndSetMaterialInstanceConstant(0).SetVectorParameterValue( ColorParamName, NewColor );

}


// we override this as we don't want an iris effect at this time
// but instead play a sound announcing our presence!
simulated protected function SpawnIRIS_FirstEncounterEffect()
{
	PlaySound( class'NanoProceduralEnemySpawner'.default.MobileRequest_RebelsAppearInWorld );
	TimeSpawnedFirstEncounterEffect = WorldInfo.TimeSeconds;
}




defaultproperties
{
	ControllerClass=class'NanoAI_Rebels_FreedomFighter'

	Begin Object Name=UIIconComponent0
		MiniMap=(IconColor=(R=64,G=64,B=255,A=255))
	End Object
	UIComponent=UIIconComponent0

	DroppedOrbClasses.Empty()


	ColorParamName="MultiplyDiffuseColor"

}






