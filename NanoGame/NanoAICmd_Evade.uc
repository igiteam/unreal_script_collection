/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Evade extends GameAICommand;

var NanoPawn NP;
var EDirection EvadeDir;

static final function Evade(GameAIController AI)
{
	local NanoAICmd_Evade Cmd;
	if (AI != None)
	{
		Cmd = new(AI) default.class;
		if (Cmd != None)
		{
			Cmd.EvadeDir = FRand() > 0.5 ? DIR_Left : DIR_Right;
			AI.PushCommand(Cmd);
		}
	}
}

static final function EvadeInDirection(GameAIController AI, EDirection NewEvadeDir)
{
	local NanoAICmd_Evade Cmd;
	if (AI != None)
	{
		Cmd = new(AI) default.class;
		if (Cmd != None)
		{
			Cmd.EvadeDir = NewEvadeDir;
			AI.PushCommand(Cmd);
		}
	}
}


function Pushed()
{
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		StopFiring();
		GotoState('Evading');
	}
}

function Popped()
{
	Pawn.Acceleration = vect(0,0,0);
}

state Evading
{
Begin:
	if (EvadeDir == DIR_Left)
	{
		NP.FullBodySlot.PlayCustomAnim('Evade_Lt',1.f,0.1,0.1);
		MoveTo(NP.Location + Normal((Focus.Location - Pawn.Location) cross vect(0,0,1)) * 512.f,Focus);
	}
	else
	{
		NP.FullBodySlot.PlayCustomAnim('Evade_Rt',1.f,0.1,0.1);
		MoveTo(NP.Location + Normal((Focus.Location - Pawn.Location) cross vect(0,0,-1)) * 512.f,Focus);
	}
	GameAIOwner.PopCommand(self);
}
