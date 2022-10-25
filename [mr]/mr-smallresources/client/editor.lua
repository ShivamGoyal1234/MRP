RegisterCommand("record", function(source , args)
    StartRecording(1)
    MRFW.Functions.Notify("Started Recording!", "success")
end)

RegisterCommand("clip", function(source , args)
    StartRecording(0)
end)

RegisterCommand("saveclip", function(source , args)
    StopRecordingAndSaveClip()
    MRFW.Functions.Notify("Saved Recording!", "success")
end)

RegisterCommand("delclip", function(source , args)
    StopRecordingAndDiscardClip()
    MRFW.Functions.Notify("Deleted Recording!", "error")
end)

RegisterCommand("editor", function(source , args)
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
    MRFW.Functions.Notify("Later aligator!", "error")
end)