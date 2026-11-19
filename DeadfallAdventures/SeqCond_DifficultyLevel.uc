class SeqCond_DifficultyLevel extends SequenceCondition
    forcescriptorder(true)
    hidecategories(Object);

var() bool bGetCombatDifficultylevel;

event Activated()
{
    local byte DifficultyLevel;

    // End:0x6F
    if(!bGetCombatDifficultylevel)
    {
        DifficultyLevel = ADVGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetDifficultyIdx();        
    }
    else
    {
        DifficultyLevel = ADVGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetDifficultyOtherIdx();
    }
    switch(DifficultyLevel)
    {
        // End:0x108
        case 0:
            OutputLinks[0].bHasImpulse = true;
            // End:0x15E
            break;
        // End:0x131
        case 1:
            OutputLinks[1].bHasImpulse = true;
            // End:0x15E
            break;
        // End:0x15B
        case 2:
            OutputLinks[2].bHasImpulse = true;
            // End:0x15E
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Easy",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Normal",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Hard",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    ObjName="Difficulty Level"
}