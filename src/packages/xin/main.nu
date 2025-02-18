def "main reboot" [] {
    let v = (ls /nix/var/nix/profiles/system-profiles/
    | filter { |x| not ($x.name | str contains "link") }
    | each { |x| { cmd: $"($x.name)/bin/switch-to-configuration boot", name: ($x.name | split row '/' | last) } })

    let selection = ($v | each {|x| $x.name } | str join "\n" | fzf)

    let cmd = ($v | filter {|x| $x.name == $selection } | first | get cmd)

    bash -c $"sudo ($cmd)"
    reboot
}

def main [] {
    $"Usage: todo..."
}
