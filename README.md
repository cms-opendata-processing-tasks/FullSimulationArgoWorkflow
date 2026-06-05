# Full Simulation Workflow with Argo

First initialize Kubernetes and Argo use by following [this tutorial](https://cms-opendata-workshop.github.io/tutorial-lesson-cloud-processing-infomaniak/episodes/01-introduction/)

After that:

1. Upload your dataset fragment to the cloud's object storage
```
openstack object create your_storage_name fragments.py --name FullSim/your_dataset_name/fragments.py
```

2. Clone this repository
```
git clone git@github.com:cms-opendata-processing-tasks/FullSimulationArgoWorkflow.git
cd FullSimulationArgoWorkflow
```

3. Change the parameters according to your needs

Open the `cms-simulation-process/run-simulation-s3.yaml` with your preferred editor

In
```
spec:
  entrypoint: cms-full-sim
  serviceAccountName: argo-service-account

  arguments:
    parameters:
      - name: bucket
        value: your_storage
      - name: dataName
        value: "parallel-testing"
      - name: fragFileName
        value: "fragments.py"
      - name: totEvents
        value: 10
      - name: nJobs
        value: 3
```
check that these parameters have correct values that are set according to you situation

5. Submit the workflow to the cluster
```
argo submit cms-simulation-process/run-simulation-s3.yaml -n argo
```

6. Follow the workflow progress with
```
argo get @latest -n argo
```

7. For debugging you can use e.g. these commands
```
kubectl logs simulation-process-unique-name-of-your-pod -n argo
kubectl describe pod/simulation-process-unique-name-of-your-pod -n argo
```
The unique name of your pod can be seen in the output of `argo get @latest -n argo`

8. Once the workflow is done
You can find the output files in your object storage in the path `your_storage/FullSim/your_dataset_name/NANO`

List the output files
```
swift list your_storage --prefix FullSim/your_dataset_name/NANO
```

Download output files locally if needed
```
swift download mirastorage --prefix FullSim/your_dataset_name/NANO --output-dir results
```
