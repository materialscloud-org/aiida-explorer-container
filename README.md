# aiida-explorer

Stand-alone docker container for AiiDA EXPLORE section

## Build

Currently requires `deploy-standalone` deploy key of frontend-explore repository
(this is no longer necessary once it becomes open source).

```
# place deploy-standalone in keys/ folder
./build.sh
```

## Usage

```
# Set AIIDA_REST_URL (defaults to value shown below)
export AIIDA_REST_URL=http://127.0.0.1:5000/api/v2

# Run docker container
./run-docker.sh 
# Open EXPLORE section on http://localhost:5001/explore
```
