class SPDAction_SetMaterial extends SPDAction
    native
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(SPDAction) export array<export MaterialInterface> Materials;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local int Idx;
    local editinline StaticMeshComponent StaticMesh;
    local editinline SkeletalMeshComponent SkeletalMesh;

    // End:0x2F
    if(DamageInfo.Component == none)
    {
        StaticMesh = Actor.GetStaticMeshComponent();        
    }
    else
    {
        StaticMesh = StaticMeshComponent(DamageInfo.Component);
    }
    // End:0xCF
    if(StaticMesh != none)
    {
        Idx = 0;
        J0x5C:

        // End:0xCC [Loop If]
        if(Idx < Materials.Length)
        {
            // End:0xC2
            if((StaticMesh.GetMaterial(Idx) != none) && Materials[Idx] != none)
            {
                StaticMesh.SetMaterial(Idx, Materials[Idx]);
            }
            Idx++;
            // [Loop Continue]
            goto J0x5C;
        }        
    }
    else
    {
        // End:0xFE
        if(DamageInfo.Component == none)
        {
            SkeletalMesh = Actor.GetSkeletalMeshComponent();            
        }
        else
        {
            SkeletalMesh = SkeletalMeshComponent(DamageInfo.Component);
        }
        // End:0x19B
        if(SkeletalMesh != none)
        {
            Idx = 0;
            J0x12B:

            // End:0x19B [Loop If]
            if(Idx < Materials.Length)
            {
                // End:0x191
                if((SkeletalMesh.GetMaterial(Idx) != none) && Materials[Idx] != none)
                {
                    SkeletalMesh.SetMaterial(Idx, Materials[Idx]);
                }
                Idx++;
                // [Loop Continue]
                goto J0x12B;
            }
        }
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Action="Action Set Material - Sets the new material to be used by static or skeletal mesh"
}