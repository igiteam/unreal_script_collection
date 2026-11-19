class OLPickableObject extends Actor
	native
	abstract;

var() StaticMeshComponent PickupMesh;
var() DynamicLightEnvironmentComponent PickupLightEnvironment;
var bool bUsed;

var() vector AttachPositionOffset;
var() rotator AttachRotationOffset;

var bool bPickupOnNotify; // whether to execute the pickup upon the pickup notify, or wait until the anim is completed

var transient bool bDisabled;

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		bDisabled = false;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bDisabled = true;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bDisabled = !bDisabled;
	}
}

cpptext
{
	virtual UBOOL IsValid() { return !bDisabled && !bHidden && !bUsed && PickupMesh && !PickupMesh->HiddenGame; } // valid for showing some kind of prompt
	virtual UBOOL CanPickup(AOLHero* hero) { return IsValid(); } // can actually pickup the object
	virtual void TryShowInvalidPickupMessage() {} // show a message if appropriate, when in range and valid but CanPickup() is false (e.g. inventory full)
	virtual void Pickup(AOLHero* hero);
	virtual FString GetPickableName() { return FString(TEXT("[undefined]")); }	
}

defaultproperties
{
	Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironmentComp		
	End Object
	PickupLightEnvironment=LightEnvironmentComp
	Components.Add(LightEnvironmentComp)	

	Begin Object Class=StaticMeshComponent Name=PickupMeshComp
		LightEnvironment=LightEnvironmentComp
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
	End Object
	PickupMesh=PickupMeshComp
	Components.Add(PickupMeshComp)	

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=10.0
		CollisionHeight=10.0
		Translation=(Z=10.0)
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bPickupOnNotify=true

	SupportedEvents.Add(class'OLSeqEvent_Pickup')
	bEdShouldSnap=True
	bAlwaysRelevant=true	
	bStatic=false
}