class EvilPointOfInterest extends Keypoint
    config(Game)
    hidecategories(Navigation);

enum EPOIForceLookType
{
    ePOIFORCELOOK_None,             // 0
    ePOIFORCELOOK_Automatic,        // 1
    ePOIFORCELOOK_PlayerInduced,    // 2
    ePOIFORCELOOK_MAX               // 3
};

var const int POIPriority_ScriptedEvent;
var const int POIPriority_RevivableComrade;
var const int POIPriority_MoveOrder;
var const int POIPriority_TargetOrder;
var const int POIPriority_ComradeHuman;
var const int POIPriority_Comrade;
var const int POIPriority_Pickup;
var string DisplayName;
var bool DisplayLong;
var bool DisplayParseTags;
var repnotify bool bEnabled;
var bool bForceLookCheckLineOfSight;
var config bool bDoTraceForFOV;
var bool bDisableOtherPOIs;
var bool bLeavePlayerFacingPOI;
var bool bHidePlayerWeapon;
var protected bool bIsInitialized;
var config float IconDuration;
var EvilPointOfInterest.EPOIForceLookType ForceLookType;
var float ForceLookDuration;
var config int LookAtPriority;
var config float DesiredFOV;
var int FOVCount;
var config float EnableDuration;
var float CurrIconDuration;
var repnotify Actor AttachedToActor;
var SeqAct_ManagePOI POIAction;

replication
{
    // Pos:0x000
    if(bNetDirty)
        AttachedToActor, DesiredFOV, 
        DisplayName, FOVCount, 
        ForceLookDuration, ForceLookType, 
        IconDuration, LookAtPriority, 
        bDoTraceForFOV, bEnabled, 
        bForceLookCheckLineOfSight;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x2C
        case 'AttachedToActor':
            InitializePOI();
            // End:0x65
            break;
        // End:0x5F
        case 'bEnabled':
            // End:0x52
            if(bEnabled)
            {
                EnablePOI();                
            }
            else
            {
                DisablePOI();
            }
            // End:0x65
            break;
        // End:0xFFFF
        default:
            // End:0x65
            break;
            break;
    }
    //return;    
}

simulated event SetEnabled(bool bOn)
{
    local bool OldbEnabled;

    OldbEnabled = bEnabled;
    // End:0x31
    if(bOn)
    {
        bEnabled = true;        
    }
    else
    {
        bEnabled = false;
    }
    // End:0x62
    if(OldbEnabled != bEnabled)
    {
        bForceNetUpdate = true;
    }
    // End:0x7C
    if(bEnabled)
    {
        EnablePOI();        
    }
    else
    {
        DisablePOI();
    }
    //return;    
}

simulated function bool ShouldControllerHavePOI(EvilPlayerController EvilPCToTest)
{
    return true;
    //return ReturnValue;    
}

simulated function EnablePOI()
{
    local EvilPlayerController LPC;

    // End:0x3C
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x3C
        if(EnableDuration > float(0))
        {
            SetTimer(EnableDuration, false, 'DisablePOI');
        }
    }
    CurrIconDuration = IconDuration;
    // End:0xA5
    foreach LocalPlayerControllers(Class'EvilPlayerController', LPC)
    {
        // End:0xA4
        if(ShouldControllerHavePOI(LPC))
        {
            LPC.AddPointOfInterest(self);
        }        
    }    
    //return;    
}

simulated function DisablePOI()
{
    local EvilPlayerController LPC;

    // End:0x87
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x3F
        if(IsTimerActive('DisablePOI'))
        {
            ClearTimer('DisablePOI');
        }
        bEnabled = false;
        bForceNetUpdate = true;
        // End:0x87
        if(POIAction != none)
        {
            POIAction.bIsDone = true;
        }
    }
    // End:0xD0
    foreach LocalPlayerControllers(Class'EvilPlayerController', LPC)
    {
        LPC.RemovePointOfInterest(self, ForceLookType);        
    }    
    //return;    
}

