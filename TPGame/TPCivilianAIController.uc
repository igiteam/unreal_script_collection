class TPCivilianAIController extends TPAIController;
	
//***********************************************************************
// Macros
//***********************************************************************

//***********************************************************************
// enum Declarations
//***********************************************************************
	
enum eCivilianStartStates
{
	//These must be the exact names of the states
	Idle,
};

//***********************************************************************
// struct Declarations
//***********************************************************************

//***********************************************************************
// Variable Declarations
//***********************************************************************
	
//var Actor ActorToFollow;
//var EObstacle        Obstacle;
//var bool             bSnapWall;
//var transient bool   bHitWallPressedJump;
//var transient vector LastHitWallNormal;
//var transient bool   bHittingWall;
//var transient float  JumpDistance;
//var transient float  JumpDuration;
//var float            Temp1;
//var float            OrigZ;
//var transient float  TotalTime;

//***********************************************************************
// CPP Text
//***********************************************************************


//***********************************************************************
// Function Declarations
//***********************************************************************

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (SeqNode.AnimSeqName == 'bb0008l_ground_mobile_position_alert_ladderjumpland')
    {
        TPPawn(Pawn).Obstacle=OB_Nothing;
    }
}
	
//***********************************************************************
// Functions/States
//***********************************************************************

//function OnJump(SeqAct_Jump inAction)
//{
//	if (Pawn != none)
//	{
//		Pawn.bCanJump = true;
//		Pawn.DoJump(true);
//	}
//}
//function OnFollowActor(SeqAct_FollowActor inAction)
//{
//	if (inAction.FollowTarget != none )
//	{
//		ActorToFollow = inAction.FollowTarget;
//		if (ActorToFollow.IsA('Controller'))
//			ActorToFollow = Controller(ActorToFollow).Pawn;
//		else
//		{
//			if (Pawn(inAction.FollowTarget) == Pawn)
//				return;
//		}
//		if (!IsInState('Following'))
//			PushState('Following');
//	}
//}

event Tick( float DeltaTime )
{
	if (anode_WeaponBlend != none)
	{
        if (Pawn.Weapon == none)
			anode_WeaponBlend.SetBlendTarget(1.0, 0.2);
		else
			anode_WeaponBlend.SetBlendTarget(0.0, 0.2);
	}

	//Updating the aim/headtracking while they still have aim nodes in their anim trees.
	UpdateAimInTheOpen(FALSE);;
	UpdateHeadTracking();	

	if (bHittingWall)
		TestObstacle();
	bHittingWall = false;
}


//function TestObstacle ( )
//{
//    TotalTime    = 0;
//    Temp1        = 0.29f; // @todo for MantlingHigh in PlayerTick
//
//    //@todo CollisionExtent not used for now
//    JumpDistance = 0;
//
//	Obstacle = TPPawn(Pawn).TestVault(LastHitWallNormal);
//	if (Obstacle == OB_Nothing)
//		Obstacle = TPPawn(Pawn).MyTestMantle (LastHitWallNormal, JumpDistance);
//	
//	`log(Obstacle);
//    if (bHitWallPressedJump)
//    {
//        switch (Obstacle)
//        {
//            case OB_Vaultable:
//               if (Pawn.Velocity.Z == 0)
//                {
//                    //PushState ('PlayerVaulting');
//                    PushState ('Vaulting');
//                }
//                break;
//            case OB_VaultMantleable:
//				if (Pawn.Velocity.Z == 0)
//                {
//                    //PushState ('PlayerVaultMantling');
//                    PushState  ('VaultMantling');
//                }
//                break;
//			case OB_MantleableLow:
//	            PushState  ('MantlingLow');
//                break;
//            case OB_MantleableMedium:
//                PushState  ('MantlingMedium');
//                break;
//            default:
//                break;
//        }
//    }
//}

event bool NotifyHitWall(vector HitNormal, actor Wall)
{
	Pawn.bCanJump = false;
	bHittingWall = true;

	bHitWallPressedJump = true;

    LastHitWallNormal = HitNormal;
	
	return false;
}
	
//************************ - BEGIN SECTION - ****************************
// PUSHABLE STATES - States that are used to stack on top of current state
//***********************************************************************

