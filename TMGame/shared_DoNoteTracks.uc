class shared_DoNoteTracks extends CoreTask within animscripts_shared;

// parameter
var name iFlagName;
var DelegateHandleNoteTracks iCustomFunction;

// output

// local
var name note;

function OnNotify(name inNote, CoreNotify inData)
{
	local CoreAnimNotify data;

	assert (iFlagName == inNote);

	data = CoreAnimNotify(inData);
	if (data != none)
		note = data.data;
	else
		note = '';
}

state main
{
Begin:
	while (true)
	{
		waittill(iFlagName);

		if (note == '')
			note = 'undefined';

		if (HandleNoteTrack(note, iFlagName, iCustomFunction))
			break;
	}

End:
}
