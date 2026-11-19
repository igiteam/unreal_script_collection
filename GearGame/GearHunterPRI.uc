/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHunterPRI extends GearMPPRI;

/** number of hats this player has in their possession */
var repnotify byte NumHats;

var array<StaticMeshComponent> HatComponents;

replication
{
	if (bNetDirty)
		NumHats;
}

/** attaches or detaches the appropriate number of hats from Pawns with this PRI */
simulated function UpdateHatAttachments()
{
	local int i;
	local GearPawn P;
	local StaticMeshComponent NewHat, HatTemplate;
	local vector HatOffset;

	// delete any components that got detached (Pawn died or whatever)
	while (i < HatComponents.length)
	{
		if (!HatComponents[i].bAttached)
		{
			HatComponents.Remove(i, 1);
		}
		else
		{
			i++;
		}
	}

	// detaching is easy, just kill some components
	while (NumHats < HatComponents.length)
	{
		i = HatComponents.length - 1;
		HatComponents[i].DetachFromAny();
		HatComponents.Remove(i, 1);
	}

	if (NumHats > HatComponents.length)
	{
		// for attaching, we need to look up the Pawn
		foreach WorldInfo.AllPawns(class'GearPawn', P)
		{
			if (P.PlayerReplicationInfo == self && (P.Health > 0 || P.IsDBNO()))
			{
				break;
			}
		}
		if (P == None || WorldInfo.GRI == None || WorldInfo.GRI.GameClass == None)
		{
			// try again later
			SetTimer(0.1, false, nameof(UpdateHatAttachments));
		}
		else
		{
			HatTemplate = class<GearGameHunter>(WorldInfo.GRI.GameClass).default.HatClass.default.HatComponent;
			while (NumHats > HatComponents.length)
			{
				NewHat = new(P) class'StaticMeshComponent'(HatTemplate);
				HatOffset.X = 20.0 + 10.0 * HatComponents.length;
				P.Mesh.AttachComponent(NewHat, (P.HeadBoneNames.length > 0) ? P.HeadBoneNames[0] : 'None', HatOffset, rot(-16384, 0, 0));
				HatComponents.AddItem(NewHat);
			}
		}
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(NumHats))
	{
		UpdateHatAttachments();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}
