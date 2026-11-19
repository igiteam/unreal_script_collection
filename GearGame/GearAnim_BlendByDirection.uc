
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByDirection extends AnimNodeBlendBase
	native(Anim);

struct native DirectionDefinition
{
	/** Name of direction for display */
	var()   Name        Name;
	/** Angle in degrees */
	var()   FLOAT       Angle;
};
var() editfixedsize Array<DirectionDefinition>	Directions;

/** Angle of direction relative to Actor */
var FLOAT       CurrentAngle;
var FLOAT       TargetAngle;
var Vector2D    TargetAim;

/** Which owner should we use */
var()	GearAnim_MovementNode.EOwnerType	OwnerType;

/** Cached pointer to GearPawnOwner */
var transient GearPawn	GearPawnOwner;

var() EDirectionInterpType  DirectionInterpType;
var() FLOAT                 CircularInterpSpeed, LinearInterpSpeed;

cpptext
{
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual	void TickAnim(FLOAT DeltaSeconds);

	/** A child has been added, update Directions array accordingly */
	void OnAddChild(INT ChildNum);
	/** A child has been removed, update Directions array accordingly */
	void OnRemoveChild(INT ChildNum);
	/** Rename all child nodes upon Add/Remove, so they match their position in the array. */
	void RenameChildConnectors();
	/** Track Changes, and trigger updates */
	void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);


	// For slider support
	virtual INT         Extend2DSlider(FCanvas* Canvas, const FIntPoint &SliderPos, INT SliderWidth, UBOOL bAABBLiesWithinViewport, INT LoSliderHandleHeight);
	virtual INT			GetNumSliders() const { return 1; }
	virtual ESliderType GetSliderType(INT InIndex) const { return ST_2D; }
	virtual FLOAT		GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual void		HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual FString		GetSliderDrawValue(INT SliderIndex);
}

defaultproperties
{
	DirectionInterpType=EDIT_None
	CircularInterpSpeed=720
	LinearInterpSpeed=1.f

	Children(0)=(Name="Forward",Weight=1.f)
	Directions(0)=(Name="Forward",Angle=0.f)
	Children(1)=(Name="Backward")
	Directions(1)=(Name="Backward",Angle=180.f)
	Children(2)=(Name="Left")
	Directions(2)=(Name="Left",Angle=-90.f)
	Children(3)=(Name="Right")
	Directions(3)=(Name="Right",Angle=90.f)
}
