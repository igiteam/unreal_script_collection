class SeqAct_AddSurvivalIcon extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum ESurvivalIconKismet
{
    ESIK_Ammo,                      // 0
    ESIK_Bank,                      // 1
    ESIK_MAX                        // 2
};

var Actor Target;
var() SeqAct_AddSurvivalIcon.ESurvivalIconKismet IconType;

event Activated()
{
    local AdvPlayerController PC;

    // End:0xD7
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        switch(IconType)
        {
            // End:0x98
            case 0:
                PC.AddObjectiveIcon(Target, "ammo_surv");
                // End:0xD6
                break;
            // End:0xD3
            case 1:
                PC.AddObjectiveIcon(Target, "bank_surv");
                // End:0xD6
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }    
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Add Survival Icon"
}