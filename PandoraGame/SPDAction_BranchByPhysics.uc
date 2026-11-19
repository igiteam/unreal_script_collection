class SPDAction_BranchByPhysics extends SPDAction
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(SPDAction) export editinline SPDGenericActionList BranchedActionLists;
var(SPDAction) Actor.EPhysics PhysicsType;
var(SPDAction) bool bBranchIfNotPhysType;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local bool bPhysMatch;

    // End:0xD5
    if(Actor != none)
    {
        // End:0x50
        if((int(PhysicsType) == int(4)) && SPPawn(Actor) != none)
        {
            bPhysMatch = SPPawn(Actor).IsPhysFlying();            
        }
        else
        {
            bPhysMatch = int(Actor.Physics) == int(PhysicsType);
        }
        // End:0xD5
        if((bPhysMatch && bBranchIfNotPhysType == false) || !bPhysMatch && bBranchIfNotPhysType == true)
        {
            // End:0xD2
            if(BranchedActionLists != none)
            {
                Manager.AddActionListWithDamageInfo(BranchedActionLists, Actor, DamageInfo);
            }
            return 2;
        }
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Action="Can randomly either just carry on to next action, or switch to one the embedded actions lists"
}