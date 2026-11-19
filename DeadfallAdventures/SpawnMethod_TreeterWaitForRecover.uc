class SpawnMethod_TreeterWaitForRecover extends SpawnMethod_WaitForRecover
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() ADVTreeterSpawner_Base TreeterSpawner;

function PostCreateActor(Actor NewActor)
{
    local AdvPawn_Treeter_Base treeter;

    treeter = AdvPawn_Treeter_Base(NewActor);
    // End:0x53
    if(treeter != none)
    {
        treeter.TreeterSpawner = TreeterSpawner;
    }
    super.PostCreateActor(NewActor);
    //return;    
}
