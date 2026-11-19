class AdvTargetTrigger extends Trigger
    hidecategories(Navigation)
    classgroup(Adventurer);

var bool bIsActive;
var() bool bEnabled;
var() AdvTypes.ETreasureType TreasureType;

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x46
    if(Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x98
        if(Action.InputLinks[2].bHasImpulse)
        {
            bEnabled = !bEnabled;            
        }
        else
        {
            bEnabled = false;
        }
    }
    //return;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    super.CreateCheckpointRecord(Record);
    Record.bEnabled = bEnabled;
    Record.bVisible = bIsActive;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    super.ApplyCheckpointRecord(Record);
    bEnabled = Record.bEnabled;
    bIsActive = Record.bVisible;
    ForceNetRelevant();
    //return;    
}

defaultproperties
{
    bEnabled=true
    // Reference: CylinderComponent'Default__AdvTargetTrigger.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}