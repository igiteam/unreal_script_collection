/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_SentryTurret extends NanoAI_Combat;

var protected transient NanoSentryTurretBase MySentryTurret;


simulated function GetPlayerViewPoint(out vector out_Location, out Rotator out_Rotation)
{
	local NanoWeaponBase NW;

	NW = NanoWeaponBase(MySentryTurret.Weapon);
	if (NW != None)
	{
		// turret "looks" from the muzzle for now
		NW.GetMuzzleLocAndRot(out_Location, out_Rotation);
	}
	else
	{
		Super.GetPlayerViewPoint(out_Location, out_Rotation);
	}
}


event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn,bVehicleTransition);
	MySentryTurret = NanoSentryTurretBase(NewPawn);

	SetTeam( 1 ); // by default be on team 1 (metacorp)
}


function SetFireTarget( Actor NewFireTarget )
{
	Super.SetFireTarget(NewFireTarget);

	`AILog( GetFuncName() @ `showvar(NewFireTarget) );

	MySentryTurret.SetTrackingTarget(NewFireTarget);
}

function bool PossiblyPickFireTarget()
{
	// don't try and fire while forging
	if (MySentryTurret.bForging)
	{
		return FALSE;
	}

	return Super.PossiblyPickFireTarget();
}

function Actor PickFireTarget()
{
	local NanoPawnBase P;

	// populate stimuli first
	Stimuli.Length = 0;
	foreach WorldInfo.AllPawns(class'NanoPawnBase', P, MySentryTurret.Location, 4096.f)
	{
		if (P.Health > 0)
		{
			AddStimulus(P, P.Location, true, IsFriendlyActor(P));
		}
	}

	// now pick
	return Super.PickFireTarget();
}


defaultproperties
{
//	ConfrontPossibleThreatQuery=( QueryLabel="ConfrontPossibleThreat",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Allow,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=9048.f )

//	ConfrontPossibleThreatQuery_Rooftop=( QueryLabel="ConfrontPossibleThreatQuery_Rooftop",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Allow,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=8048.f )


	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_SentryTurret' )
}
