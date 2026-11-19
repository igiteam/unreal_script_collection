class NavigationOIRImpl extends KynapseCoverNode;

function bool IsDifferentOIR(Object ActiveOIR, bool bAnimsChanged)
{
    local bool bRet;
    local Object prevOIR;

    // End:0x4C
    if(bAnimsChanged)
    {
        prevOIR = OirInstance(ActiveOIR).GetObjFromInterface(OirInstance(ActiveOIR).OIRParent);
        // End:0x4C
        if(KynapseCoverNode(prevOIR) == none)
        {
            return true;
        }
    }
    bRet = NativeIsDifferentOIR(LocationRotationObject(ActiveOIR).Location);
    return bRet;
    //return ReturnValue;    
}

function bool IsDifferentReference(OIROwnerInterface prevOIR)
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    OIRAnimSet=AnimSet'Anim_AI_NavigationOIRAnimSet.AnimSet.FixedFireAnimSet'
    OIRAnimTree=AnimTree'Anim_AI_NavigationOIR.AnimTrees.NavigationTree'
}