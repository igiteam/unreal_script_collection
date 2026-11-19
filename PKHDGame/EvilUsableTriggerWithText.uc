class EvilUsableTriggerWithText extends Trigger
    hidecategories(Navigation)
    implements(EvilUsableInfoInterface);

var() float TimerDelay;
var() export editinline EvilCaptionComponent CaptionComponent;
var() export editinline StaticMeshComponent MeshComp;
var() MaterialInterface DefaultMaterial;
var() array<MaterialInterface> Materials;
var() SoundCue UseSound;
var transient bool Enabled;
var transient bool Initialized;

function bool UsedBy(Pawn User)
{
    local EvilPlayerController PC;
    local array<SequenceEvent> SeqEventList;
    local SequenceEvent SeqEvent;
    local bool Result;

    PC = EvilPlayerController(User.Controller);
    // End:0x13C
    if(PC != none)
    {
        // End:0x99
        if(UseSound != none)
        {
            PC.Pawn.PlaySound(UseSound, false, true, false, Location);
        }
        AfterUse();
        Result = TriggerEventClass(Class'Engine.SeqEvent_Used', User, -1);
        FindEventsOfClass(Class'Engine.SeqEvent_Used', SeqEventList, true);
        // End:0x130
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
    // End:0xE0
    if(Action.InputLinks[0].bHasImpulse || Action.InputLinks[2].bHasImpulse)
    {
        // End:0xD0
        foreach SeqEventList(SeqEvent)
        {
            SeqEvent_Used(SeqEvent).bEnabled = true;            
        }        
        Enabled = true;        
    }
    else
    {
        // End:0x122
        foreach SeqEventList(SeqEvent)
        {
            SeqEvent_Used(SeqEvent).bEnabled = false;            
        }        
        Enabled = false;
    }
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
    // End:0x1C5
    if(Action.InputLinks[0].bHasImpulse)
    {
        MeshComp.SetHidden(true);
        CaptionComponent.bVisible = false;        
    }
    else
    {
        // End:0x240
        if(Action.InputLinks[1].bHasImpulse)
        {
            MeshComp.SetHidden(false);
            CaptionComponent.bVisible = true;            
        }
        else
        {
            MeshComp.SetHidden(!MeshComp.HiddenGame);
            CaptionComponent.bVisible = MeshComp.HiddenGame;
        }
    }
    ForceNetRelevant();
    // End:0x306
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
    CaptionComponent.bVisible = false;
    ClearTimer('TestTick');
    //return;    
}

function TestTick()
{
    local array<SequenceEvent> SeqEventList;
    local SequenceEvent SeqEvent;

    // End:0xAD
    if(!Initialized)
    {
        FindEventsOfClass(Class'Engine.SeqEvent_Used', SeqEventList, true);
        // End:0xAC
        foreach SeqEventList(SeqEvent)
        {
            SeqEvent_Used(SeqEvent).MaxTriggerCount = 0;
            Enabled = SeqEvent_Used(SeqEvent).bEnabled;
            Initialized = true;            
        }        
    }
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

function bool IsUsable()
{
    return true;
    //return ReturnValue;    
}

function bool IsUsableAndActive()
{
    return Enabled;
    //return ReturnValue;    
}

function bool CanBeUsedNow(PlayerController PC)
{
    return (Enabled && EvilPlayerController(PC) != none) && EvilPlayerController(PC).UsableTrigger == self;
    //return ReturnValue;    
}

defaultproperties
{
    TimerDelay=0.2000000
    // Reference: EvilCaptionComponent'Default__EvilUsableTriggerWithText.CaptionComp'
    begin object name="CaptionComp" class=Class'EvilCaptionComponent'
    end object
    CaptionComponent=CaptionComp
    // Reference: StaticMeshComponent'Default__EvilUsableTriggerWithText.PickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMeshComp'
    begin object name="PickupMeshComp" class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bIgnoreOwnerHidden=true
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bUsePrecomputedShadows=true
    end object
    MeshComp=PickupMeshComp
    // Reference: CylinderComponent'Default__EvilUsableTriggerWithText.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__EvilUsableTriggerWithText.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Sprite'
    // Archetype: SpriteComponent'Engine.Default__Trigger.Sprite'
    begin object name="Sprite"
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=PickupMeshComp
    Components[3]=CaptionComp
    CollisionComponent=CollisionCylinder
}