class SplineMover extends Spline
						native
						placeable;

enum eDrawType
{
	DT_Static,
	DT_Skeletal,
};

var() eDrawType DrawType;
var() SkeletalMesh SkeletalMesh;
var() StaticMesh StaticMesh;
var() bool bOrientToPath;
			
var SplinePathNode CurrentPath;
var float Speed, OldSpeed;
var float CurrentTime, CurrentPathLength;
var float DistanceTraveled;
		
var SkeletalMeshComponent SkeletalMeshComponent;
var StaticMeshComponent StaticMeshComponent;
var CylinderComponent CylinderComponent;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Returns true if Finished
native function bool MoveOnSpline(float DeltaTime);

function OnAttachToSpline(SeqAct_AttachToSpline Action)
{
	if (Action.Path != none)
	{
		CurrentPath = Action.Path;
		CurrentTime = FClamp(Action.Time, 0, 1);
		CurrentPathLength = CurrentPath.SplineComponent.GetSplineLength();
		DistanceTraveled = CurrentTime * CurrentPathLength;

		// Set our location and rotation to the current time on the spline
		SetLocation(CurrentPath.SplineComponent.GetPositionAtTime(CurrentTime));
		if(bOrientToPath)
			SetRotation(CurrentPath.SplineComponent.GetOrientationAtTime(CurrentTime));
	}
} 				
 
function OnMoveOnSpline(SeqAct_MoveOnSpline Action)
{	
	DistanceTraveled = 0;
	// Convert speed from MPH to Unreal Units per second
	Speed = (Action.SpeedMPH * 140800.0) / 3600.0;
	if (CurrentPath.NextSplineNode != none && Speed > 0 && !IsInState('MoveForward'))
		GotoState('MoveForward');
}

function OnPauseSplineMovement(SeqAct_PauseSplineMovement Action)
{
	if (OldSpeed == 0)
	{
		OldSpeed = Speed;
		Speed = 0;
	}
	else
	{
		Speed = OldSpeed;
		OldSpeed = 0;
	}
}

state MoveForward
{
	simulated function Tick(float dt)
	{	
		if (!MoveOnSpline(dt))
		{
			ClearLatentAction(class'SeqAct_MoveOnSpline', false);
			GotoState('');
			return;
		}
	}
}

