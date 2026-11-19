/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
* this reaction will activate if stopping power value gets above the threshold
*/
class AIReactCond_StoppingPowerThreshold extends AIReactCondition_Base
	within TGAI;

var() float StoppingPowerThresh;

/** chance that we stumble rather than evade */
var() float ChanceToStumble;

/** last time we were triggered so we don't trigger again for a short time */
var float LastTriggerTime;

event bool ShouldActivate( Actor EventInstigator, AIReactChannel OrigChan )
{

	//MessagePlayer(GetFuncName()@EventInstigator@self);
	//`log(GetFuncName()@EventInstigator@OrigChan.channelname@OrigChan);
	if (!Super.ShouldActivate(EventInstigator,OrigChan) || WorldInfo.TimeSeconds - LastTriggerTime < 1.0)
	{
		//`log(GetFuncName()@"Super forbade activation!");
		return false;
	}

	//MessagePlayer(GetFuncName()@MyTGPawn.GetResultingStoppingPower()@StoppingPowerThresh);
	if(MyTGPawn != none && !MyTGPawn.IsInCover() && MyTGPawn.GetResultingStoppingPower() > StoppingPowerThresh)
	{
		return true;
	}

	return false;
}


event Activate(Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	LastTriggerTime = WorldInfo.TimeSeconds;

	//MessagePlayer(GetFuncName()@self);
	Super.Activate(EventInstigator,OriginatingChannel);

	// evade chance scaling happens elsewhere for bot AI, so only check the CanEvade() one for SP AI
	if (FRand() >= ChanceToStumble && CanEvade(TGAI_TDM(Outer) == None, 1.0, 1.0))
	{
		DoEvade( GetBestEvadeDir( MyTGPawn.Location, Pawn(EventInstigator) ), TRUE );
	}
	else
	{
		NotifyStumbleAction( SM_StumbleFromMelee );
	}
}


