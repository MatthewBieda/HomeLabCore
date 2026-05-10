[master]
%{ for name, ip in vms ~}
%{ if name == "master" ~}
${name} ansible_host=${ip} ansible_user=${ansible_user} ansible_python_interpreter=/usr/bin/python3
%{ endif ~}
%{ endfor ~}

[workers]
%{ for name, ip in vms ~}
%{ if name != "master" ~}
${name} ansible_host=${ip} ansible_user=${ansible_user} ansible_python_interpreter=/usr/bin/python3
%{ endif ~}
%{ endfor ~}

[lab:children]
master
workers
