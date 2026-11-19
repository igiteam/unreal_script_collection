class SPDAction extends Object
    abstract
    native
    editinlinenew
    collapsecategories;

struct native SPDProcesData
{
    var byte Padding[4];

    structdefaultproperties
    {
        Padding[0]=0
        Padding[1]=0
        Padding[2]=0
        Padding[3]=0
    }
};

/** VARIABLE DECLARATIONS */
var() const editconst string Action;
var() string DebugString;
/** True if this action can only execute on the servernative function SPDADebugBreak(int id, Actor a, string str); CPP TEXT    FUNCTIONS/STATES----------------------------------------------------------------------- Function: Description:----------------------------------------------------------------------- */
var() const bool bServerOnly;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Action="?"
}