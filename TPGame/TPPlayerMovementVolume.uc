class TPPlayerMovementVolume extends Volume
    placeable
    native
    HideCategories(Brush);


struct native PMMovement
{
    var() bool bAllowVault;
    var() bool bAllowMantle;
    var() bool bAllowShimmy;
};

struct native PMShimmyOptions
{
    var() bool bCannotPullUp;
    var() bool bUseNonWalledAnimations;
    var() bool bAllowLeftTurn90;
    var() bool bAllowRightTurn90;
    var() bool bAllowLeftTurn270;
    var() bool bAllowRightTurn270;
};

struct native PMMantleOptions
{
    var() bool bTurnOffInitialCollision;
};

struct native PMPawns
{
    var() bool bAllowPlayer;
    var() bool bAllowNPCs;

    structdefaultproperties
    {
        bAllowPlayer=true
        bAllowNPCs=true
    }
};


struct native PMDistanceOptions
{
    var() float MantleTestConstraints[5];
    var() float LineCheckStartHeight;

    // This effectively disables being able to VaultMantle
    //MantleTestConstraints(0) = 90.0f
    //MantleTestConstraints(1) = 128.0f

    structdefaultproperties
    {
        MantleTestConstraints(0) = 0.0f
        MantleTestConstraints(1) = 0.1f
        MantleTestConstraints(2) = 192.0f
        MantleTestConstraints(3) = 234.0f
        MantleTestConstraints(4) = 288.0f

        LineCheckStartHeight     = 288.0f
    }
};

var() PMMovement         Movement;
var() PMPawns            Pawns;
var() PMShimmyOptions    ShimmyOptions;
var() PMDistanceOptions  DistanceOptions;
var() PMMantleOptions    MantleOptions;

var() bool               bCameraCanRotate;

var   Actor              ActorRotation;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
	if (Role == Role_Authority)
		Movement;
}

function OnSetCameraView(SeqAct_SetCameraView action)
{
    if (action.InputLinks[0].bHasImpulse)
        ActorRotation = action.ActorRotation;
    else if (action.InputLinks[1].bHasImpulse)
        ActorRotation = None;
}

event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
    local TPPawn TpPawn;

    if ((Other.IsA('PlayerPawn') && Pawns.bAllowPlayer) ||
        (Other.IsA('TPPawn') && Pawns.bAllowNPCs && !(Other.IsA('PlayerPawn'))))
    {
        TpPawn = TPPawn(Other);
        TpPawn.MovementVolumes.AddItem(self);
    }
}

event Untouch(Actor Other)
{
    local TPPawn TpPawn;
    local int    Index;

    if ((Other.IsA('PlayerPawn') && Pawns.bAllowPlayer) ||
        (Other.IsA('TPPawn') && Pawns.bAllowNPCs && !(Other.IsA('PlayerPawn'))))
    {
        TpPawn = TPPawn(Other);
	
        Index = TpPawn.MovementVolumes.Find(self);
        if (Index != -1)
            TpPawn.MovementVolumes.Remove (Index,1);
        else
            ;
    }
}

