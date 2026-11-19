class SeqAct_AIFactoryObserver extends SeqAct_Latent
    abstract
    forcescriptorder(true)
    hidecategories(Object)
    implements(AIFactoryObserverInterface);

var int CountedCorpses;
var int ActiveSpawns;
var class<SeqAct_AIFactory> ObservableFactoryClass;

event Activated()
{
    local array<SequenceObject> AIFactories;
    local SequenceObject AIFactory;
    local Sequence GameSeq;

    GameSeq = GetWorldInfo().GetGameSequence();
    // End:0xB6
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(ObservableFactoryClass, true, AIFactories);
        // End:0xB5
        foreach AIFactories(AIFactory)
        {
            SeqAct_AIFactory(AIFactory).AddObserver(AIFactoryObserverInterface(self));            
        }        
    }
    CountedCorpses = 0;
    //return;    
}

function NotifySpawnActived(SeqAct_AIFactory AIFactory)
{
    ActiveSpawns++;
    //return;    
}

function NotifySpawnDeactivated(SeqAct_AIFactory AIFactory)
{
    ActiveSpawns--;
    //return;    
}

function NotifyPawnDied(SeqAct_AIFactory AIFactory, EvilPawn inPawn)
{
    CountedCorpses++;
    //return;    
}
