class AdvFloorSwitch extends AdvTrigger
    hidecategories(Navigation);

var() bool bIsPressable;
var() float ZPressOffset;
var() float ActivationTime;
var() array< class<Actor> > Activators;
var Vector BaseLocation;
var Vector DestinationLocation;
var float MovementTime;

simulated function PostBeginPlay()
{
    super(Trigger).PostBeginPlay();
    BaseLocation = Location;
    DestinationLocation = BaseLocation;
    DestinationLocation.Z += ZPressOffset;
    //return;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x78
    if((Activators.Find(Other.Class) != ) || )
    {
        Pawn(Other) != none;        
        // End:0x6D
        if(bIsPressable)
        {
            GotoState('Pressed');            
        }
        else
        {
            Activate(true);
        }
    }
    super(Trigger).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

event UnTouch(Actor Other)
{
    super(Actor).UnTouch(Other);
    // End:0x5B
    if((Pawn(Other) != none) || Touching.Find(Other) != )
    {        
        GotoState('UnPressed');
    }
    //return;    
}

function Activate(bool Activate)
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Switch SwitchEvent;
    local array<int> ActivateIndices;
    local bool bNoDeactive;
    local Actor Act;

    // End:0xC2
    if(!Activate && Touching.Length > 0)
    {
        bNoDeactive = false;
        // End:0xA4
        foreach TouchingActors(Class'Engine.Actor', Act)
        {
            // End:0xA3
            if((Activators.Find(Act.Class) != ) || )
            {
                Pawn(Act) != none;                
                bNoDeactive = true;
                // End:0xA4
                break;
            }            
        }        
        // End:0xC2
        if(bNoDeactive)
        {
            GotoState('Pressed');
            return;
        }
    }
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x207
    if((GameSeq != none) && bEnabled)
    {
        // End:0x126
        if(Activate)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Switch', true, ExecutionEvents);
        // End:0x206
        foreach ExecutionEvents(ExecutionEvent)
        {
            SwitchEvent = SeqEvent_Switch(ExecutionEvent);
            // End:0x205
            if(SwitchEvent.Originator == self)
            {
                SwitchEvent.CheckActivate(SwitchEvent.Originator, self, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

auto state Idle
{Begin:

    MovementTime = 0.0000000;
    stop;                    
}

state Pressed
{
    simulated function Tick(float DeltaTime)
    {
        local float Alpha;
        local Vector CurrentLocation;

        MovementTime += DeltaTime;
        Alpha = MovementTime / ActivationTime;
        // End:0x54
        if(Alpha > 1.0000000)
        {
            Alpha = 1.0000000;
        }
        CurrentLocation = VLerp(BaseLocation, DestinationLocation, Alpha);
        Move(CurrentLocation - Location);
        // End:0xBB
        if(Alpha == 1.0000000)
        {
            GotoState('Active');
        }
        //return;        
    }
    stop;    
}

state UnPressed
{
    simulated function Tick(float DeltaTime)
    {
        local float Alpha;
        local Vector CurrentLocation;

        MovementTime -= DeltaTime;
        Alpha = MovementTime / ActivationTime;
        // End:0x54
        if(Alpha < 0.0000000)
        {
            Alpha = 0.0000000;
        }
        CurrentLocation = VLerp(BaseLocation, DestinationLocation, Alpha);
        Move(CurrentLocation - Location);
        // End:0xBB
        if(Alpha == 0.0000000)
        {
            GotoState('Idle');
        }
        //return;        
    }
Begin:

    Activate(false);
    stop;                    
}

state Active
{Begin:

    Activate(true);
    stop;                    
}

defaultproperties
{
    bIsPressable=true
    ZPressOffset=-10.0000000
    ActivationTime=1.0000000
    Activators[0]=Class'AdvPhysicsTriggerBox'
    // Reference: StaticMeshComponent'Default__AdvFloorSwitch.Mesh'
    begin object name=Mesh
        ReplacementPrimitive=none
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Scale3D=(X=1.6000000,Y=1.6000000,Z=0.1000000)
    end object
    TriggerMesh=Mesh
    // Reference: DynamicLightEnvironmentComponent'Default__AdvFloorSwitch.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__AdvFloorSwitch.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=20.0000000
        CollisionRadius=70.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
    Components[3]=Mesh
    Components[4]=Mesh
    bHidden=false
    CollisionComponent=Mesh
    SupportedEvents=/* Array type was not detected. */
}