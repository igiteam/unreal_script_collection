class EvilUsableTriggerWithText extends Trigger
    native
    hidecategories(Navigation)
    implements(EvilUsableInfoInterface);

var() float TimerDelay;
var() export editinline EvilCaptionComponent CaptionComponent;
var() export editinline StaticMeshComponent MeshComp;
var() MaterialInterface DefaultMaterial;
var() array<MaterialInterface> Materials;
var() SoundCue UseSound;
var() bool Enabled;
var transient bool Initialized;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        Enabled;
}

function bool UsedBy(Pawn User)
{
    local EvilPlayerController PC;
    local array<SequenceEvent> SeqEventList;
    local SequenceEvent SeqEvent;
    local bool Result;

    PC = EvilPlayerController(User.Controller);
    // End:0x14B
    if(PC != none)
    {
        // End:0xA8
        if((UseSound != none) && Enabled)
        {
            PC.Pawn.PlaySound(UseSound, false, true, false, Location);
        }
        AfterUse();
        Result = TriggerEventClass(Class'Engine.SeqEvent_Used', User, -1);
        FindEventsOfClass(Class'Engine.SeqEvent_Used', SeqEventList, true);
        // End:0x13F
        foreach SeqEventList(SeqEvent)
        {
            SeqEvent_Used(SeqEvent).bEnabled = false;            
        }        
        return Result;
    }
    return false;
    //return ReturnValue;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    local array<SequenceEvent> SeqEventList;
    local SequenceEvent SeqEvent;

    FindEventsOfClass(Class'Engine.SeqEvent_Used', SeqEventList, true);
    // End:0xA6
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x96
        foreach SeqEventList(SeqEvent)
        {
            SeqEvent_Used(SeqEvent).bEnabled = true;            
        }        
        Enabled = true;        
    }
    else
    {
        // End:0x146
        if(Action.InputLinks[2].bHasImpulse)
        {
            // End:0x12B
            foreach SeqEventList(SeqEvent)
            {
                SeqEvent_Used(SeqEvent).bEnabled = !Enabled;                
            }            
            Enabled = !Enabled;            
        }
        else
        {
            // End:0x188
            foreach SeqEventList(SeqEvent)
            {
                SeqEvent_Used(SeqEvent).bEnabled = false;                
            }            
            Enabled = false;
        }
    }
    ForceNetRelevant();
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    local int AttachIdx, IgnoreIdx;
    local Actor A;

    // End:0x14A
    if(Action.bToggleBasedActors)
    {
        AttachIdx = 0;
        J0x2D:

        // End:0x14A [Loop If]
        if(AttachIdx < Attached.Length)
        {
            A = Attached[AttachIdx];
            IgnoreIdx = 0;
            J0x6D:

            // End:0x102 [Loop If]
            if(IgnoreIdx < Action.IgnoreBasedClasses.Length)
            {
                // End:0xF4
                if(ClassIsChildOf(A.Class, Action.IgnoreBasedClasses[IgnoreIdx]))
                {
                    A = none;
                    // [Explicit Break]
                    goto J0x102;
                }
                IgnoreIdx++;
                // [Loop Continue]
                goto J0x6D;
            }
            J0x102:

            // End:0x114
            if(A == none)
            {                
            }
            else
            {
                A.OnToggleHidden(Action);
            }
            AttachIdx++;
            // [Loop Continue]
            goto J0x2D;
        }
    }
    // End:0x1C3
    if(Action.InputLinks[0].bHasImpulse)
    {
        MeshComp.SetHidden(true);
        CaptionComponent.Hide();        
    }
    else
    {
        // End:0x23C
        if(Action.InputLinks[1].bHasImpulse)
        {
            MeshComp.SetHidden(false);
            CaptionComponent.Show();            
        }
        else
        {
            // End:0x280
            if(CaptionComponent.bPostRenderDisabled)
            {
                CaptionComponent.Show();                
            }
            else
            {
                CaptionComponent.Hide();
            }
            MeshComp.SetHidden(!MeshComp.HiddenGame);
        }
    }
    ForceNetRelevant();
    // End:0x326
    if(int(RemoteRole) != int(ROLE_None))
    {
        SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bHidden', bHidden == default.bHidden);
    }
    //return;    
}

simulated function ResetCaption()
{
    //return;    
}

simulated function AfterUse()
{
    Enabled = false;
    ForceNetRelevant();
    //return;    
}

simulated function PostBeginPlay()
{
    local PlayerController PC;

    Initialized = false;
    super.PostBeginPlay();
    SetTimer(TimerDelay, true, 'TestTick');
    // End:0xF6
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xAF
        if(!PC.bIsPlayer || PC.myHUD == none)
        {
            continue;            
        }
        EvilGFxHudWrapper(PC.myHUD).AddPostRenderedComponent(CaptionComponent);        
    }    
    //return;    
}

simulated event ShutDown()
{
    super(Actor).ShutDown();
    Enabled = false;
    MeshComp.SetHidden(true);
    CaptionComponent.Hide();
    ClearTimer('TestTick');
    //return;    
}

