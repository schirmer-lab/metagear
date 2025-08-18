---
layout: default
title: Installation
parent: Quick start
nav_order: 1
permalink: /quick-start/installation/
---

# Installation

To install the MetaGEAR Pipeline Wrapper, simply run:

```bash
curl -L http://get-metagear.schirmerlab.de | bash
```

The installer sets resource limits to roughly 80% of your available CPUs and RAM (capped at 48 CPUs and 80 GB). Review `~/.metagear/metagear.config` and `~/.metagear/metagear.env` before running any workflow.


## Post-installation steps

### Choose a Runner
The default runner is Docker. However, we highly encourage Singularity or Apptainer to be used. Please decide what runner you want to use and set the default value in `~/.metagear/metagear.config`. For example:

```
#!/usr/bin/env bash

export NXF_SINGULARITY_CACHEDIR=/where/do/you/want/the/images/downloaded

# Please use this for singularity (or docker,docker_custom for Docker)
RUN_PROFILES="-profile singularity,singularity_custom"
NF_WORK="./nf_work"
```

### Add filesystems and non-standard mount points
By default, filesystems like `/nfs`, `/lustre`, or other non-standard mount points are usually not mounted automatically. Please make sure you include them in `~/.metagear/metagear.config` before running any workflow. For example:

```
/* --------------------------------------------------------------*/
/* --- PLEASE UPDATE THESE PARAMETERS BEFORE RUNNING METAGEAR ---*/
/* --------------------------------------------------------------*/

profiles {
    singularity_custom {
        singularity.runOptions = "--writable-tmpfs -B /nfs/mydata:/nfs/mydata -B /:/"

        process {
            maxForks = 5
        }
    }
    docker_custom {
        docker.runOptions = '-u $(id -u):$(id -g) -v /nfs/mydata:/nfs/mydata'
    }
}
```

For better resource control, a `maxForks` parameter can be adjusted for all processes. This will determine the number of parallel processes that can be executed at a given time. Keep in mind that each process can request a certain number of CPUs and RAM, this is important to consider when dealing with oversubscription or memory problems.


[← Back to Quick start Overview]({{ site.baseurl }}/){: .btn .btn-outline }