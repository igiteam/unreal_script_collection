class ActionStartConversation extends Scripting.Action;

var() Name Conversation;

latent function Variable execute()
{
    SwatRepo(parentScript.Level.GetRepo()).GetConversationManager().StartConversation(Conversation);

    return None;
}

// editorDisplayString
function editorDisplayString(out string s)
{
    s = "Start the Conversation named "$Conversation;
}








// Decompiled with UE Explorer.
defaultproperties
{
    actionDisplayName="Start a Conversation"
    actionHelp="Starts a Conversation"
    category="Script"
}