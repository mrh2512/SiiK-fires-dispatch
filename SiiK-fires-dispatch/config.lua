Config = {}

-- Jobs that can receive pager alerts
Config.AllowedJobs = {
    'firefighter' -- Only firefighters
}

-- Pager UI settings
Config.Pager = {
    OpenKey = 'E',
    CloseOnAccept = true,
    CloseOnDecline = true,
    SoundOnDispatch = true,
    SoundName = "Event_Start_Text",
    SoundSet = "GTAO_FM_Events_Soundset"
}

-- Keybinds for pager
Config.PagerKeys = {
    Accept = "KeyE",
    Decline = "KeyR"
}

-- Blip settings for calls
Config.Blip = {
    Sprite = 436,
    Color = 1,
    Scale = 1.0,
    Time = 120,
    ShowRouteOnAccept = true
}

-- General settings
Config.General = {
    EnableLogging = false,
    AcceptNotify = true,
    DeclineNotify = true
}