//state MantlingLow
//{
//    function PushedState()
//    {
//		Pawn.bCanJump = true;
//        TPPawn(Pawn).StopMovement ( );
//        TPPawn(Pawn).Obstacle=OB_MantleableLow;
//        Pawn.Mesh.RootMotionMode=RMM_Translate;
//        Pawn.SetPhysics (PHYS_None);
//        Pawn.bCollideWorld=true;
//		// 0.25f is time it takes for player to put his hands on wall
//        // in this anim - hardcoded for now
//        JumpDuration = 0.25f;
//        OrigZ = 0;
//    }
//
//    event OnAnimEnd(AnimNodeSequence SeqNode)
//    {
//        Pawn.SetPhysics(PHYS_Falling);
//        Pawn.bCollideWorld = true;
//        TPPawn(Pawn).Obstacle=OB_Nothing;
//        PopState();
//    }
//    
//    function Tick(float DeltaTime)
//    {
//        local float PrevNewLocation;
//        local float Percentage;
//        local vector NewLocation;
//
//		TPPawn(Pawn).StopMovement ( );
//
//		TotalTime += DeltaTime;
//
//		NewLocation = Pawn.Location;
//
//        PrevNewLocation = OrigZ;
//        Percentage = fclamp (TotalTime/JumpDuration, 0, 1);
//        
//        NewLocation.Z = Percentage*JumpDistance;
//        OrigZ = NewLocation.Z;
//        NewLocation.Z = NewLocation.Z - PrevNewLocation;
//
//        NewLocation.Z = Pawn.Location.Z + NewLocation.Z;
//
//        Pawn.SetLocation (NewLocation);
//    }
//}
//
//state MantlingMedium
//{
//    function PushedState()
//    {
//		Pawn.bCanJump = true;
//        TPPawn(Pawn).StopMovement ( );
//        TPPawn(Pawn).Obstacle=OB_MantleableMedium;
//        Pawn.Mesh.RootMotionMode=RMM_Translate;
//        Pawn.SetPhysics (PHYS_None);
//        Pawn.bCollideWorld=true;
//        JumpDuration = 0.3f;
//        OrigZ = 0;
//    }
//
//    event OnAnimEnd(AnimNodeSequence SeqNode)
//    {
//        Pawn.SetPhysics(PHYS_Falling);
//        Pawn.bCollideWorld = true;
//        TPPawn(Pawn).Obstacle=OB_Nothing;
//        PopState();
//    }
//
//    function Tick(float DeltaTime)
//    {
//        local float PrevNewLocation;
//        local float Percentage;
//        local vector NewLocation;
//
//        TPPawn(Pawn).StopMovement ( );
//
//        TotalTime += DeltaTime;
//
//        NewLocation = Pawn.Location;
//
//        PrevNewLocation = OrigZ;
//        Percentage = fclamp (TotalTime/JumpDuration, 0, 1);
//        
//        NewLocation.Z = Percentage*JumpDistance;
//        OrigZ = NewLocation.Z;
//        NewLocation.Z = NewLocation.Z - PrevNewLocation;
//
//        NewLocation.Z = Pawn.Location.Z + NewLocation.Z;
//
//        Pawn.SetLocation (NewLocation);
//
//    }
//}
//
//state Vaulting
//{
//    function PushedState()
//    {
//		Pawn.bCanJump = true;
//        TPPawn(Pawn).Obstacle=OB_Vaultable;
//        Pawn.Mesh.RootMotionMode=RMM_Translate;
//        Pawn.SetPhysics (PHYS_None);
//        Pawn.bCollideWorld=false;
//		Pawn.SetCollision(false,false);
//		Pawn.Mesh.SetActorCollision(false,false);
//		Pawn.Mesh.SetTraceBlocking(false, false);
//    }
//
//    event OnAnimEnd(AnimNodeSequence SeqNode)
//    {
//        Pawn.SetPhysics(PHYS_Falling);
//        Pawn.bCollideWorld = true;
//		Pawn.SetCollision(true,true);
//		Pawn.Mesh.SetActorCollision(true,true);
//		Pawn.Mesh.SetTraceBlocking(true, true);
//        TPPawn(Pawn).Obstacle=OB_Nothing;
//		PopState();
//    }
//    
//    function Tick(float DeltaTime)
//    {
//        local vector X, Y, Z;
//
//        GetAxes(Pawn.Rotation, X,Y,Z);
//
//        //@todo 100 is distance to travel, the goal is to eventually adjust
//        // distance based on distance from obstacle that is being vaulted
//        // 1.06 is animation duration - hardcoded for now
//        //
//        Pawn.Velocity.X = X.X * (200/1.06);
//        Pawn.Velocity.Y = X.Y * (200/1.06);
//    }
//}
//
//state VaultMantling
//{
//    function PushedState ()
//    {
//        TPPawn(Pawn).StopMovement ( );
//        TPPawn(Pawn).Obstacle=OB_VaultMantleable;
//		Pawn.bCanJump = true;
//        Pawn.Mesh.RootMotionMode=RMM_Translate;
//		Pawn.SetPhysics (PHYS_None);
//        Pawn.bCollideWorld=true;
//        JumpDuration = 0.25f;
//        OrigZ = 0;
//    }
//
//    event OnAnimEnd(AnimNodeSequence SeqNode)
//    {
//        Pawn.SetPhysics(PHYS_Walking);
//        Pawn.bCollideWorld = true;
//        TPPawn(Pawn).Obstacle=OB_Nothing;
//        PopState();
//    }
//
//    function Tick(float DeltaTime)
//    {
//        local float PrevNewLocation;
//        local float Percentage;
//        local vector NewLocation;
//
//		TPPawn(Pawn).StopMovement ( );
//
//		TotalTime += DeltaTime;
//
//		NewLocation = Pawn.Location;
//
//        PrevNewLocation = OrigZ;
//        Percentage = fclamp (TotalTime/JumpDuration, 0, 1);
//        
//        NewLocation.Z = Percentage*JumpDistance;
//        OrigZ = NewLocation.Z;
//        NewLocation.Z = NewLocation.Z - PrevNewLocation;
//
//        NewLocation.Z = Pawn.Location.Z + NewLocation.Z;
//
//        Pawn.SetLocation (NewLocation);
//    }
//}

//***********************************************************************
// PUSHABLE STATES
//************************ - END SECTION - ******************************




//************************ - BEGIN SECTION - ****************************
// AI STATES
//***********************************************************************


//***********************************************************************
// AI STATES
//************************ - END SECTION - ******************************

	

auto state WaitingForPawn
{
	// THIS FUNCTION IS CALLED WHEN THE PAWN IS POSSESSED BY THIS CONTROLLER
	// PUT ANY ONE-TIME INITIALIZATION CODE HERE
	function Possess(Pawn aPawn, bool bVehicleTransition)
	{
		Super.Possess(aPawn, bVehicleTransition);

	    //anode_AIM = AnimNodeAimOffset(Pawn.Mesh.Animations.FindAnimNode('AIM_NODE'));
	}

}
