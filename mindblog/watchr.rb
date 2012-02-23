
def run_shell(cmd)
	IO.popen(cmd){ |io| while (line = io.gets) do puts line end }
end


watch("(src|css)/.*"){
  run_shell("make dev")
}
