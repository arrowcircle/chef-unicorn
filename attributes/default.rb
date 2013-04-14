default["unicorn"]["timeout"] = 60
default["unicorn"]["worker_processes"] = [node["cpu"]["total"].to_i * 2, 8].min