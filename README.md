# ansible_pkg_mgr_config

Often we may want to specify a particular package manager in our ansible .yml files. This comes in handy since different distributions have different package managers.

To get a catalogue of the information ansible retrieves from your vms, run ```ansible 10.142.0.12 -m setup```. From here you can find the ```ansible_pkg_mgr```, this will be your vms package manager. How to implement ```ansible_pkg_mgr``` is self-explanatory when looking at the script.


*NOTE*:
One thing to keep in mind, is that ansible requires python to be installed in /usr/bin, but ubuntu has python3 installed instead. This is a problem.

To work around this, we edit the known hosts file on our master machine as such:

```bash
[ubuntu_hosts]
10.142.0.12
[ubuntu_hosts:vars]
ansible_python_interpreter=/usr/bin/python3
```
