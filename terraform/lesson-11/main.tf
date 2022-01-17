terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = var.tokengit
}

resource "github_repository" "repo-learning" {
  name        = "terraform-example"
  description = "My awesome terraform code"

  visibility = "public"

}