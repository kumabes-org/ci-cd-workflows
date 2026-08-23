#!/bin/bash

echo "Create Role"
aws iam create-role \
    --role-name github-repo-1341183187 \
    --assume-role-policy-document file://data.json

echo "Attach Role Policy"
aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AdministratorAccess \
    --role-name github-repo-1341183187
