class TPLadderVolume extends LadderVolume
    native;

var native vector Entrance;
var native vector EntranceBottom;
var native vector EntranceTop;
var native vector Top;
var native vector Bottom;
var transient array<float>  RungHeights;

 // Distance pawn needs to be before playing entering from bottom animation
var const float   PawnDistance;

var Actor         ActorRotation;

var() bool bDontAllowExitTop;
var() bool bPlaySewerExitAnimation;
var() bool bAllowSlide;
var() vector EnterBottomOffset;
var() vector EnterTopOffset;

var   vector EntranceOffset;

native function vector FindTop();
native function vector FindBottom();


 // Distance from middle of topmost rung to top of ladder volume

 // Distance from bottom of ladder volume to middle of first rung

 // Distance between the middle of two rungs


simulated function PostBeginPlay()
{
    local float VolumeHeight;
    local int   NumRungs, i;

    Super.PostBeginPlay();

    FindTop();
    FindBottom();

    VolumeHeight  = VSize(Top-Bottom);
    VolumeHeight -= 67.0f;

    NumRungs = int(VolumeHeight/38.4f);

    RungHeights[0] = Bottom.Z + 36.0f;
    for(i = 1; i <= NumRungs; i++)
        RungHeights[i] = RungHeights[i-1] + 38.4f;
}

//function Tick (float DeltaTime)
//{
//    local int i;
//    local vector Blah;
//
//    for(i=0; i < RungHeights.Length; i++)
//    {
//        Blah = Bottom;
//        Blah.Z = RungHeights[i];
//        DrawDebugLine (Blah, Blah - vector(WallDir)*200, 0,255,0);
//    }
//}

simulated event PawnEnteredVolume(Pawn P)
{
    //local float Time;
    //P.Clock (Time);
    //TPPlayerController(TPPawn(P).Controller).ClientMessage ("Entered Volume : " @ Time);

    TPPawn(P).Ladder = self;

    if ( !P.CanGrabLadder() )
		return;

    TPPawn(P).IsInLadderVolume = true;

    Super(PhysicsVolume).PawnEnteredVolume(P);
}

simulated event PawnLeavingVolume(Pawn P)
{
    //local float Time;
    local Controller C;
    //P.Clock (Time);
    //TPPlayerController(TPPawn(P).Controller).ClientMessage ("Leaving Volume : " @ Time);

    TPPawn(P).IsInLadderVolume = false;

	if ( P.OnLadder != self)
		return;

    if (TPPawn(P).LadderAction == LA_ExitSewer || TPPawn(P).LadderAction == LA_ExitTop)
        return;

	Super(PhysicsVolume).PawnLeavingVolume(P);

	P.OnLadder = None;
	P.EndClimbLadder(self);
	if ( P == PendingClimber )
		PendingClimber = None;

    TPPawn(P).LadderAction = LA_None;
	TPPawn(P).ServerSetLadderAction(LA_None);
	// tell all waiting pawns, if not in use
	if ( !InUse(P) )
	{
		foreach WorldInfo.AllControllers(class'Controller', C)
		{
			if (C.bPreparingMove && Ladder(C.MoveTarget) != None && Ladder(C.MoveTarget).MyLadder == self)
			{
				C.bPreparingMove = false;
				PendingClimber = C.Pawn;
				return;
			}
		}
	}
}

simulated function Enter(TPPawn tpPawn)
{
    if (tpPawn.Physics == PHYS_Walking)
        EnterLadder(tpPawn);
    else if (tpPawn.Physics == PHYS_Falling && vector(tpPawn.Rotation) Dot LookDir > tpPawn.LadderAngle)
        CatchLadder(tpPawn);
}

simulated function EnterLadder(TPPawn tpPawn)
{
    local vector             MyLocation;
    local TPPlayerController tppController;
    local bool               EnterTop;
    local bool               EnterBottom;

    EnterTop    = tpPawn.CanEnterLadderFromTop();
    EnterBottom = tpPawn.CanEnterLadderFromBottom();

    tppController = TPPlayerController(tpPawn.Controller);

    if (EnterTop)
    {
        tpPawn.Ladder.Entrance       = tpPawn.Ladder.EntranceTop;
        tpPawn.Ladder.EntranceOffset = tpPawn.Ladder.EnterTopOffset;

        tpPawn.LadderRight       = false;
		tpPawn.ServerSetLadderRight(false);

        if (tppController != None)
        {
            if (ActorRotation != None)
                tppController.SetRotation(ActorRotation.Rotation);
            else
                tppController.SetRotation(rotator(vector(rot(-4096,0,0)) >> tpPawn.Ladder.Rotation));
        }
		else
			tpPawn.ServerSetLocationAndRotation(tpPawn.Location, rotator(vector(rot(-4096,0,0)) >> tpPawn.Ladder.Rotation));
    }
	else if (EnterBottom)
    {
        tpPawn.Ladder.Entrance       = tpPawn.Ladder.EntranceBottom;
        tpPawn.Ladder.EntranceOffset = tpPawn.Ladder.EnterBottomOffset;

        tpPawn.LadderRight       = true;
		tpPawn.ServerSetLadderRight(true);

        if (tppController != None)
        {
            if (ActorRotation != None)
                tppController.SetRotation(ActorRotation.Rotation);
            else
                tppController.SetRotation(rotator(vector(rot(-4096,0,0)) >> tpPawn.Ladder.Rotation));
        }
		else
			tpPawn.ServerSetLocationAndRotation(tpPawn.Location, rotator(vector(rot(-4096,0,0)) >> tpPawn.Ladder.Rotation));
    }


    if (EnterTop || EnterBottom)
    {
        MyLocation       = tpPawn.Location;
        MyLocation.Z     = 0;
        tpPawn.LadderAction = LA_Transition;
		tpPawn.Ladder.Entrance.Z = 0;
		
		PlayerPawn(tpPawn).bClimbingLadder = true;
		PlayerPawn(tpPawn).ServerSetClimbing(true);
		PlayerPawn(tpPawn).anode_WeaponBlend.SetBlendTarget(1.0, 0.0);

		if (tppController != None)
        {            
            tppController.IgnoreMoveInput(true);
        }
    }

    tpPawn.LadderDirection = Normal (tpPawn.Ladder.Entrance - MyLocation);
    tpPawn.LadderDistance  = VSize (tpPawn.Ladder.Entrance - MyLocation);
    tpPawn.LadderTime      = 0;
}

simulated function CatchLadder(TPPawn tpPawn)
{
    local float   Dist, Height;
    local vector  EyesPos;
    local rotator Dummy;

    // Calculate the height of the ladder volume
    Dist = Top.Z-Bottom.Z - 67.0f;

    tpPawn.GetActorEyesViewPoint(EyesPos,Dummy);
    Height = EyesPos.Z;

    // Calculate percentage to top of ladder volume pawn is at
    Dist = (Height-Bottom.Z)/Dist;

    ;
    ; // ceiling

}

function OnSetCameraView(SeqAct_SetCameraView action)
{
    if (action.InputLinks[0].bHasImpulse)
        ActorRotation = action.ActorRotation;
    else if (action.InputLinks[1].bHasImpulse)
        ActorRotation = None;
}

simulated event PhysicsChangedFor(Actor Other)
{
    return;  // Do nothing
}

