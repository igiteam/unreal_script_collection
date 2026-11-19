class PPA_Boss_Giant_Spawn extends PPA_Boss_Giant_Base_Action;

var bool bHitAlready;

event PawnActionStarted(bool bForced, byte PrevAction)
{
    super(EvilPawnAction).PawnActionStarted(bForced, PrevAction);
    // End:0x3E
    if(Rand(100) > 50)
    {
        AnimName = 'Attack1';        
    }
    else
    {
        AnimName = 'Attack2';
    }
    PlayAnimation();
    //return;    
}

function Tick(float DeltaTime)
{
    // End:0x165
    if(!bHitAlready && VSize2D(PawnOwner.MyEvilAI.Enemy.Location - PawnOwner.Mesh.GetBoneLocation('RightHand')) < float(300))
    {
        bHitAlready = true;
        PawnOwner.MyEvilAI.Enemy.TakeDamage(50, none, PawnOwner.Mesh.GetBoneLocation('RightHand'), vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee',, PawnOwner);
    }
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    super(EvilPawnAction).OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    bHitAlready = false;
    //return;    
}

defaultproperties
{
    AnimName="Attack1"
}