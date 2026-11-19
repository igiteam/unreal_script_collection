/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Boulder extends NanoPlan;

var() protected const float ForgeDistance;
var() protected const float ForgeHeight;

function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	local vector CamFvec, TraceStart, TraceEnd, HitLoc, HitNorm;
	local rotator CamRot;
	local Actor HitActor;

	CamRot = PawnOwner.GetViewRotation();
	CamFvec = vector(CamRot);

	// trace out
	TraceStart = PawnOwner.Location;
	TraceEnd = TraceStart + CamFvec * default.ForgeDistance;
	HitActor = PawnOwner.Trace(HitLoc, HitNorm, TraceEnd, TraceStart);

	// now trace up
	TraceStart = (HitActor == None) ? TraceEnd : HitLoc;
	TraceEnd.Z += default.ForgeHeight;
	HitActor = PawnOwner.Trace(HitLoc, HitNorm, TraceEnd, TraceStart);
	if (HitActor == None) 
	{
		HitLoc = TraceEnd;
	}

	PawnOwner.Spawn(class<Actor>(DynamicLoadObject("NanoGameContent.NanoForgedBoulder", class'class')),,, HitLoc, CamRot,, TRUE);

	Super.StartForge(OnFinishCallback);
}

defaultproperties
{
	PlanName="Boulder"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="HUGE BOULDER",PlanDescription="Drops a Giant boulder onto the ground crushing those beneath",UIMesh=StaticMesh'AA_Test.Mesh.SM_Rock_Chunk_02')
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintBoulder',Coords=(U=0,V=0,UL=256,VL=256))

	ForgeDistance=500
	ForgeHeight=200
}