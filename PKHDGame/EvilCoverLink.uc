class EvilCoverLink extends CoverLink
    config(Game)
    hidecategories(Navigation,Lighting,LightColor,Force)
    implements(EvilNavPointInterface);

var() EvilCoverLink NextBetterCoverLink;
var array<ECoverAIDebugInfo> CoverAIDebugInfoArray;
var() EvilTypesNative.EMoveMode MoveMode;

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    super.CreateCheckpointRecord(Record);
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    super.ApplyCheckpointRecord(Record);
    //return;    
}

function EvilTypes.ENavPointMoveToGoalMode GetMoveToGoalMode()
{
    return 1;
    //return ReturnValue;    
}

function array<EvilNavPointAction> GetNavPointActions()
{
    //return ReturnValue;    
}

function EvilTypesNative.EMoveMode GetMoveMode()
{
    return MoveMode;
    //return ReturnValue;    
}

function string GetAIDebugString(int SlotIdx, EvilAIController Controller)
{
    local string DebugString;
    local ECoverAIDebugInfo CoverAIDebugInfo;

    // End:0x26
    if(!IsEnabled())
    {
        DebugString = "Disabled";        
    }
    else
    {
        // End:0x17A
        foreach CoverAIDebugInfoArray(CoverAIDebugInfo)
        {
            // End:0x179
            if(CoverAIDebugInfo.Controller == Controller)
            {
                // End:0x179
                if((CoverAIDebugInfo.SlotRating[SlotIdx] > 0.0000000) || CoverAIDebugInfo.SlotVerboseDebug[SlotIdx] != "")
                {
                    // End:0x13E
                    if(CoverAIDebugInfo.SlotRating[SlotIdx] > 0.0000000)
                    {
                        DebugString = (DebugString @ "Rating:") @ string(CoverAIDebugInfo.SlotRating[SlotIdx]);
                    }
                    DebugString = DebugString @ CoverAIDebugInfo.SlotVerboseDebug[SlotIdx];
                }
            }            
        }        
    }
    return (((string(Name) @ "Slot:") @ string(SlotIdx)) @ "\n") @ DebugString;
    //return ReturnValue;    
}

function SetAIDebug(EvilAIController Controller, int SlotIdx, float Rating, optional string VerboseDebug)
{
    local ECoverAIDebugInfo CoverAIDebugInfo;
    local int I, Index;

    // End:0x12
    if(Controller == none)
    {
        return;
    }
    Index = -1;
    // End:0x7E
    foreach CoverAIDebugInfoArray(CoverAIDebugInfo, I)
    {
        // End:0x7D
        if(CoverAIDebugInfo.Controller == Controller)
        {
            Index = I;
        }        
    }    
    // End:0xE1
    if(Index < 0)
    {
        CoverAIDebugInfoArray.Add(1);
        Index = CoverAIDebugInfoArray.Length - 1;
        CoverAIDebugInfoArray[Index].Controller = Controller;
    }
    CoverAIDebugInfoArray[Index].SlotRating[SlotIdx] = Rating;
    CoverAIDebugInfoArray[Index].SlotVerboseDebug[SlotIdx] = VerboseDebug;
    //return;    
}

defaultproperties
{
    MoveMode=EMoveMode.None
    bClaimAllSlots=true
    MidHeight=75.0000000
    StandingLeanOffset=(X=0.0000000,Y=50.0000000,Z=60.0000000)
    CrouchLeanOffset=(X=0.0000000,Y=70.0000000,Z=-10.0000000)
    PopupOffset=(X=0.0000000,Y=0.0000000,Z=40.0000000)
    SlipDist=50.0000000
    // Reference: CylinderComponent'Default__EvilCoverLink.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Engine.Default__CoverLink.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=CollisionCylinder
    Components[3]=none
    CollisionComponent=CollisionCylinder
}