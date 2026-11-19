
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_PlantShield extends GSM_BasePlaySingleAnim;

var CameraAnim	CameraAnimPlantShield;

protected function bool InternalCanDoSpecialMove()
{
	return (PawnOwner.EquippedShield != None && Super.InternalCanDoSpecialMove());
}

function bool CanChainMove(ESpecialMove NextMove)
{
	// needed in case client is behind on this move, so they get into the shield's cover properly after planting
	return NextMove == SM_Run2MidCov;
}

/**
 * Allow special moves to delay DBNO until they are complete
 *
 * @return true if DBNO should be delayed
 */
function bool CanDelayDBNO()
{
	return true;
}

function PlayAnimation()
{
	Super.PlayAnimation();
	PawnOwner.SetTimer( 1.26f * 1.f/SpeedModifier, FALSE, nameof(self.PlantShield), self );
	PlayCameraAnim(PawnOwner, CameraAnimPlantShield);
}

function PlantShield()
{
	local GearShield Shield;
	local GearDroppedPickup_Shield DeployedShield;
	local CovPosInfo CovInfo;

	PawnOwner.ClearTimer('PlantShield', self);
	if ( PawnOwner.Role == ROLE_Authority && PawnOwner.IsCarryingShield() &&
		(PawnOwner.SpecialMove == SM_None || PawnOwner.SpecialMove == SM_PlantShield) )
	{
		// find the shield and force it to deploy
		Shield = GearShield(PawnOwner.FindInventoryType(class'GearShield', true));
		DeployedShield = Shield.Deploy();
		if (DeployedShield != None)
		{
			PawnOwner.DropShield(true);
			// can't use IsDBNO() here since it just does a specialmove check
			if (PCOwner != None && PawnOwner.Health > 0 && Abs(PawnOwner.Location.Z - DeployedShield.Location.Z) < PawnOwner.GetCollisionHeight() * 1.8)
			{
				if (PCOwner.IsLocalPlayerController())
				{
					CovInfo.Link        = DeployedShield.DeployedLink_Rear;
					CovInfo.LtSlotIdx   = 0;
					CovInfo.RtSlotIdx   = 0;
					CovInfo.LtToRtPct   = 0.f;
					CovInfo.Location    = CovInfo.Link.GetSlotLocation( 0 );
					CovInfo.Normal      = vector(CovInfo.Link.GetSlotRotation(0)) * -1;
					PCOwner.AcquireCover(CovInfo);
				}
				else
				{
					// tell the client to acquire the cover
					PCOwner.ServerDictatedCover.Link    = DeployedShield.DeployedLink_Rear;
					PCOwner.ServerDictatedCover.SlotIdx = 0;
				}
			}
		}
	}
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (PawnOwner.IsTimerActive('PlantShield', self))
	{
		PlantShield();
	}
	Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
}

function EndThisSpecialMove()
{
	if (PawnOwner.IsTimerActive('PlantShield', self))
	{
		PlantShield();
	}
	Super.EndThisSpecialMove();
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Shield_Deployed_Plant")))
	CameraAnimPlantShield=CameraAnim'COG_MarcusFenix.Camera_Anims.ShieldPlant_Cam01'
	bCanFireWeapon=FALSE
	bShouldAbortWeaponReload=TRUE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
}
