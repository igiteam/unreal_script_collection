/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLAISightComponent extends ActorComponent
	dependson(OLEnemyPawn)
	native(AI)
	config(Enemy);

var OLBot Bot;

var bool bAlwaysSeeTarget;
var bool bWasAlwaysSeeTarget;

var bool bIgnoreTarget;

var bool CanSeeTarget;
var bool CouldSeeTarget;

var bool IsInClose;
var bool IsInNarrowCone;
var bool IsInWideCone;

var bool bSawPlayerEnterHidingSpot;
var bool bSawPlayerEnterBed;

var bool bSawPlayerGoUnder;
var vector SawPlayerGoUnderLastPosition;

var const float SawPlayerGoUnderMaxDistance;

var bool bPeeking;
var bool bCrouched;

var bool bSawPlayerInSqueeze;
var OLSqueezeVolume	LastSqueeze;

var float WideConeTimer;
var float LoseTimer;

var transient float DistanceToPlayer;
var transient float HorizontalAngleToPlayer;
var transient float VerticalAngleToPlayer;

var config bool bDebugSight;

cpptext
{
	virtual void Tick(FLOAT DeltaTime);

private:
	FVisionParameters* GetCurrentVisionParameters();
	void UpdateTargetVisibility();
	UBOOL IsTargetInCone(FVisionCone& aCone, FLOAT DistToPlayerSqr, FLOAT aHorizontalAngleToPlayer, FLOAT aVerticalAngleToPlayer, UBOOL bPeeking, UBOOL bCrouching, FLOAT CrouchMultiplier);

	void GetVisionBoneLocationAndRotation(FVector& out_BoneLocation, FRotator& out_BoneRotation);

	void DrawDebugVisionCone(const FVisionCone& Cone, BYTE R, BYTE G, BYTE B, UBOOL bPersistentLines=FALSE);
	void DrawDebug();
}


simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	HUD.Canvas.SetDrawColor(210,32,249);
	HUD.Canvas.SetPos(8,out_YPos);
	// Sight Component
	HUD.Canvas.SetPos(12,out_YPos);
	HUD.Canvas.DrawText("Target Visible: " $ CanSeeTarget $ " [Locker: " $ bSawPlayerEnterHidingSpot $ ", Bed: " $ bSawPlayerEnterBed $ ", Squeeze: " $ bSawPlayerInSqueeze $ ", Under: " $ bSawPlayerGoUnder $ ", Peeking: " $ bPeeking $ ", Crouched: " $ bCrouched $ "]");
	out_YPos += out_YL;
	HUD.Canvas.DrawText("In Close: " $ IsInClose $ ", In Narrow Cone: " $ IsInNarrowCone $ ", In Wide Cone: " $ IsInWideCone);
	out_YPos += out_YL;
	HUD.Canvas.DrawText("Timers - Wide Cone : " $ WideConeTimer $ ", Lose Target : " $ LoseTimer);
	out_YPos += out_YL;
	HUD.Canvas.DrawText("Player Distance: " $ DistanceToPlayer $ ", Angle H: " $ HorizontalAngleToPlayer $ ", V: " $ VerticalAngleToPlayer);
	out_YPos += out_YL;
}

defaultproperties
{
	TickGroup=TG_DuringAsyncWork
	
	bAlwaysSeeTarget=false

	SawPlayerGoUnderMaxDistance=100.0f
}