protected simulated function AttachToActor(Actor Host)
{
    AttachedToActor = Host;
    bForceNetUpdate = true;
    // End:0xAA
    if(AttachedToActor != none)
    {
        // End:0xAA
        if((AttachedToActor.IsA('EvilDroppedPickup') || AttachedToActor.IsA('EvilPickupFactory')) || AttachedToActor.IsA('EvilPawn'))
        {
            SetBase(AttachedToActor);
        }
    }
    //return;    
}

simulated function int GetLookAtPriority(EvilPlayerController PC)
{
    // End:0x45
    if((PC != none) && AttachedToActor != none)
    {
        // End:0x45
        if(AttachedToActor.IsA('EvilPawn'))
        {
            return 0;
        }
    }
    return LookAtPriority;
    //return ReturnValue;    
}

simulated function InitializePOI()
{
    // End:0x11A
    if(!bIsInitialized)
    {
        // End:0xF7
        if(AttachedToActor != none)
        {
            // End:0xF7
            if(AttachedToActor.IsA('EvilPawn'))
            {
                // End:0xE4
                if(EvilPawn(AttachedToActor).PlayerReplicationInfo != none)
                {
                    CurrIconDuration = 0.0000000;
                    IconDuration = 0.0000000;
                    DisplayName = EvilPawn(AttachedToActor).PlayerReplicationInfo.PlayerName;
                    LookAtPriority = -1;                    
                }
                else
                {
                    SetTimer(0.5000000, false, 'InitializePOI');
                }
            }
        }
        // End:0x10E
        if(bEnabled)
        {
            EnablePOI();
        }
        bIsInitialized = true;
    }
    //return;    
}

simulated event PostBeginPlay()
{
    CurrIconDuration = IconDuration;
    // End:0x75
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x4C
        if(Base != none)
        {
            AttachedToActor = Base;            
        }
        else
        {
            AttachToActor(Owner);
        }
        bForceNetUpdate = true;
        InitializePOI();
    }
    //return;    
}

simulated function MessageInfo RetrievePOIMessage(string TagName)
{
    return EvilGame(WorldInfo.Game).LocalizedMessages.FindMessageInfo(TagName);
    //return ReturnValue;    
}

simulated function MessageInfo GetDisplayName()
{
    return RetrievePOIMessage(DisplayName);
    //return ReturnValue;    
}

simulated function Destroyed()
{
    DisablePOI();
    //return;    
}

final simulated function float GetDesiredFOV(Vector CameraLoc)
{
    // End:0x57
    if((FOVCount >= 0) && DesiredFOV >= float(0))
    {
        // End:0x57
        if(!bDoTraceForFOV || FastTrace(Location, CameraLoc))
        {
            return DesiredFOV;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

final simulated function Vector GetActualLookatLocation()
{
    local Vector FocusLocation;
    local editinline SkeletalMeshComponent ComponentIt;
    local Actor LookAtActor;
    local name LookAtBoneName;
    local EvilPawn WP;

    LookAtActor = self;
    // End:0x80
    if(AttachedToActor != none)
    {
        WP = EvilPawn(AttachedToActor);
        // End:0x80
        if(WP != none)
        {
            LookAtBoneName = WP.HeadBone;
            LookAtActor = WP;
        }
    }
    // End:0x106
    if(LookAtBoneName != 'None')
    {
        // End:0x102
        foreach LookAtActor.ComponentList(Class'Engine.SkeletalMeshComponent', ComponentIt)
        {
            FocusLocation = ComponentIt.GetBoneLocation(LookAtBoneName);
            // End:0x102
            break;            
        }                
    }
    else
    {
        FocusLocation = LookAtActor.Location;
    }
    return FocusLocation;
    //return ReturnValue;    
}

defaultproperties
{
    POIPriority_ScriptedEvent=1000
    POIPriority_RevivableComrade=750
    POIPriority_MoveOrder=650
    POIPriority_TargetOrder=700
    POIPriority_ComradeHuman=-1
    POIPriority_Comrade=-1
    POIPriority_Pickup=500
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    TickGroup=ETickingGroup.TG_DuringAsyncWork
    bStatic=false
    bAlwaysRelevant=true
    NetUpdateFrequency=1.0000000
}