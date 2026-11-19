class APA_Emerge_Treeter extends EPA_Emerge;

var float MaterialSpawnActive;
var bool bFadeOutMaterialSpawnActive;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    // End:0xE3
    if((PawnOwner.MyEvilAI != none) && PawnOwner.MyEvilAI.Enemy != none)
    {
        PawnOwner.MyEvilAI.ShotTarget = PawnOwner.MyEvilAI.Enemy;
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    // End:0xA2
    if(PawnOwner.MyEvilAI != none)
    {
        PawnOwner.MyEvilAI.ShotTarget = none;
        PawnOwner.SetParameterForAllMaterials('EmmisiveMultiply', 7.0000000);
    }
    //return;    
}

function DoEmerge(optional float _SightSenseLength = 1000.0000000, optional float _HearSenseLength = 1000.0000000, optional bool bEnableMotionDelta = false, optional bool bInEnableTakeDamage = false)
{
    // End:0x67
    if(int(PawnOwner.WakeInformation.RecoverID) == int(0))
    {
        bFadeOutMaterialSpawnActive = true;        
    }
    else
    {
        PawnOwner.SetParameterForAllMaterials('Active', MaterialSpawnActive);
        bFadeOutMaterialSpawnActive = false;
    }
    super.DoEmerge(_SightSenseLength, _HearSenseLength, bEnableMotionDelta, bInEnableTakeDamage);
    //return;    
}

function Tick(float DeltaTime)
{
    local float EmmisiveMult;

    // End:0x15D
    if((PawnOwner.MyEvilAI != none) && PawnOwner.MyEvilAI.ShotTarget != none)
    {
        EmmisiveMult = FMin(1.0000000, PawnOwner.MyEvilAI.EnemyDistance_Melee / PawnOwner.MyEvilAI.GetEnemyInfo(PawnOwner.MyEvilAI.ShotTarget).DistanceToEnemy);
        PawnOwner.SetParameterForAllMaterials('EmmisiveMultiply', (EmmisiveMult ** float(8)) * 7.0000000);
    }
    // End:0x1DA
    if(bFadeOutMaterialSpawnActive)
    {
        // End:0x1DA
        if(MaterialSpawnActive > 0.0000000)
        {
            MaterialSpawnActive = FMax(0.0000000, MaterialSpawnActive - (DeltaTime * 0.3000000));
            PawnOwner.SetParameterForAllMaterials('Active', MaterialSpawnActive);
        }
    }
    super(EvilPawnAction).Tick(DeltaTime);
    //return;    
}

defaultproperties
{
    MaterialSpawnActive=0.6000000
}