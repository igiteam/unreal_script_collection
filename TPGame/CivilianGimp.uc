class CivilianGimp extends CivilianPawn
	placeable
	dependson(CivilianPawn)
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 10

var vector                    Dir;
var float                     TotalDistance;
var float                     CurrDistance;
var SeqAct_GimpMoveToActor    MoveTo;
var Actor                     LookAt;
var float                     MoveToVelocity;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().CivilianGimpMoveData );
}

event OnSetSkeletalMesh(SeqAct_SetSkeletalMesh Action)
{
	if (Action.NewSkeletalMesh != None && Action.NewSkeletalMesh != Mesh.SkeletalMesh)
	{
		Mesh.SetSkeletalMesh(Action.NewSkeletalMesh);
		//ReplicatedMesh = Action.NewSkeletalMesh;
	}
}

function OnGimpMoveToActor(SeqAct_GimpMoveToActor Action)
{
    local SeqVar_Object ObjVar;
    local Actor         Dest;

    LookAt = None;

    if (MoveTo != None)
        ClearLatentAction(class'SeqAct_GimpMoveToActor', true);

	foreach Action.LinkedVariables(class'SeqVar_Object', ObjVar, "Destination")
	{
		Dest = Actor(ObjVar.GetObjectValue());
		if (Dest != None)
			break;
	}

	foreach Action.LinkedVariables(class'SeqVar_Object', ObjVar, "Look At")
	{
		LookAt = Actor(ObjVar.GetObjectValue());
		if (LookAt != None)
			break;
	}

    if (Dest != None)
        MoveTo = Action;
    else
        return;

	SetMovementType( Action.MovementType );
	SetMovementVariation( Action.MovementVariation );
	
	if ( Action.OverrideTuneData  )
		MoveToVelocity = Action.Velocity;
	else
		MoveToVelocity = GroundSpeed;

    Dir             = Dest.Location - Location;
    TotalDistance   = VSize(Dir);
    Dir             = Normal(Dir);
    CurrDistance    = 0;


}

// @optimization Move to native?
simulated function Tick(float DeltaTime)
{
    local float   Dist;
    local Rotator Rot;

    if(MoveTo != None)
    {
        Dist = MoveToVelocity*DeltaTime;
        if ((TotalDistance - CurrDistance) < Dist)
        {
            MoveTo          = None;
            Dist            = TotalDistance - CurrDistance;
            ClearLatentAction(class'SeqAct_GimpMoveToActor');
        }

        CurrDistance += Dist;
        SetLocation(Location + Dir*Dist);

        if (LookAt != None)
        {
            //Rot = Rotator(LookAt.Location - Location);
            Rot = RLerp(Rotation,Rotator(LookAt.Location - Location),5.0f*DeltaTime,true);
        }
        else
        {
            Rot = RLerp(Rotation,Rotator(Dir),5.0f*DeltaTime,true);
        }

        SetRotation(Rot);
    }
}

