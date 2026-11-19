/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class Trigger_ButtonInteraction extends Trigger
	implements(Interface_NavMeshPathSwitch)
	implements(EditorLinkSelectionInterface)
	native(AI);


// list of pylons whose status is tied to this switch
var() array<AISwitchablePylon> LinkedPylons;


cpptext
{
	// returns the spot that an AI should run to to operate this switch
	virtual FVector GetDestination(FLOAT EntityRadius);

	// returns TRUE if the passed bot is able to operate this switch
	virtual UBOOL CanBotUseThisSwitch(AAIController* AI);

	// returns TRUE if this switch is 'open' in that the fence/gate it controls is pathable right now
	virtual UBOOL IsSwitchOpen();

	// returns TRUE if this switch is linked to (e.g. opens) the passed switchable pylon
	virtual UBOOL IsLinkedTo(AAISwitchablePylon* Py);

	// >>>>>> EditorLinkSelectionInterface
	virtual void LinkSelection(USelection* SelectedObjects);

	virtual INT GetNumLinkedPylons() const;
	virtual class AAISwitchablePylon* GetLinkedPylonAtIdx(INT Idx);

	// overidden to clip the end of the path off after the button so we don't get overlapping paths etc
	virtual UBOOL ModifyFinalPath( UNavigationHandle* Handle, INT Idx );
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local Pawn P;
	local AIController AIC;
	P = Pawn(Other);
	if (P != None)
	{
		AIC = AIController(P.Controller);
		if(AIC != none)
		{
			AIActivateSwitch(AIC);
		}
	}
}

// called to tell the AI to do wahtever it needs to to activate this switch
event bool AIActivateSwitch(AIController InAI)
{
	local Pawn P;
	local GearAI AI;
	local int i;

	// get AI to push the button
	P = InAI.Pawn;
	if (P != None && P.Health > 0)
	{
		// enable any linked switches
		for(i=0;i<LinkedPylons.length;++i)
		{
			LinkedPylons[i].SetEnabled(true);
		}

		// tickers trigger buttons by exploding on them
		if (P.IsA('GearPawn_LocustTickerBase'))
		{
			P.Suicide();
			return TRUE;
		}
		else
		{
			AI = GearAI(InAI);
			if (AI != None)
			{
				class'AICmd_PushButton'.static.PushButton(AI, self);
				return TRUE;
			}
		}
	}

	return FALSE;
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=128.f
		CollisionHeight=128.f
	End Object

	SupportedEvents.Add(class'SeqEvt_ButtonPush')
	SupportedEvents.Remove(class'SeqEvent_Used')
}
