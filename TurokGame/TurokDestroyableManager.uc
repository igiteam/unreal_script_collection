class TurokDestroyableManager extends Object
    native
    config(Engine);

var protected config int mMaxNumVisibleComponents;
var protected int mCurNumVisibleComponents;
var protected array mActors;

// Export UTurokDestroyableManager::execCanDestroy(FFrame&, void* const)
native function bool CanDestroy(int numNewComponents);

function int GetMaxNumVisibleComponents()
{
    return mMaxNumVisibleComponents;
    //return ReturnValue;    
}

function int GetCurNumVisibleComponents()
{
    return mCurNumVisibleComponents;
    //return ReturnValue;    
}
