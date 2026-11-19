interface EvilNavPointInterface extends Interface
    abstract;

function EvilTypesNative.EMoveMode GetMoveMode()
{
    return 6;
    //return ReturnValue;    
}

function EvilTypes.ENavPointMoveToGoalMode GetMoveToGoalMode()
{
    return 0;
    //return ReturnValue;    
}

function array<EvilNavPointAction> GetNavPointActions()
{
    //return ReturnValue;    
}
