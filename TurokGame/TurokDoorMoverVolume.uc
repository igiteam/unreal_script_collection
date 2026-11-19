class TurokDoorMoverVolume extends PhysicsVolume
    native
    hidecategories(Navigation,Object,Movement,Display,Advanced,Attachment,Brush,Collision,PhysicsVolume,Volume);

var() @NULL mDoorActor;

event PawnEnteredVolume(@NULL P)
{
    super.PawnEnteredVolume(P);
    // End:0x18
    if(mDoorActor == none)
    {
        return;
    }
    // End:0x60
    if(mDoorActor.IsConsideredAProximityDoor() && mDoorActor.CanOpen(P))
    {
        mDoorActor.SetDoorAction(0);
    }
    //return;    
}

event PawnLeavingVolume(@NULL P)
{
    local @NULL tph;
    local bool bHumanTouching;

    super.PawnLeavingVolume(P);
    // End:0x18
    if(mDoorActor == none)
    {
        return;
    }
    bHumanTouching = false;
    // End:0x75
    foreach TouchingActors(Class'TurokPawnHuman', tph)
    {
        // End:0x74
        if(((Encompasses(tph)) && tph != P) && tph.Health > 0)
        {
            bHumanTouching = true;
            // End:0x75
            break;
        }        
    }    
    // End:0xAC
    if(!bHumanTouching)
    {
        // End:0xAC
        if(mDoorActor.IsConsideredAProximityDoor())
        {
            mDoorActor.SetDoorAction(1);
        }
    }
    //return;    
}

defaultproperties
{
    mSetVolumeFlags=4
    // Reference: BrushComponent'Default__TurokDoorMoverVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}