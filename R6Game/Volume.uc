class Volume extends Brush
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

var() edfindable Actor AssociatedActor;
var() int LocationPriority;
var() const localized string LocationName;

// Export UVolume::execEncompasses(FFrame&, void* const)
native function bool Encompasses(Actor other);

function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x25
    if(AssociatedActor != none)
    {
        GotoState('AssociatedTouch');
        InitialState = GetStateName();
    }
    return;
}

simulated function string GetLocationStringFor(PlayerReplicationInfo PRI)
{
    return LocationName;
    return;
}

function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    DisplayDebug(HUD, out_YL, out_YPos);
    HUD.Canvas.__NFUN_465__("AssociatedActor " $ string(AssociatedActor), false);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x31
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x2E
        if(!bCollideActors)
        {
            SetCollision(true, bBlockActors);
        }        
    }
    else
    {
        // End:0x60
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0x5D
            if(bCollideActors)
            {
                SetCollision(false, bBlockActors);
            }            
        }
        else
        {
            // End:0x8B
            if(Action.InputLinks[2].bHasImpulse)
            {
                SetCollision(!bCollideActors, bBlockActors);
            }
        }
    }
    return;
}

state AssociatedTouch
{
    function BeginState(name PreviousStateName)
    {
        local Actor A;

        // End:0x39
        foreach TouchingActors(Class'Actor', A)
        {
            Touch(A, none, A.Location, vect(0.0000000, 0.0000000, 1.0000000));            
        }        
        return;
    }
    stop;
}

defaultproperties
{
    // Reference: BrushComponent'Default__Volume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: BrushComponent'Default__Brush.BrushComponent0'
    begin object name="BrushComponent0"
        CollideActors=true
        BlockNonZeroExtent=true
        AlwaysLoadOnClient=true
        AlwaysLoadOnServer=true
    end object
    BrushComponent=BrushComponent0
    bSkipActorPropertyReplication=true
    bCollideActors=true
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}