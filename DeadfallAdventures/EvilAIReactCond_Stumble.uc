class EvilAIReactCond_Stumble extends EvilAIReactCond_RandomCallDelegate within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0xD7
    if(((!super.ShouldActivate(InInstigator, OriginatingChannel) || Outer.MyEvilPawn.AST_GetAnimCount(68) < 1) || !Outer.MyEvilPawn.bShouldBeginStumble) || !Outer.MyEvilPawn.IsRunning())
    {
        return false;
    }
    Outer.MyEvilPawn.RunFailAnimIndex = Outer.MyEvilPawn.AST_GetRandomAnimIndex(68);
    // End:0x242
    if(Outer.InLatentExecution(503) && Outer.MoveTimer > Outer.MyEvilPawn.Mesh.GetAnimLength(Outer.MyEvilPawn.AST_GetAnimName(68, Outer.MyEvilPawn.RunFailAnimIndex)))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}
