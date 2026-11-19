// Implementation of a Rope
class BaseDynaRope extends Actor
						native
						placeable;

var() Actor StartConstraintActor;      // Must be set to something
var() Actor EndConstraintActor;		// Can Be None, if left none then the rope dangles.
var() int NumSegments;
var() color SegmentColor;
var() int SegmentThickness;
var() float SegmentStiffness;
var() float SegmentDamping;
var() float SegmentLength;				// If EndConstraintActor is used then this is modified by VSize(StartActor.Location - EndActor.Location) / NumSegments
var() bool bSpringy;					// Is the rope springy.  If true, then it uses stiffness and damping.

// Internal
var array<RB_ConstraintActor> Constraints;
var array<KAsset> RopePieces;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native final function vector FindClosestPoint(vector LocationToCheck);

simulated function PostBeginPlay()
{
	local int i;
	local RB_BSJointActor NewConstraint;
	local RopePart RopePiece;
	local vector Norm;

	super.PostBeginPlay();
	
	if (NumSegments <= 0)
		NumSegments = 1;
	
	RopePieces.Insert(0,NumSegments);

	if (StartConstraintActor == none)
	{	
		;	
		return;
	}
	if (EndConstraintActor != none)
	{
		Constraints.Insert(0,NumSegments+1);
	
		SegmentLength = VSize(StartConstraintActor.Location - EndConstraintActor.Location) / NumSegments-1;
		
		Norm = Normal(EndConstraintActor.Location - StartConstraintActor.Location);
		for (i = 0; i < NumSegments; i++)
		{
			NewConstraint = Spawn(class'RB_BSJointActor',,,StartConstraintActor.Location + (Norm * ((SegmentLength)*i)),Rotation);
			RopePiece = Spawn(class'RopePart',,,StartConstraintActor.Location + (Norm * ((SegmentLength)*i)), Rotation);
			
			NewConstraint.ConstraintSetup.bLinearLimitSoft = FALSE;
			NewConstraint.ConstraintSetup.bSwingLimited = FALSE;

			NewConstraint.ConstraintSetup.PriAxis1 = Norm;//vect(0,0,1);
			NewConstraint.ConstraintSetup.SecAxis1 = Norm cross vect(0,0,1);//vect(0,1,0);

			NewConstraint.ConstraintSetup.PriAxis2 = Norm;//vect(0,0,1);
			NewConstraint.ConstraintSetup.SecAxis2 = Norm cross vect(0,0,1);//vect(0,1,0);

			NewConstraint.ConstraintSetup.LinearXSetup.LimitSize = SegmentLength;
			NewConstraint.ConstraintSetup.LinearYSetup.LimitSize = SegmentLength;
			NewConstraint.ConstraintSetup.LinearZSetup.LimitSize = SegmentLength;

			NewConstraint.ConstraintSetup.bLinearLimitSoft = bSpringy;
			if (bSpringy)
			{
				NewConstraint.ConstraintSetup.LinearLimitStiffness = SegmentStiffness;
				NewConstraint.ConstraintSetup.LinearLimitDamping = SegmentDamping;
			}
			Constraints[i] = NewConstraint;
			RopePieces[i] = RopePiece;
		}

		NewConstraint = Spawn(class'RB_BSJointActor',,,StartConstraintActor.Location + (Norm * ((SegmentLength)*NumSegments-1)),Rotation);
		Constraints[NumSegments] = NewConstraint;
	}
	else
	{
		Constraints.Insert(0,NumSegments);
	
		for (i = 0; i < NumSegments; i++)
		{
			NewConstraint = Spawn(class'RB_BSJointActor',,,StartConstraintActor.Location + (vect(0,0,-1) * (i*(SegmentLength))),Rotation);
			RopePiece = Spawn(class'RopePart',self,,StartConstraintActor.Location + (vect(0,0,-1) * (i*(SegmentLength))), Rotation);
			
			NewConstraint.ConstraintSetup.bLinearLimitSoft = TRUE;
			NewConstraint.ConstraintSetup.bSwingLimited = TRUE;

			NewConstraint.ConstraintSetup.PriAxis1 = vect(0,0,1);
			NewConstraint.ConstraintSetup.SecAxis1 = vect(0,1,0);

			NewConstraint.ConstraintSetup.PriAxis2 = vect(0,0,1);
			NewConstraint.ConstraintSetup.SecAxis2 = vect(0,1,0);

			NewConstraint.ConstraintSetup.LinearXSetup.LimitSize = SegmentLength;
			NewConstraint.ConstraintSetup.LinearYSetup.LimitSize = SegmentLength;
			NewConstraint.ConstraintSetup.LinearZSetup.LimitSize = SegmentLength;

			NewConstraint.ConstraintSetup.bLinearLimitSoft = bSpringy;
			if (bSpringy)
			{
				NewConstraint.ConstraintSetup.LinearLimitStiffness = SegmentStiffness;
				NewConstraint.ConstraintSetup.LinearLimitDamping = SegmentDamping;
			}

			Constraints[i] = NewConstraint;
			RopePieces[i] = RopePiece;
		}
	}
	for (i = 0; i < NumSegments; i++)
	{
		Constraints[i].SetDisableCollision(true);

		if (i == 0)
		{
			/*RopePieces[i].SetPhysics(Phys_None);
			RopePieces[i].Attach(StartConstraintActor);
			RopePieces[i].SetBase(StartConstraintActor);*/
			Constraints[i].InitConstraint( RopePieces[i], none, 'Canteen_root', '', 0.f);
			
		}
		else
		{
			if ( i == NumSegments - 1 && EndConstraintActor != none)
			{
			//	Constraints[i].InitConstraint( RopePieces[i-1], RopePieces[i], 'Canteen_root', 'Canteen_root', 0.f);
				//RopePieces[i].SetPhysics(Phys_None) ;
				Constraints[i].InitConstraint( RopePieces[i], RopePieces[i-1], 'Canteen_root', 'Canteen_root', 0.f);
				Constraints[i+1].InitConstraint( RopePieces[i], none, 'Canteen_root', '', 0.f);
			//	//RopePieces[i].Attach(EndConstraintActor);
			//	//RopePieces[i].SetBase(EndConstraintActor);
			}
			else
				Constraints[i].InitConstraint( RopePieces[i], RopePieces[i-1], 'Canteen_root', 'Canteen_root', 0.f);
		}
	}
	/*if (EndConstraintActor != none)
	{
		NewConstraint = Spawn(class'RB_BSJointActor',,,EndConstraintActor.Location,Rotation);
		
		NewConstraint.ConstraintSetup.bLinearLimitSoft = TRUE;
		NewConstraint.ConstraintSetup.bSwingLimited = TRUE;

		NewConstraint.ConstraintSetup.PriAxis1 = vect(0,0,1);
		NewConstraint.ConstraintSetup.SecAxis1 = vect(0,1,0);

		NewConstraint.ConstraintSetup.PriAxis2 = vect(0,0,1);
		NewConstraint.ConstraintSetup.SecAxis2 = vect(0,1,0);

		NewConstraint.ConstraintSetup.LinearXSetup.LimitSize = SegmentLength;
		NewConstraint.ConstraintSetup.LinearYSetup.LimitSize = SegmentLength;
		NewConstraint.ConstraintSetup.LinearZSetup.LimitSize = SegmentLength;

		NewConstraint.ConstraintSetup.bLinearLimitSoft = bSpringy;
		if (bSpringy)
		{
			NewConstraint.ConstraintSetup.LinearLimitStiffness = SegmentStiffness;
			NewConstraint.ConstraintSetup.LinearLimitDamping = SegmentDamping;
		}

		Constraints[RopePieces.Length] = NewConstraint;
		NewConstraint.InitConstraint( RopePieces[RopePieces.Length-1], none, 'Canteen_root', '', 0.f);
	}*/
}

