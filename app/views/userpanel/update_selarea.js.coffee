$("#select_area").empty()
.append("<%= escape_javascript(render(partial: 'update_selarea', locals:{itma: @areacol} )) %>")