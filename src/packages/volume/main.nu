def "main sink toggle" [] {
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
}

def "main sink up" [] {
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+
}

def "main sink down" [] {
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-
}

def "main source toggle" [] {
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
}

def "main source up" [] {
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05+
}

def "main source down" [] {
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05-
}

def main [] {}
