class EPA_Jump extends EvilPawnAction
    abstract;

function PawnLanded(Vector HitNormal, Actor FloorActor)
{
    PawnOwner.EndPawnAction();
    //return;    
}

defaultproperties
{
    bLockPawnRotation=true
}