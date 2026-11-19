class MOHAAnimPlayByPawnClass extends MOHAAnimPlayByBase
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

event int GetChildIndexToPlay()
{
    local int Index;
    local editinline MOHASkeletalMeshComponent Mesh;
    local Actor Owner;

    Index = 0;
    Mesh = MOHASkeletalMeshComponent(SkelComponent);
    // End:0x83
    if(Mesh != none)
    {
        Owner = Mesh.Owner;
        // End:0x51
        if(MOHAMultiplayerPawn(Owner) != none)
        {
            Index = 3;            
        }
        else
        {
            // End:0x6C
            if(MOHAPlayerPawn(Owner) != none)
            {
                Index = 2;                
            }
            else
            {
                // End:0x83
                if(MOHAAIPawn(Owner) != none)
                {
                    Index = 1;
                }
            }
        }
    }
    return Index;
    //return ReturnValue;    
}

defaultproperties
{
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}