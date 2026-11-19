class DialogueManager extends Actor
    notplaceable
    hidecategories(lighting);

function bool TriggerDialogueEvent(class<SequenceEvent> InEventClass, Actor InInstigator, Actor InOriginator)
{
    return;
}

defaultproperties
{
    TickGroup=1
}