function TestTick()
{
    local array<SequenceEvent> SeqEventList;
    local SequenceEvent SeqEvent;

    // End:0xE9
    if(!Initialized)
    {
        FindEventsOfClass(Class'Engine.SeqEvent_Used', SeqEventList, true);
        // End:0xE8
        foreach SeqEventList(SeqEvent)
        {
            SeqEvent_Used(SeqEvent).MaxTriggerCount = 0;
            // End:0xA8
            if(!Enabled)
            {
                SeqEvent_Used(SeqEvent).bEnabled = false;                
            }
            else
            {
                Enabled = SeqEvent_Used(SeqEvent).bEnabled;
            }
            Initialized = true;            
        }        
    }
    ForceNetRelevant();
    //return;    
}

function SetDefaultMaterial()
{
    MeshComp.SetMaterial(0, DefaultMaterial);
    //return;    
}

function SetMaterialIndex(int Index)
{
    // End:0x4B
    if(Materials.Length > Index)
    {
        MeshComp.SetMaterial(0, Materials[Index]);
    }
    //return;    
}

simulated function bool IsUsable()
{
    return true;
    //return ReturnValue;    
}

simulated function bool IsUsableAndActive()
{
    return Enabled;
    //return ReturnValue;    
}

simulated function bool CanBeUsedNow(PlayerController PC)
{
    return (Enabled && EvilPlayerController(PC) != none) && EvilPlayerController(PC).UsableTrigger == self;
    //return ReturnValue;    
}

simulated function float GetInteractRange()
{
    local array<SequenceEvent> SeqEventList;
    local SequenceEvent SeqEvent;

    FindEventsOfClass(Class'Engine.SeqEvent_Used', SeqEventList, true);
    // End:0x5E
    foreach SeqEventList(SeqEvent)
    {        
        return SeqEvent_Used(SeqEvent).InteractDistance;        
    }    
    return 0.0000000;
    //return ReturnValue;    
}

function bool AimToInteract()
{
    local array<SequenceEvent> SeqEventList;
    local SequenceEvent SeqEvent;

    FindEventsOfClass(Class'Engine.SeqEvent_Used', SeqEventList, true);
    // End:0x5F
    foreach SeqEventList(SeqEvent)
    {        
        return SeqEvent_Used(SeqEvent).bAimToInteract;        
    }    
    return false;
    //return ReturnValue;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    super.CreateCheckpointRecord(Record);
    Record.bEnabled = Enabled;
    Record.bVisible = !MeshComp.HiddenGame;
    Record.CurrentCaptionLocString = CaptionComponent.LocString;
    Record.CurrentCaptionOffset = CaptionComponent.Offset;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local array<SequenceEvent> SeqEventList;
    local SequenceEvent SeqEvent;
    local Actor OldBase;
    local editinline SkeletalMeshComponent OldBaseComp;
    local name OldBaseBoneName;
    local array<Actor> OldAttached;
    local array<Vector> OldLocations;
    local int I;

    OldAttached = Attached;
    J0x13:

    // End:0xD4 [Loop If]
    if(I < OldAttached.Length)
    {
        // End:0xBC
        if((OldAttached[I] != none) && OldAttached[I].bJustTeleported)
        {
            OldLocations[I] = OldAttached[I].Location;
            I++;            
        }
        else
        {
            OldAttached.Remove(I, 1);            
        }
        // [Loop Continue]
        goto J0x13;
    }
    OldBase = Base;
    OldBaseComp = BaseSkelComponent;
    OldBaseBoneName = BaseBoneName;
    super.ApplyCheckpointRecord(Record);
    SetBase(OldBase,, OldBaseComp, OldBaseBoneName);
    I = 0;
    J0x14A:

    // End:0x1E4 [Loop If]
    if(I < OldAttached.Length)
    {
        // End:0x1D6
        if(OldAttached[I] != none)
        {
            OldAttached[I].SetLocation(OldLocations[I]);
            OldAttached[I].SetBase(self);
        }
        I++;
        // [Loop Continue]
        goto J0x14A;
    }
    Enabled = Record.bEnabled;
    MeshComp.SetHidden(!Record.bVisible);
    CaptionComponent.LocString = Record.CurrentCaptionLocString;
    CaptionComponent.Offset = Record.CurrentCaptionOffset;
    // End:0x302
    if(Record.bVisible)
    {
        CaptionComponent.Show();        
    }
    else
    {
        CaptionComponent.Hide();
    }
    FindEventsOfClass(Class'Engine.SeqEvent_Used', SeqEventList, true);
    // End:0x389
    foreach SeqEventList(SeqEvent)
    {
        SeqEvent_Used(SeqEvent).bEnabled = Enabled;        
    }    
    ForceNetRelevant();
    //return;    
}

defaultproperties
{
    TimerDelay=0.2000000
    // Reference: EvilCaptionComponent'Default__EvilUsableTriggerWithText.CaptionComp'
    begin object name=CaptionComp class=Class'EvilCaptionComponent'
    end object
    CaptionComponent=CaptionComp
    // Reference: StaticMeshComponent'Default__EvilUsableTriggerWithText.PickupMeshComp'
    begin object name=PickupMeshComp class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bIgnoreOwnerHidden=true
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bUsePrecomputedShadows=true
    end object
    MeshComp=PickupMeshComp
    Enabled=true
    // Reference: CylinderComponent'Default__EvilUsableTriggerWithText.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__EvilUsableTriggerWithText.Sprite'
    begin object name=Sprite
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=PickupMeshComp
    Components[3]=CaptionComp
    CollisionComponent=CollisionCylinder
}