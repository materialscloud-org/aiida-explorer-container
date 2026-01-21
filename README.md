> [!WARNING]
> This repository is **deprecated** and no longer maintained.
>
> Please see **https://github.com/aiidateam/aiida-explorer** instead.


# aiida-explorer

Stand-alone docker container for AiiDA EXPLORE section

## Build

Currently requires `deploy-standalone` deploy key of frontend-explore repository
(this is no longer necessary once it becomes open source).

```
# place deploy-standalone in keys/ folder

# Set AIIDA_REST_API (defaults to value shown below)
export AIIDA_REST_API=http://127.0.0.1:5000/api/v2

./build.sh
```

Note: The REST API currently needs to be set when building the image.
In order to enable setting the REST API when running the container,
one should add a script that is run on startup (like apache)
and replaces the corresponding value in the Gruntfile with the 
environment variable.

## Usage

```
# Run docker container
./run-docker.sh 
# Open EXPLORE section on http://localhost:5001/explore
```

Note: Currently, it is the /sssp section that is overwritten with
the environment variable.
To improve in the future 
(rename sssp to something else + change description).
