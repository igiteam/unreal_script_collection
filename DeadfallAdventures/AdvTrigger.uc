class AdvTrigger extends Trigger
    hidecategories(Navigation)
    classgroup(Adventurer);

var() protected const export editinline StaticMeshComponent TriggerMesh;
var() protected const editconst export editinline DynamicLightEnvironmentComponent LightEnvironment;
var() protected repnotify bool bEnabled;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        bEnabled;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2E
    if(VarName == 'bEnabled')
    {
        SetEnabled(bEnabled);        
    }
    else
    {
        super(Actor).ReplicatedEvent(VarName);
    }
    //return;    
}

function SetEnabled(bool Enable)
{
    bEnabled = Enable;
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x11D
    if(!bStatic)
    {
        // End:0x55
        if(Action.InputLinks[0].bHasImpulse)
        {
            bEnabled = true;            
        }
        else
        {
            // End:0x9B
            if(Action.InputLinks[1].bHasImpulse)
            {
                bEnabled = false;                
            }
            else
            {
                // End:0xEA
                if(Action.InputLinks[2].bHasImpulse)
                {
                    bEnabled = !bEnabled;
                }
            }
        }
        ForceNetRelevant();
        SetForcedInitialReplicatedProperty(BoolProperty'AdvTrigger.bEnabled', bEnabled == default.bEnabled);
    }
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvTrigger.Mesh'
    begin object name=Mesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=none
        ReplacementPrimitive=none
        Translation=(X=0.0000000,Y=0.0000000,Z=-15.0000000)
        Scale3D=(X=0.6000000,Y=0.6000000,Z=0.4000000)
    end object
    TriggerMesh=Mesh
    // Reference: DynamicLightEnvironmentComponent'Default__AdvTrigger.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    bEnabled=true
    // Reference: CylinderComponent'Default__AdvTrigger.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=25.0000000
        CollisionRadius=30.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
    Components[3]=Mesh
    CollisionComponent=Mesh
}