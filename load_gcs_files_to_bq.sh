#!/bin/bash

# This file aims to creat tables in bigquery and load data from gcs csv files

PROJECT_ID="****sandbox"
DATASET_ID="hackathon"
GCS_BUCKET="technical_test"

# Fetch a list of CSV files in the GCS bucket
CSV_FILES=$(gsutil ls gs://${GCS_BUCKET}/*.csv)

for FILE_PATH in ${CSV_FILES}; do
    TABLE_NAME=$(basename -- "${FILE_PATH}" .csv)

    # Create the table using bq load with autodetect
    bq load \
        --autodetect \
        --skip_leading_rows 1 \
        --source_format CSV \
        ${PROJECT_ID}:${DATASET_ID}.${TABLE_NAME} \
        ${FILE_PATH}
    # echo "Table ${PROJECT_ID}:${DATASET_ID}.${TABLE_NAME} created."
    echo ${FILE_PATH}
done