# general
variable "tenancy_ocid" {
  type = string
}
variable "compartment_ocid" {
  type = string
}
variable "compartment_name" {
  type = string
}

# naming
variable "coderepo_dynamic_group_name" {
  type = string
}
variable "build_dynamic_group_name" {
  type = string
}
variable "deploy_dynamic_group_name" {
  type = string
}
variable "devops_general_policy_name" {
  type = string
}
variable "devops_notification_topic_name" {
  type = string
}
variable "devops_notification_subscription_endpoint_email" {
  type = string
}
variable "devops_notification_subscription_endpoint_slack" {
  type = string
}
variable "devops_project_name" {
  type = string
}
variable "devops_repository_name" {
  type = string
}
variable "devops_build_pipeline_name" {
  type = string
}
variable "devops_deploy_pipeline_name" {
  type = string
}
variable "build_branch_name" {
  type = string
}
variable "artifact_repository_name" {
  type = string
}
variable "container_image_path" {
  type = string
}
variable "deployment_oke_cluster_ocid" {
  type = string
}
variable "deployment_oke_cluster_namespace" {
  type = string
}
variable "arifact_build_spec_image_nais" {
  type = string
}
variable "arifact_build_spec_manifest_nais" {
  type = string
}

# networking
variable "subnet_id" {
  type = string
}