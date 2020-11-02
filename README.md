# Docmaker

Drone plugin to generate static website with [mkdocs][] and push it to S3.

### Usage

In your `.drone.yaml` file configure a pipeline step to use this plugin:

```yaml
kind: pipeline
name: default

steps:
  - name: docs
    image: shuttleng/drone-docmaker:latest
    settings:
      bucket: s3.bucket.name
      site_path: docs/project
      source_dir: docs
      iam_role_arn: arn:aws:iam::1234567890:role/RoleWithS3PutObjectPermissions
      aws_region: us-east-1
```

### Configuration

Following configuration options are available:

| Setting | Required | Description |
|:---------:|:---------:|--------|
| `bucket` |  Yes | Name of the S3 bucket where the site will be uploaded |
| `site_path` |  Yes | S3 file path prefix where the site will be uploaded. Do not add leading or trailing slashes |
| `source_dir` |  No | Directory that contains the source files for site generation. Defaults to `docs` |
| `iam_role_arn` |  No | ARN of the IAM role to assume. Used for S3 file sync |
| `aws_region` |  No | AWS region name used by aws-cli commands |
| `site_generation` |  No | `true` if you want to generate html files from markdown files, `false` if the source files are already html. Defaults to `true`  |

Note that if you use an iam role to acquire credentials for S3, the drone agent EC2 role must have permission to assume the configured role.

