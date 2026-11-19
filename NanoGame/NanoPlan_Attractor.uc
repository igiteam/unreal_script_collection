/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Attractor extends NanoPlan;

var() protected const vector SpawnOffset;

var class<NanoAttractMetaCorpTroopsBase> AttractorClass;

function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	// start pawn's special move
	PawnOwner.DoSpecialMove( 'NSM_ForgeCycleFast',,,, 1 );

	DoSingleForge();

	Super.StartForge(OnFinishCallback);
}



protected function DoSingleForge()
{
	local NanoAttractMetaCorpTroopsBase Attractor;
	local vector SpawnLoc, CamX, CamY, CamZ;
	local rotator CamRot;

	CamRot = PawnOwner.GetViewRotation();
	GetAxes(CamRot, CamX, CamY, CamZ);
	SpawnLoc = PawnOwner.Location + (SpawnOffset >> CamRot);

	Attractor = PawnOwner.Spawn(AttractorClass,,, SpawnLoc, CamRot,, TRUE);
	Attractor.ForgeActor(SingleForgeFinished);
}

function SingleForgeFinished()
{
	local NSM_ForgeCycle SM;

	// signal special move to end
	SM = NSM_ForgeCycle(PawnOwner.ActiveSpecialMove);
	if( SM != None )
	{
		SM.PlayCompleteAnimation();
	}
}



defaultproperties
{
	PlanName="Attractor"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Attractor",PlanDescription="Placed on the ground it will attract a number of AI to it.",UIMesh=StaticMesh'LT_Spaceship.SM_Cine.Meshes.LT_Spaceship_SM_Cine_Body2',Scale=0.05f)
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintAttractor',Coords=(U=0,V=0,UL=256,VL=256))


	SpawnOffset=(X=200.f,Z=150.f)


	AttractorClass=class'NanoAttractMetaCorpTroops'

}
