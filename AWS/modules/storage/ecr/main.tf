resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.ecr_repo_name
  image_tag_mutability = var.mutability

  image_scanning_configuration {
    scan_on_push = true
  }
}