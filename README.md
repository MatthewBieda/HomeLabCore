Lab environment for this blogpost:
[https://matthewbieda.github.io/Blog/selfhostedVMs.html](https://matthewbieda.github.io/Blog/bootstrapKubernetesLinux.html)

The Terraform configuration has been extended to provision 3 virtual machines, 1 control plane and 2 worker nodes. The Ansible playbook prepares each machine with the prerequisites needed to initialize the cluster with kubeadm and join the worker nodes.
