#!/bin/bash

while getopts e: opt; do
  case $opt in
    e)
      ECS_ENV=$OPTARG
      ;;
  esac
done

if [ "x${ECS_ENV}" != "x" ]; then
  PREFIX="${ECS_ENV}-"
fi

AWS_REGION="--region us-east-1"
SERVICE_NAME="${PREFIX}fork-be"
TASK_FAMILY="${PREFIX}fork-be-taskdef"
ECS_CLUSTER="${PREFIX}fork-be"
SCRIPT_DIR=$(dirname $0)

# Create a new task definition for this build
aws ecs register-task-definition ${AWS_REGION} --family ${TASK_FAMILY} --cli-input-json file://${SCRIPT_DIR}/${PREFIX}taskdef.json

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition ${AWS_REGION} --task-definition ${TASK_FAMILY} | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services ${AWS_REGION} --cluster ${ECS_CLUSTER} --services ${SERVICE_NAME} | egrep "desiredCount" | head -1 | tr "/" " " | awk '{print $2}' | sed 's/,$//'`

aws ecs update-service ${AWS_REGION} --cluster ${ECS_CLUSTER} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}
