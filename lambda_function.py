import boto3

s3 = boto3.client('s3')

SOURCE_BUCKET = "qamar-s3-backup-source"
DEST_BUCKET = "qamar-s3-backup-destination"

def lambda_handler(event, context):
    objects = s3.list_objects_v2(Bucket=SOURCE_BUCKET)

    if 'Contents' not in objects:
        return {
            "status": "No files to backup"
        }

    for obj in objects['Contents']:
        copy_source = {
            'Bucket': SOURCE_BUCKET,
            'Key': obj['Key']
        }

        s3.copy_object(
            CopySource=copy_source,
            Bucket=DEST_BUCKET,
            Key=obj['Key']
        )

    return {
        "status": "Backup completed"
    }
