class LadderVolume extends PhysicsVolume
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

var() name ClimbingAnimation;
var() name TopAnimation;
var Rotator WallDir;
var Vector LookDir;
var Vector ClimbDir;
var const Ladder LadderList;
var() bool bNoPhysicalLadder;
var() bool bAutoPath;
var() bool bAllowLadderStrafing;
var Pawn PendingClimber;

simulated function PostBeginPlay()
{
    local Ladder L, M;
    local Vector Dir;

    PostBeginPlay();
    WallDir = Rotation;
    LookDir = Vector(WallDir);
    // End:0x145
    if(!bAutoPath && LookDir.Z != float(0))
    {
        ClimbDir = vect(0.0000000, 0.0000000, 1.0000000);
        L = LadderList;
        J0x5C:

        // End:0x10E [Loop If]
        if(L != none)
        {
            M = LadderList;
            J0x72:

            // End:0xF7 [Loop If]
            if(M != none)
            {
                // End:0xE0
                if(M != L)
                {
                    Dir = Normal(M.Location - L.Location);
                    // End:0xD4
                    if((Dir Dot ClimbDir) < float(0))
                    {
                        Dir *= float(-1);
                    }
                    ClimbDir += Dir;
                }
                M = M.LadderList;
                // [Loop Continue]
                goto J0x72;
            }
            L = L.LadderList;
            // [Loop Continue]
            goto J0x5C;
        }
        ClimbDir = Normal(ClimbDir);
        // End:0x145
        if((ClimbDir Dot vect(0.0000000, 0.0000000, 1.0000000)) < float(0))
        {
            ClimbDir *= float(-1);
        }
    }
    return;
}

function bool InUse(Pawn Ignored)
{
    local Pawn StillClimbing;

    // End:0x4B
    foreach TouchingActors(Class'Pawn', StillClimbing)
    {
        // End:0x4A
        if(((StillClimbing != Ignored) && StillClimbing.bCollideActors) && StillClimbing.bBlockActors)
        {            
            return true;
        }        
    }    
    // End:0xEF
    if(PendingClimber != none)
    {
        // End:0xEF
        if(((((PendingClimber.Controller == none) || !PendingClimber.bCollideActors) || !PendingClimber.bBlockActors) || Ladder(PendingClimber.Controller.MoveTarget) == none) || Ladder(PendingClimber.Controller.MoveTarget).MyLadder != self)
        {
            PendingClimber = none;
        }
    }
    return (PendingClimber != none) && PendingClimber != Ignored;
    return;
}

simulated event PawnEnteredVolume(Pawn P)
{
    local Rotator PawnRot;

    PawnEnteredVolume(P);
    // End:0x23
    if(!P.CanGrabLadder())
    {
        return;
    }
    PawnRot = P.Rotation;
    PawnRot.Pitch = 0;
    // End:0xAE
    if(((Vector(PawnRot) Dot LookDir) > 0.9000000) || (AIController(P.Controller) != none) && Ladder(P.Controller.MoveTarget) != none)
    {
        P.ClimbLadder(self);        
    }
    else
    {
        // End:0xEA
        if(!P.bDeleteMe && P.Controller != none)
        {
            __NFUN_278__(Class'PotentialClimbWatcher', P);
        }
    }
    return;
}

simulated event PawnLeavingVolume(Pawn P)
{
    local Controller C;

    // End:0x16
    if(P.OnLadder != self)
    {
        return;
    }
    PawnLeavingVolume(P);
    P.OnLadder = none;
    P.EndClimbLadder(self);
    // End:0x59
    if(P == PendingClimber)
    {
        PendingClimber = none;
    }
    // End:0x101
    if(!InUse(P))
    {
        // End:0x100
        foreach WorldInfo.AllControllers(Class'Controller', C)
        {
            // End:0xFF
            if((C.bPreparingMove && Ladder(C.MoveTarget) != none) && Ladder(C.MoveTarget).MyLadder == self)
            {
                C.bPreparingMove = false;
                PendingClimber = C.Pawn;                
                return;
            }            
        }        
    }
    return;
}

simulated event PhysicsChangedFor(Actor other)
{
    // End:0x77
    if(((((int(other.Physics) == int(2)) || int(other.Physics) == int(9)) || other.bDeleteMe) || Pawn(other) == none) || Pawn(other).Controller == none)
    {
        return;
    }
    __NFUN_278__(Class'PotentialClimbWatcher', other);
    return;
}

defaultproperties
{
    ClimbDir=(X=0.0000000,Y=0.0000000,Z=1.0000000)
    bAutoPath=true
    bAllowLadderStrafing=true
    // Reference: BrushComponent'Default__LadderVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: BrushComponent'Default__PhysicsVolume.BrushComponent0'
    begin object name="BrushComponent0"
    end object
    Components[0]=BrushComponent0
    // Reference: ArrowComponent'Default__LadderVolume.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'ArrowComponent'
        ArrowColor=(R=150,G=100,B=150,A=255)
        ArrowSize=5.0000000
    end object
    Components[1]=Arrow
    RemoteRole=1
}