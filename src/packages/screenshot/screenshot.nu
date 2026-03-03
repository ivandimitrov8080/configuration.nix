let ss_dir = $"(xdg-user-dir PICTURES)/ss"
let pic_dir = $"($ss_dir)/(date now | format date "%+").png"
mkdir $"($ss_dir)"
def "main area" [] { grimshot savecopy area $"($pic_dir)" }
def "main screen" [] { grimshot savecopy screen $"($pic_dir)" }
def "main window" [] { grimshot savecopy active $"($pic_dir)" }
def main [] { $"Usage: todo..." }
