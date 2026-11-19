class InterpActor extends DynamicSMActor
    native
    placeable
    hidecategories(lighting);

var NavigationPoint MyMarker;
var bool bMonitorMover;
var bool bMonitorZVelocity;
var float MaxZVelocity;
var float StayOpenTime;
var() /*0x04000000-0x00000000*/ SoundCue OpenSound;
var() /*0x04000000-0x00000000*/ SoundCue CloseSound;

event bool EncroachingOn(Actor other)
{
    local int I;
    local SeqEvent_Mover MoverEvent;
    local Pawn P;
    local Vector Height, HitLocation, HitNormal;
    local bool bLandingPawn;

    // End:0x208
    if((Normal(Velocity) Dot Normal(other.Location - Location)) >= 0.0000000)
    {
        P = Pawn(other);
        // End:0x1A6
        if(P != none)
        {
            // End:0x131
            if((int(P.Physics) == int(2)) && Velocity.Z > 0.0000000)
            {
                Height = P.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000);
                // End:0x12E
                if(TraceComponent(HitLocation, HitNormal, StaticMeshComponent, P.Location - Height, P.Location + Height, P.GetCollisionExtent()))
                {
                    // End:0x126
                    if(P.Location.Z < Location.Z)
                    {
                        P.SetLocation(HitLocation + Height);
                    }
                    bLandingPawn = true;
                }                
            }
            else
            {
                // End:0x1A6
                if(((P.Controller != none) && P.Controller.PendingMover != none) && P.Controller.PendingMover == self)
                {
                    P.Controller.UnderLift(LiftCenter(MyMarker));
                }
            }
        }
        // End:0x208
        if(!bLandingPawn)
        {
            I = 0;
            J0x1B8:

            // End:0x208 [Loop If]
            if(I < GeneratedEvents.Length)
            {
                MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
                // End:0x1FE
                if(MoverEvent != none)
                {
                    MoverEvent.NotifyEncroachingOn(other);
                }
                I++;
                // [Loop Continue]
                goto J0x1B8;
            }
        }
    }
    return false;
    return;
}

event Attach(Actor other)
{
    local int I;
    local SeqEvent_Mover MoverEvent;

    I = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(I < GeneratedEvents.Length)
    {
        MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
        // End:0x4D
        if(MoverEvent != none)
        {
            MoverEvent.NotifyAttached(other);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

event Detach(Actor other)
{
    local int I;
    local SeqEvent_Mover MoverEvent;

    I = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(I < GeneratedEvents.Length)
    {
        MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
        // End:0x4D
        if(MoverEvent != none)
        {
            MoverEvent.NotifyDetached(other);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function Restart()
{
    local Actor A;

    // End:0x1D
    foreach BasedActors(Class'Actor', A)
    {
        Attach(A);        
    }    
    return;
}

function FinishedOpen()
{
    local int I;
    local SeqEvent_Mover MoverEvent;

    I = 0;
    J0x07:

    // End:0x52 [Loop If]
    if(I < GeneratedEvents.Length)
    {
        MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
        // End:0x48
        if(MoverEvent != none)
        {
            MoverEvent.NotifyFinishedOpen();
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

simulated function PlayMovingSound(bool bClosing)
{
    local SoundCue SoundToPlay;

    SoundToPlay = ((bClosing) ? CloseSound : OpenSound);
    // End:0x38
    if(SoundToPlay != none)
    {
        PlaySound(SoundToPlay, 4, true);
    }
    return;
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction)
{
    ClearTimer('Restart');
    ClearTimer('FinishedOpen');
    PlayMovingSound(InterpAction.bReversePlayback);
    InterpolationStarted(InterpAction);
    return;
}

event InterpolationFinished(SeqAct_Interp InterpAction)
{
    local DoorMarker DoorNav;
    local Controller C;

    DoorNav = DoorMarker(MyMarker);
    // End:0x5A
    if(InterpAction.bReversePlayback)
    {
        // End:0x3C
        if(Attached.Length > 0)
        {
            SetTimer(StayOpenTime, false, 'Restart');
        }
        // End:0x57
        if(DoorNav != none)
        {
            DoorNav.MoverClosed();
        }        
    }
    else
    {
        SetTimer(StayOpenTime, false, 'FinishedOpen');
        // End:0x83
        if(DoorNav != none)
        {
            DoorNav.MoverOpened();
        }
    }
    // End:0xCE
    if(bMonitorMover)
    {
        // End:0xCD
        foreach WorldInfo.AllControllers(Class'Controller', C)
        {
            // End:0xCC
            if(C.PendingMover == self)
            {
                C.MoverFinished();
            }            
        }        
    }
    return;
}

simulated event InterpolationChanged(SeqAct_Interp InterpAction)
{
    PlayMovingSound(InterpAction.bReversePlayback);
    return;
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__InterpActor.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__DynamicSMActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        WireframeColor=(R=255,G=0,B=255,A=255)
    end object
    StaticMeshComponent=StaticMeshComponent0
    bNoDelete=true
    bAlwaysRelevant=true
    bOnlyDirtyReplication=true
    m_bTickOnlyWhenVisible=true
    Components[0]=StaticMeshComponent0
    Physics=7
    RemoteRole=0
    TickGroup=1
    NetUpdateFrequency=1.0000000
    NetPriority=2.7000000
    CollisionComponent=StaticMeshComponent0
    SupportedEvents[0]=Class'SeqEvent_Touch'
    SupportedEvents[1]=Class'SeqEvent_Destroyed'
    SupportedEvents[2]=Class'SeqEvent_TakeDamage'
    SupportedEvents[3]=Class'SeqEvent_R6LookedAt'
    SupportedEvents[4]=Class'SeqEvent_Mover'
    SupportedEvents[5]=Class'SeqEvent_TakeDamage'
}