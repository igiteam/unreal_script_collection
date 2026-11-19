class AdvTreasureTrigger_Base extends EvilUsableTriggerWithText
    abstract
    native
    hidecategories(Navigation);

var() export editinline LensFlareComponent FlareCmp;
var AdvDummyActor Flare;
var bool bFlareVisible;
var bool bCollected;
var() bool bShowOnCompassEvenWhenNotEnabled;
var() int InteractionRange;
var() string TreasureID;

simulated function HideTreasure()
{
    Enabled = false;
    bCollected = true;
    SetFlareEnabled(false);
    MeshComp.SetHidden(true);
    CaptionComponent.Hide();
    //return;    
}

simulated function PostBeginPlay()
{
    local AdvEngine Eng;

    super.PostBeginPlay();
    Flare = Spawn(Class'AdvDummyActor', self,, Location);
    Flare.SetBase(self);
    Flare.AttachComponent(FlareCmp);
    bFlareVisible = FlareCmp.bAutoActivate;
    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x10A
    if(Eng.IsTreasureCollected(TreasureID))
    {
        HideTreasure();
    }
    //return;    
}

static function AdvTypes.ETreasureType GetTreasureTypeFromID(string InTreasureID)
{
    local AdvTypes.ETreasureType TType;

    // End:0x2C
    if(InStr(InTreasureID, "LIF") != -1)
    {
        TType = 0;        
    }
    else
    {
        // End:0x58
        if(InStr(InTreasureID, "WAR") != -1)
        {
            TType = 2;            
        }
        else
        {
            TType = 1;
        }
    }
    return TType;
    //return ReturnValue;    
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
    return float(InteractionRange);
    //return ReturnValue;    
}

function TestTick()
{
    //return;    
}

function bool UsedBy(Pawn User)
{
    local AdvPlayerController PC;
    local AdvPRI PRI;
    local AdvEngine Eng;
    local bool bUsed;
    local AdvTypes.ETreasureType TreasureType;

    // End:0x2DB
    if(Enabled)
    {
        TreasureType = GetTreasureTypeFromID(TreasureID);
        PC = AdvPlayerController(User.Controller);
        // End:0x2B3
        if(PC != none)
        {
            PRI = AdvPRI(PC.PlayerReplicationInfo);
            PRI.AddTreasure(TreasureID, TreasureType);
            Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
            Eng.SetCollectedTreasure(TreasureID);
            AdvGFxHud(AdvGFxHudWrapper(PC.myHUD).HudMovie).ShowTreasureCollectedMessage(TreasureType);
            PC.TryUnlockTreasureAchievement();
            // End:0x2B3
            if(PC.GetPlayer().GetWeaponLeft().IsA('AdvInventoryItem_Compass') || PC.GetPlayer().GetWeaponLeft().IsA('AdvInventoryItem_Map'))
            {
                // End:0x28F
                if(PC.CanHideGameplayObject())
                {
                    PC.HideGameplayObject();                    
                }
                else
                {
                    PC.RetryHideGameplayObject(1.0000000);
                }
            }
        }
        bUsed = super.UsedBy(User);
        HideTreasure();
    }
    return bUsed;
    //return ReturnValue;    
}

simulated function SetFlareEnabled(bool bState)
{
    FlareCmp.SetIsActive(bState);
    bFlareVisible = bState;
    //return;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    super.CreateCheckpointRecord(Record);
    Record.CustomData = 0;
    Record.CustomData = Record.CustomData | (int(bCollected) << 0);
    Record.CustomData = Record.CustomData | (int(bFlareVisible) << 1);
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    super.ApplyCheckpointRecord(Record);
    bCollected = (Record.CustomData & (1 << 0)) != 0;
    bFlareVisible = (Record.CustomData & (1 << 1)) != 0;
    SetFlareEnabled(bFlareVisible);
    //return;    
}

simulated event ShutDown()
{
    MeshComp.SetHidden(true);
    super.ShutDown();
    //return;    
}

defaultproperties
{
    // Reference: LensFlareComponent'Default__AdvTreasureTrigger_Base.Flare0'
    begin object name=Flare0 class=Class'Engine.LensFlareComponent'
        NextTraceTime=-0.6699728
        ReplacementPrimitive=none
    end object
    FlareCmp=Flare0
    bShowOnCompassEvenWhenNotEnabled=true
    InteractionRange=256
    // Reference: EvilCaptionComponent'Default__AdvTreasureTrigger_Base.CaptionComp'
    begin object name=CaptionComp
        LocString="TreasurePick"
        LocAltString="Treasure"
    end object
    CaptionComponent=CaptionComp
    // Reference: StaticMeshComponent'Default__AdvTreasureTrigger_Base.PickupMeshComp'
    begin object name=PickupMeshComp
        ReplacementPrimitive=none
        bCastStaticShadow=false
    end object
    MeshComp=PickupMeshComp
    // Reference: CylinderComponent'Default__AdvTreasureTrigger_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__AdvTreasureTrigger_Base.Sprite'
    begin object name=Sprite
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=PickupMeshComp
    Components[3]=CaptionComp
    CollisionComponent=CollisionCylinder
}