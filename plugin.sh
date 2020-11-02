#!/bin/sh

set -e

die() { echo "$1"; exit 1; }

src_dir="${PLUGIN_SOURCE_DIR:-./}"
iam_role="${PLUGIN_IAM_ROLE_ARN:-NONE}"
site_generation="${PLUGIN_SITE_GENERATION:-true}" 

[ -n "${PLUGIN_AWS_REGION}" ] && export AWS_REGION="${PLUGIN_AWS_REGION}" AWS_DEFAULT_REGION="${PLUGIN_AWS_REGION}"

[ -z "${PLUGIN_BUCKET}" ] && die "bucket name is not set"
[ -z "${PLUGIN_SITE_PATH}" ] && die "site path is not set"

if [ "${site_generation}" = "true" ]; then
  cd "${src_dir}"
  build_dir=$(mktemp -p "${PWD}" -d _site-XXXXXX)
  mkdocs build --clean --site-dir "${build_dir}"  
fi

if [ "${site_generation}" = "false" ]; then
  build_dir=$(mktemp -p "/tmp" -d _site-XXXXXX)
  cp -a "${src_dir}"/. "${build_dir}"  
fi

if [ "${iam_role}" != "NONE" ]; then
  aws sts assume-role  \
      --role-arn "${iam_role}" \
      --role-session-name "docmaker-build-${DRONE_BUILD_NUMBER}" \
      --query 'Credentials' | parse-creds > /tmp/aws-creds

  . /tmp/aws-creds
fi

aws s3 sync --delete "${build_dir}" "s3://${PLUGIN_BUCKET}/${PLUGIN_SITE_PATH}/"
