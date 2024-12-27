# Minimal Stack is ran using the full Hashicorp Suite of products for orchestration, automation, secret management and more.
The first steps in developing this project was considering what problem I am attempting to solve. Presently, the openstack horizon user interface is difficult for new students to use. It provides a lot of options, and many of them are not necessary to the basic end user. Many students want to host a minecraft server, a personal website, or other basic projects that do not require layers of security groups and rules, routing, server groups, and more. To address this, a new orchestration platform is required- it would be best to personally develop one with only the basic features, but Hashicorp Nomad provides all of the beginner objects a user might want without being overwhelming.


## Service Chart
```mermaid
flowchart TD
    subgraph s0["Authentication / RBAC"]
    subgraph s1["Consul"]
    direction LR
        %% Consul HA starts with odd number, with a leader and
        %% corresponding followers.
        c1["Consul Follower"]
        c2["Consul Leader"]
        c3["Consul Follower"]
        
        c1 --> c2
        c3 --> c2
    end
    style s1 fill:#666666

    subgraph s2["Vault"]
    direction LR
        %% Vault HA also has 3 instances or 5 or ...
        v1["Vault Instance"]
        v2["Vault Instance"]
        v3["Vault Instance"]

        v1 --- v2 --- v3
    end
    style s2 fill:#666666

    subgraph s4["Boundary Workers"]
        %% Boundary workers are scaled as needed
        bw1["Scaled Boundary Worker 1"]
        bw2["Scaled Boundary Worker 2"]
    end
    style s4 fill:#666666

     %% Standalone datagrams
    b1["Primary Boundary Controller"]
    b2["Backup Boundary Controller"]
    auth["Authentik Endpoint"]
    end

    subgraph s5["Nomad Servers"]
    direction LR
        ns1["Nomad Server Leader"]
        ns2["Nomad Server Follower"]
        ns3["Nomad Server Follower"]
        ns2 --> ns1
        ns3 --> ns1
    end
    subgraph s6["Nomad Clients"]
    direction LR
        nc1["Nomad Client"] ---
        nc2["Nomad Client"] ---
        nc3["Nomad Client"] ---
        nc4["Nomad Client"] ---
        nc5["Nomad Client"] ---
        nc6["Nomad Client"] ---
        nc7["Nomad Client"]
    end

   
    eu["Users Accessing Minimal Stack"]

    s2-->s1
    s1-->s2
    s2-->s5
    b1-->s2
    s1-->s6
    b2---b1
    auth-->s2
    eu-->s4
    s4-->b1
    s1-->s5
    s5-->s6
    b1-->s5
    s2-->s6
    b1-->auth
    s1-->b1
```

## How access is managed
Hashicorp Boundary, Vault, and Consul work together to provide secure, consistent, and ephemeral access to users. 

## How orchestration is handled
Hashicorp Terraform is used to provision servers on Openstack, Redhat Ansible is used to configure services. I have not yet addressed how to scale based on usage, as this will never require that, but I will work on adding it for the sake of demonstration. 
