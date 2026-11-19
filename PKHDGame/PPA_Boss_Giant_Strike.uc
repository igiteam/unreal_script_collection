class PPA_Boss_Giant_Strike extends PPA_Boss_Giant_Base_Action;

var Vector OldLocation;
var name LeftHandStrikeBone;
var name RightHandStrikeBone;

event PawnActionStarted(bool bForced, byte PrevAction)
{
    super(EvilPawnAction).PawnActionStarted(bForced, PrevAction);
    // End:0x89
    if(PkPawn_Boss_Giant_Base(PawnOwner).StrikeHandBoneName == LeftHandStrikeBone)
    {
        // End:0x73
        if(Rand(100) > 25)
        {
            AnimName = 'Attack4';            
        }
        else
        {
            AnimName = 'Attack3';
        }        
    }
    else
    {
        // End:0xAA
        if(Rand(100) > 25)
        {
            AnimName = 'Attack3';            
        }
        else
        {
            AnimName = 'Attack4';
        }
    }
    // End:0x108
    if(AnimName == 'Attack3')
    {
        PkPawn_Boss_Giant_Base(PawnOwner).StrikeHandBoneName = LeftHandStrikeBone;        
    }
    else
    {
        PkPawn_Boss_Giant_Base(PawnOwner).StrikeHandBoneName = RightHandStrikeBone;
    }
    OldLocation = PawnOwner.Mesh.GetBoneLocation(PkPawn_Boss_Giant_Base(PawnOwner).StrikeHandBoneName);
    PlayAnimation();
    //return;    
}

event Tick(float DeltaTime)
{
    PkPawn_Boss_Giant_Base(PawnOwner).StrikeDirection = PawnOwner.Mesh.GetBoneLocation(PkPawn_Boss_Giant_Base(PawnOwner).StrikeHandBoneName) - OldLocation;
    OldLocation = PawnOwner.Mesh.GetBoneLocation(PkPawn_Boss_Giant_Base(PawnOwner).StrikeHandBoneName);
    //return;    
}

event PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PkPawn_Boss_Giant_Base(PawnOwner).bHitAlready = false;
    //return;    
}

defaultproperties
{
    LeftHandStrikeBone="LeftHandMiddle2"
    RightHandStrikeBone="RightHandMiddle2"
    AnimName="Attack3"
}